import 'package:LikLok/helpers/zego_handler/live_audio_room_manager.dart';
import 'package:LikLok/shared/network/remote/ChatRoomService.dart';

class ExitRoomHelper {
  final int user_id ;
  final int room_id ;
  ExitRoomHelper( this.user_id ,  this.room_id){
    handleExitRoom();
  }
  handleExitRoom() async{
    await ChatRoomService().exitRoom(user_id, room_id);
    ZegoLiveAudioRoomManager().logoutRoom();
    // await FirebaseFirestore.instance.collection("exitRoom").add({
    //   'room_id': room_id,
    //   'user_id': user_id,
    // });
  }
}