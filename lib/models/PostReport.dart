class PostReport {
  final int id ;
  final int post_id ;
  final int user_id ;
  final int type ;

  PostReport({required this.id , required this.post_id , required this.user_id , required this.type});

  factory PostReport.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
      'id': int id,
      'post_id': int post_id,
      'user_id': int user_id,
      'type': int type,
      } =>
          PostReport(
            id: id,
            post_id: post_id,
            user_id: user_id,
            type: type,
          ),
      _ => throw const FormatException('Failed to load album.'),
    };
  }

}