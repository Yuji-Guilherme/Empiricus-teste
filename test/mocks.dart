import 'package:empiricus_test/core/network/http_service.dart';
import 'package:mocktail/mocktail.dart';
import 'package:empiricus_test/core/network/network_info.dart';
import 'package:empiricus_test/features/auth/domain/repositories/auth_repository.dart';
import 'package:empiricus_test/core/services/auth_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class MockNetworkInfo extends Mock implements NetworkInfo {}

class MockAuthRepository extends Mock implements IAuthRepository {}

class MockAuthService extends Mock implements AuthService {}

class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

class MockHttpAdapter extends Mock implements IHttpAdapter {}
