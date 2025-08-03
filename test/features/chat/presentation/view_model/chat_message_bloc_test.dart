import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:venure/core/error/failure.dart';
import 'package:venure/core/network/socket_service.dart';
import 'package:venure/features/chat/domain/entity/message_entity.dart';
import 'package:venure/features/chat/domain/repository/i_chat_repository.dart';
import 'package:venure/features/chat/presentation/view_model/chat_message_bloc.dart';
import 'package:venure/features/chat/presentation/view_model/chat_message_event.dart';
import 'package:venure/features/chat/presentation/view_model/chat_message_state.dart';

// ---------- Mocks ----------
class MockChatRepository extends Mock implements IChatRepository {}

class MockSocketService extends Mock implements SocketService {}

class FakeMessageEntity extends Fake implements MessageEntity {}

void main() {
  late MockChatRepository mockChatRepository;
  late MockSocketService mockSocketService;
  late ChatMessagesBloc bloc;

  const currentUserId = 'user-123';
  const chatId = 'chat-1';

  final tMessage1 = MessageEntity(
    id: 'm1',
    chatId: chatId,
    senderId: 'u1',
    receiverId: 'u2',
    text: 'Hello',
    timestamp: DateTime(2025, 1, 1),
    seen: false,
  );

  final tMessage2 = MessageEntity(
    id: 'm2',
    chatId: chatId,
    senderId: 'u2',
    receiverId: 'u1',
    text: 'Hi back',
    timestamp: DateTime(2025, 1, 2),
    seen: false,
  );

  const tFailure = ApiFailure(message: 'Error loading messages');

  setUpAll(() {
    registerFallbackValue(FakeMessageEntity());
  });

  setUp(() {
    mockChatRepository = MockChatRepository();
    mockSocketService = MockSocketService();

    when(
      () => mockSocketService.initialize(
        userId: any(named: 'userId'),
        chatId: any(named: 'chatId'),
      ),
    ).thenReturn(null);

    when(() => mockSocketService.dispose()).thenReturn(null);

    bloc = ChatMessagesBloc(
      chatRepository: mockChatRepository,
      socketService: mockSocketService,
      currentUserId: currentUserId,
    );
  });

  tearDown(() => bloc.close());

  test('initial state is ChatMessagesInitial', () {
    expect(bloc.state, ChatMessagesInitial());
  });

  group('LoadChatMessages', () {
    blocTest<ChatMessagesBloc, ChatMessagesState>(
      'emits [Loading, Loaded] on success and initializes socket',
      build: () {
        when(
          () => mockChatRepository.getMessagesForChat(chatId),
        ).thenAnswer((_) async => Right([tMessage1]));

        // IMPORTANT: mock saveMessageLocally to return Future<void>
        when(
          () => mockChatRepository.saveMessageLocally(any()),
        ).thenAnswer((_) async {});

        when(() => mockSocketService.onReceiveMessage(any())).thenAnswer((
          invocation,
        ) {
          final listener =
              invocation.positionalArguments[0] as void Function(MessageEntity);
          Future.microtask(() => listener(tMessage2));
          return null;
        });

        return bloc;
      },
      act: (bloc) => bloc.add(const LoadChatMessages(chatId)),
      expect:
          () => [
            ChatMessagesLoading(),
            ChatMessagesLoaded([tMessage1]),
            ChatMessagesLoaded([tMessage1, tMessage2]),
          ],
      verify: (_) {
        verify(() => mockChatRepository.getMessagesForChat(chatId)).called(1);
        verify(
          () => mockSocketService.initialize(
            userId: currentUserId,
            chatId: chatId,
          ),
        ).called(1);
        verify(() => mockSocketService.onReceiveMessage(any())).called(1);
      },
    );

    blocTest<ChatMessagesBloc, ChatMessagesState>(
      'emits [Loading, Error] on failure',
      build: () {
        when(
          () => mockChatRepository.getMessagesForChat(chatId),
        ).thenAnswer((_) async => const Left(tFailure));
        return bloc;
      },
      act: (bloc) => bloc.add(const LoadChatMessages(chatId)),
      expect:
          () => [
            ChatMessagesLoading(),
            ChatMessagesError(tFailure.message ?? 'Unexpected error'),
          ],
    );
  });

  group('ReceiveMessage', () {
    blocTest<ChatMessagesBloc, ChatMessagesState>(
      'adds new message to existing list',
      build: () {
        when(
          () => mockChatRepository.saveMessageLocally(any()),
        ).thenAnswer((_) async => Future.value());
        return bloc;
      },
      seed: () => ChatMessagesLoaded([tMessage1]),
      act: (bloc) => bloc.add(ReceiveMessage(tMessage2)),
      expect:
          () => [
            ChatMessagesLoaded([tMessage1, tMessage2]),
          ],
      verify: (_) {
        verify(
          () => mockChatRepository.saveMessageLocally(tMessage2),
        ).called(1);
      },
    );

    blocTest<ChatMessagesBloc, ChatMessagesState>(
      'creates new list if state is not Loaded',
      build: () {
        when(
          () => mockChatRepository.saveMessageLocally(any()),
        ).thenAnswer((_) async => Future.value());
        return bloc;
      },
      seed: () => ChatMessagesInitial(),
      act: (bloc) => bloc.add(ReceiveMessage(tMessage1)),
      expect:
          () => [
            ChatMessagesLoaded([tMessage1]),
          ],
      verify: (_) {
        verify(
          () => mockChatRepository.saveMessageLocally(tMessage1),
        ).called(1);
      },
    );
  });

  group('sendMessage', () {
    test('calls socketService.sendMessage with correct params', () {
      when(
        () => mockSocketService.sendMessage(
          chatId: chatId,
          sender: 'u1',
          receiver: 'u2',
          text: 'Hello',
        ),
      ).thenReturn(null);

      bloc.sendMessage(
        chatId: chatId,
        senderId: 'u1',
        receiverId: 'u2',
        text: 'Hello',
      );

      verify(
        () => mockSocketService.sendMessage(
          chatId: chatId,
          sender: 'u1',
          receiver: 'u2',
          text: 'Hello',
        ),
      ).called(1);
    });
  });

  group('close', () {
    test('disposes socketService on close', () async {
      await bloc.close();
      verify(() => mockSocketService.dispose()).called(1);
    });
  });
}
