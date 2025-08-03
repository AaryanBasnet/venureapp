import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:venure/core/error/failure.dart';
import 'package:venure/features/auth/domain/repository/user_repository.dart';
import 'package:venure/features/auth/domain/use_case/send_rest_code_usecase.dart';

// Mock class for IUserRepository
class MockUserRepository extends Mock implements IUserRepository {}

void main() {
  late SendResetCodeUseCase useCase;
  late MockUserRepository mockRepository;

  const tEmail = 'test@example.com';

  setUp(() {
    mockRepository = MockUserRepository();
    useCase = SendResetCodeUseCase(mockRepository);
  });

  group('SendResetCodeUseCase', () {
    test(
      'should return Right(void) when sendResetCode is successful',
      () async {
        // Arrange
        when(
          () => mockRepository.sendResetCode(tEmail),
        ).thenAnswer((_) async => const Right(null));

        // Act
        final result = await useCase(tEmail);

        // Assert
        expect(result, const Right(null));
        verify(() => mockRepository.sendResetCode(tEmail)).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );

    test('should return Left(Failure) when sendResetCode fails', () async {
      // Arrange
      final failure = ApiFailure(message: 'Send code failed');
      when(
        () => mockRepository.sendResetCode(tEmail),
      ).thenAnswer((_) async => Left(failure));

      // Act
      final result = await useCase(tEmail);

      // Assert
      expect(result, Left(failure));
      verify(() => mockRepository.sendResetCode(tEmail)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
