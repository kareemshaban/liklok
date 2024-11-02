class Comment {
  final int id ;
  final int post_id ;
  final int user_id ;
  final String content ;
  final int order ;
  final String user_name ;
  final String user_tag ;
  final String user_img ;
  final int gender ;
  final String created_at ;

  Comment({required this.id, required this.post_id, required this.user_id, required this.content, required this.order , required this.user_name , required this.user_tag , required this.user_img , required this.gender , required this.created_at});
  factory Comment.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
      'id': int id,
      'post_id': int post_id,
      'user_id': int user_id,
      'content': String content,
      'order': int order,
      'user_name': String user_name,
      'user_tag': String user_tag,
      'user_img': String user_img,
      'gender': int gender,
      'created_at': String created_at,
      } =>
          Comment(
            id: id,
            post_id: post_id,
            user_id: user_id,
            content: content,
            order: order,
            user_name: user_name,
            user_tag: user_tag,
            user_img: user_img,
            gender: gender,
            created_at: created_at,
          ),
      _ => throw const FormatException('Failed to load Country.'),
    };
  }


}