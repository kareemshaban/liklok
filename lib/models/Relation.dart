import 'package:LikLok/models/Mall.dart';

class RelationModel {
  final int id ;
  final String name;
  final String tag;
  final String price;
  final String icon ;
  final String motion_icon ;


  RelationModel({required this.id , required this.name , required this.tag , required this.price , required this.icon , required this.motion_icon});

  factory RelationModel.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
      'id': int id,
      'name': String name,
      'tag': String tag,
      'price': String price,
      'icon': String icon,
      'motion_icon': String motion_icon,

      } =>
          RelationModel(
            id: id,
            name: name,
            tag: tag,
            price: price,
            icon: icon,
            motion_icon: motion_icon,

          ),
      _ => throw const FormatException('Failed to load album.'),
    };
  }
}