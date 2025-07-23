import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:venure/features/chat/domain/entity/message_entity.dart';
import 'package:venure/features/chat/presentation/view_model/chat_message_bloc.dart';
import 'package:venure/features/chat/presentation/view_model/chat_message_event.dart';

class MessageInputField extends StatefulWidget {
  final String chatId;
  final String currentUserId;
  final String otherUserId;

  const MessageInputField({
    super.key,
    required this.chatId,
    required this.currentUserId,
    required this.otherUserId,
  });

  @override
  State<MessageInputField> createState() => _MessageInputFieldState();
}

class _MessageInputFieldState extends State<MessageInputField> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose(); // don't forget this!
    super.dispose();
  }

  void _sendMessage() {
    if (_controller.text.trim().isNotEmpty) {
      final text = _controller.text.trim();

      final myMessage = MessageEntity(
        id: UniqueKey().toString(),
        chatId: widget.chatId,
        senderId: widget.currentUserId,
        receiverId: widget.otherUserId,
        text: text,
        timestamp: DateTime.now(),
        seen: false,
      );

      context.read<ChatMessagesBloc>().add(ReceiveMessage(myMessage));
      context.read<ChatMessagesBloc>().sendMessage(
            chatId: widget.chatId,
            senderId: widget.currentUserId,
            receiverId: widget.otherUserId,
            text: text,
          );

      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
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
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }
}
