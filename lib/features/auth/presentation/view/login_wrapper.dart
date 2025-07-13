import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:venure/features/auth/domain/use_case/user_login_usecase.dart';
import 'package:venure/features/auth/presentation/view/login_view.dart';
import 'package:venure/features/auth/presentation/view_model/login_view_model/login_state.dart';
import 'package:venure/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:venure/app/service_locator/service_locator.dart';
import 'package:venure/features/common/presentation/view/venure_main_screen.dart';
import 'package:venure/features/common/presentation/view_model/navigation_cubit.dart';

class LoginWrapper extends StatelessWidget {
  final UserLoginUsecase? loginUsecase;

  const LoginWrapper({this.loginUsecase, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginViewModel>(
      create: (_) => LoginViewModel(
        loginUsecase ?? serviceLocator<UserLoginUsecase>(),
      ),
      child: BlocListener<LoginViewModel, LoginState>(
        listener: (context, state) {
          if (state.isSuccess) {
            _handleSuccess(context);
          } else if (!state.isLoading && state.errorMessage != null) {
            _handleError(context, state.errorMessage!);
          }
        },
        child: const LoginView(),
      ),
    );
  }

  void _handleSuccess(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Login successful!'),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => NavigationCubit(),
          child: const VenureMainScreen(),
        ),
      ),
      (route) => false,
    );
  }

  void _handleError(BuildContext context, String errorMessage) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
    );
  }
}
