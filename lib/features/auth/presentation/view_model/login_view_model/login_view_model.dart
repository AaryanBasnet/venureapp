import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:venure/app/service_locator/service_locator.dart';
import 'package:venure/core/snackbar/my_snackbar.dart';
import 'package:venure/features/auth/domain/use_case/user_login_usecase.dart';
import 'package:venure/features/auth/presentation/view/register_view.dart';
import 'package:venure/features/auth/presentation/view_model/login_view_model/login_event.dart';
import 'package:venure/features/auth/presentation/view_model/login_view_model/login_state.dart';
import 'package:venure/features/auth/presentation/view_model/register_view_model.dart';
import 'package:venure/features/home/presentation/view/home_screen_view.dart';
import 'package:venure/features/home/presentation/view_model/home_view_model.dart';
import 'package:venure/view/home_screen.dart';

class LoginViewModel extends Bloc<LoginEvent, LoginState> {
  final UserLoginUsecase _loginUsecase;

  LoginViewModel(this._loginUsecase) : super(LoginState.initial()) {
    on<NavigateToSignupView>(_onNavigateToSignupView);
    on<LoginIntoSystemEvent>(_onLoginWithEmailAndPassword);
    on<NavigateToDashboardView>(_onNavigateToDashboardView);
  }

  void _onNavigateToSignupView(
    NavigateToSignupView event,
    Emitter<LoginState> emit,
  ) {
    if (event.context.mounted) {
      Navigator.push(
        event.context,
        MaterialPageRoute(
          builder:
              (context) => BlocProvider.value(
                value: serviceLocator<RegisterViewModel>(),
                child: RegisterView(),
              ),
        ),
      );
    }
  }

  void _onLoginWithEmailAndPassword(
    LoginIntoSystemEvent event,
    Emitter<LoginState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    final result = await _loginUsecase(
      LoginUserParams(email: event.email, password: event.password),
    );

    result.fold(
      (failure) {
        emit(state.copyWith(isLoading: false, isSuccess: false));

        showMySnackBar(
          context: event.context,
          message: 'Invalid credentials. Please try again.',
          color: Colors.red,
        );
      },
      (token) {
        emit(state.copyWith(isLoading: false, isSuccess: true));
        Navigator.pushAndRemoveUntil(
          event.context,
          MaterialPageRoute(builder: (_) => HomeScreenView()),
          (route) => false,
        );

        //to navigate to dashboard
        // Navigator.pushReplacementNamed(event.context, '/dashboard');

        // add(SomeNextEvent());

        // If no further action needed here, just remove the empty add()
      },
    );
  }

  void _onNavigateToDashboardView(
    NavigateToDashboardView event,
    Emitter<LoginState> emit,
  ) {
    if (event.context.mounted) {
      Navigator.push(
        event.context,
        MaterialPageRoute(
          builder:
              (context) => BlocProvider.value(
                value: serviceLocator<HomeScreenBloc>(),
                child: HomeScreenView(),
              ),
        ),
      );
    }
  }
}
