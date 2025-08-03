import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:venure/core/error/failure.dart';
import 'package:venure/features/auth/domain/repository/user_repository.dart';
import 'package:venure/features/auth/domain/use_case/verify_password_usecase.dart';

// Mock for IUserRepository
class MockUserRepository extends Mock implements IUserRepository {}

void main() {
  late VerifyPasswordUsecase usecase;
  late MockUserRepository mockRepository;

  const tUserId = 'user123';
  const tPassword = 'password!@#';
  final tParams = VerifyPasswordParams(userId: tUserId, password: tPassword);

  setUp(() {
    mockRepository = MockUserRepository();
    usecase = VerifyPasswordUsecase(mockRepository);
  });

  group('VerifyPasswordParams', () {
    test('should have correct props', () {
      expect(tParams.props, [tUserId, tPassword]);
    });
  });

  group('VerifyPasswordUsecase', () {
    test('should be instantiated with repository', () {
      expect(usecase.repository, equals(mockRepository));
    });

    test('should return Right(true) when password verification is successful', () async {
      // Arrange
      when(() => mockRepository.verifyPassword(tUserId, tPassword))
          .thenAnswer((_) async => const Right(true));

      // Act
      final result = await usecase.call(tParams);

      // Assert
      expect(result, const Right(true));
      verify(() => mockRepository.verifyPassword(tUserId, tPassword)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return Right(false) when password verification fails (wrong password)', () async {
      // Arrange
      when(() => mockRepository.verifyPassword(tUserId, tPassword))
          .thenAnswer((_) async => const Right(false));

      // Act
      final result = await usecase.call(tParams);

      // Assert
      expect(result, const Right(false));
      verify(() => mockRepository.verifyPassword(tUserId, tPassword)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return Left(Failure) when repository returns failure', () async {
      // Arrange
      final failure = ApiFailure(message: 'Verification failed');
      when(() => mockRepository.verifyPassword(tUserId, tPassword))
          .thenAnswer((_) async => Left(failure));

      // Act
      final result = await usecase.call(tParams);

      // Assert
      expect(result, Left(failure));
      verify(() => mockRepository.verifyPassword(tUserId, tPassword)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
