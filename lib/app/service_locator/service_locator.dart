import 'package:get_it/get_it.dart';
import 'package:venure/core/network/hive_service.dart';
import 'package:venure/features/auth/data/data_source/local_data_source/user_local_datasource.dart';
import 'package:venure/features/auth/data/repository/local_repository/user_local_repository.dart';
import 'package:venure/features/auth/domain/use_case/user_login_usecase.dart';
import 'package:venure/features/auth/domain/use_case/user_register_usecase.dart';
import 'package:venure/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:venure/features/auth/presentation/view_model/register_view_model.dart';
import 'package:venure/features/home/presentation/view_model/home_view_model.dart';

final serviceLocator = GetIt.instance;
Future initDependencies() async {
  serviceLocator.registerLazySingleton<HiveService>(() => HiveService());

  _initLoginModule();
  _initSignupModule();
  // _initDashboardModule(); 
}

Future _initSignupModule() async {
  serviceLocator.registerFactory(
    () => UserLocalDatasource(hiveService: serviceLocator<HiveService>()),
  );

  serviceLocator.registerFactory(
    () => UserLocalRepository(
      userLocalDataSource: serviceLocator<UserLocalDatasource>(),
    ),
  );

  serviceLocator.registerFactory(
    () =>
        UserRegisterUsecase(repository: serviceLocator<UserLocalRepository>()),
  );

  serviceLocator.registerFactory(
    () => RegisterViewModel(serviceLocator<UserRegisterUsecase>()),
  );
}

Future _initLoginModule() async {
  serviceLocator.registerFactory(
    () => UserLoginUsecase(repository: serviceLocator<UserLocalRepository>()),
  );

  serviceLocator.registerFactory(
    () => LoginViewModel(serviceLocator<UserLoginUsecase>()),
  );
}

// Future _initDashboardModule() async {
//   // Register any use cases, repositories or data sources as needed
//   // serviceLocator.registerFactory(() => HomeRepository());
//   // serviceLocator.registerFactory(() => HomeUseCase());

//   serviceLocator.registerFactory(() => HomeViewModel());
// }
