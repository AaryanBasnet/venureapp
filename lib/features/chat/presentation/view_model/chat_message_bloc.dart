import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:venure/core/network/socket_service.dart';
import 'package:venure/features/chat/domain/entity/message_entity.dart';
import 'package:venure/features/chat/domain/repository/i_chat_repository.dart';
import 'package:venure/features/chat/presentation/view_model/chat_message_event.dart';
import 'package:venure/features/chat/presentation/view_model/chat_message_state.dart';

class ChatMessagesBloc extends Bloc<ChatMessagesEvent, ChatMessagesState> {
  final IChatRepository chatRepository;
  final SocketService socketService;
  final String currentUserId;

  ChatMessagesBloc({
    required this.chatRepository,
    required this.socketService,
    required this.currentUserId,
  }) : super(ChatMessagesInitial()) {
    on<LoadChatMessages>(_onLoadChatMessages);
    on<ReceiveMessage>(_onReceiveMessage);
  }

  Future<void> _onLoadChatMessages(
    LoadChatMessages event,
    Emitter<ChatMessagesState> emit,
  ) async {
    emit(ChatMessagesLoading());

    final failureOrMessages = await chatRepository.getMessagesForChat(
      event.chatId,
    );

    failureOrMessages.fold(
      (failure) =>
          emit(ChatMessagesError(failure.message ?? 'Unexpected error')),
      (messages) {
        emit(ChatMessagesLoaded(messages));

        // Initialize socket and register callback
        socketService.initialize(userId: currentUserId, chatId: event.chatId);

        socketService.onReceiveMessage((message) {
          print('Received message on socket: ${message.text}');
          add(ReceiveMessage(message));
        });
      },
    );
  }

  void _onReceiveMessage(
    ReceiveMessage event,
    Emitter<ChatMessagesState> emit,
  ) {
    final currentState = state;
    if (currentState is ChatMessagesLoaded) {
      final updatedMessages = List<MessageEntity>.from(currentState.messages)
        ..add(event.message);
      emit(ChatMessagesLoaded(updatedMessages));
    } else {
      emit(ChatMessagesLoaded([event.message]));
    }
  }

  void sendMessage({
    required String chatId,
    required String senderId,
    required String receiverId,
    required String text,
  }) {
    socketService.sendMessage(
      chatId: chatId,
      sender: senderId,
      receiver: receiverId,
      text: text,
    );
  }

  @override
  Future<void> close() {
    socketService.dispose();
    return super.close();
  }
}
