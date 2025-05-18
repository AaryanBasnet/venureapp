import 'package:flutter/material.dart';
import 'package:venure/view/home_screen.dart';
import 'package:venure/view/login_screen.dart';
import 'package:venure/view/signup_screen.dart';
import 'package:venure/view/splash_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignupScreen(),
        '/homeScreen': (context) => Homescreen(),
      },
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Dosis'),
    );
  }
}
