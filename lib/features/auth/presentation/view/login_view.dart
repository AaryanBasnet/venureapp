import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:venure/core/common/common_text_form_field.dart';
import 'package:venure/features/auth/domain/use_case/user_login_usecase.dart';
import 'package:venure/features/auth/presentation/view/register_view.dart';
import 'package:venure/features/auth/presentation/view_model/login_view_model/login_event.dart';
import 'package:venure/features/auth/presentation/view_model/login_view_model/login_state.dart';
import 'package:venure/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:venure/app/service_locator/service_locator.dart';

class LoginView extends StatelessWidget {
  static const Color primaryColor = Color(0xFF3B2063);

  LoginView({super.key});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginViewModel>(
      create: (_) => LoginViewModel(serviceLocator<UserLoginUsecase>()),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: BlocListener<LoginViewModel, LoginState>(
            listener: (context, state) {
              if (state.isSuccess) {
                // Show success snackbar
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Login successful!'),
                    backgroundColor: Colors.green,
                  ),
                );
                // Navigator.pushReplacement(
                //   context,
                //   MaterialPageRoute(builder: (_) => LoginView()),
                // );
              }
              if (!state.isSuccess &&
                  !state.isLoading &&
                  state.errorMessage != null) {
                // Show error snackbar
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.errorMessage!),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 15),
              child: Column(
                children: [
                  Center(
                    child: Image.asset(
                      'assets/img/logo_nobg.png',
                      fit: BoxFit.contain,
                      width: 200,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Sign in to your account!",
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w500,
                            color: primaryColor,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Enter your email and password to login!",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                  CommonTextFormField(
                    label: "Email",
                    icon: Icons.email,
                    color: primaryColor,
                    controller: emailController,
                    onChanged: (value) {},
                  ),
                  const SizedBox(height: 20),
                  CommonTextFormField(
                    label: "Password",
                    icon: Icons.lock,
                    color: primaryColor,
                    obsecure: true,
                    controller: passwordController,
                    onChanged: (value) {},
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        // TODO: Implement forgot password
                      },
                      child: const Text(
                        "Forgot password?",
                        style: TextStyle(
                          fontSize: 18,
                          color: primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  BlocBuilder<LoginViewModel, LoginState>(
                    builder: (context, state) {
                      return SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed:
                              state.isLoading
                                  ? null
                                  : () {
                                    // Dispatch login event
                                    context.read<LoginViewModel>().add(
                                      LoginIntoSystemEvent(
                                        email: emailController.text.trim(),
                                        password: passwordController.text,
                                        context: context,
                                      ),
                                    );
                                  },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
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
                                      fontSize: 28,
                                    ),
                                  ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  const Text("OR", style: TextStyle(fontSize: 28)),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        debugPrint('Google login button pressed');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        side: const BorderSide(color: primaryColor),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset("assets/img/google_logo.png"),
                          const SizedBox(width: 20),
                          const Text(
                            "Login with Google",
                            style: TextStyle(fontSize: 22, color: primaryColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account? "),
                      TextButton(
                        onPressed:
                            () => context.read<LoginViewModel>().add(
                              NavigateToSignupView(
                                context: context,
                                destination: RegisterView(),
                              ),
                            ),
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
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
