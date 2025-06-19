class LoginState {
  final bool isLoading;
  final bool isSuccess;
    final String? errorMessage;

  LoginState({
    required this.isLoading,
    required this.isSuccess,
    this.errorMessage,
    
  });
  LoginState.initial()
    : isLoading = false,
      isSuccess = false,
      errorMessage = null;

  LoginState copyWith({
    bool? isLoading,
    bool? isSuccess,
    String? errorMessage,
  }) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}