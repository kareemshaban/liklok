class RolletMember {
  final int rollet_user_id ;
  final String user_name ;
  final String user_img ;
  final int User_id ;

  RolletMember({required this.rollet_user_id , required this.user_name , required this.user_img ,required this.User_id});

  factory RolletMember.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
      'rollet_user_id': int rollet_user_id,
      'user_name': String user_name,
      'user_img': String user_img,
      'User_id': int User_id,
      } =>
          RolletMember(
              rollet_user_id: rollet_user_id,
              user_name: user_name,
              user_img: user_img,
              User_id: User_id
          ),
      _ => throw const FormatException('Failed to load album.'),
    };
  }

}