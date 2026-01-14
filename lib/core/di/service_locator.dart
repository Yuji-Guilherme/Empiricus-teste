import 'package:empiricus_test/core/constants/api_constants.dart';
import 'package:empiricus_test/core/network/http_adapter.dart';
import 'package:empiricus_test/core/network/network_info.dart';
import 'package:empiricus_test/core/services/auth_service.dart';
import 'package:empiricus_test/features/articles/presentation/bloc/article_bloc.dart';
import 'package:empiricus_test/features/articles/data/repositories/article_repository_impl.dart';
import 'package:empiricus_test/features/articles/domain/repositories/article_repository.dart';
import 'package:empiricus_test/features/articles/presentation/bloc/detail_bloc.dart';
import 'package:empiricus_test/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:empiricus_test/features/auth/domain/repositories/auth_repository.dart';
import 'package:empiricus_test/features/auth/domain/usecases/login_case.dart';
import 'package:empiricus_test/features/auth/presentation/bloc/login_cubit.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

final sl = GetIt.instance;

Future<void> setupServiceLocator() async {
  sl.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(),
  );
  sl.registerLazySingleton(() => InternetConnection());

  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfo(sl()));

  sl.registerLazySingleton<IHttpAdapter>(
    () => HttpAdapterImpl(baseUrl: ApiConstants.baseUrl),
  );

  sl.registerLazySingleton<AuthService>(() => AuthService(storage: sl()));

  sl.registerLazySingleton<IAuthRepository>(
    () => AuthRepositoryImpl(networkInfo: sl()),
  );
  sl.registerLazySingleton<IArticleRepository>(
    () => ArticleRepositoryImpl(client: sl(), networkInfo: sl()),
  );

  sl.registerLazySingleton<LoginUseCase>(
    () => LoginUseCase(repository: sl(), authService: sl()),
  );

  sl.registerFactory(() => LoginCubit(loginUseCase: sl()));
  sl.registerFactory(() => ArticleBloc(repository: sl()));
  sl.registerFactory(() => ArticleDetailBloc(repository: sl()));
}
