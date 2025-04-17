class Intro {
  final int id ;
  final String img ;
  final int active ;

  Intro({ required this.id , required this.img , required this.active});

  factory Intro.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {

      'id': int id,
      'img': String img,
      'active': int active,

      } =>
          Intro(
            id: id,
            img: img,
            active: active,
          ),
      _ => throw const FormatException('Failed to load album.'),
    };
  }
}