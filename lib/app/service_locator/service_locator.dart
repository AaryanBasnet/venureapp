import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:venure/core/network/api_service.dart';
// import 'package:venure/core/network/hive_service.dart'; // 
// import 'package:venure/features/auth/data/data_source/local_data_source/user_local_datasource.dart'; 
import 'package:venure/features/auth/data/data_source/remote_data_source/user_remote_data_source.dart';
// import 'package:venure/features/auth/data/repository/local_repository/user_local_repository.dart'; 
import 'package:venure/features/auth/data/repository/remote_repository/user_remote_repository.dart';
// import 'package:venure/features/auth/domain/repository/user_repository.dart'; // 
import 'package:venure/features/auth/domain/use_case/user_login_usecase.dart';
import 'package:venure/features/auth/domain/use_case/user_register_usecase.dart';
import 'package:venure/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:venure/features/auth/presentation/view_model/register_view_model.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  // serviceLocator.registerLazySingleton<HiveService>(() => HiveService()); 
  _initApiService();
  _initAuthModule();
}

Future<void> _initApiService() async {
  serviceLocator.registerLazySingleton(() => ApiService(Dio()));
}

Future<void> _initAuthModule() async {
  // Data Sources
  serviceLocator.registerFactory<UserRemoteDataSource>(
    () => UserRemoteDataSource(apiService: serviceLocator<ApiService>()),
  );
  // serviceLocator.registerFactory<UserLocalDatasource>( // Removed: Not using local storage
  //   () => UserLocalDatasource(hiveService: serviceLocator<HiveService>()),
  // );

  // Repositories
  serviceLocator.registerFactory<UserRemoteRepository>(
    () => UserRemoteRepository(
        userRemoteDataSource: serviceLocator<UserRemoteDataSource>()),
  );
  // serviceLocator.registerFactory<UserLocalRepository>( // Removed: Not using local storage
  //   () => UserLocalRepository(
  //       userLocalDataSource: serviceLocator<UserLocalDatasource>()),
  // );

  // Use Cases
  serviceLocator.registerFactory<UserRegisterUsecase>(
    () => UserRegisterUsecase(repository: serviceLocator<UserRemoteRepository>()),
  );

  serviceLocator.registerFactory<UserLoginUsecase>(
    () => UserLoginUsecase(repository: serviceLocator<UserRemoteRepository>()),
  );

  // View Models
  serviceLocator.registerFactory<RegisterViewModel>(
    () => RegisterViewModel(serviceLocator<UserRegisterUsecase>()),
  );

  serviceLocator.registerFactory<LoginViewModel>(
    () => LoginViewModel(serviceLocator<UserLoginUsecase>()),
  );
}

// Future _initDashboardModule() async {
//   // Register any use cases, repositories or data sources as needed
//   // serviceLocator.registerFactory(() => HomeRepository());
//   // serviceLocator.registerFactory(() => HomeUseCase());

//   serviceLocator.registerFactory(() => HomeViewModel());
// }