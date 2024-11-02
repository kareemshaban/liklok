class Medal {
  final int id ;
  final String name ;
  final String icon ;
  final String description ;

  Medal({required this.id , required this.name , required this.icon , required this.description});

  factory Medal.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
      'id': int id,
      'name': String name,
      'icon': String icon,
      'description': String description
      } =>
          Medal(
              id: id,
              name: name,
              icon: icon,
              description: description
          ),
      _ => throw const FormatException('Failed to load album.'),
    };
  }
}