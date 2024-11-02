class PostLike {
  final int id ;
  final int post_id ;
  final int user_id ;
  final int total_count ;
  final String user_name ;
  final String user_tag ;
  final String user_img ;
  final int gender ;

  PostLike({required this.id , required this.post_id , required this.user_id , required this.total_count ,
    required this.user_name , required this.user_tag , required this.user_img , required this.gender});

  factory PostLike.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
      'id': int id,
      'post_id': int post_id,
      'user_id': int user_id,
      'total_count': int total_count,
      'user_name': String user_name,
      'user_tag': String user_tag,
      'user_img': String user_img,
      'gender': int gender,
      } =>
          PostLike(
            id: id,
            post_id: post_id,
            user_id: user_id,
            total_count: total_count,
            user_name: user_name,
            user_tag: user_tag,
            user_img: user_img,
            gender: gender,
          ),
      _ => throw const FormatException('Failed to load album.'),
    };
  }

}