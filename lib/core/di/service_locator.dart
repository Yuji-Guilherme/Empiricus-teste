import 'package:empiricus_test/core/constants/api_constants.dart';
import 'package:empiricus_test/core/network/http_client.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> setupServiceLocator() async {
  sl.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(),
  );
  sl.registerLazySingleton<IHttpClient>(
    () => HttpClientImplementation(baseUrl: ApiConstants.baseUrl),
  );
}
