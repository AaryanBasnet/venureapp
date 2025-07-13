import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:venure/core/error/failure.dart';
import 'package:venure/features/auth/domain/entity/user_entity.dart';
import 'package:venure/features/auth/domain/use_case/user_login_usecase.dart';
import 'package:venure/features/auth/presentation/view_model/login_view_model/login_event.dart';
import 'package:venure/features/auth/presentation/view_model/login_view_model/login_state.dart';
import 'package:venure/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:venure/app/constant/shared_pref/local_storage_service.dart';

// Mocks
class MockUserLoginUsecase extends Mock implements UserLoginUsecase {}

class MockLocalStorageService extends Mock implements LocalStorageService {}

// Fake for LoginUserParams to allow any() matching
class FakeLoginUserParams extends Fake implements LoginUserParams {}

void main() {
  final sl = GetIt.instance;

  late MockUserLoginUsecase mockUsecase;
  late MockLocalStorageService mockLocalStorageService;
  late LoginViewModel loginViewModel;

  setUpAll(() {
    registerFallbackValue(FakeLoginUserParams());
  });

  setUp(() {
    mockUsecase = MockUserLoginUsecase();
    mockLocalStorageService = MockLocalStorageService();
    registerFallbackValue(FakeUserEntity());

    // Register or reset the LocalStorageService in GetIt
    if (sl.isRegistered<LocalStorageService>()) {
      sl.unregister<LocalStorageService>();
    }
    sl.registerSingleton<LocalStorageService>(mockLocalStorageService);

    loginViewModel = LoginViewModel(mockUsecase);
  });

  const testEmail = 'test@example.com';
  const testPassword = 'password123';

  final testUser = UserEntity(
    userId: '1',
    name: 'Test User',
    email: testEmail,
    phone: '1234567890',
    password: testPassword,
    token: 'token',
    role: 'user', 
  );

  blocTest<LoginViewModel, LoginState>(
    'emits [loading, success] when login succeeds',
    build: () {
      when(
        () => mockUsecase(
          LoginUserParams(email: testEmail, password: testPassword),
        ),
      ).thenAnswer((_) async => Right(testUser));

      when(
        () => mockLocalStorageService.saveUser(testUser),
      ).thenAnswer((_) async => Future.value());

      return loginViewModel;
    },
    act:
        (bloc) => bloc.add(
          LoginIntoSystemEvent(
            email: testEmail,
            password: testPassword,
          ),
        ),
    expect:
        () => [
          LoginState(isLoading: true, isSuccess: false, errorMessage: null),
          LoginState(isLoading: false, isSuccess: true, errorMessage: null),
        ],
    verify: (_) {
      verify(
        () => mockUsecase(
          LoginUserParams(email: testEmail, password: testPassword),
        ),
      ).called(1);

      verify(() => mockLocalStorageService.saveUser(testUser)).called(1);
    },
  );

  blocTest<LoginViewModel, LoginState>(
    'emits [loading, failure] when login fails',
    build: () {
      when(
        () => mockUsecase(
          LoginUserParams(email: testEmail, password: testPassword),
        ),
      ).thenAnswer((_) async => Left(ApiFailure(message: 'Login failed')));

      return loginViewModel;
    },
    act:
        (bloc) => bloc.add(
          LoginIntoSystemEvent(
            email: testEmail,
            password: testPassword,
          ),
        ),
    expect:
        () => [
          LoginState(isLoading: true, isSuccess: false, errorMessage: null),
          LoginState(
            isLoading: false,
            isSuccess: false,
            errorMessage: 'Login failed',
          ),
        ],
    verify: (_) {
      verify(
        () => mockUsecase(
          LoginUserParams(email: testEmail, password: testPassword),
        ),
      ).called(1);

      verifyNever(() => mockLocalStorageService.saveUser(any()));
    },
  );
}

// Minimal fake BuildContext for the event context parameter
class FakeBuildContext extends Fake implements BuildContext {}

class FakeUserEntity extends Fake implements UserEntity {}
