

import 'package:equatable/equatable.dart';
import 'package:venure/features/chat/domain/use_case/get_or_create_chat_usecase.dart';

abstract class ChatListEvent extends Equatable {
  const ChatListEvent();
  @override
  List<Object?> get props => [];
}

class LoadUserChats extends ChatListEvent {
  final String? venueId;
  final String currentUserId;
  const LoadUserChats({this.venueId, required this.currentUserId});

  @override
  List<Object?> get props => [venueId, currentUserId];
}

class GetOrCreateChat extends ChatListEvent {
  final GetOrCreateChatParamsWithUser params;
  const GetOrCreateChat(this.params);

  @override
  List<Object?> get props => [params];
}
