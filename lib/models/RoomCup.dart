import 'package:LikLok/models/AppUser.dart';

class RoomCup {
  final int sender_id ;
  final String sum ;
  AppUser? user ;
  RoomCup({required this.sender_id , required this.sum , this.user});

  factory RoomCup.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
      'sender_id': int sender_id,
      'sum': String sum,

      } =>
          RoomCup(
              sender_id: sender_id,
              sum: sum,

          ),
      _ => throw const FormatException('Failed to load album.'),
    };
  }
}