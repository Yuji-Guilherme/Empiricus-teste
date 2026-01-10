abstract class IAuthRepository {
  Future<String> login(String email, String password);
}
