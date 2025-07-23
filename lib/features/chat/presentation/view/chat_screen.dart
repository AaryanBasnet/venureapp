import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:venure/features/chat/presentation/widgets/message_bubble.dart';
import 'package:venure/features/chat/presentation/view_model/chat_message_bloc.dart';
import 'package:venure/features/chat/presentation/view_model/chat_message_state.dart';
import 'package:venure/features/chat/presentation/view_model/chat_message_event.dart';
import 'package:venure/features/chat/presentation/widgets/message_input_field.dart';

class ChatScreen extends StatelessWidget {
  final String chatId;
  final String currentUserId;
  final String otherUserId;
  final String venueId;

  const ChatScreen({
    super.key,
    required this.chatId,
    required this.currentUserId,
    required this.otherUserId,
    required this.venueId,
  });

  @override
  Widget build(BuildContext context) {
    context.read<ChatMessagesBloc>().add(LoadChatMessages(chatId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
        backgroundColor: const Color.fromARGB(221, 19, 148, 38),
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<ChatMessagesBloc, ChatMessagesState>(
              builder: (context, state) {
                if (state is ChatMessagesLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is ChatMessagesLoaded) {
                  final messages = state.messages.reversed.toList();

                  if (messages.isEmpty) {
                    return const Center(child: Text('No messages yet.'));
                  }

                  return ListView.builder(
                    reverse: true,
                    padding: const EdgeInsets.all(16),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final msg = messages[index];
                      final isMe = msg.senderId == currentUserId;

                      return MessageBubble(message: msg, isMe: isMe);
                    },
                  );
                }

                if (state is ChatMessagesError) {
                  return Center(
                    child: Text('Failed to load chat: ${state.message}'),
                  );
                }

                return const Center(child: Text('No messages yet.'));
              },
            ),
          ),
          MessageInputField(
            chatId: chatId,
            currentUserId: currentUserId,
            otherUserId: otherUserId,
          ),
        ],
      ),
    );
  }
}
