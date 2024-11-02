class AgencyMember {
  final String member_name ;
  final String member_tag ;
  final String member_img;
  final String joining_date ;
  final int state ;
  final int user_id ;

  AgencyMember({required this.member_img , required this.member_name , required this.member_tag , required this.joining_date , required this.state , required this.user_id });

  factory AgencyMember.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
      'member_img': String member_img,
      'member_name': String member_name,
      'member_tag': String member_tag,
      'joining_date': String joining_date,
      'state': int state,
      'user_id': int user_id

      } =>
          AgencyMember(
            member_img: member_img,
            member_name: member_name,
            member_tag: member_tag,
            joining_date: joining_date,
            state:state,
            user_id:user_id

          ),
      _ => throw const FormatException('Failed to load album.'),
    };
  }

}