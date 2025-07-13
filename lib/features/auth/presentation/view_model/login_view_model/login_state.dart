import 'package:equatable/equatable.dart';
import 'package:venure/features/auth/domain/entity/user_entity.dart';

class LoginState extends Equatable {
  final bool isLoading;
  final bool isSuccess;
  final String? errorMessage;
  final UserEntity? user;

  const LoginState({
    required this.isLoading,
    required this.isSuccess,
    this.errorMessage,
    this.user,
  });

  factory LoginState.initial() {
    return const LoginState(
      isLoading: false,
      isSuccess: false,
      errorMessage: null,
      user: null,
    );
  }

  LoginState copyWith({
    bool? isLoading,
    bool? isSuccess,
    String? errorMessage,
    UserEntity? user,
  }) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage,
      user: user ?? this.user,
    );
  }

  @override
  List<Object?> get props => [isLoading, isSuccess, errorMessage, user];
}
