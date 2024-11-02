import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRoomMessagesHelper {
  final int room_id ;
  final int user_id ;
  final String message ;
  final String type ; //'TEXT' , 'GIFT' , 'NURD' , 'LUCKY'

  ChatRoomMessagesHelper({required this.room_id , required this.user_id , required this.message  , required this.type});

  handleSendRoomMessage() async{
    await FirebaseFirestore.instance.collection("RoomMessages").add({
      'room_id': room_id,
      'user_id': user_id,
      'message': message,
      'type': type
    });
  }

}