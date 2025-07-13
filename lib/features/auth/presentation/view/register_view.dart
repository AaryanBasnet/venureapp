import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:venure/core/common/common_text_form_field.dart';
import 'package:venure/features/auth/presentation/view_model/register_view_model/register_event.dart';
import 'package:venure/features/auth/presentation/view_model/register_view_model/register_state.dart';
import 'package:venure/features/auth/presentation/view_model/register_view_model/register_view_model.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  static const primaryColor = Color(0xFF3B2063);

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final phoneNumberController = TextEditingController();
    final passwordController = TextEditingController();
    final _formKey = GlobalKey<FormState>();

    return BlocBuilder<RegisterViewModel, RegisterState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 40),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Image.asset(
                        'assets/img/logo_nobg.png',
                        height: 80,
                      ),
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      "Create Your Account",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Your perfect venue, just a click away!",
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                    const SizedBox(height: 30),
                    CommonTextFormField(
                      label: "Full Name",
                      icon: Icons.person,
                      color: primaryColor,
                      controller: nameController,
                      validator: (value) =>
                          value!.isEmpty ? 'Enter full name' : null,
                      onChanged: (_) {},
                    ),
                    const SizedBox(height: 20),
                    CommonTextFormField(
                      label: "Email",
                      icon: Icons.email,
                      color: primaryColor,
                      controller: emailController,
                      validator: (value) => value!.contains('@')
                          ? null
                          : 'Enter a valid email',
                      onChanged: (_) {},
                    ),
                    const SizedBox(height: 20),
                    CommonTextFormField(
                      label: "Phone Number",
                      icon: Icons.phone,
                      color: primaryColor,
                      controller: phoneNumberController,
                      validator: (value) => value!.length < 10
                          ? 'Enter valid phone number'
                          : null,
                      onChanged: (_) {},
                    ),
                    const SizedBox(height: 20),
                    CommonTextFormField(
                      label: "Password",
                      icon: Icons.lock,
                      color: primaryColor,
                      controller: passwordController,
                      obsecure: true,
                      validator: (value) =>
                          value!.length < 6 ? 'Password too short' : null,
                      onChanged: (_) {},
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: state.isLoading
                            ? null
                            : () {
                                if (_formKey.currentState!.validate()) {
                                  context.read<RegisterViewModel>().add(
                                        RegisterUserEvent(
                                          name: nameController.text,
                                          phone: phoneNumberController.text,
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
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 5,
                        ),
                        child: state.isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
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
                    const SizedBox(height: 20),
                    Center(
                      child: GestureDetector(
                        key: const Key('login_navigator'), // For test
                        onTap: () {
                          Navigator.of(context).pushNamed('/login');
                        },
                        child: Text.rich(
                          TextSpan(
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                            children: [
                              const TextSpan(
                                text: 'Already have an account? ',
                              ),
                              TextSpan(
                                text: 'Log In!',
                                style: const TextStyle(
                                  color: primaryColor,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
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
