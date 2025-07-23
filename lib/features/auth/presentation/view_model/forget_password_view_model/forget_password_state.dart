
class ForgotPasswordState {
  final bool isLoading;
  final bool success;
  final String? errorMessage;

  ForgotPasswordState({
    this.isLoading = false,
    this.success = false,
    this.errorMessage,
  });

  ForgotPasswordState copyWith({
    bool? isLoading,
    bool? success,
    String? errorMessage,
  }) {
    return ForgotPasswordState(
      isLoading: isLoading ?? this.isLoading,
      success: success ?? this.success,
      errorMessage: errorMessage,
    );
  }

  factory ForgotPasswordState.initial() => ForgotPasswordState();
}