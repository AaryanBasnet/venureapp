import 'dart:io';

import 'package:flutter/material.dart';

@immutable
sealed class RegisterEvent {}

class RegisterUserEvent extends RegisterEvent {
  final BuildContext context;
  final String fullName;
  final String email;
  final String phone;
  final String password;

  RegisterUserEvent({
    required this.context,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.password,
  });
}
