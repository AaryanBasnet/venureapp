
import 'package:flutter/material.dart';

@immutable
abstract class RegisterEvent {}

// class NavigateToLoginView extends RegisterEvent {
//   final BuildContext context;

//   NavigateToLoginView({required this.context});
// }

class RegisterUserEvent extends RegisterEvent {
  final BuildContext context;
  final String name;
  final String email;
  final String phone;
  final String password;
  final VoidCallback onSuccess;

  RegisterUserEvent({
    required this.context,
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
    required this.onSuccess
  });
}
