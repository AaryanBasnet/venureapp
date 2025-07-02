


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:venure/core/snackbar/my_snackbar.dart';
import 'package:venure/features/auth/domain/use_case/user_register_usecase.dart';
import 'package:venure/features/auth/presentation/view/login_view.dart';
import 'package:venure/features/auth/presentation/view_model/register_event.dart';
import 'package:venure/features/auth/presentation/view_model/register_state.dart';

class RegisterViewModel extends Bloc<RegisterEvent, RegisterState> {

final UserRegisterUsecase _userRegisterUsecase;

RegisterViewModel(this._userRegisterUsecase) : super(RegisterState.initial()){
     on<NavigateToLoginView>(_onNavigateToLoginView);
         on<RegisterUserEvent>(_onRegisterUser);
}


  void _onNavigateToLoginView(
    NavigateToLoginView event,
    Emitter<RegisterState> emit,
  ) {
    if (event.context.mounted) {
      Navigator.push(
        event.context,
        MaterialPageRoute(builder: (_) => LoginView()),
      );
    }
  }

  Future<void> _onRegisterUser(
    RegisterUserEvent event,
    Emitter<RegisterState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    final result = await _userRegisterUsecase(
      RegisterUserParams(
        name: event.name,
        phone: event.phone,
        email: event.email,
        password: event.password,
      ),
    );

    result.fold(
      (l) {
        emit(state.copyWith(isLoading: false, isSuccess: false));
        showMySnackBar(
          context: event.context,
          message: l.message,
          color: Colors.red,
        );
      },
      (r) {
        emit(state.copyWith(isLoading: false, isSuccess: true));
        showMySnackBar(
          context: event.context,
          message: "Registration Successful",
        );
        event.onSuccess();
      },
    );

  }
}