import 'package:flutter/material.dart';
import 'package:venure/app/theme/theme_data.dart';
import 'package:venure/features/splash/presentation/view/splash_view.dart';
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Venure",
      debugShowCheckedModeBanner: false,
      theme: getApplicationTheme(),
      home: const SplashView(),
    );
  }
}
