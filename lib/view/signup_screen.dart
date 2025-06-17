import 'package:flutter/material.dart';
import 'package:venure/core/common/common_text_form_field.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF3B2063);
    // const accentColor = Color(0xFF7E57C2);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.asset('assets/img/logo_nobg.png', height: 80),
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

              // Full Name
              CommonTextFormField(
                label: "Full Name",
                icon: Icons.person,
                color: primaryColor,
                controller: fullNameController,
                onChanged: (value) {},
              ),

              // Email
              CommonTextFormField(
                label: "Email",
                icon: Icons.email,
                color: primaryColor,
                controller: emailController,
                onChanged: (value) {},
              ),

              // Phone Number
              CommonTextFormField(
                label: "Phone Number",
                icon: Icons.phone,
                color: primaryColor,
                controller: phoneNumberController,
                onChanged: (value) {},
              ),

              // Password
              CommonTextFormField(
                label: "Password",
                icon: Icons.lock,
                color: primaryColor,
                controller: passwordController,
                obsecure: true,
                onChanged: (value) {},
              ),

              // Confirm Password
              CommonTextFormField(
                label: "Confirm Password",
                icon: Icons.lock_outline,
                color: primaryColor,
                controller: confirmPasswordController,
                obsecure: true,
                onChanged: (value) {},
              ),

              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 5,
                  ),
                  child: const Text(
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
              SizedBox(
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account? "),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/login');
                      },
                      child: const Text(
                        "Log In!",
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
