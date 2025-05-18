import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF3B2063);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
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

                // Email Field
                _buildField(
                  label: "Email",
                  icon: Icons.email,
                  color: primaryColor,
                  controller: emailController,
                  onChanged: (value) {},
                ),

                const SizedBox(height: 20),

                // Password Field
                _buildField(
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
                    onPressed: () {},
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

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/homeScreen');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                    ),
                    child: const Text(
                      "Login",
                      style: TextStyle(color: Colors.white, fontSize: 28),
                    ),
                  ),
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
                      side: BorderSide(color: primaryColor),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset("assets/img/google_logo.png"),
                        const SizedBox(width: 20),
                        const Text(
                          "Login ",
                          style: TextStyle(fontSize: 22, color: primaryColor),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                SizedBox(
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account? "),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/signup');
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
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField({
    required String label,
    required IconData icon,
    required Color color,
    bool obsecure = false,
    required TextEditingController controller,
    required ValueChanged<String> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: controller,
        obscureText: obsecure,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: color),
          filled: true,
          fillColor: const Color(
            0xFFF5F5F5,
          ), // Light grey background for inputs
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(color: color),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(color: color, width: 2),
          ),
        ),
        onChanged: onChanged,
      ),
    );
  }
}
