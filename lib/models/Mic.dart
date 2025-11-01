import 'package:LikLok/models/Design.dart';

class   Mic {
  final int id ;
  final int room_id ;
  final int order ;
  final int user_id ;
  final int isClosed ;
  final int isMute ;
  final String? mic_user_tag ;
  final String? mic_user_name ;
  final String? mic_user_img ;
  final int? mic_user_gender ;
  final String? mic_user_birth_date ;
  final String? mic_user_share_level ;
  final String? mic_user_karizma_level ;
  final String? mic_user_charging_level ;
  String? frame ;
  final int counter ;

  Mic({required this.id , required this.room_id , required this.order, required this.user_id , required this.isClosed ,
    required this.isMute ,
    this.mic_user_tag , this.mic_user_name , this.mic_user_img , this.mic_user_gender , this.mic_user_birth_date ,
    this.mic_user_share_level , this.mic_user_karizma_level , this.mic_user_charging_level , this.frame , required this.counter});


  factory Mic.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
      'id': int id,
      'room_id': int room_id,
      'order': int order,
      'user_id': int user_id,
      'isClosed': int isClosed,
      'isMute': int isMute,
      'mic_user_tag': String? mic_user_tag,
      'mic_user_name': String? mic_user_name,
      'mic_user_img': String? mic_user_img,
      'mic_user_gender': int? mic_user_gender,
      'mic_user_birth_date': String? mic_user_birth_date,
      'mic_user_share_level': String? mic_user_share_level,
      'mic_user_karizma_level': String? mic_user_karizma_level,
      'mic_user_charging_level': String? mic_user_charging_level,
      'frame': String? frame ,
      'counter': int counter
      } =>
          Mic(
              id: id,
              room_id: room_id,
              order: order,
              user_id: user_id,
              isClosed: isClosed,
              isMute: isMute,
              mic_user_tag: mic_user_tag,
              mic_user_name: mic_user_name,
              mic_user_img: mic_user_img,
              mic_user_gender: mic_user_gender,
              mic_user_birth_date: mic_user_birth_date,
              mic_user_share_level: mic_user_share_level,
              mic_user_karizma_level: mic_user_karizma_level,
              mic_user_charging_level: mic_user_charging_level,
              frame:  frame ,
              counter:counter
          ),
      _ => throw const FormatException('Failed to load album.'),
    };
  }
}