import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:LikLok/shared/network/remote/ChatRoomService.dart';

class RoomHelper {
  final int room_id ;
  final int bg ;
  RoomHelper({required this.room_id , required this.bg});

  changeTheme() async{
    await ChatRoomService().changeTheme(bg, room_id);
    await FirebaseFirestore.instance.collection("themes").add({
      'room_id': room_id,
      'theme': bg,
    });

  }


}