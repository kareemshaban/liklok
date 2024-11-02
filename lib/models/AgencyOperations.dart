class AgencyOperations {
  final int id ;
  final int agency_id ;
  final int user_id ;
  final String type ;
  final int gold ;
  final String source ;
  final int state ;
  final String charging_date ;
  final String? user_name ;

  AgencyOperations({required this.id , required this.agency_id , required this.user_id , required this.type , required this.gold
  , required this.source , required this.state , required this.charging_date , this.user_name});

  factory AgencyOperations.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
      'id': int id,
      'agency_id': int agency_id,
      'user_id': int user_id,
      'type': String type,
      'gold': int gold,
      'source': String source,
      'state': int state,
      'charging_date': String charging_date,
      'user_name': String? user_name,
      } =>
          AgencyOperations(
            id: id,
            agency_id: agency_id,
            user_id: user_id,
            type: type,
            gold: gold,
            source: source,
            state: state,
            charging_date: charging_date,
            user_name: user_name,
          ),
      _ => throw const FormatException('Failed to load album.'),
    };
  }

}