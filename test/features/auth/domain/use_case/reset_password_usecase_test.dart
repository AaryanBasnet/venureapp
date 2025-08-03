import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:venure/core/error/failure.dart';
import 'package:venure/features/auth/domain/repository/user_repository.dart';
import 'package:venure/features/auth/domain/use_case/reset_password_usecase.dart';

// Mock class for IUserRepository
class MockUserRepository extends Mock implements IUserRepository {}

void main() {
  late ResetPasswordUseCase useCase;
  late MockUserRepository mockRepository;

  const tEmail = 'test@example.com';
  const tCode = '123456';
  const tNewPassword = 'newPassword123';

  setUp(() {
    mockRepository = MockUserRepository();
    useCase = ResetPasswordUseCase(mockRepository);
  });

  group('ResetPasswordUseCase', () {
    test(
      'should return Right(void) when resetPassword is successful',
      () async {
        // Arrange
        when(
          () => mockRepository.resetPassword(
            email: tEmail,
            code: tCode,
            newPassword: tNewPassword,
          ),
        ).thenAnswer((_) async => const Right(null));

        // Act
        final result = await useCase(
          email: tEmail,
          code: tCode,
          newPassword: tNewPassword,
        );

        // Assert
        expect(result, const Right(null));
        verify(
          () => mockRepository.resetPassword(
            email: tEmail,
            code: tCode,
            newPassword: tNewPassword,
          ),
        ).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );

    test('should return Left(Failure) when resetPassword fails', () async {
      // Arrange
      final failure = ApiFailure(message: 'Reset failed');
      when(
        () => mockRepository.resetPassword(
          email: tEmail,
          code: tCode,
          newPassword: tNewPassword,
        ),
      ).thenAnswer((_) async => Left(failure));

      // Act
      final result = await useCase(
        email: tEmail,
        code: tCode,
        newPassword: tNewPassword,
      );

      // Assert
      expect(result, Left(failure));
      verify(
        () => mockRepository.resetPassword(
          email: tEmail,
          code: tCode,
          newPassword: tNewPassword,
        ),
      ).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
