import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:venure/features/chat/domain/use_case/get_chat_usecase.dart';
import 'package:venure/features/chat/domain/use_case/get_or_create_chat_usecase.dart';
import 'package:venure/features/chat/presentation/view_model/chat_list_event.dart';
import 'package:venure/features/chat/presentation/view_model/chat_list_state.dart';

class ChatListBloc extends Bloc<ChatListEvent, ChatListState> {
  final GetUserChatsUseCase getUserChatsUseCase;
  final GetOrCreateChatUseCase getOrCreateChatUseCase;
  final String currentUserId;

  ChatListBloc({
    required this.getUserChatsUseCase,
    required this.getOrCreateChatUseCase,
    required this.currentUserId,
  }) : super(ChatListInitial()) {
    on<LoadUserChats>(_onLoadUserChats);
    on<GetOrCreateChat>(_onGetOrCreateChat);
  }

  Future<void> _onLoadUserChats(
    LoadUserChats event,
    Emitter<ChatListState> emit,
  ) async {
    if (state is ChatListLoading) return;

    emit(ChatListLoading());
    final failureOrChats = await getUserChatsUseCase({
      'venueId': event.venueId,
      'currentUserId': currentUserId,
    });

    failureOrChats.fold(
      (failure) => emit(ChatListError(failure.message ?? 'Unexpected error')),
      (chats) => emit(ChatListLoaded(chats)),
    );
  }

  Future<void> _onGetOrCreateChat(
    GetOrCreateChat event,
    Emitter<ChatListState> emit,
  ) async {
    emit(ChatListLoading());
    final failureOrChat = await getOrCreateChatUseCase(event.params);
    failureOrChat.fold(
      (failure) => emit(ChatListError(failure.message ?? 'Unexpected error')),
      (chat) => emit(ChatListLoadedChat(chat)),
    );
  }
}
