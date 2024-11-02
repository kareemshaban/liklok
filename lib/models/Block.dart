class Block {
  final int id ;
  final int user_id ;
  final int blocke_user ;
  final String blocked_date ;
  final String blocked_name ;
  final String blocked_tag ;




  Block({required this.id , required this.user_id , required this.blocke_user , required this.blocked_date , required this.blocked_name ,
    required this.blocked_tag  });


  factory Block.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
      'id': int id,
      'user_id': int user_id,
      'blocke_user': int blocke_user,
      'blocked_date': String blocked_date,
      'blocked_name': String blocked_name,
      'blocked_tag': String blocked_tag,


      } =>
          Block(
              id: id,
              user_id: user_id,
              blocke_user: blocke_user,
              blocked_date: blocked_date,
              blocked_name: blocked_name,
              blocked_tag: blocked_tag,
          ),
      _ => throw const FormatException('Failed to load album.'),
    };
  }

}