import 'package:LikLok/shared/network/remote/ChatRoomService.dart';
import 'package:flutter/material.dart';

class EnterRoomHelper {
  final int user_id ;
  final int room_id ;
  final BuildContext context; // ✅ أضفنا الكونتكست
  EnterRoomHelper( this.user_id ,  this.room_id, this.context,){
    handleEnterRoom();
  }
  handleEnterRoom() async{
    print('handleEnterRoom1');
    // final token = await ChatRoomService().generateToken(user_id);
    await ChatRoomService().enterRoom(user_id, room_id);
    print('✅ دخل الروم $room_id');
  }
}