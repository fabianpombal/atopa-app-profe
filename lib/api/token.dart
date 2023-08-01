class Token {
  final String token;
  final String refresh;

  const Token({
    required this.token,
    required this.refresh,
  });

  factory Token.fromJson(Map<String, dynamic> json) {
    return Token(
      token: json['token'],
      refresh: json['refresh'],
    );
  }
}