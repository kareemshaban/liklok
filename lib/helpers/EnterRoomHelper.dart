import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:LikLok/shared/network/remote/ChatRoomService.dart';

class EnterRoomHelper {
  final int user_id ;
  final int room_id ;
  EnterRoomHelper( this.user_id ,  this.room_id){
    handleEnterRoom();
  }
  handleEnterRoom() async{
    print('handleEnterRoom1');
    await ChatRoomService().enterRoom(user_id, room_id);
    await FirebaseFirestore.instance.collection("enterRoom").add({
      'room_id': room_id,
      'user_id': user_id,
    });
    print('handleEnterRoom2');
  }





}