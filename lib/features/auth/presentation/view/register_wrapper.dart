import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:venure/features/auth/presentation/view/register_view.dart';
import 'package:venure/features/auth/presentation/view_model/register_view_model/register_view_model.dart';
import 'package:venure/app/service_locator/service_locator.dart';

class RegisterWrapper extends StatelessWidget {
  const RegisterWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RegisterViewModel>(
      create: (_) => serviceLocator<RegisterViewModel>(),
      child: const RegisterView(),
    );
  }
}
