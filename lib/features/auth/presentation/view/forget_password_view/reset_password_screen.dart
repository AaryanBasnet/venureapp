import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:venure/app/service_locator/service_locator.dart';
import 'package:venure/features/auth/domain/use_case/reset_password_usecase.dart';
import 'package:venure/features/auth/domain/use_case/send_rest_code_usecase.dart';
import 'package:venure/features/auth/domain/use_case/verify_reset_code_usecase.dart';
import 'package:venure/features/auth/presentation/view_model/forget_password_view_model/forget_password_event.dart';
import 'package:venure/features/auth/presentation/view_model/forget_password_view_model/forget_password_state.dart';
import 'package:venure/features/auth/presentation/view_model/forget_password_view_model/forget_password_view_model.dart';

class ResetPasswordScreen extends StatelessWidget {
  final String email;
  final String code;

  ResetPasswordScreen({Key? key, required this.email, required this.code})
    : super(key: key);

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

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
        appBar: AppBar(title: const Text("Reset Password")),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: _ResetPasswordForm(
              email: email,
              code: code,
              passwordController: _passwordController,
              confirmPasswordController: _confirmPasswordController,
            ),
          ),
        ),
      ),
    );
  }
}

class _ResetPasswordForm extends StatefulWidget {
  final String email;
  final String code;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;

  const _ResetPasswordForm({
    Key? key,
    required this.email,
    required this.code,
    required this.passwordController,
    required this.confirmPasswordController,
  }) : super(key: key);

  @override
  State<_ResetPasswordForm> createState() => _ResetPasswordFormState();
}

class _ResetPasswordFormState extends State<_ResetPasswordForm> {
  bool _isButtonEnabled = false;

  void _validatePasswords() {
    final isValid =
        widget.passwordController.text.isNotEmpty &&
        widget.passwordController.text == widget.confirmPasswordController.text;
    if (isValid != _isButtonEnabled) {
      setState(() {
        _isButtonEnabled = isValid;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    widget.passwordController.addListener(_validatePasswords);
    widget.confirmPasswordController.addListener(_validatePasswords);
  }

  @override
  void dispose() {
    widget.passwordController.removeListener(_validatePasswords);
    widget.confirmPasswordController.removeListener(_validatePasswords);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Set a new password for ${widget.email}"),
        const SizedBox(height: 8),
        TextField(
          controller: widget.passwordController,
          decoration: const InputDecoration(labelText: "New Password"),
          obscureText: true,
        ),
        const SizedBox(height: 8),
        TextField(
          controller: widget.confirmPasswordController,
          decoration: const InputDecoration(labelText: "Confirm Password"),
          obscureText: true,
        ),
        const SizedBox(height: 20),
        BlocConsumer<ForgotPasswordViewModel, ForgotPasswordState>(
          listener: (context, state) {
            if (state.success) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Password reset successful. Please login."),
                ),
              );
              Navigator.of(context).popUntil((route) => route.isFirst);
            }
            if (state.errorMessage != null) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
            }
          },
          builder: (context, state) {
            return SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed:
                    state.isLoading || !_isButtonEnabled
                        ? null
                        : () {
                          context.read<ForgotPasswordViewModel>().add(
                            ResetPasswordEvent(
                              widget.email,
                              widget.code,
                              widget.passwordController.text,
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
                        : const Text("Reset Password"),
              ),
            );
          },
        ),
      ],
    );
  }
}
