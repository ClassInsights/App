class AuthCredentials {
  final String accessToken;
  final String refreshToken;

  const AuthCredentials({
    required this.accessToken,
    required this.refreshToken,
  });

  static AuthCredentials blank() {
    return const AuthCredentials(accessToken: "", refreshToken: "");
  }
}
