import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:venure/app/service_locator/service_locator.dart';
import 'package:venure/features/auth/domain/use_case/reset_password_usecase.dart';
import 'package:venure/features/auth/domain/use_case/send_rest_code_usecase.dart';
import 'package:venure/features/auth/domain/use_case/verify_reset_code_usecase.dart';
import 'package:venure/features/auth/presentation/view_model/forget_password_view_model/forget_password_event.dart';
import 'package:venure/features/auth/presentation/view_model/forget_password_view_model/forget_password_state.dart';
import 'package:venure/features/auth/presentation/view_model/forget_password_view_model/forget_password_view_model.dart';

// Import ResetPasswordScreen here:
import 'reset_password_screen.dart';

class VerifyResetCodeScreen extends StatelessWidget {
  final String email;

  VerifyResetCodeScreen({super.key, required this.email});

  final _codeController = TextEditingController();

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
        appBar: AppBar(title: const Text("Verify Reset Code")),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Enter the reset code sent to $email"),
                const SizedBox(height: 8),
                TextField(
                  controller: _codeController,
                  decoration: const InputDecoration(labelText: "Reset Code"),
                ),
                const SizedBox(height: 20),
                BlocConsumer<ForgotPasswordViewModel, ForgotPasswordState>(
                  listener: (context, state) {
                    if (state.success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Code verified! Please set new password.",
                          ),
                        ),
                      );

                      // Navigate via widget and pass arguments directly:
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => ResetPasswordScreen(
                                email: email,
                                code: _codeController.text.trim(),
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
                                    VerifyResetCodeEvent(
                                      email,
                                      _codeController.text.trim(),
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
                                : const Text("Verify Code"),
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
