import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:venure/core/error/failure.dart';
import 'package:venure/features/chat/domain/entity/chat_entity.dart';
import 'package:venure/features/chat/domain/use_case/get_chat_usecase.dart';
import 'package:venure/features/chat/domain/use_case/get_or_create_chat_usecase.dart';
import 'package:venure/features/chat/presentation/view_model/chat_list_bloc.dart';
import 'package:venure/features/chat/presentation/view_model/chat_list_event.dart';
import 'package:venure/features/chat/presentation/view_model/chat_list_state.dart';

// --------- Mocks ----------
class MockGetUserChatsUseCase extends Mock implements GetUserChatsUseCase {}

class MockGetOrCreateChatUseCase extends Mock
    implements GetOrCreateChatUseCase {}

class FakeGetOrCreateChatParamsWithUser extends Fake
    implements GetOrCreateChatParamsWithUser {}

void main() {
  late MockGetUserChatsUseCase mockGetUserChatsUseCase;
  late MockGetOrCreateChatUseCase mockGetOrCreateChatUseCase;
  late ChatListBloc bloc;

  const currentUserId = 'user-123';
  final tChat1 = ChatEntity(
    id: 'c1',
    participants: ['u1', 'u2'],
    venueId: '',
    venueName: '',
    participantId: '',
    participantName: '',
  );
  final tChat2 = ChatEntity(
    id: 'c2',
    participants: ['u3', 'u4'],
    venueId: '',
    venueName: '',
    participantId: '',
    participantName: '',
  );
  final tChats = [tChat1, tChat2];
  const tFailure = ApiFailure(message: 'Something went wrong');

  setUpAll(() {
    registerFallbackValue(FakeGetOrCreateChatParamsWithUser());
  });

  setUp(() {
    mockGetUserChatsUseCase = MockGetUserChatsUseCase();
    mockGetOrCreateChatUseCase = MockGetOrCreateChatUseCase();
    bloc = ChatListBloc(
      getUserChatsUseCase: mockGetUserChatsUseCase,
      getOrCreateChatUseCase: mockGetOrCreateChatUseCase,
      currentUserId: currentUserId,
    );
  });

  tearDown(() => bloc.close());

  test('initial state is ChatListInitial', () {
    expect(bloc.state, ChatListInitial());
  });

  group('LoadUserChats', () {
    blocTest<ChatListBloc, ChatListState>(
      'emits [ChatListLoading, ChatListLoaded] on success',
      build: () {
        when(
          () => mockGetUserChatsUseCase(any()),
        ).thenAnswer((_) async => Right(tChats));
        return bloc;
      },
      act:
          (bloc) => bloc.add(
            LoadUserChats(venueId: 'venue-1', currentUserId: currentUserId),
          ),
      expect: () => [ChatListLoading(), ChatListLoaded(tChats)],
      verify: (_) {
        verify(() => mockGetUserChatsUseCase(any())).called(1);
      },
    );

    blocTest<ChatListBloc, ChatListState>(
      'emits [ChatListLoading, ChatListError] on failure',
      build: () {
        when(
          () => mockGetUserChatsUseCase(any()),
        ).thenAnswer((_) async => const Left(tFailure));
        return bloc;
      },
      act:
          (bloc) => bloc.add(
            LoadUserChats(venueId: 'venue-1', currentUserId: currentUserId),
          ),
      expect:
          () => [
            ChatListLoading(),
            ChatListError(tFailure.message ?? 'Unexpected error'),
          ],
    );

    blocTest<ChatListBloc, ChatListState>(
      'does nothing if state is already ChatListLoading',
      build: () {
        when(
          () => mockGetUserChatsUseCase(any()),
        ).thenAnswer((_) async => Right(tChats));
        return bloc;
      },
      seed: () => ChatListLoading(),
      act:
          (bloc) => bloc.add(
            LoadUserChats(venueId: 'venue-1', currentUserId: currentUserId),
          ),
      expect: () => [],
      verify: (_) {
        verifyNever(() => mockGetUserChatsUseCase(any()));
      },
    );
  });

  group('GetOrCreateChat', () {
    final params = FakeGetOrCreateChatParamsWithUser();

    blocTest<ChatListBloc, ChatListState>(
      'emits [ChatListLoading, ChatListLoadedChat] on success',
      build: () {
        when(
          () => mockGetOrCreateChatUseCase(any()),
        ).thenAnswer((_) async => Right(tChat1));
        return bloc;
      },
      act: (bloc) => bloc.add(GetOrCreateChat(params)),
      expect: () => [ChatListLoading(), ChatListLoadedChat(tChat1)],
      verify: (_) {
        verify(() => mockGetOrCreateChatUseCase(any())).called(1);
      },
    );

    blocTest<ChatListBloc, ChatListState>(
      'emits [ChatListLoading, ChatListError] on failure',
      build: () {
        when(
          () => mockGetOrCreateChatUseCase(any()),
        ).thenAnswer((_) async => const Left(tFailure));
        return bloc;
      },
      act: (bloc) => bloc.add(GetOrCreateChat(params)),
      expect:
          () => [
            ChatListLoading(),
            ChatListError(tFailure.message ?? 'Unexpected error'),
          ],
    );
  });
}
