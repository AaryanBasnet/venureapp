import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:venure/core/error/failure.dart';
import 'package:venure/features/profile/data/model/user_profile_model.dart';
import 'package:venure/features/profile/domain/entity/user_profile_entity.dart';
import 'package:venure/features/profile/domain/use_case/update_profile_params.dart';
import 'package:venure/features/profile/presentation/view_model/profile_view_model.dart';
import 'package:venure/features/profile/presentation/view_model/profile_event.dart';
import 'package:venure/features/profile/presentation/view_model/profile_state.dart';
import 'package:venure/features/profile/domain/use_case/get_profile_usecase.dart';
import 'package:venure/features/profile/domain/use_case/update_profile_usecase.dart';
import 'package:venure/features/profile/data/data_source/local_data_source/profile_local_data_source.dart';
import 'package:venure/app/constant/shared_pref/local_storage_service.dart';
import 'package:dartz/dartz.dart';

// Mocks
class MockGetProfileUseCase extends Mock implements GetProfileUseCase {}

class MockUpdateProfileUseCase extends Mock implements UpdateProfileUseCase {}

class MockLocalStorageService extends Mock implements LocalStorageService {}

class MockProfileLocalDataSource extends Mock
    implements ProfileLocalDataSource {}

// Fakes and fallback registrations
class UserProfileModelFake extends Fake implements UserProfileModel {}

class UpdateProfileParamsFake extends Fake implements UpdateProfileParams {}

// Fake UserProfileEntity implementation for test returns
class FakeUserProfileEntity implements UserProfileEntity {
  @override
  final String id;
  @override
  final String name;
  @override
  final String email;
  @override
  final String phone;
  @override
  final String address;
  @override
  final String avatar;

  FakeUserProfileEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.avatar,
  });
}

// Fake BuildContext with mounted getter for LogoutUser event
class FakeBuildContext extends Fake implements BuildContext {
  @override
  bool get mounted => true;
}

class FakeFailure extends Failure {
  @override
  final String message;
  const FakeFailure(this.message) : super(message: message);
}

void main() {
  setUpAll(() {
    registerFallbackValue(UserProfileModelFake());
    registerFallbackValue(UpdateProfileParamsFake());
  });

  late ProfileViewModel viewModel;
  late MockGetProfileUseCase mockGetProfileUseCase;
  late MockUpdateProfileUseCase mockUpdateProfileUseCase;
  late MockLocalStorageService mockStorageService;
  late MockProfileLocalDataSource mockLocalDataSource;

  setUp(() {
    mockGetProfileUseCase = MockGetProfileUseCase();
    mockUpdateProfileUseCase = MockUpdateProfileUseCase();
    mockStorageService = MockLocalStorageService();
    mockLocalDataSource = MockProfileLocalDataSource();

    viewModel = ProfileViewModel(
      getProfileUseCase: mockGetProfileUseCase,
      updateProfileUseCase: mockUpdateProfileUseCase,
      storageService: mockStorageService,
      localDataSource: mockLocalDataSource,
    );
  });

  group('LoadUserProfile', () {
    final token = 'valid_token';
    final cachedProfile = UserProfileModel(
      id: 'id1',
      name: 'Cached User',
      email: 'cached@example.com',
      phone: '111222333',
      address: 'Cached Address',
      avatar: 'cached_avatar.png',
    );
    final remoteProfile = FakeUserProfileEntity(
      id: 'id2',
      name: 'Remote User',
      email: 'remote@example.com',
      phone: '999888777',
      address: 'Remote Address',
      avatar: 'remote_avatar.png',
    );

    blocTest<ProfileViewModel, ProfileState>(
      'emits loggedOut if token is null',
      build: () {
        when(() => mockStorageService.token).thenReturn(null);
        return viewModel;
      },
      act: (bloc) => bloc.add(LoadUserProfile()),
      expect: () => [
        ProfileState.initial().copyWith(isLoading: true, error: null),
        ProfileState.initial().copyWith(isLoading: false, isLoggedIn: false),
      ],
    );

    blocTest<ProfileViewModel, ProfileState>(
      'emits remote profile on success and caches it',
      build: () {
        when(() => mockStorageService.token).thenReturn(token);
        when(
          () => mockGetProfileUseCase(token),
        ).thenAnswer((_) async => Right(remoteProfile));
        when(
          () => mockLocalDataSource.cacheUserProfile(any()),
        ).thenAnswer((_) async {});
        return viewModel;
      },
      act: (bloc) => bloc.add(LoadUserProfile()),
      expect: () => [
        ProfileState.initial().copyWith(isLoading: true, error: null),
        ProfileState.initial().copyWith(
          name: remoteProfile.name,
          email: remoteProfile.email,
          phone: remoteProfile.phone,
          address: remoteProfile.address,
          avatar: remoteProfile.avatar,
          isLoggedIn: true,
          isLoading: false,
        ),
      ],
      verify: (_) {
        verify(() => mockLocalDataSource.cacheUserProfile(any())).called(1);
      },
    );

    blocTest<ProfileViewModel, ProfileState>(
      'emits cached profile on remote failure',
      build: () {
        when(() => mockStorageService.token).thenReturn(token);
        when(
          () => mockGetProfileUseCase(token),
        ).thenAnswer((_) async => Left(FakeFailure('fail')));
        when(
          () => mockLocalDataSource.getCachedUserProfile(),
        ).thenAnswer((_) async => cachedProfile);
        return viewModel;
      },
      act: (bloc) => bloc.add(LoadUserProfile()),
      expect: () => [
        ProfileState.initial().copyWith(isLoading: true, error: null),
        ProfileState.initial().copyWith(
          name: cachedProfile.name,
          email: cachedProfile.email,
          phone: cachedProfile.phone,
          address: cachedProfile.address,
          avatar: cachedProfile.avatar,
          isLoggedIn: true,
          isLoading: false,
        ),
      ],
    );

    blocTest<ProfileViewModel, ProfileState>(
      'emits error if cached profile is invalid',
      build: () {
        when(() => mockStorageService.token).thenReturn(token);
        when(
          () => mockGetProfileUseCase(token),
        ).thenAnswer((_) async => Left(FakeFailure('fail')));
        when(() => mockLocalDataSource.getCachedUserProfile()).thenAnswer(
          (_) async => UserProfileModel(
            id: '',
            name: '',
            email: '',
            phone: '',
            address: '',
            avatar: '',
          ),
        );
        return viewModel;
      },
      act: (bloc) => bloc.add(LoadUserProfile()),
      expect: () => [
        ProfileState.initial().copyWith(isLoading: true, error: null),
        ProfileState.initial().copyWith(
          isLoading: false,
          error: 'No valid profile found',
        ),
      ],
    );

    blocTest<ProfileViewModel, ProfileState>(
      'emits error if remote profile is empty',
      build: () {
        when(() => mockStorageService.token).thenReturn(token);
        when(
          () => mockGetProfileUseCase(token),
        ).thenAnswer(
          (_) async => Right(
            FakeUserProfileEntity(
              id: '',
              name: '',
              email: 'empty@example.com',
              phone: '12345',
              address: 'Empty Address',
              avatar: 'empty.png',
            ),
          ),
        );
        return viewModel;
      },
      act: (bloc) => bloc.add(LoadUserProfile()),
      expect: () => [
        ProfileState.initial().copyWith(isLoading: true, error: null),
        ProfileState.initial().copyWith(
          isLoading: false,
          error: 'Received empty profile from API',
        ),
      ],
    );
  });

  group('UpdateUserProfile', () {
    final token = 'valid_token';
    final updateEvent = UpdateUserProfile(
      name: 'Updated Name',
      phone: '1234567890',
      address: 'Updated Address',
      avatarFile: null,
    );

    blocTest<ProfileViewModel, ProfileState>(
      'emits error if token missing',
      build: () {
        when(() => mockStorageService.token).thenReturn(null);
        return viewModel;
      },
      act: (bloc) => bloc.add(updateEvent),
      expect: () => [
        ProfileState.initial().copyWith(isLoading: true, error: null),
        ProfileState.initial().copyWith(
          isLoading: false,
          error: 'Token not found',
        ),
      ],
    );

    blocTest<ProfileViewModel, ProfileState>(
      'calls updateProfileUseCase and reloads profile on success',
      build: () {
        when(() => mockStorageService.token).thenReturn(token);
        when(
          () => mockUpdateProfileUseCase(any()),
        ).thenAnswer((_) async => const Right(null));
        when(() => mockGetProfileUseCase(token)).thenAnswer(
          (_) async => Right(
            FakeUserProfileEntity(
              id: 'id3',
              name: 'Updated Name',
              email: 'updated@example.com',
              phone: '1234567890',
              address: 'Updated Address',
              avatar: 'updated_avatar.png',
            ),
          ),
        );
        when(
          () => mockLocalDataSource.cacheUserProfile(any()),
        ).thenAnswer((_) async {});
        return viewModel;
      },
      act: (bloc) => bloc.add(updateEvent),
      expect: () => [
        ProfileState.initial().copyWith(isLoading: true, error: null),
        ProfileState.initial().copyWith(
          name: 'Updated Name',
          email: 'updated@example.com',
          phone: '1234567890',
          address: 'Updated Address',
          avatar: 'updated_avatar.png',
          isLoggedIn: true,
          isLoading: false,
        ),
      ],
    );

    blocTest<ProfileViewModel, ProfileState>(
      'emits error if update fails',
      build: () {
        when(() => mockStorageService.token).thenReturn(token);
        when(
          () => mockUpdateProfileUseCase(any()),
        ).thenAnswer((_) async => Left(FakeFailure('Update failed')));
        return viewModel;
      },
      act: (bloc) => bloc.add(updateEvent),
      expect: () => [
        ProfileState.initial().copyWith(isLoading: true, error: null),
        ProfileState.initial().copyWith(
          isLoading: false,
          error: 'Update failed',
        ),
      ],
    );
  });
  group('LogoutUser', () {
    blocTest<ProfileViewModel, ProfileState>(
      'calls clearLoginData on logout and updates isLoggedIn to false and isLoggedOut to true',
      build: () {
        when(
          () => mockStorageService.clearLoginData(),
        ).thenAnswer((_) async {});
        return viewModel;
      },
      seed: () => ProfileState.initial().copyWith(isLoggedIn: true, isLoggedOut: false),
      act: (bloc) => bloc.add(LogoutUser()),
      // The BLoC only emits one state after the event, so we only expect one.
      expect: () => [
        ProfileState.initial().copyWith(
          isLoggedIn: false,
          isLoggedOut: true,
        ),
      ],
      verify: (_) {
        verify(() => mockStorageService.clearLoginData()).called(1);
      },
    );
  });
}
