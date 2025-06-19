
import 'package:flutter/material.dart';

@immutable
sealed class RegisterEvent {}

class NavigateToLoginView extends RegisterEvent {
  final BuildContext context;
  final Widget destination;

  NavigateToLoginView({required this.context, required this.destination});
}

class RegisterUserEvent extends RegisterEvent {
  final BuildContext context;
  final String fullName;
  final String email;
  final String phone;
  final String password;
  final VoidCallback onSuccess;

  RegisterUserEvent({
    required this.context,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.password,
    required this.onSuccess
  });
}
