import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:venure/app/service_locator/service_locator.dart';
import 'package:venure/features/auth/domain/use_case/reset_password_usecase.dart';
import 'package:venure/features/auth/domain/use_case/send_rest_code_usecase.dart';
import 'package:venure/features/auth/domain/use_case/verify_reset_code_usecase.dart';
import 'package:venure/features/auth/presentation/view_model/forget_password_view_model/forget_password_event.dart';
import 'package:venure/features/auth/presentation/view_model/forget_password_view_model/forget_password_state.dart';
import 'package:venure/features/auth/presentation/view_model/forget_password_view_model/forget_password_view_model.dart';

import 'verify_reset_code_screen.dart';

class ForgotPasswordScreen extends StatelessWidget {
  ForgotPasswordScreen({super.key});

  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ForgotPasswordViewModel>(
      create:
          (_) => ForgotPasswordViewModel(
            sendResetCodeUseCase: serviceLocator<SendResetCodeUseCase>(),
            verifyResetCodeUseCase: serviceLocator<VerifyResetCodeUseCase>(),
            resetPasswordUseCase: serviceLocator<ResetPasswordUseCase>(),
          ),
      child: Scaffold(
        appBar: AppBar(title: const Text("Forgot Password")),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Enter your email to receive reset code"),
                const SizedBox(height: 8),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: "Email"),
                ),
                const SizedBox(height: 20),
                BlocConsumer<ForgotPasswordViewModel, ForgotPasswordState>(
                  listener: (context, state) {
                    if (state.success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Reset code sent! Check your email"),
                        ),
                      );
                      // Navigate using widget, passing the email:
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => VerifyResetCodeScreen(
                                email: _emailController.text.trim(),
                              ),
                        ),
                      );
                    }
                    if (state.errorMessage != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.errorMessage!)),
                      );
                    }
                  },
                  builder: (context, state) {
                    return SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed:
                            state.isLoading
                                ? null
                                : () {
                                  context.read<ForgotPasswordViewModel>().add(
                                    SendResetCodeEvent(
                                      _emailController.text.trim(),
                                    ),
                                  );
                                },
                        child:
                            state.isLoading
                                ? const SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.5,
                                  ),
                                )
                                : const Text("Send Reset Code"),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
