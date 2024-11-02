class BannerData {
  final int id ;
  final int type ;
  final String name ;
  final int order ;
  final String img ;
  final int action ;
  final String url ;
  final int user_id ;
  final int room_id ;

 const BannerData({required this.id, required this.type, required this.name, required this.order,
   required this.img, required this.action, required this.url, required this.user_id, required this.room_id});


  factory BannerData.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
      'id': int id,
      'type': int type,
      'name': String name,
      'order': int order,
      'img': String img,
      'action': int action,
      'url': String url,
      'user_id': int user_id,
      'room_id': int room_id,
      } =>
          BannerData(
            id: id,
            type: type,
            name: name,
            order: order,
            img: img,
            action: action,
            url: url,
            user_id: user_id,
            room_id: room_id,
          ),
      _ => throw const FormatException('Failed to load album.'),
    };
  }

}