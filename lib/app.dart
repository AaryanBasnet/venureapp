import 'package:flutter/material.dart';
import 'package:venure/view/splash_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {'/': (context) => SplashScreen()},
      debugShowCheckedModeBanner: false,
    );
    
  }
}
