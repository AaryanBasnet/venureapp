import 'package:equatable/equatable.dart';
import 'package:venure/features/chat/domain/entity/chat_entity.dart';

class ChatListState extends Equatable {
  const ChatListState();
  @override
  List<Object?> get props => [];
}

class ChatListInitial extends ChatListState {}

class ChatListLoading extends ChatListState {}

class ChatListLoaded extends ChatListState {
  final List<ChatEntity> chats;
  const ChatListLoaded(this.chats);

  @override
  List<Object?> get props => [chats];
}

class ChatListLoadedChat extends ChatListState {
  final ChatEntity chat;
  const ChatListLoadedChat(this.chat);

  @override
  List<Object?> get props => [chat];
}

class ChatListError extends ChatListState {
  final String message;
  const ChatListError(this.message);

  @override
  List<Object?> get props => [message];
}
