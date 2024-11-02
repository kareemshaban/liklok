class AgencyMemberStatics {
  final int id ;
  final int user_id ;
  final int agency_id ;
  final String start_time;
  final String end_time ;
  final String net_hours ;

  AgencyMemberStatics({required this.id , required this.user_id , required this.agency_id ,
    required this.start_time , required this.end_time , required this.net_hours });

  factory AgencyMemberStatics.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
      'id': int id,
      'user_id': int user_id,
      'agency_id': int agency_id,
      'start_time': String start_time,
      'end_time': String end_time,
      'net_hours': String net_hours,

      } =>
          AgencyMemberStatics(
            id: id,
            user_id: user_id,
            agency_id: agency_id,
            start_time: start_time,
            end_time: end_time,
            net_hours: net_hours,

          ),
      _ => throw const FormatException('Failed to load album.'),
    };
  }

}