// import 'package:flutter/material.dart';
// import 'package:venure/core/common/common_text_form_field.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();

//   static const Color primaryColor = Color(0xFF3B2063);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 15),
//             child: Column(
//               children: [
//                 Center(
//                   child: Image.asset(
//                     'assets/img/logo_nobg.png',
//                     fit: BoxFit.contain,
//                     width: 200,
//                   ),
//                 ),
//                 const SizedBox(height: 30),

//                 Align(
//                   alignment: Alignment.centerLeft,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: const [
//                       Text(
//                         "Sign in to your account!",
//                         style: TextStyle(
//                           fontSize: 32,
//                           fontWeight: FontWeight.w500,
//                           color: primaryColor,
//                         ),
//                       ),
//                       SizedBox(height: 8),
//                       Text(
//                         "Enter your email and password to login!",
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.w300,
//                         ),
//                       ),
//                       SizedBox(height: 20),
//                     ],
//                   ),
//                 ),

//                 // Email Field
//                 CommonTextFormField(
//                   label: "Email",
//                   icon: Icons.email,
//                   color: primaryColor,
//                   controller: emailController,
//                 ),

//                 const SizedBox(height: 20),

//                 // Password Field
//                 CommonTextFormField(
//                   label: "Password",
//                   icon: Icons.lock,
//                   color: primaryColor,
//                   obsecure: true,
//                   controller: passwordController,
//                 ),

//                 const SizedBox(height: 10),

//                 Align(
//                   alignment: Alignment.centerRight,
//                   child: TextButton(
//                     onPressed: () {},
//                     child: const Text(
//                       "Forgot password?",
//                       style: TextStyle(
//                         fontSize: 18,
//                         color: primaryColor,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ),
//                 ),

//                 const SizedBox(height: 25),

//                 SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton(
//                     onPressed: () {
//                       if (emailController.text == "admin@gmail.com" &&
//                           passwordController.text == "Admin123") {
//                         debugPrint("correct");
//                         Navigator.pushReplacementNamed(
//                           context,
//                           '/dashboardScreen',
//                         );
//                       } else {
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           const SnackBar(
//                             content: Text("Invalid email or password"),
//                             backgroundColor: Colors.red,
//                             duration: Duration(seconds: 2),
//                           ),
//                         );
//                       }
//                     },

//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: primaryColor,
//                     ),
//                     child: const Text(
//                       "Login",
//                       style: TextStyle(color: Colors.white, fontSize: 28),
//                     ),
//                   ),
//                 ),

//                 const SizedBox(height: 20),

//                 const Text("OR", style: TextStyle(fontSize: 28)),
//                 const SizedBox(height: 20),

//                 SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton(
//                     onPressed: () {
//                       debugPrint('Google login button pressed');
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.white,
//                       side: BorderSide(color: primaryColor),
//                     ),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Image.asset("assets/img/google_logo.png"),
//                         const SizedBox(width: 20),
//                         const Text(
//                           "Login with Google",
//                           style: TextStyle(fontSize: 22, color: primaryColor),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),

//                 const SizedBox(height: 40),

//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const Text("Don't have an account? "),
//                     TextButton(
//                       onPressed: () {
//                         Navigator.pushReplacementNamed(context, '/signup');
//                       },
//                       child: const Text(
//                         "Sign Up!",
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           decoration: TextDecoration.underline,
//                           fontSize: 18,
//                           color: primaryColor,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
