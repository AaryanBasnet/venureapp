import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:venure/app/service_locator/service_locator.dart';
import 'package:venure/app/theme/theme_data.dart';
import 'package:venure/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:venure/features/auth/presentation/view_model/register_view_model.dart';
import 'package:venure/features/home/presentation/view_model/home_view_model.dart';
import 'package:venure/features/splash/presentation/view/splash_view.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<RegisterViewModel>(
          create: (_) => serviceLocator<RegisterViewModel>(),
        ),
        BlocProvider<LoginViewModel>(
          create: (_) => serviceLocator<LoginViewModel>(),
        ),
        BlocProvider<HomeScreenBloc>(
          create: (_) => serviceLocator<HomeScreenBloc>(),
        ),
      ],
      child: MaterialApp(
        title: "Venure",
        debugShowCheckedModeBanner: false,
        theme: getApplicationTheme(),
        home: SplashView(), // Start from LoginScreen
      ),
    );
  }
}
