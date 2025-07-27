import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:venure/app/constant/shared_pref/local_storage_service.dart';
import 'package:venure/core/network/api_service.dart';
import 'package:venure/core/network/hive_service.dart';
import 'package:venure/core/network/search_venue_service.dart';
import 'package:venure/core/network/socket_service.dart';
import 'package:venure/features/auth/data/data_source/local_data_source/user_local_datasource.dart';
// import 'package:venure/core/network/hive_service.dart'; //
// import 'package:venure/features/auth/data/data_source/local_data_source/user_local_datasource.dart';
import 'package:venure/features/auth/data/data_source/remote_data_source/user_remote_data_source.dart';
import 'package:venure/features/auth/data/repository/hybrid_user_repository.dart';
import 'package:venure/features/auth/data/repository/local_repository/user_local_repository.dart';
// import 'package:venure/features/auth/data/repository/local_repository/user_local_repository.dart';
import 'package:venure/features/auth/data/repository/remote_repository/user_remote_repository.dart';
import 'package:venure/features/auth/domain/repository/user_repository.dart';
import 'package:venure/features/auth/domain/use_case/reset_password_usecase.dart';
import 'package:venure/features/auth/domain/use_case/send_rest_code_usecase.dart';
// import 'package:venure/features/auth/domain/repository/user_repository.dart'; //
import 'package:venure/features/auth/domain/use_case/user_login_usecase.dart';
import 'package:venure/features/auth/domain/use_case/user_register_usecase.dart';
import 'package:venure/features/auth/domain/use_case/verify_password_usecase.dart';
import 'package:venure/features/auth/domain/use_case/verify_reset_code_usecase.dart';
import 'package:venure/features/auth/presentation/view_model/forget_password_view_model/forget_password_view_model.dart';
import 'package:venure/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:venure/features/auth/presentation/view_model/register_view_model/register_view_model.dart';
import 'package:venure/features/booking/data/data_source/local_data_source/booking_local_data_source.dart';
import 'package:venure/features/booking/data/data_source/remote_data_source/booking_remote_data_source.dart';
import 'package:venure/features/booking/data/repository/booking_repository_impl.dart';
import 'package:venure/features/booking/domain/repository/booking_repository.dart';
import 'package:venure/features/booking/domain/use_case/cancel_booking_usecase.dart';
import 'package:venure/features/booking/domain/use_case/create_booking_usecase.dart';
import 'package:venure/features/booking/domain/use_case/get_booking_usecase.dart';
import 'package:venure/features/booking/presentation/view_model/booking_view_model.dart';
import 'package:venure/features/chat/data/data_source/local_data_source/chat_local_data_source.dart';
import 'package:venure/features/chat/data/data_source/remote_data_source/chat_api_service.dart';
import 'package:venure/features/chat/data/data_source/remote_data_source/chat_remote_data_source.dart';
import 'package:venure/features/chat/data/repository/chat_repository_impl.dart';
import 'package:venure/features/chat/domain/repository/i_chat_repository.dart';
import 'package:venure/features/chat/domain/use_case/get_chat_usecase.dart';
import 'package:venure/features/chat/domain/use_case/get_or_create_chat_usecase.dart';
import 'package:venure/features/chat/presentation/view_model/chat_list_bloc.dart';
import 'package:venure/features/chat/presentation/view_model/chat_message_bloc.dart';
import 'package:venure/features/common/presentation/view_model/venue_details_bloc.dart';
import 'package:venure/features/home/data/data_source/ivenue_data_source.dart';
import 'package:venure/features/home/data/data_source/local_data_source/venue_local_datasource.dart';
import 'package:venure/features/home/data/data_source/remote_data_source/venue_remote_datasource.dart';
import 'package:venure/features/home/data/repository/hybrid_venue_repository.dart';
import 'package:venure/features/home/data/repository/local_repository/venue_local_repository.dart';
import 'package:venure/features/home/data/repository/remote_repository/venue_remote_repository.dart';
import 'package:venure/features/home/domain/repository/venue_repository.dart';
import 'package:venure/features/home/domain/use_case/get_%20favorites_usecase.dart';
import 'package:venure/features/home/domain/use_case/get_all_venues_use_case.dart';
import 'package:venure/features/home/domain/use_case/search_venue_usecase.dart';
import 'package:venure/features/home/domain/use_case/toggle_favorite_usecase.dart';
import 'package:venure/features/home/presentation/view_model/home_view_model.dart';
import 'package:venure/features/home/presentation/view_model/search_bloc.dart';
import 'package:venure/features/notification/data/data_source/remote_data_source/notification_api_service.dart';
import 'package:venure/features/notification/data/repository/remote_repository/notification_repository_impl.dart';
import 'package:venure/features/notification/domain/repository/notification_repository.dart';
import 'package:venure/features/notification/domain/use_case/get_notification.dart';
import 'package:venure/features/notification/domain/use_case/mark_all_as_read.dart';
import 'package:venure/features/notification/domain/use_case/mark_as_read.dart';
import 'package:venure/features/notification/presentation/view_model/notification_view_model.dart';
import 'package:venure/features/profile/data/data_source/local_data_source/profile_local_data_source.dart';
import 'package:venure/features/profile/data/data_source/remote_data_source/profile_remote_data_source.dart';
import 'package:venure/features/profile/data/model/user_profile_model.dart';
import 'package:venure/features/profile/data/repository/profile_repository_impl.dart';
import 'package:venure/features/profile/domain/repository/profile_repository.dart';
import 'package:venure/features/profile/domain/use_case/get_profile_usecase.dart';
import 'package:venure/features/profile/domain/use_case/update_profile_usecase.dart';
import 'package:venure/features/profile/presentation/view_model/my_bookings_view_model/my_booking_view_model.dart';
import 'package:venure/features/profile/presentation/view_model/profile_view_model.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  await _initCoreServices();
  await _initAuthModule();
  await _initHomeModule();
  await _initSearchModule();
  await _initBookingModule();
  await _initProfileModule();
  await _initChatModule();
  await _initLocalStorageService();
  await _initNotificationModule();
}

Future<void> _initCoreServices() async {
  if (!serviceLocator.isRegistered<ApiService>()) {
    serviceLocator.registerLazySingleton(() => ApiService(Dio()));
  }

  if (!serviceLocator.isRegistered<SocketService>()) {
    serviceLocator.registerLazySingleton(() => SocketService());
  }

  if (!serviceLocator.isRegistered<NotificationApiService>()) {
    serviceLocator.registerLazySingleton(
      () => NotificationApiService(serviceLocator<ApiService>()),
    );
  }

  // ✅ Add HiveService Singleton
  if (!serviceLocator.isRegistered<HiveService>()) {
    final hiveService = HiveService.instance;
    await hiveService.init();
    serviceLocator.registerSingleton<HiveService>(hiveService);
  }
}

Future<void> _initAuthModule() async {
  if (!serviceLocator.isRegistered<UserRemoteDataSource>()) {
    serviceLocator.registerFactory(
      () => UserRemoteDataSource(apiService: serviceLocator<ApiService>()),
    );
  }

  if (!serviceLocator.isRegistered<UserLocalDatasource>()) {
    serviceLocator.registerFactory(
      () => UserLocalDatasource(hiveService: serviceLocator<HiveService>()),
    );
  }

  if (!serviceLocator.isRegistered<UserLocalRepository>()) {
    serviceLocator.registerFactory(
      () => UserLocalRepository(
        userLocalDataSource: serviceLocator<UserLocalDatasource>(),
      ),
    );
  }

  if (!serviceLocator.isRegistered<UserRemoteRepository>()) {
    serviceLocator.registerFactory(
      () => UserRemoteRepository(
        userRemoteDataSource: serviceLocator<UserRemoteDataSource>(),
      ),
    );
  }

  // Register the Hybrid Repository implementing IUserRepository
  if (!serviceLocator.isRegistered<IUserRepository>()) {
    serviceLocator.registerFactory<IUserRepository>(
      () => HybridUserRepository(
        remote: serviceLocator<UserRemoteRepository>(),
        local: serviceLocator<UserLocalRepository>(),
      ),
    );
  }

  // Now use IUserRepository (hybrid) in your usecases
  if (!serviceLocator.isRegistered<UserRegisterUsecase>()) {
    serviceLocator.registerFactory(
      () => UserRegisterUsecase(
        repository: serviceLocator<IUserRepository>(), // <-- Hybrid here
      ),
    );
  }

  if (!serviceLocator.isRegistered<UserLoginUsecase>()) {
    serviceLocator.registerFactory(
      () => UserLoginUsecase(
        repository: serviceLocator<IUserRepository>(), // <-- Hybrid here
        localStorageService: serviceLocator<LocalStorageService>(),
      ),
    );
  }

  if (!serviceLocator.isRegistered<VerifyPasswordUsecase>()) {
    serviceLocator.registerFactory(
      () => VerifyPasswordUsecase(
        serviceLocator<IUserRepository>(),
      ), // <-- Hybrid here
    );
  }

  if (!serviceLocator.isRegistered<RegisterViewModel>()) {
    serviceLocator.registerFactory(
      () => RegisterViewModel(serviceLocator<UserRegisterUsecase>()),
    );
  }

  if (!serviceLocator.isRegistered<LoginViewModel>()) {
    serviceLocator.registerFactory(
      () => LoginViewModel(serviceLocator<UserLoginUsecase>()),
    );
  }

  // Assuming you have these use cases implemented
  if (!serviceLocator.isRegistered<SendResetCodeUseCase>()) {
    serviceLocator.registerFactory(
      () => SendResetCodeUseCase(serviceLocator<IUserRepository>()),
    );
  }

  // Register Forgot Password Usecases
  if (!serviceLocator.isRegistered<VerifyResetCodeUseCase>()) {
    serviceLocator.registerFactory(
      () => VerifyResetCodeUseCase(serviceLocator<IUserRepository>()),
    );
  }

  if (!serviceLocator.isRegistered<ResetPasswordUseCase>()) {
    serviceLocator.registerFactory(
      () => ResetPasswordUseCase(serviceLocator<IUserRepository>()),
    );
  }

  // Register ForgotPasswordViewModel
  if (!serviceLocator.isRegistered<ForgotPasswordViewModel>()) {
    serviceLocator.registerFactory(
      () => ForgotPasswordViewModel(
        sendResetCodeUseCase: serviceLocator<SendResetCodeUseCase>(),
        verifyResetCodeUseCase: serviceLocator<VerifyResetCodeUseCase>(),
        resetPasswordUseCase: serviceLocator<ResetPasswordUseCase>(),
      ),
    );
  }
}

Future<void> _initHomeModule() async {
  if (!serviceLocator.isRegistered<VenueRemoteDataSource>()) {
    serviceLocator.registerLazySingleton(
      () => VenueRemoteDataSource(apiService: serviceLocator<ApiService>()),
    );
  }

  if (!serviceLocator.isRegistered<VenueLocalDataSource>()) {
    serviceLocator.registerLazySingleton(
      () => VenueLocalDataSource(hiveService: serviceLocator<HiveService>()),
    );
  }

  if (!serviceLocator.isRegistered<VenueLocalRepository>()) {
    serviceLocator.registerLazySingleton<VenueLocalRepository>(
      () => VenueLocalRepository(
        localDataSource: serviceLocator<VenueLocalDataSource>(),
      ),
    );
  }

  if (!serviceLocator.isRegistered<VenueRemoteRepository>()) {
    serviceLocator.registerLazySingleton<VenueRemoteRepository>(
      () => VenueRemoteRepository(
        remoteDataSource: serviceLocator<VenueRemoteDataSource>(),
      ),
    );
  }

  serviceLocator.registerLazySingleton<IVenueRepository>(
    () => HybridVenueRepository(
      remoteRepository: serviceLocator<VenueRemoteRepository>(),
      localRepository: serviceLocator<VenueLocalRepository>(),
    ),
  );

  if (!serviceLocator.isRegistered<GetAllVenuesUseCase>()) {
    serviceLocator.registerLazySingleton(
      () => GetAllVenuesUseCase(serviceLocator<IVenueRepository>()),
    );
  }

  if (!serviceLocator.isRegistered<GetFavoritesUseCase>()) {
    serviceLocator.registerLazySingleton(
      () => GetFavoritesUseCase(serviceLocator<IVenueRepository>()),
    );
  }

  if (!serviceLocator.isRegistered<ToggleFavoriteUseCase>()) {
    serviceLocator.registerLazySingleton(
      () => ToggleFavoriteUseCase(serviceLocator<IVenueRepository>()),
    );
  }

  if (!serviceLocator.isRegistered<HomeScreenBloc>()) {
    serviceLocator.registerFactory(
      () => HomeScreenBloc(
        getAllVenuesUseCase: serviceLocator<GetAllVenuesUseCase>(),
        getFavoritesUseCase: serviceLocator<GetFavoritesUseCase>(),
        toggleFavoriteUseCase: serviceLocator<ToggleFavoriteUseCase>(),
      ),
    );
  }

  if (!serviceLocator.isRegistered<VenueDetailsBloc>()) {
    serviceLocator.registerFactory(
      () =>
          VenueDetailsBloc(venueRepository: serviceLocator<IVenueRepository>()),
    );
  }
}

Future<void> _initSearchModule() async {
  if (!serviceLocator.isRegistered<SearchVenuesUseCase>()) {
    serviceLocator.registerLazySingleton(
      () => SearchVenuesUseCase(serviceLocator<IVenueRepository>()),
    );
  }

  if (!serviceLocator.isRegistered<SearchBloc>()) {
    serviceLocator.registerFactory(
      () => SearchBloc(
        searchVenuesUseCase: serviceLocator<SearchVenuesUseCase>(),
        getFavoritesUseCase: serviceLocator<GetFavoritesUseCase>(),
        toggleFavoriteUseCase: serviceLocator<ToggleFavoriteUseCase>(),
      ),
    );
  }
}

Future<void> _initBookingModule() async {
  if (!serviceLocator.isRegistered<BookingRemoteDataSource>()) {
    serviceLocator.registerLazySingleton(
      () => BookingRemoteDataSource(serviceLocator<ApiService>()),
    );
  }

  if (!serviceLocator.isRegistered<BookingLocalDataSource>()) {
    serviceLocator.registerLazySingleton(() => BookingLocalDataSource());
  }

  if (!serviceLocator.isRegistered<BookingRepository>()) {
    serviceLocator.registerLazySingleton<BookingRepository>(
      () => BookingRepositoryImpl(
        remoteDataSource: serviceLocator<BookingRemoteDataSource>(),
        localDataSource: serviceLocator<BookingLocalDataSource>(),
        venueRepository: serviceLocator<IVenueRepository>(),
      ),
    );
  }

  if (!serviceLocator.isRegistered<CreateBookingUseCase>()) {
    serviceLocator.registerLazySingleton(
      () => CreateBookingUseCase(serviceLocator<BookingRepository>()),
    );
  }

  if (!serviceLocator.isRegistered<BookingViewModel>()) {
    serviceLocator.registerFactory(
      () => BookingViewModel(
        createBookingUseCase: serviceLocator<CreateBookingUseCase>(),
        localStorage: serviceLocator<LocalStorageService>(),
      ),
    );
  }

  if (!serviceLocator.isRegistered<GetMyBookingsUseCase>()) {
    serviceLocator.registerLazySingleton(
      () => GetMyBookingsUseCase(serviceLocator<BookingRepository>()),
    );
  }

  if (!serviceLocator.isRegistered<CancelBookingUseCase>()) {
    serviceLocator.registerLazySingleton(
      () => CancelBookingUseCase(serviceLocator<BookingRepository>()),
    );
  }
}

Future<void> _initProfileModule() async {
  if (!serviceLocator.isRegistered<ProfileRemoteDataSource>()) {
    serviceLocator.registerLazySingleton(
      () => ProfileRemoteDataSource(apiService: serviceLocator<ApiService>()),
    );
  }

  if (!serviceLocator.isRegistered<ProfileLocalDataSource>()) {
    serviceLocator.registerLazySingleton(
      () => ProfileLocalDataSource(hiveService: serviceLocator<HiveService>()),
    );
  }
  if (!serviceLocator.isRegistered<IProfileRepository>()) {
    serviceLocator.registerLazySingleton<IProfileRepository>(
      () => ProfileRepositoryImpl(
        remoteDataSource: serviceLocator<ProfileRemoteDataSource>(),
        localDataSource: serviceLocator<ProfileLocalDataSource>(),
      ),
    );
  }

  if (!serviceLocator.isRegistered<GetProfileUseCase>()) {
    serviceLocator.registerLazySingleton(
      () => GetProfileUseCase(serviceLocator<IProfileRepository>()),
    );
  }

  if (!serviceLocator.isRegistered<UpdateProfileUseCase>()) {
    serviceLocator.registerLazySingleton(
      () => UpdateProfileUseCase(serviceLocator<IProfileRepository>()),
    );
  }

  if (!serviceLocator.isRegistered<ProfileViewModel>()) {
    serviceLocator.registerFactory(
      () => ProfileViewModel(
        getProfileUseCase: serviceLocator<GetProfileUseCase>(),
        updateProfileUseCase: serviceLocator<UpdateProfileUseCase>(),
        storageService: serviceLocator<LocalStorageService>(),
        localDataSource: serviceLocator<ProfileLocalDataSource>(),
      ),
    );
  }

  if (!serviceLocator.isRegistered<BookingBloc>()) {
    serviceLocator.registerFactory(
      () => BookingBloc(
        getBookingsUseCase: serviceLocator<GetMyBookingsUseCase>(),
        cancelBookingUseCase: serviceLocator<CancelBookingUseCase>(),
      ),
    );
  }
}

Future<void> _initChatModule() async {
  if (!serviceLocator.isRegistered<ChatApiService>()) {
    serviceLocator.registerLazySingleton(
      () => ChatApiService(apiService: serviceLocator<ApiService>()),
    );
  }

  if (!serviceLocator.isRegistered<ChatRemoteDataSource>()) {
    serviceLocator.registerLazySingleton<ChatRemoteDataSource>(
      () => ChatRemoteDataSourceImpl(
        chatApiService: serviceLocator<ChatApiService>(),
      ),
    );
  }
  if (!serviceLocator.isRegistered<ChatLocalDataSource>()) {
    serviceLocator.registerLazySingleton<ChatLocalDataSource>(
      () => ChatLocalDataSourceImpl(),
    );
  }
  if (!serviceLocator.isRegistered<IChatRepository>()) {
    serviceLocator.registerLazySingleton<IChatRepository>(
      () => ChatRepositoryImpl(
        apiService: serviceLocator<ApiService>(),
        remoteDataSource: serviceLocator<ChatRemoteDataSource>(),
        localDataSource: serviceLocator<ChatLocalDataSource>(),
      ),
    );
  }

  if (!serviceLocator.isRegistered<GetUserChatsUseCase>()) {
    serviceLocator.registerLazySingleton(
      () => GetUserChatsUseCase(serviceLocator<IChatRepository>()),
    );
  }

  if (!serviceLocator.isRegistered<GetOrCreateChatUseCase>()) {
    serviceLocator.registerLazySingleton(
      () => GetOrCreateChatUseCase(serviceLocator<IChatRepository>()),
    );
  }

  serviceLocator.registerFactory(
    () => ChatListBloc(
      getUserChatsUseCase: serviceLocator<GetUserChatsUseCase>(),
      getOrCreateChatUseCase: serviceLocator<GetOrCreateChatUseCase>(),
      currentUserId: serviceLocator<HiveService>().getCurrentUserIdSync(),
    ),
  );

  if (!serviceLocator.isRegistered<ChatMessagesBloc>()) {
    serviceLocator.registerFactory(
      () => ChatMessagesBloc(
        chatRepository: serviceLocator<IChatRepository>(),
        socketService: serviceLocator<SocketService>(),
        currentUserId: serviceLocator<LocalStorageService>().userId ?? '',
      ),
    );
  }
}

Future<void> _initLocalStorageService() async {
  if (!serviceLocator.isRegistered<LocalStorageService>()) {
    final localStorageService = await LocalStorageService.getInstance();
    serviceLocator.registerSingleton<LocalStorageService>(localStorageService);
  }
}

Future<void> _initNotificationModule() async {
  // Notification Repository Impl
  if (!serviceLocator.isRegistered<NotificationRepository>()) {
    serviceLocator.registerLazySingleton<NotificationRepository>(
      () =>
          NotificationRepositoryImpl(serviceLocator<NotificationApiService>()),
    );
  }

  // Use Cases
  if (!serviceLocator.isRegistered<GetNotificationsUseCase>()) {
    serviceLocator.registerLazySingleton(
      () => GetNotificationsUseCase(serviceLocator<NotificationRepository>()),
    );
  }

  if (!serviceLocator.isRegistered<MarkAsReadUseCase>()) {
    serviceLocator.registerLazySingleton(
      () => MarkAsReadUseCase(serviceLocator<NotificationRepository>()),
    );
  }

  if (!serviceLocator.isRegistered<MarkAllAsReadUseCase>()) {
    serviceLocator.registerLazySingleton(
      () => MarkAllAsReadUseCase(serviceLocator<NotificationRepository>()),
    );
  }

  // Bloc/ViewModel
  if (!serviceLocator.isRegistered<NotificationViewModel>()) {
    serviceLocator.registerFactory(
      () => NotificationViewModel(
        getNotificationsUseCase: serviceLocator<GetNotificationsUseCase>(),
        markAsReadUseCase: serviceLocator<MarkAsReadUseCase>(),
        markAllAsReadUseCase: serviceLocator<MarkAllAsReadUseCase>(),
      ),
    );
  }
}
