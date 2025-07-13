import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:venure/core/error/failure.dart';
import 'package:venure/features/auth/domain/entity/user_entity.dart';
import 'package:venure/features/auth/domain/repository/user_repository.dart';
import 'package:venure/app/constant/shared_pref/local_storage_service.dart';
import 'package:venure/features/auth/domain/use_case/user_login_usecase.dart';

// Fake for UserEntity to handle any() matcher
class FakeUserEntity extends Fake implements UserEntity {}

// Mock classes
class MockUserRepository extends Mock implements IUserRepository {}

class MockLocalStorageService extends Mock implements LocalStorageService {}

void main() {
  late UserLoginUsecase usecase;
  late MockUserRepository mockUserRepository;
  late MockLocalStorageService mockLocalStorageService;

  setUpAll(() {
    registerFallbackValue(FakeUserEntity());
  });

  setUp(() {
    mockUserRepository = MockUserRepository();
    mockLocalStorageService = MockLocalStorageService();
    usecase = UserLoginUsecase(
      repository: mockUserRepository,
      localStorageService: mockLocalStorageService,
    );
  });

  const validEmail = 'test@example.com';
  const validPassword = 'password123';

  final testUserEntity = UserEntity(
    userId: '123',
    name: 'Test User',
    email: validEmail,
    phone: '1234567890',
    password: validPassword,
    token: 'token_abc',
    role: 'user',
  );

  group('LoginUserParams Tests', () {
    test('should support value equality and props', () {
      const params1 = LoginUserParams(email: 'a@b.com', password: '1234');
      const params2 = LoginUserParams(email: 'a@b.com', password: '1234');
      const params3 = LoginUserParams(email: 'x@y.com', password: 'abcd');

      expect(params1, equals(params2));
      expect(params1 == params2, isTrue);
      expect(params1 == params3, isFalse);
      expect(params1.props, ['a@b.com', '1234']);
    });

    test('should create initial LoginUserParams with empty strings', () {
      const params = LoginUserParams.initial();

      expect(params.email, '');
      expect(params.password, '');
      expect(params.props, ['', '']);
    });
  });

  group('UserLoginUsecase Tests', () {
    test('constructor should initialize properly', () {
      expect(usecase, isA<UserLoginUsecase>());
    });

    test('should return UserEntity and call saveUser when login is successful', () async {
      when(() => mockUserRepository.loginUser(validEmail, validPassword))
          .thenAnswer((_) async => Right(testUserEntity));

      when(() => mockLocalStorageService.saveUser(testUserEntity))
          .thenAnswer((_) async => Future.value());

      final result = await usecase(LoginUserParams(email: validEmail, password: validPassword));

      expect(result, Right(testUserEntity));
      verify(() => mockUserRepository.loginUser(validEmail, validPassword)).called(1);
      verify(() => mockLocalStorageService.saveUser(testUserEntity)).called(1);
      verifyNoMoreInteractions(mockUserRepository);
      verifyNoMoreInteractions(mockLocalStorageService);
    });

    test('should return Failure and not call saveUser when login fails', () async {
      final failure = ApiFailure(message: 'Invalid credentials');
      when(() => mockUserRepository.loginUser(validEmail, validPassword))
          .thenAnswer((_) async => Left(failure));

      final result = await usecase(LoginUserParams(email: validEmail, password: validPassword));

      expect(result, Left(failure));
      verify(() => mockUserRepository.loginUser(validEmail, validPassword)).called(1);
      verifyNever(() => mockLocalStorageService.saveUser(any()));
      verifyNoMoreInteractions(mockUserRepository);
      verifyNoMoreInteractions(mockLocalStorageService);
    });

    test('should handle LoginUserParams.initial() with empty email/password', () async {
      const params = LoginUserParams.initial();

      final failure = ApiFailure(message: 'Email or password empty');
      when(() => mockUserRepository.loginUser(params.email, params.password))
          .thenAnswer((_) async => Left(failure));

      final result = await usecase(params);

      expect(result, Left(failure));
      verify(() => mockUserRepository.loginUser(params.email, params.password)).called(1);
      verifyNever(() => mockLocalStorageService.saveUser(any()));
    });
  });
}
