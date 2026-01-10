import 'package:empiricus_test/core/constants/api_constants.dart';
import 'package:empiricus_test/core/network/http_client.dart';
import 'package:empiricus_test/core/services/auth_service.dart';
import 'package:empiricus_test/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:empiricus_test/features/auth/domain/repositories/i_auth_repository.dart';
import 'package:empiricus_test/features/auth/presentation/cubit/login_cubit.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> setupServiceLocator() async {
  sl.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(),
  );

  sl.registerLazySingleton<AuthService>(
    () => AuthService(storage: sl<FlutterSecureStorage>()),
  );

  sl.registerLazySingleton<IHttpClient>(
    () => HttpClientImplementation(baseUrl: ApiConstants.baseUrl),
  );

  sl.registerLazySingleton<IAuthRepository>(() => AuthRepositoryImpl());

  sl.registerFactory(() => LoginCubit(authRepository: sl(), authService: sl()));
}
