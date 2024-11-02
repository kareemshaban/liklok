class UserHoppy {
  final int id ;
  final String name ;
  final int user_id ;

  UserHoppy({required this.id , required this.name , required this.user_id});

  factory UserHoppy.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
      'id': int id,
      'name': String name,
      'user_id': int user_id,
      } =>
          UserHoppy(
            id: id,
            name: name,
            user_id: user_id,
          ),
      _ => throw const FormatException('Failed to load album.'),
    };
  }

}