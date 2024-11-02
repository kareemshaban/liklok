class Follower {
  final int id ;
  final int user_id ;
  final int follower_id ;
  final String following_date ;
  final String follower_name ;
  final String follower_tag ;
  final String follower_img ;
  final int follower_gender ;
  final String share_level_img ;
  final String karizma_level_img ;
  final String charging_level_img ;

  Follower({required this.id , required this.user_id , required this.follower_id , required this.following_date , required this.follower_name , required this.follower_tag ,
    required this.follower_img , required this.follower_gender , required this.share_level_img , required this.karizma_level_img , required this.charging_level_img});


  factory Follower.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
      'id': int id,
      'user_id': int user_id,
      'follower_id': int follower_id,
      'following_date': String following_date,
      'follower_name': String follower_name,
      'follower_tag': String follower_tag,
      'follower_img': String follower_img,
      'follower_gender': int follower_gender,
      'share_level_img': String share_level_img,
      'karizma_level_img': String karizma_level_img,
      'charging_level_img': String charging_level_img,

      } =>
          Follower(
            id: id,
            user_id: user_id,
            follower_id: follower_id,
            following_date: following_date,
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