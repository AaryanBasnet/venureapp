import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:venure/app/constant/shared_pref/local_storage_service.dart';
import 'package:venure/app/service_locator/service_locator.dart';
import 'package:venure/features/auth/domain/entity/user_entity.dart';
import 'package:venure/features/auth/domain/use_case/user_login_usecase.dart';
import 'package:venure/features/auth/presentation/view_model/login_view_model/login_event.dart';
import 'package:venure/features/auth/presentation/view_model/login_view_model/login_state.dart';

class LoginViewModel extends Bloc<LoginEvent, LoginState> {
  final UserLoginUsecase _loginUsecase;

  LoginViewModel(this._loginUsecase) : super(LoginState.initial()) {
    on<LoginIntoSystemEvent>(_handleLogin);
   
  }

  Future<void> _handleLogin(
    LoginIntoSystemEvent event,
    Emitter<LoginState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    final result = await _loginUsecase(
      LoginUserParams(email: event.email, password: event.password),
    );

    await result.fold(
      (failure) {
        emit(state.copyWith(isLoading: false, isSuccess: false, errorMessage: failure.message));
        
      },
      (UserEntity userEntity) async {
        emit(state.copyWith(isLoading: false, isSuccess: true));

        final localStorage = serviceLocator<LocalStorageService>();
        await localStorage.saveUser(userEntity);

         
      },
    );
  }

  
}
