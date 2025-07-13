

import 'package:flutter/material.dart';

@immutable  
abstract class LoginEvent {}

// class NavigateToSignupView extends LoginEvent {
//   final BuildContext context;

//   NavigateToSignupView({required this.context});
// }

// class NavigateToDashboardView extends LoginEvent {
//   final BuildContext context;
//   final Widget destination;

//   NavigateToDashboardView({required this.context, required this.destination});
  
// }

class LoginIntoSystemEvent extends LoginEvent {
  final String email;
  final String password;

  LoginIntoSystemEvent({
    required this.email,
    required this.password,
  });
}


