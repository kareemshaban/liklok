class FestivalBanner {
  final int id ;
  final String title ;
  final int type ;
  final String description ;
  final String img ;
  final int room_id ;
  final String start_date ;
  final String  duration_in_hour ;
  final int enable ;
  final int accepted ;


  const FestivalBanner({required this.id, required this.type, required this.title, required this.description,
    required this.img, required this.room_id, required this.start_date, required this.duration_in_hour, required this.enable , required this.accepted});


  factory FestivalBanner.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
      'id': int id,
      'type': int type,
      'title': String title,
      'description': String description,
      'img': String img,
      'room_id': int room_id,
      'start_date': String start_date,
      'duration_in_hour': String duration_in_hour,
      'enable': int enable,
      'accepted': int accepted,
      } =>
          FestivalBanner(
            id: id,
            type: type,
            title: title,
            description: description,
            img: img,
            room_id: room_id,
            start_date: start_date,
            duration_in_hour: duration_in_hour,
            accepted: accepted,
            enable: enable,
          ),
      _ => throw const FormatException('Failed to load album.'),
    };
  }

}