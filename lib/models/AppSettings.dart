class AppSettings {
  final int id;

  final String agora_id;

  final int enableGooglePayments;

  final int enableStripePayments;

  final int game25;

  final int game10;

  final int game1;

  final int game26;

  final int game7;

  final int game20;

  final int game15;

  final int game8;

  final int isTest;

  final String zegoAppId;

  final String zegoAppSign;

  final String zegoAppSecret;

  AppSettings({
    required this.id,
    required this.agora_id,
    required this.enableGooglePayments,
    required this.enableStripePayments,
    required this.game25,
    required this.game10,
    required this.game1,
    required this.game26,
    required this.game7,
    required this.game20,
    required this.game15,
    required this.game8,
    required this.isTest,
    required this.zegoAppId,
    required this.zegoAppSign,
    required this.zegoAppSecret
  });

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'id': int id,
        'agora_id': String agora_id,
        'enableGooglePayments': int enableGooglePayments,
        'enableStripePayments': int enableStripePayments,
        'game25': int game25,
        'game10': int game10,
        'game1': int game1,
        'game26': int game26,
        'game7': int game7,
        'game20': int game20,
        'game15': int game15,
        'game8': int game8,
        'isTest': int isTest,
        'zegoAppId': String zegoAppId,
        'zegoAppSign': String zegoAppSign,
        'zegoAppSecret': String zegoAppSecret
      } =>
        AppSettings(
          id: id,
          agora_id: agora_id,
          enableGooglePayments: enableGooglePayments,
          enableStripePayments: enableStripePayments,
          game25: game25,
          game10: game10,
          game1: game1,
          game26: game26,
          game7: game7,
          game20: game20,
          game15: game15,
          game8: game8,
          isTest: isTest,
          zegoAppId: zegoAppId,
          zegoAppSign: zegoAppSign,
          zegoAppSecret: zegoAppSecret
        ),
      _ => throw const FormatException('Failed to load album.'),
    };
  }
}
