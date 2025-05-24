import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import '../../core/data/local/secure_storage_service.dart';
import '../../core/data/repositories_impl/connectivity_repository_impl.dart';
import '../../core/domain/repositories/connectivity_repository.dart';
import '../../features/auth/data/auth_data_impl.dart';
import '../../features/auth/data/remote/auth_remote_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/view_model/auth_view_model.dart';

final inject = GetIt.instance;

class AppModules {
  setup() {
    _setupCoreModule();
    _setupAuthModule();
    _setupConnectivityModule();
  }

  _setupCoreModule() {
    inject.registerLazySingleton(() => InternetConnection());
    inject.registerLazySingleton(() => SecureStorageService());
  }

  _setupConnectivityModule() {
    inject.registerLazySingleton<ConnectivityRepository>(
        () => ConnectivityRepositoryImpl(inject<InternetConnection>()));
  }

  _setupAuthModule() {
    inject.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
    inject.registerFactory(() => AuthRemoteImpl(inject.get()));
    inject.registerFactory<AuthRepository>(() => AuthDataImpl(inject.get()));
    inject.registerSingleton(AuthViewModel(inject.get()));
  }
}
