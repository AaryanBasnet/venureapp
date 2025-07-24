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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Trigger loading user chats when screen loads
    context.read<ChatListBloc>().add(
      LoadUserChats(currentUserId: context.read<ChatListBloc>().currentUserId),
    );

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: const Text(
          'Messages',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: colorScheme.surface,
        elevation: 0,
        scrolledUnderElevation: 1,
        surfaceTintColor: colorScheme.surfaceTint,
      ),
      body: BlocBuilder<ChatListBloc, ChatListState>(
        builder: (context, state) {
          if (state is ChatListLoading) {
            return _buildLoadingState();
          }

          if (state is ChatListLoaded) {
            final chats = state.chats;

            if (chats.isEmpty) {
              return _buildEmptyState(colorScheme);
            }

            return RefreshIndicator(
              onRefresh: () async {
                context.read<ChatListBloc>().add(
                  LoadUserChats(
                    currentUserId: context.read<ChatListBloc>().currentUserId,
                  ),
                );
              },
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: chats.length,
                separatorBuilder:
                    (_, __) => Divider(
                      height: 1,
                      thickness: 0.5,
                      color: colorScheme.outline.withOpacity(0.2),
                      indent: 72,
                    ),
                itemBuilder: (context, index) {
                  final chat = chats[index];
                  return _buildChatTile(context, chat, colorScheme);
                },
              ),
            );
          }

          if (state is ChatListError) {
            return _buildErrorState(context, state.message, colorScheme);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Loading conversations...'),
        ],
      ),
    );
  }

  Widget _buildEmptyState(ColorScheme colorScheme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline_rounded,
            size: 64,
            color: colorScheme.outline,
          ),
          const SizedBox(height: 16),
          Text(
            'No conversations yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start chatting to see your conversations here',
            style: TextStyle(fontSize: 14, color: colorScheme.outline),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(
    BuildContext context,
    String message,
    ColorScheme colorScheme,
  ) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline_rounded, size: 64, color: colorScheme.error),
          const SizedBox(height: 16),
          Text(
            'Something went wrong',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: colorScheme.error,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: TextStyle(fontSize: 14, color: colorScheme.outline),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () {
              context.read<ChatListBloc>().add(
                LoadUserChats(
                  currentUserId: context.read<ChatListBloc>().currentUserId,
                ),
              );
            },
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  Widget _buildChatTile(
    BuildContext context,
    ChatEntity chat,
    ColorScheme colorScheme,
  ) {
    final participantName = chat.participantName ?? 'Unknown User';
    final lastMessage = chat.lastMessage ?? '';
    final unreadCount = chat.unreadCount;
    final hasUnread = unreadCount > 0;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _navigateToChat(context, chat),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              // Avatar
              CircleAvatar(
                radius: 28,
                backgroundColor: colorScheme.primaryContainer,
                child: Text(
                  _getInitials(participantName),
                  style: TextStyle(
                    color: colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Chat content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            participantName,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight:
                                  hasUnread ? FontWeight.w600 : FontWeight.w500,
                              color:
                                  hasUnread
                                      ? colorScheme.onSurface
                                      : colorScheme.onSurfaceVariant,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (hasUnread)
                          _buildUnreadBadge(unreadCount, colorScheme),
                      ],
                    ),
                    const SizedBox(height: 4),
                    if (lastMessage.isNotEmpty)
                      Text(
                        lastMessage,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14,
                          color:
                              hasUnread
                                  ? colorScheme.onSurfaceVariant
                                  : colorScheme.outline,
                          fontWeight:
                              hasUnread ? FontWeight.w500 : FontWeight.normal,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUnreadBadge(int count, ColorScheme colorScheme) {
    final displayCount = count > 99 ? '99+' : count.toString();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: colorScheme.primary,
        borderRadius: BorderRadius.circular(12),
      ),
      constraints: const BoxConstraints(minWidth: 20, minHeight: 20),
      child: Text(
        displayCount,
        style: TextStyle(
          color: colorScheme.onPrimary,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  String _getInitials(String name) {
    if (name.isEmpty) return 'U';

    final words = name.trim().split(' ');
    if (words.length == 1) {
      return words[0].substring(0, 1).toUpperCase();
    }

    return (words[0].substring(0, 1) + words[1].substring(0, 1)).toUpperCase();
  }

  void _navigateToChat(BuildContext context, ChatEntity chat) {
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
                currentUserId: context.read<ChatListBloc>().currentUserId,
                otherUserId: chat.participants.firstWhere(
                  (p) => p != context.read<ChatListBloc>().currentUserId,
                  orElse: () => '',
                ),
                venueId: chat.venueId,
              ),
            ),
      ),
    );
  }
}
