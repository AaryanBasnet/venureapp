import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:venure/core/common/common_text_form_field.dart';
import 'package:venure/features/auth/presentation/view/register_wrapper.dart';
import 'package:venure/features/auth/presentation/view_model/login_view_model/login_event.dart';
import 'package:venure/features/auth/presentation/view_model/login_view_model/login_state.dart';
import 'package:venure/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:venure/features/auth/presentation/view_model/register_view_model/register_view_model.dart';

class LoginView extends StatelessWidget {
  final RegisterViewModel? registerViewModel;

  const LoginView({super.key, this.registerViewModel});

  static const Color primaryColor = Color(0xFF3B2063);

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLogo(),
              const SizedBox(height: 30),
              _buildTitle(),
              const SizedBox(height: 20),
              CommonTextFormField(
                label: "Email",
                icon: Icons.email,
                color: primaryColor,
                controller: emailController,
                onChanged: (String) {},
              ),
              const SizedBox(height: 20),
              CommonTextFormField(
                label: "Password",
                icon: Icons.lock,
                obsecure: true,
                color: primaryColor,
                controller: passwordController,
                onChanged: (String) {},
              ),
              const SizedBox(height: 10),
              _buildForgotPassword(),
              const SizedBox(height: 25),
              _buildLoginButton(context, emailController, passwordController),
              const SizedBox(height: 20),
              _buildGoogleLoginButton(),
              const SizedBox(height: 40),
              _buildSignUpText(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Center(
      child: Image.asset(
        'assets/img/logo_nobg.png',
        fit: BoxFit.contain,
        width: 200,
      ),
    );
  }

  Widget _buildTitle() {
    return const Text(
      "Sign in to your account!",
      style: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: primaryColor,
      ),
    );
  }

  Widget _buildForgotPassword() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () async {
          // TODO: Implement Forgot Password logic here
        },
        child: const Text(
          "Forgot password?",
          style: TextStyle(
            fontSize: 16,
            color: primaryColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton(
    BuildContext context,
    TextEditingController emailController,
    TextEditingController passwordController,
  ) {
    return BlocBuilder<LoginViewModel, LoginState>(
      builder: (context, state) {
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: state.isLoading
                ? null
                : () async {
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
            ),
            child: state.isLoading
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
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        );
      },
    );
  }

  Widget _buildGoogleLoginButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () async {
          debugPrint('Google login button pressed');
          // TODO: Implement Google login logic here
        },
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: primaryColor),
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/img/google_logo.png", height: 24),
            const SizedBox(width: 12),
            const Text(
              "Login with Google",
              style: TextStyle(fontSize: 18, color: primaryColor),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSignUpText(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have an account? "),
        TextButton(
          onPressed: () async {
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => RegisterWrapper(
                  registerViewModel: registerViewModel,
                ),
              ),
            );
          },
          child: const Text(
            "Sign Up!",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
              fontSize: 18,
              color: primaryColor,
            ),
          ),
        ),
      ],
    );
  }
}
