import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:venure/app/constant/shared_pref/local_storage_service.dart';
import 'package:venure/features/profile/data/data_source/remote_data_source/profile_remote_data_source.dart';
import 'package:venure/features/profile/data/model/user_profile_model.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileViewModel extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRemoteDataSource remoteDataSource;
  final LocalStorageService _storageService;

  ProfileViewModel({
    required this.remoteDataSource,
    required LocalStorageService storageService,
  }) : _storageService = storageService,
       super(ProfileState.initial()) {
    on<LoadUserProfile>(_onLoadUserProfile);
    on<UpdateUserProfile>(_onUpdateUserProfile);
  }

  Future<void> _onLoadUserProfile(
    LoadUserProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      final token = _storageService.token;
      if (token == null || token.isEmpty) {
        emit(state.copyWith(isLoading: false, isLoggedIn: false));
        return;
      }

      final profileResponse = await remoteDataSource.getUserProfile(token);
      final userData = profileResponse['user'];

      emit(
        state.copyWith(
          name: userData['name'],
          email: userData['email'],
          phone: userData['phone'],
          address: userData['address'],
          avatar: userData['avatar'],
          isLoggedIn: true,
          isLoading: false,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _onUpdateUserProfile(
    UpdateUserProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final token = _storageService.token;
      if (token == null || token.isEmpty) throw Exception('No token found');

      await remoteDataSource.updateUserProfile(
        token: token,
        name: event.name,
        phone: event.phone,
        address: event.address,
        avatarFile: event.avatarFile,
      );

      // Refresh profile after update
      add(LoadUserProfile());
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }
}
