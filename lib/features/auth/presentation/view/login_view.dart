import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:venure/core/common/common_text_form_field.dart';
import 'package:venure/features/auth/presentation/view/forget_password_view/forget_password_screen.dart';
import 'package:venure/features/auth/presentation/view/register_wrapper.dart';
import 'package:venure/features/auth/presentation/view_model/login_view_model/login_event.dart';
import 'package:venure/features/auth/presentation/view_model/login_view_model/login_state.dart';
import 'package:venure/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:venure/features/auth/presentation/view_model/register_view_model/register_view_model.dart';

class LoginView extends StatelessWidget {
  final RegisterViewModel? registerViewModel;

  const LoginView({super.key, this.registerViewModel});

  static const Color primaryColor = Color(0xFFE11D48);
  static const Color lightGray = Color(0xFFF1F5F9);

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Image.asset('assets/img/app-icon.png', height: 80)),
              const Center(
                child: Text(
                  "VENURE",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 6,
                    color: primaryColor,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const Center(
                child: Text(
                  "Luxury • Redefined",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1.5,
                    color: Colors.grey,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              CommonTextFormField(
                label: "Email",
                icon: Icons.email_outlined,
                color: primaryColor,
                controller: emailController,
                onChanged: (_) {},
              ),
              const SizedBox(height: 20),
              CommonTextFormField(
                label: "Password",
                icon: Icons.lock_outline,
                obsecure: true,
                color: primaryColor,
                controller: passwordController,
                onChanged: (_) {},
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => ForgotPasswordScreen()),
                    );
                  },
                  child: const Text(
                    "Forgot password?",
                    style: TextStyle(fontSize: 14, color: primaryColor),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              BlocBuilder<LoginViewModel, LoginState>(
                builder: (context, state) {
                  return SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed:
                          state.isLoading
                              ? null
                              : () {
                                context.read<LoginViewModel>().add(
                                  LoginIntoSystemEvent(
                                    email: emailController.text.trim(),
                                    password: passwordController.text,
                                  ),
                                );
                              },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child:
                          state.isLoading
                              ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 3,
                                ),
                              )
                              : const Text(
                                "Login",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account? "),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => RegisterWrapper(
                                registerViewModel: registerViewModel,
                              ),
                        ),
                      );
                    },
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
