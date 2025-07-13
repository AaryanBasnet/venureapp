import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:venure/core/error/failure.dart';
import 'package:venure/features/auth/domain/use_case/user_register_usecase.dart';
import 'package:venure/features/auth/presentation/view_model/register_view_model/register_event.dart';
import 'package:venure/features/auth/presentation/view_model/register_view_model/register_state.dart';
import 'package:venure/features/auth/presentation/view_model/register_view_model/register_view_model.dart';

class MockRegisterUsecase extends Mock implements UserRegisterUsecase {}

class FakeRegisterParams extends Fake implements RegisterUserParams {}

void main() {
  late MockRegisterUsecase mockRegisterUsecase;
  late RegisterViewModel viewModel;

  const testName = 'Test User';
  const testPhone = '9876543210';
  const testEmail = 'test@example.com';
  const testPassword = 'password123';

  setUpAll(() {
    registerFallbackValue(FakeRegisterParams());
  });

  setUp(() {
    mockRegisterUsecase = MockRegisterUsecase();
    viewModel = RegisterViewModel(mockRegisterUsecase);
  });

  group('RegisterViewModel', () {
    blocTest<RegisterViewModel, RegisterState>(
      'emits [loading, success] when registration succeeds and calls onSuccess',
      build: () {
        when(() => mockRegisterUsecase(any()))
            .thenAnswer((_) async => const Right(unit));
        return viewModel;
      },
      act: (bloc) {
        bool onSuccessCalled = false;

        bloc.add(RegisterUserEvent(
          name: testName,
          phone: testPhone,
          email: testEmail,
          password: testPassword,
          context: FakeBuildContext(),
          onSuccess: () => onSuccessCalled = true,
        ));

        // Verify after bloc processed events
        Future.delayed(Duration.zero, () {
          expect(onSuccessCalled, isTrue);
        });
      },
      expect: () => [
        const RegisterState(isLoading: true, isSuccess: false, errorMessage: null),
        const RegisterState(isLoading: false, isSuccess: true, errorMessage: null),
      ],
      verify: (_) {
        verify(() => mockRegisterUsecase(any())).called(1);
      },
    );

    blocTest<RegisterViewModel, RegisterState>(
      'emits [loading, failure] when registration fails (no onSuccess call)',
      build: () {
        when(() => mockRegisterUsecase(any()))
            .thenAnswer((_) async => Left(ApiFailure(message: 'Server Error')));
        return viewModel;
      },
      act: (bloc) {
        bool onSuccessCalled = false;

        bloc.add(RegisterUserEvent(
          name: testName,
          phone: testPhone,
          email: testEmail,
          password: testPassword,
          context: FakeBuildContext(),
          onSuccess: () => onSuccessCalled = true,
        ));

        // Verify after bloc processed events
        Future.delayed(Duration.zero, () {
          expect(onSuccessCalled, isFalse);
        });
      },
      expect: () => [
        const RegisterState(isLoading: true, isSuccess: false, errorMessage: null),
        const RegisterState(isLoading: false, isSuccess: false, errorMessage: null),
      ],
      verify: (_) {
        verify(() => mockRegisterUsecase(any())).called(1);
      },
    );
  });
}

class FakeBuildContext extends Fake implements BuildContext {}
