import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:venure/app/service_locator/service_locator.dart';
import 'package:venure/app/theme/theme_data.dart';
import 'package:venure/features/auth/presentation/view/register_view.dart';
import 'package:venure/features/auth/presentation/view_model/register_view_model.dart';


class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Venure",
      debugShowCheckedModeBanner: false,
      theme: getApplicationTheme(),
      home: MultiBlocProvider(
        providers: [
          BlocProvider<RegisterViewModel>(
            create: (_) => serviceLocator<RegisterViewModel>(),
          ),
          // Future example:
          // BlocProvider<LoginViewModel>(
          //   create: (_) => serviceLocator<LoginViewModel>(),
          // ),
        ],
        child: RegisterView(),
      ),
    );
  }
}
