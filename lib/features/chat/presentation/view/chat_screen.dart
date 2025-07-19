import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:venure/features/chat/domain/entity/message_entity.dart';
import 'package:venure/features/chat/presentation/view_model/chat_message_bloc.dart';
import 'package:venure/features/chat/presentation/view_model/chat_message_event.dart';
import 'package:venure/features/chat/presentation/view_model/chat_message_state.dart';

class ChatScreen extends StatefulWidget {
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
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<ChatMessagesBloc>().add(LoadChatMessages(widget.chatId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
        backgroundColor: Colors.black87,
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
                  final messages =
                      state.messages.reversed.toList(); // show latest at bottom

                  if (messages.isEmpty) {
                    return const Center(child: Text('No messages yet.'));
                  }

                  return ListView.builder(
                    reverse: true,
                    padding: const EdgeInsets.all(16),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final msg = messages[index];
                      final isMe = msg.senderId == widget.currentUserId;

                      return Align(
                        alignment:
                            isMe ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: isMe ? Colors.blue[700] : Colors.grey[300],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            msg.text,
                            style: TextStyle(
                              color: isMe ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      );
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
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    if (_controller.text.trim().isNotEmpty) {
                      final text = _controller.text.trim();

                      final myMessage = MessageEntity(
                        id: UniqueKey().toString(), // Temporary local ID
                        chatId: widget.chatId,
                        senderId: widget.currentUserId,
                        receiverId: widget.otherUserId,
                        text: text,
                        timestamp: DateTime.now(),
                        seen: false,
                      );

                      // Immediately show the message in the UI
                      context.read<ChatMessagesBloc>().add(
                        ReceiveMessage(myMessage),
                      );

                      // Send message over socket
                      context.read<ChatMessagesBloc>().sendMessage(
                        chatId: widget.chatId,
                        senderId: widget.currentUserId,
                        receiverId: widget.otherUserId,
                        text: text,
                      );

                      _controller.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
