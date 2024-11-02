class Emossion {
  final int id ;
  final String img ;
  final String icon;

  Emossion({required this.id , required this.img , required this.icon});

  factory Emossion.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
      'id': int id,
      'img': String img,
      'icon': String icon
      } =>
          Emossion(
              id: id,
              img: img,
              icon: icon
          ),
      _ => throw const FormatException('Failed to load album.'),
    };
  }


}