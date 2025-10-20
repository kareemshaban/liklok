class TokenModel {
  final String token;
  final String userId;

  TokenModel({
    required this.token,
    required this.userId,
  });

  factory TokenModel.fromJson(Map<String, dynamic> json) {
    return TokenModel(
      token: json['token'] ?? '',
      userId: json['user_id'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'user_id': userId,
    };
  }
}
