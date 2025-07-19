import 'package:equatable/equatable.dart';
import 'package:venure/features/chat/domain/entity/message_entity.dart';

abstract class ChatMessagesEvent extends Equatable {
  const ChatMessagesEvent();
  @override
  List<Object?> get props => [];
}

class LoadChatMessages extends ChatMessagesEvent {
  final String chatId;
  const LoadChatMessages(this.chatId);

  @override
  List<Object?> get props => [chatId];
}

class ReceiveMessage extends ChatMessagesEvent {
  final MessageEntity message;
  const ReceiveMessage(this.message);

  @override
  List<Object?> get props => [message];
}
