class TokenModel {
  final String accessToken;
  final String refreshToken;
  final String tokenType;
  final int expiresIn;

  TokenModel({
    required this.accessToken,
    required this.refreshToken,
    required this.tokenType,
    required this.expiresIn,
  });

  factory TokenModel.fromJson(Map<String, dynamic> json) {
    return TokenModel(
      accessToken: json['access_token'] ?? '',
      refreshToken: json['refresh_token'] ?? '',
      tokenType: json['token_type'] ?? 'Bearer',
      expiresIn: json['expires_in'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'access_token': accessToken,
      'refresh_token': refreshToken,
      'token_type': tokenType,
      'expires_in': expiresIn,
    };
  }
}
