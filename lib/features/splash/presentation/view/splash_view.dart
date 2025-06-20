import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:venure/features/splash/presentation/view_model/splash_view_model.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  final SplashViewModel viewModel = SplashViewModel();

  @override
  void initState() {
    super.initState();
    viewModel.navigateAfterDelay(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Or your brand color
      body: Center(
        child: Lottie.asset(
          "assets/animation/splash_animation.json",
          width: 250,
          height: 250,
          fit: BoxFit.contain,
          frameRate: FrameRate.max,
        ),

        // ch
        // child: Lottie.network(
        //   "https://lottie.host/3034d92d-ed86-475d-835c-568f42c3ca33/GKD1C4zMX5.json",
        //   width: 250,
        //   height: 250,
        //   fit: BoxFit.contain,
        //   frameRate: FrameRate.max,
        //   errorBuilder: (context, error, stackTrace) {
        //     return const CircularProgressIndicator(); // fallback
        //   },
        // ),
      ),
    );
  }
}
