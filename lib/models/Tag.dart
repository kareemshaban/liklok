class Tag {
  final int id ;
  final String name  ;
  final int type ;

  Tag({ required this.id , required this.name , required this.type  });


  factory Tag.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
      'id': int id,
      'name': String name,
      'type': int type,
      } =>
          Tag(
            id: id,
            name: name,
            type: type,
          ),
      _ => throw const FormatException('Failed to load album.'),
    };
  }

}