import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:venure/app/constant/shared_pref/local_storage_service.dart';
import 'package:venure/app/constant/shared_pref/shared_preferences.dart';
import 'package:venure/app/service_locator/service_locator.dart';
import 'package:venure/core/snackbar/my_snackbar.dart';
import 'package:venure/features/auth/domain/use_case/user_login_usecase.dart';
import 'package:venure/features/auth/presentation/view/login_wrapper.dart';
import 'package:venure/features/auth/presentation/view/register_wrapper.dart';
import 'package:venure/features/auth/presentation/view_model/login_view_model/login_event.dart';
import 'package:venure/features/auth/presentation/view_model/login_view_model/login_state.dart';
import 'package:venure/features/common/presentation/view/venure_main_screen.dart';
import 'package:venure/features/common/presentation/view_model/navigation_cubit.dart';
import 'package:venure/features/home/presentation/view/home_screen_view.dart';
import 'package:venure/features/home/presentation/view/home_screen_wrapper.dart';

class LoginViewModel extends Bloc<LoginEvent, LoginState> {
  final UserLoginUsecase _loginUsecase;

  LoginViewModel(this._loginUsecase) : super(LoginState.initial()) {
    on<LoginIntoSystemEvent>(_handleLogin);
    on<NavigateToSignupView>(_navigateToSignup);
    on<NavigateToDashboardView>(_navigateToDashboard);
  }

  /// Handles login with email and password
 Future<void> _handleLogin(
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
        message: failure.message,
        color: Colors.red,
      );
    },
    (json) async {
      emit(state.copyWith(isLoading: false, isSuccess: true));

      // Store login data persistently
      final localStorage = serviceLocator<LocalStorageService>();
      await localStorage.saveLoginData(json);

      Navigator.pushAndRemoveUntil(
        event.context,
        MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => NavigationCubit(),
            child: VenureMainScreen(),
            
          ),
          
        ),
        (route) => false,
      );
    },
  );
}


  /// Navigates to the Register screen (using wrapper)
  void _navigateToSignup(NavigateToSignupView event, Emitter<LoginState> emit) {
    if (event.context.mounted) {
      Navigator.push(
        event.context,
        MaterialPageRoute(builder: (_) => const RegisterWrapper()),
      );
    }
  }

  /// Navigates to Dashboard/Home (used if required separately)
  void _navigateToDashboard(
    NavigateToDashboardView event,
    Emitter<LoginState> emit,
  ) {
    if (event.context.mounted) {
      Navigator.push(
        event.context,
        MaterialPageRoute(builder: (_) => const HomeScreenWrapper()),
      );
    }
  }
}
