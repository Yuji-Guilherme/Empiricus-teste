import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class NetworkInfo {
  final InternetConnection _connection;

  NetworkInfo(this._connection);

  Future<bool> get isConnected => _connection.hasInternetAccess;
}
