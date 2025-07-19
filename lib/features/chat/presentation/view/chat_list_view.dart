import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:venure/app/service_locator/service_locator.dart';
import 'package:venure/features/chat/domain/entity/chat_entity.dart';
import 'package:venure/features/chat/presentation/view/chat_screen.dart';
import 'package:venure/features/chat/presentation/view_model/chat_list_bloc.dart';
import 'package:venure/features/chat/presentation/view_model/chat_list_event.dart';
import 'package:venure/features/chat/presentation/view_model/chat_list_state.dart';
import 'package:venure/features/chat/presentation/view_model/chat_message_bloc.dart';
import 'package:venure/features/chat/presentation/view_model/chat_message_event.dart';

import 'package:venure/features/chat/domain/entity/message_entity.dart';
import 'package:venure/features/chat/domain/repository/i_chat_repository.dart';

class ChatScreenView extends StatelessWidget {
  const ChatScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    // Trigger loading user chats when screen loads
    context.read<ChatListBloc>().add(
      LoadUserChats(currentUserId: context.read<ChatListBloc>().currentUserId),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Chats')),
      body: BlocBuilder<ChatListBloc, ChatListState>(
        builder: (context, state) {
          if (state is ChatListLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ChatListLoaded) {
            final chats = state.chats;

            if (chats.isEmpty) {
              return const Center(child: Text('No chats found.'));
            }

            return ListView.separated(
              itemCount: chats.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final chat = chats[index];
                final participantName = chat.participantName ?? 'Unknown';
                final lastMessage = chat.lastMessage ?? '';
                final unreadCount = chat.unreadCount;

                return ListTile(
                  title: Text(participantName),
                  subtitle: Text(
                    lastMessage,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing:
                      unreadCount > 0
                          ? CircleAvatar(
                            radius: 12,
                            backgroundColor: Colors.redAccent,
                            child: Text(
                              unreadCount.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          )
                          : null,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => BlocProvider<ChatMessagesBloc>(
                              create:
                                  (_) =>
                                      serviceLocator<ChatMessagesBloc>()
                                        ..add(LoadChatMessages(chat.id)),
                              child: ChatScreen(
                                chatId: chat.id,
                                currentUserId:
                                    context.read<ChatListBloc>().currentUserId,
                                otherUserId: chat.participants.firstWhere(
                                  (p) =>
                                      p !=
                                      context
                                          .read<ChatListBloc>()
                                          .currentUserId,
                                  orElse: () => '',
                                ),
                                venueId: chat.venueId,
                              ),
                            ),
                      ),
                    );
                  },
                );
              },
            );
          }

          if (state is ChatListError) {
            return Center(child: Text(state.message));
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
