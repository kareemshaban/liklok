class AgencyMemberWithStatics {
  final String member_name ;
  final String member_tag ;
  final String member_img;
  final String joining_date ;
  final int user_id ;
  final int points ;
  final int days ;
  final String hostSalary ;
  final String agentSalary ;



  AgencyMemberWithStatics({required this.member_img , required this.member_name , required this.member_tag , required this.joining_date  , required this.user_id ,
  required this.points , required this.days , required this.hostSalary , required this.agentSalary});

  factory AgencyMemberWithStatics.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
      'member_img': String member_img,
      'member_name': String member_name,
      'member_tag': String member_tag,
      'joining_date': String joining_date,
      'user_id': int user_id,
      'points': int points,
      'days': int days,
      'hostSalary': String hostSalary,
      'agentSalary': String agentSalary,
      } =>
          AgencyMemberWithStatics(
            member_img: member_img,
            member_name: member_name,
            member_tag: member_tag,
            joining_date: joining_date,
            user_id:user_id,
            points:points,
            days:days,
            hostSalary:hostSalary,
            agentSalary:agentSalary,
          ),
      _ => throw const FormatException('Failed to load album.'),
    };
  }

}