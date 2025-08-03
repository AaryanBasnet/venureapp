import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:venure/core/error/failure.dart';
import 'package:venure/features/auth/domain/repository/user_repository.dart';
import 'package:venure/features/auth/domain/use_case/verify_reset_code_usecase.dart';

// Mock IUserRepository
class MockUserRepository extends Mock implements IUserRepository {}

void main() {
  late VerifyResetCodeUseCase useCase;
  late MockUserRepository mockRepository;

  const tEmail = 'test@example.com';
  const tCode = '123456';

  setUp(() {
    mockRepository = MockUserRepository();
    useCase = VerifyResetCodeUseCase(mockRepository);
  });

  group('VerifyResetCodeUseCase', () {
    test(
      'should return Right(void) when verifyResetCode is successful',
      () async {
        // Arrange
        when(
          () => mockRepository.verifyResetCode(tEmail, tCode),
        ).thenAnswer((_) async => const Right(null));

        // Act
        final result = await useCase(tEmail, tCode);

        // Assert
        expect(result, const Right(null));
        verify(() => mockRepository.verifyResetCode(tEmail, tCode)).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );

    test('should return Left(Failure) when verifyResetCode fails', () async {
      // Arrange
      final failure = ApiFailure(message: 'Verification failed');
      when(
        () => mockRepository.verifyResetCode(tEmail, tCode),
      ).thenAnswer((_) async => Left(failure));

      // Act
      final result = await useCase(tEmail, tCode);

      // Assert
      expect(result, Left(failure));
      verify(() => mockRepository.verifyResetCode(tEmail, tCode)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
