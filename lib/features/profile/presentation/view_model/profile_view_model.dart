import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:venure/app/constant/shared_pref/local_storage_service.dart';
import 'package:venure/app/service_locator/service_locator.dart';
import 'package:venure/features/auth/presentation/view/login_wrapper.dart';
import 'package:venure/features/profile/presentation/view_model/profile_event.dart';
import 'package:venure/features/profile/presentation/view_model/profile_state.dart';

class ProfileViewModel extends Bloc<ProfileEvent, ProfileState> {
  final LocalStorageService _storageService =
      serviceLocator<LocalStorageService>();

  ProfileViewModel() : super(ProfileState.initial()) {
    on<LoadUserProfile>(_onLoadUserProfile);
    on<LogoutUser>(_onLogoutUser);
  }

  void _onLoadUserProfile(
    LoadUserProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    final isLoggedIn = _storageService.isLoggedIn;

    if (isLoggedIn) {
      emit(
        state.copyWith(
          name: _storageService.name,
          email: _storageService.email,
          isLoggedIn: true,
          isLoading: false,
        ),
      );
    } else {
      emit(state.copyWith(isLoading: false));
    }
  }

  void _onLogoutUser(LogoutUser event, Emitter<ProfileState> emit) async {
    await _storageService.clearLoginData();
    if (event.context.mounted) {
      Navigator.push(
        event.context,
        MaterialPageRoute(builder: (_) => const LoginWrapper()),
      );
    }
  }
}

// void _navigateToDashboard(
//     NavigateToDashboardView event,
//     Emitter<LoginState> emit,
//   ) {
//     if (event.context.mounted) {
//       Navigator.push(
//         event.context,
//         MaterialPageRoute(builder: (_) => const HomeScreenWrapper()),
//       );
//     }
//   }
// }
