class ChargingOperation {
  final int id ;
  final int user_id ;
  final int gold ;
  final String source ;
  final int state ;
  final String charging_date;

  ChargingOperation({required this.id , required this.user_id , required this.gold , required this.source ,
    required this.state , required this.charging_date});

  factory ChargingOperation.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
      'id': int id,
      'user_id': int user_id,
      'gold': int gold,
      'source': String source,
      'state': int state,
      'charging_date': String charging_date
      } =>
          ChargingOperation(
              id: id,
              user_id: user_id,
              gold: gold,
              source: source,
              state: state,
              charging_date: charging_date,
          ),
      _ => throw const FormatException('Failed to load Country.'),
    };
  }

}