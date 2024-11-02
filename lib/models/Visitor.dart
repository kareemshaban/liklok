class Visitor {
  final int id ;
  final int user_id ;
  final int visitor_id ;
  final int visits_count ;
  final String last_visit_date ;
  final String follower_name ;
  final String follower_tag ;
  final String follower_img ;
  final int follower_gender ;
  final String share_level_img ;
  final String karizma_level_img ;
  final String charging_level_img ;


  Visitor({required this.id , required this.user_id , required this.visitor_id , required this.visits_count , required this.last_visit_date , required this.follower_name , required this.follower_tag ,
    required this.follower_img , required this.follower_gender , required this.share_level_img , required this.karizma_level_img , required this.charging_level_img});


  factory Visitor.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
      'id': int id,
      'user_id': int user_id,
      'visitor_id': int visitor_id,
      'visits_count': int visits_count,
      'last_visit_date': String last_visit_date,
      'follower_name': String follower_name,
      'follower_tag': String follower_tag,
      'follower_img': String follower_img,
      'follower_gender': int follower_gender,
      'share_level_img': String share_level_img,
      'karizma_level_img': String karizma_level_img,
      'charging_level_img': String charging_level_img,

      } =>
          Visitor(
              id: id,
              user_id: user_id,
              visitor_id: visitor_id,
              visits_count: visits_count,
              last_visit_date: last_visit_date,
              follower_name: follower_name,
              follower_tag: follower_tag,
              follower_img: follower_img,
              follower_gender: follower_gender,
              share_level_img:share_level_img,
              karizma_level_img:karizma_level_img,
              charging_level_img:charging_level_img
          ),
      _ => throw const FormatException('Failed to load album.'),
    };
  }

}