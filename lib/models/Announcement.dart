class Announcement {

  final int id ;
  final String title ;
  final String message ;
  final String img ;
  final String link ;
  final int type ;
  final String user_id ;
  final String created_at ;

  Announcement({required this.id , required this.title , required this.message , required this.img , required this.link , required this.type , required this.user_id , required this.created_at});


  factory Announcement.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
      'id': int id,
      'title': String title,
      'message': String message,
      'img': String img,
      'link': String link,
      'type': int type,
      'user_id': String user_id,
      'created_at': String created_at,

      } =>
          Announcement(
            id: id,
            title: title,
            message: message,
            img: img,
            link: link,
            type: type,
            user_id: user_id,
            created_at: created_at,
          ),
      _ => throw const FormatException('Failed to load Announcement.'),
    };
  }


}