class Category {
  final int id ;
  final String name ;
  final int order ;
  final int enable ;

  Category({required this.id , required this.name , required this.order , required this.enable});

  factory Category.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
      'id': int id,
      'name': String name,
      'order': int order,
      'enable': int enable
      } =>
          Category(
            id: id,
            name: name,
            order: order,
            enable: enable
          ),
      _ => throw const FormatException('Failed to load album.'),
    };
  }


}