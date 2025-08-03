import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:venure/core/error/failure.dart';
import 'package:venure/features/chat/domain/entity/chat_entity.dart';
import 'package:venure/features/chat/domain/repository/i_chat_repository.dart';
import 'package:venure/features/chat/domain/use_case/get_or_create_chat_usecase.dart';

// Mock IChatRepository
class MockChatRepository extends Mock implements IChatRepository {}

void main() {
  late GetOrCreateChatUseCase useCase;
  late MockChatRepository mockRepository;

  const tParticipantId = 'participant123';
  const tVenueId = 'venue456';
  const tCurrentUserId = 'currentUser789';

  final tParams = GetOrCreateChatParamsWithUser(
    participantId: tParticipantId,
    venueId: tVenueId,
    currentUserId: tCurrentUserId,
  );

  final tChatEntity = ChatEntity(
    id: 'chat123',
    participants: [tParticipantId, tCurrentUserId],
    venueId: tVenueId,
    lastMessage: 'Hello there!',
    venueName: 'TEST VENUE', participantId: '1', participantName: '2',
  );

  setUp(() {
    mockRepository = MockChatRepository();
    useCase = GetOrCreateChatUseCase(mockRepository);
  });

  group('GetOrCreateChatUseCase', () {
    test('should return Right(ChatEntity) when repository call is successful', () async {
      // Arrange
      when(() => mockRepository.getOrCreateChat(
            participantId: tParticipantId,
            venueId: tVenueId,
            currentUserId: tCurrentUserId,
          )).thenAnswer((_) async => Right(tChatEntity));

      // Act
      final result = await useCase.call(tParams);

      // Assert
      expect(result, Right(tChatEntity));
      verify(() => mockRepository.getOrCreateChat(
            participantId: tParticipantId,
            venueId: tVenueId,
            currentUserId: tCurrentUserId,
          )).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return Left(ApiFailure) when repository returns failure', () async {
      // Arrange
      final failure = ApiFailure(message: 'Chat creation failed');
      when(() => mockRepository.getOrCreateChat(
            participantId: tParticipantId,
            venueId: tVenueId,
            currentUserId: tCurrentUserId,
          )).thenAnswer((_) async => Left(failure));

      // Act
      final result = await useCase.call(tParams);

      // Assert
      expect(result, Left(failure));
      verify(() => mockRepository.getOrCreateChat(
            participantId: tParticipantId,
            venueId: tVenueId,
            currentUserId: tCurrentUserId,
          )).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
