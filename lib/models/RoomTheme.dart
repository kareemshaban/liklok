class RoomTheme {
  final int id ;
  final String name ;
  final String img ;
  final int isMain ;


  RoomTheme({required this.id , required this.name , required this.img , required this.isMain});

  factory RoomTheme.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
      'id': int id,
      'img': String img,
      'name': String name ,
      'isMain': int isMain
      } =>
          RoomTheme(
              id: id,
              img: img,
              isMain: isMain,
              name: name
          ),
      _ => throw const FormatException('Failed to load album.'),
    };
  }
}