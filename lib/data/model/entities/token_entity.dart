class TokenEntity {
  final String accessToken;
  TokenEntity({required this.accessToken});

  factory TokenEntity.fromJson(Map<String, dynamic> json) {
    return TokenEntity(accessToken: json['access_token'] as String);
  }
}
