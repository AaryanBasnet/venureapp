import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:venure/app/constant/shared_pref/local_storage_service.dart';
import 'package:venure/features/auth/presentation/view/login_wrapper.dart';
import 'package:venure/features/profile/domain/use_case/get_profile_usecase.dart';
import 'package:venure/features/profile/domain/use_case/update_profile_usecase.dart';
import 'package:venure/features/profile/domain/use_case/update_profile_params.dart';
import 'package:venure/features/profile/data/data_source/local_data_source/profile_local_data_source.dart';
import 'package:venure/features/profile/data/model/user_profile_model.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileViewModel extends Bloc<ProfileEvent, ProfileState> {
  final GetProfileUseCase getProfileUseCase;
  final UpdateProfileUseCase updateProfileUseCase;
  final LocalStorageService _storageService;
  final ProfileLocalDataSource _localDataSource;

  ProfileViewModel({
    required this.getProfileUseCase,
    required this.updateProfileUseCase,
    required LocalStorageService storageService,
    required ProfileLocalDataSource localDataSource,
  }) : _storageService = storageService,
       _localDataSource = localDataSource,
       super(ProfileState.initial()) {
    on<LoadUserProfile>(_onLoadUserProfile);
    on<UpdateUserProfile>(_onUpdateUserProfile);
    on<LogoutUser>(_onLogoutUser);
  }

  Future<void> _onLoadUserProfile(
    LoadUserProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));

    final token = _storageService.token;
    if (token == null || token.isEmpty) {
      emit(state.copyWith(isLoading: false, isLoggedIn: false));
      return;
    }

    final result = await getProfileUseCase(token);

    if (emit.isDone) return;

    await result.fold(
      (failure) async {
        debugPrint("❌ Remote fetch failed: ${failure.message}");
        try {
          final cached = await _localDataSource.getCachedUserProfile();

          if (cached.id.isEmpty || cached.name.isEmpty) {
            throw Exception("⚠️ Cached user data is empty or invalid");
          }

          emit(
            state.copyWith(
              name: cached.name,
              email: cached.email,
              phone: cached.phone,
              address: cached.address,
              avatar: cached.avatar,
              isLoggedIn: true,
              isLoading: false,
            ),
          );
        } catch (e) {
          emit(
            state.copyWith(isLoading: false, error: "No valid profile found"),
          );
        }
      },
      (profile) async {
        if (profile.id.isEmpty || profile.name.isEmpty) {
          emit(
            state.copyWith(
              isLoading: false,
              error: "Received empty profile from API",
            ),
          );
          return;
        }

        final model = UserProfileModel(
          id: profile.id,
          name: profile.name,
          email: profile.email,
          phone: profile.phone,
          address: profile.address,
          avatar: profile.avatar,
        );

        // ⛳ ADD THIS DEBUG LOG
        debugPrint("📥 Profile from API to cache:");
        debugPrint("  → ID: ${model.id}");
        debugPrint("  → Name: ${model.name}");
        debugPrint("  → Email: ${model.email}");
        debugPrint("  → Avatar: ${model.avatar}");

        await _localDataSource.cacheUserProfile(model);

        emit(
          state.copyWith(
            name: profile.name,
            email: profile.email,
            phone: profile.phone,
            address: profile.address,
            avatar: profile.avatar,
            isLoggedIn: true,
            isLoading: false,
          ),
        );
      },
    );
  }

  Future<void> _onUpdateUserProfile(
    UpdateUserProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));

    final token = _storageService.token;
    if (token == null || token.isEmpty) {
      emit(state.copyWith(isLoading: false, error: "Token not found"));
      return;
    }

    final params = UpdateProfileParams(
      token: token,
      name: event.name,
      phone: event.phone,
      address: event.address,
      avatarFile: event.avatarFile,
    );

    final result = await updateProfileUseCase(params);

    result.fold(
      (failure) {
        emit(state.copyWith(isLoading: false, error: failure.message));
      },
      (_) {
        add(LoadUserProfile()); // Refresh profile after update
      },
    );
  }

  Future<void> _onLogoutUser(
    LogoutUser event,
    Emitter<ProfileState> emit,
  ) async {
    await _storageService.clearLoginData();
    if (event.context.mounted) {
      Navigator.pushAndRemoveUntil(
        event.context,
        MaterialPageRoute(builder: (_) => const LoginWrapper()),
        (route) => false,
      );
    }
  }
}
