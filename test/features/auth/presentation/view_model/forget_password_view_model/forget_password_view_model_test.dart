import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:venure/core/error/failure.dart';
import 'package:venure/features/auth/domain/use_case/reset_password_usecase.dart';
import 'package:venure/features/auth/domain/use_case/send_rest_code_usecase.dart';
import 'package:venure/features/auth/domain/use_case/verify_reset_code_usecase.dart';
import 'package:venure/features/auth/presentation/view_model/forget_password_view_model/forget_password_event.dart';
import 'package:venure/features/auth/presentation/view_model/forget_password_view_model/forget_password_state.dart';
import 'package:venure/features/auth/presentation/view_model/forget_password_view_model/forget_password_view_model.dart';

class MockSendResetCodeUseCase extends Mock implements SendResetCodeUseCase {}

class MockVerifyResetCodeUseCase extends Mock
    implements VerifyResetCodeUseCase {}

class MockResetPasswordUseCase extends Mock implements ResetPasswordUseCase {}

void main() {
  late MockSendResetCodeUseCase mockSendResetCodeUseCase;
  late MockVerifyResetCodeUseCase mockVerifyResetCodeUseCase;
  late MockResetPasswordUseCase mockResetPasswordUseCase;
  late ForgotPasswordViewModel bloc;

  const tEmail = 'test@example.com';
  const tCode = '123456';
  const tNewPassword = 'NewPass@123';
  final tFailure = ApiFailure(message: 'Something went wrong');

  setUp(() {
    mockSendResetCodeUseCase = MockSendResetCodeUseCase();
    mockVerifyResetCodeUseCase = MockVerifyResetCodeUseCase();
    mockResetPasswordUseCase = MockResetPasswordUseCase();

    bloc = ForgotPasswordViewModel(
      sendResetCodeUseCase: mockSendResetCodeUseCase,
      verifyResetCodeUseCase: mockVerifyResetCodeUseCase,
      resetPasswordUseCase: mockResetPasswordUseCase,
    );
  });

  group('ForgotPasswordViewModel', () {
    blocTest<ForgotPasswordViewModel, ForgotPasswordState>(
      'emits [loading, success] when SendResetCodeEvent succeeds',
      build: () {
        when(
          () => mockSendResetCodeUseCase(tEmail),
        ).thenAnswer((_) async => const Right(null));
        return bloc;
      },
      act: (bloc) => bloc.add(SendResetCodeEvent(tEmail)),
      expect:
          () => [
            ForgotPasswordState.initial().copyWith(
              isLoading: true,
              errorMessage: null,
            ),
            ForgotPasswordState.initial().copyWith(
              isLoading: false,
              success: true,
            ),
          ],
      verify: (_) {
        verify(() => mockSendResetCodeUseCase(tEmail)).called(1);
      },
    );

    blocTest<ForgotPasswordViewModel, ForgotPasswordState>(
      'emits [loading, error] when SendResetCodeEvent fails',
      build: () {
        when(
          () => mockSendResetCodeUseCase(tEmail),
        ).thenAnswer((_) async => Left(tFailure));
        return bloc;
      },
      act: (bloc) => bloc.add(SendResetCodeEvent(tEmail)),
      expect:
          () => [
            ForgotPasswordState.initial().copyWith(
              isLoading: true,
              errorMessage: null,
            ),
            ForgotPasswordState.initial().copyWith(
              isLoading: false,
              errorMessage: tFailure.message,
            ),
          ],
    );

    blocTest<ForgotPasswordViewModel, ForgotPasswordState>(
      'emits [loading, success] when VerifyResetCodeEvent succeeds',
      build: () {
        when(
          () => mockVerifyResetCodeUseCase(tEmail, tCode),
        ).thenAnswer((_) async => const Right(null));
        return bloc;
      },
      act: (bloc) => bloc.add(VerifyResetCodeEvent(tEmail, tCode)),
      expect:
          () => [
            ForgotPasswordState.initial().copyWith(
              isLoading: true,
              errorMessage: null,
            ),
            ForgotPasswordState.initial().copyWith(
              isLoading: false,
              success: true,
            ),
          ],
    );

    blocTest<ForgotPasswordViewModel, ForgotPasswordState>(
      'emits [loading, error] when VerifyResetCodeEvent fails',
      build: () {
        when(
          () => mockVerifyResetCodeUseCase(tEmail, tCode),
        ).thenAnswer((_) async => Left(tFailure));
        return bloc;
      },
      act: (bloc) => bloc.add(VerifyResetCodeEvent(tEmail, tCode)),
      expect:
          () => [
            ForgotPasswordState.initial().copyWith(
              isLoading: true,
              errorMessage: null,
            ),
            ForgotPasswordState.initial().copyWith(
              isLoading: false,
              errorMessage: tFailure.message,
            ),
          ],
    );

    blocTest<ForgotPasswordViewModel, ForgotPasswordState>(
      'emits [loading, success] when ResetPasswordEvent succeeds',
      build: () {
        when(
          () => mockResetPasswordUseCase(
            email: tEmail,
            code: tCode,
            newPassword: tNewPassword,
          ),
        ).thenAnswer((_) async => const Right(null));
        return bloc;
      },
      act: (bloc) => bloc.add(ResetPasswordEvent(tEmail, tCode, tNewPassword)),
      expect:
          () => [
            ForgotPasswordState.initial().copyWith(
              isLoading: true,
              errorMessage: null,
            ),
            ForgotPasswordState.initial().copyWith(
              isLoading: false,
              success: true,
            ),
          ],
    );

    blocTest<ForgotPasswordViewModel, ForgotPasswordState>(
      'emits [loading, error] when ResetPasswordEvent fails',
      build: () {
        when(
          () => mockResetPasswordUseCase(
            email: tEmail,
            code: tCode,
            newPassword: tNewPassword,
          ),
        ).thenAnswer((_) async => Left(tFailure));
        return bloc;
      },
      act: (bloc) => bloc.add(ResetPasswordEvent(tEmail, tCode, tNewPassword)),
      expect:
          () => [
            ForgotPasswordState.initial().copyWith(
              isLoading: true,
              errorMessage: null,
            ),
            ForgotPasswordState.initial().copyWith(
              isLoading: false,
              errorMessage: tFailure.message,
            ),
          ],
    );
  });
}
