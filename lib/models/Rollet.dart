import 'package:LikLok/models/RolletMember.dart';

class Rollet {
  final int id ;
  final int type ;
  final int value ;
  final int member_count ;
  final int adminShare ;
  final int state ;
  final int room_id;
  final int winner_id ;
  final int actual_member_count ;
  List<RolletMember>? members = [] ;
  Rollet({required this.id , required this.type , required this.value , required this.member_count , required this.adminShare , required this.state , required this.room_id , required this.winner_id ,
  required this.actual_member_count , this.members });

  factory Rollet.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
      'id': int id,
      'type': int type,
      'value': int value,
      'member_count': int member_count,
      'adminShare': int adminShare,
      'state': int state,
      'room_id': int room_id,
      'winner_id': int winner_id,
      'actual_member_count': int actual_member_count
      } =>
          Rollet(
              id: id,
              type: type,
              value: value,
              member_count: member_count,
              adminShare: adminShare,
              state: state,
              room_id: room_id,
              winner_id: winner_id,
              actual_member_count: actual_member_count

          ),
      _ => throw const FormatException('Failed to load album.'),
    };
  }

}