class AuthService {
  AuthService._();

  static String? bearerToken;

  static void setToken(String token) {
    bearerToken = token;
  }

  static String? getToken() => bearerToken;
}
