class LevelStats {
  final int charging_value ;
  final int charging_up_value ;
  final double charging_percent ;
  final int share_value ;
  final int share_up ;
  final double share_percent ;
  final int karizma_value ;
  final int karizma_up ;
  final double karizma_percent ;

  LevelStats({required this.charging_value , required this.charging_up_value , required this.charging_percent , required this.share_value , required this.share_up , required this.share_percent ,
  required this.karizma_value , required this.karizma_up , required this.karizma_percent});

  factory LevelStats.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
      'charging_value': int charging_value,
      'charging_up_value': int charging_up_value,
      'charging_percent': double charging_percent,
      'share_value': int share_value,
      'share_up': int share_up,
      'share_percent': double share_percent,
      'karizma_value': int karizma_value,
      'karizma_up': int karizma_up,
      'karizma_percent': double karizma_percent,

      } =>
          LevelStats(
              charging_value: charging_value,
              charging_up_value: charging_up_value,
              charging_percent: charging_percent,
              share_value: share_value,
              share_up: share_up,
              share_percent: share_percent,
              karizma_value: karizma_value,
              karizma_up: karizma_up,
              karizma_percent:karizma_percent,
          ),
      _ => throw const FormatException('Failed to load album.'),
    };
  }
}