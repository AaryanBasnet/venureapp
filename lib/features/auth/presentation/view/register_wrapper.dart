import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:venure/core/snackbar/my_snackbar.dart';
import 'package:venure/features/auth/domain/use_case/user_register_usecase.dart'; // <-- Add this import
import 'package:venure/features/auth/presentation/view/login_wrapper.dart';
import 'package:venure/features/auth/presentation/view/register_view.dart';
import 'package:venure/features/auth/presentation/view_model/register_view_model/register_state.dart';
import 'package:venure/features/auth/presentation/view_model/register_view_model/register_view_model.dart';
import 'package:venure/app/service_locator/service_locator.dart';

class RegisterWrapper extends StatelessWidget {
  final RegisterViewModel? registerViewModel;
  final UserRegisterUsecase? registerUsecase; // <-- Add this

  const RegisterWrapper({super.key, this.registerViewModel, this.registerUsecase});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RegisterViewModel>(
      create: (_) => registerViewModel ??
          RegisterViewModel(registerUsecase ?? serviceLocator<UserRegisterUsecase>()), // <-- Pass use case here
      child: BlocListener<RegisterViewModel, RegisterState>(
        listener: (context, state) {
          if (!state.isLoading && state.isSuccess) {
            showMySnackBar(
              context: context,
              message: "Registration Successful",
              color: Colors.green,
            );

            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const LoginWrapper()),
              (route) => false,
            );
          } else if (!state.isLoading &&
              !state.isSuccess &&
              state.errorMessage != null) {
            showMySnackBar(
              context: context,
              message: state.errorMessage!,
              color: Colors.red,
            );
          }
        },
        child: const RegisterView(),
      ),
    );
  }
}
