import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:venure/core/common/common_text_form_field.dart';
import 'package:venure/features/auth/presentation/view/login_wrapper.dart';
import 'package:venure/features/auth/presentation/view_model/register_view_model/register_event.dart';
import 'package:venure/features/auth/presentation/view_model/register_view_model/register_state.dart';
import 'package:venure/features/auth/presentation/view_model/register_view_model/register_view_model.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  static const Color primaryColor = Color(0xFFE11D48);
  static const Color lightGray = Color(0xFFF1F5F9);

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final phoneController = TextEditingController();
    final passwordController = TextEditingController();
    final _formKey = GlobalKey<FormState>();

    return BlocBuilder<RegisterViewModel, RegisterState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Image.asset(
                        'assets/img/app-icon.png',
                        height: 90,
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: 16),
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
                    const SizedBox(height: 4),
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

                    // Fields
                    CommonTextFormField(
                      label: "Full Name",
                      icon: Icons.person_outline,
                      color: primaryColor,
                      controller: nameController,
                      validator:
                          (value) => value!.isEmpty ? 'Enter full name' : null,
                      onChanged: (_) {},
                    ),
                    const SizedBox(height: 20),

                    CommonTextFormField(
                      label: "Email",
                      icon: Icons.email_outlined,
                      color: primaryColor,
                      controller: emailController,
                      validator:
                          (value) =>
                              value!.contains('@')
                                  ? null
                                  : 'Enter a valid email',
                      onChanged: (_) {},
                    ),
                    const SizedBox(height: 20),

                    CommonTextFormField(
                      label: "Phone Number",
                      icon: Icons.phone_outlined,
                      color: primaryColor,
                      controller: phoneController,
                      validator:
                          (value) =>
                              value!.length < 10
                                  ? 'Enter valid phone number'
                                  : null,
                      onChanged: (_) {},
                    ),
                    const SizedBox(height: 20),

                    CommonTextFormField(
                      label: "Password",
                      icon: Icons.lock_outline,
                      color: primaryColor,
                      obsecure: true,
                      controller: passwordController,
                      validator:
                          (value) =>
                              value!.length < 6 ? 'Password too short' : null,
                      onChanged: (_) {},
                    ),
                    const SizedBox(height: 30),

                    // Register button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed:
                            state.isLoading
                                ? null
                                : () {
                                  if (_formKey.currentState!.validate()) {
                                    context.read<RegisterViewModel>().add(
                                      RegisterUserEvent(
                                        name: nameController.text,
                                        phone: phoneController.text,
                                        email: emailController.text,
                                        password: passwordController.text,
                                        context: context,
                                        onSuccess: () {},
                                      ),
                                    );
                                  }
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
                                  "Sign Up",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Login link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Already have an account? ",
                          style: TextStyle(fontSize: 15),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const LoginWrapper(),
                              ),
                            );
                          },
                          child: const Text(
                            "Log In!",
                            style: TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                              fontSize: 16,
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
        );
      },
    );
  }
}
