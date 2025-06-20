import 'dart:async';
import 'package:flutter/material.dart';
import 'package:venure/features/auth/presentation/view/login_view.dart';

class SplashViewModel {
  void navigateAfterDelay(BuildContext context) {
    Future.delayed(const Duration(seconds: 6), () {
      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) =>  LoginView(), 
          ),
        );
      }
    });
  }
}
