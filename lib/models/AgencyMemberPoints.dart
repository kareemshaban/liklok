class AgencyMemberPoints {
  final int id ;
  final int user_id ;
  final int agency_id ;
  final int gift_id;
  final int points ;
  final String send_date ;

  AgencyMemberPoints({required this.id , required this.user_id , required this.agency_id ,
    required this.gift_id , required this.points , required this.send_date});

  factory AgencyMemberPoints.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
      'id': int id,
      'user_id': int user_id,
      'agency_id': int agency_id,
      'gift_id': int gift_id,
      'points': int points,
      'send_date': String send_date,

      } =>
          AgencyMemberPoints(
            id: id,
            user_id: user_id,
            agency_id: agency_id,
            gift_id: gift_id,
            points: points,
            send_date: send_date,

          ),
      _ => throw const FormatException('Failed to load album.'),
    };
  }

}