import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:venure/core/error/failure.dart';
import 'package:venure/features/auth/domain/entity/user_entity.dart';
import 'package:venure/features/auth/domain/repository/user_repository.dart';
import 'package:venure/features/auth/domain/use_case/user_register_usecase.dart';

// Mocks & Fakes
class MockUserRepository extends Mock implements IUserRepository {}

class FakeUserEntity extends Fake implements UserEntity {}

void main() {
  late MockUserRepository mockUserRepository;
  late UserRegisterUsecase usecase;

  const testName = 'John Doe';
  const testEmail = 'john@example.com';
  const testPhone = '1234567890';
  const testPassword = 'password123';

  const params = RegisterUserParams(
    name: testName,
    email: testEmail,
    phone: testPhone,
    password: testPassword,
  );

  setUpAll(() {
    registerFallbackValue(FakeUserEntity());
  });

  setUp(() {
    mockUserRepository = MockUserRepository();
    usecase = UserRegisterUsecase(repository: mockUserRepository);
  });

  group('RegisterUserParams', () {
    test('should compare correctly with Equatable', () {
      const params1 = RegisterUserParams(
        name: testName,
        email: testEmail,
        phone: testPhone,
        password: testPassword,
      );

      const params2 = RegisterUserParams(
        name: testName,
        email: testEmail,
        phone: testPhone,
        password: testPassword,
      );

      expect(params1, params2);
      expect(params1.props, [testName, testEmail, testPhone, testPassword]);
    });

    test('should create initial params correctly', () {
      const initialParams = RegisterUserParams.initial(
        name: 'Init Name',
        email: 'init@example.com',
        phone: '0000000000',
        password: 'initPassword',
      );

      expect(initialParams.name, 'Init Name');
      expect(initialParams.email, 'init@example.com');
      expect(initialParams.phone, '0000000000');
      expect(initialParams.password, 'initPassword');
    });
  });

  group('UserRegisterUsecase', () {
    test('constructor should initialize properly', () {
      expect(usecase, isA<UserRegisterUsecase>());
    });

    test('should call repository.registerUser with correct UserEntity', () async {
      when(() => mockUserRepository.registerUser(any()))
          .thenAnswer((_) async => const Right(null));

      final result = await usecase(params);

      expect(result, const Right(null));
      verify(() => mockUserRepository.registerUser(any(
            that: isA<UserEntity>()
                .having((u) => u.name, 'name', testName)
                .having((u) => u.email, 'email', testEmail)
                .having((u) => u.phone, 'phone', testPhone)
                .having((u) => u.password, 'password', testPassword)
                .having((u) => u.token, 'token', '')
                .having((u) => u.role, 'role', ''),
          ))).called(1);
    });

    test('should return failure when repository fails', () async {
      final failure = ApiFailure(message: 'Registration failed');

      when(() => mockUserRepository.registerUser(any()))
          .thenAnswer((_) async => Left(failure));

      final result = await usecase(params);

      expect(result, Left(failure));
      verify(() => mockUserRepository.registerUser(any())).called(1);
    });
  });
}
