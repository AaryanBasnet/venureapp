import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:venure/features/auth/domain/use_case/reset_password_usecase.dart';

import 'package:venure/features/auth/domain/use_case/send_rest_code_usecase.dart';
import 'package:venure/features/auth/domain/use_case/verify_reset_code_usecase.dart';
import 'package:venure/features/auth/presentation/view_model/forget_password_view_model/forget_password_event.dart';
import 'package:venure/features/auth/presentation/view_model/forget_password_view_model/forget_password_state.dart';

class ForgotPasswordViewModel
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  final SendResetCodeUseCase sendResetCodeUseCase;
  final VerifyResetCodeUseCase verifyResetCodeUseCase;
  final ResetPasswordUseCase resetPasswordUseCase;

  ForgotPasswordViewModel({
    required this.sendResetCodeUseCase,
    required this.verifyResetCodeUseCase,
    required this.resetPasswordUseCase,
  }) : super(ForgotPasswordState.initial()) {
    on<SendResetCodeEvent>(_onSendResetCode);
    on<VerifyResetCodeEvent>(_onVerifyResetCode);
    on<ResetPasswordEvent>(_onResetPassword);
  }

  Future<void> _onSendResetCode(
    SendResetCodeEvent event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    final result = await sendResetCodeUseCase(event.email);
    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (_) => emit(state.copyWith(isLoading: false, success: true)),
    );
  }

  Future<void> _onVerifyResetCode(
    VerifyResetCodeEvent event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    final result = await verifyResetCodeUseCase(event.email, event.code);
    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (_) => emit(state.copyWith(isLoading: false, success: true)),
    );
  }

  Future<void> _onResetPassword(
    ResetPasswordEvent event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    final result = await resetPasswordUseCase(
      email: event.email,
      code: event.code,
      newPassword: event.newPassword,
    );
    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (_) => emit(state.copyWith(isLoading: false, success: true)),
    );
  }
}
