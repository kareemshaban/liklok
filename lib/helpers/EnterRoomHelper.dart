import 'package:LikLok/helpers/zego_handler/live_audio_room_manager.dart';
import 'package:LikLok/shared/network/remote/ChatRoomService.dart';

class EnterRoomHelper {
  final int user_id ;
  final int room_id ;
  final String token ;
  EnterRoomHelper( this.user_id ,  this.room_id, this.token){
    handleEnterRoom();
  }
  handleEnterRoom() async{
    print('handleEnterRoom1');
    await ChatRoomService().enterRoom(user_id, room_id);
    print('object');
    await ZegoLiveAudioRoomManager()
        .loginRoom(
      room_id.toString(),
      ZegoLiveAudioRoomRole.audience,
      token: token.toString(),
    )
        .then((result) {
      if (result.errorCode == 0) {
        print('Login Room Success');
        // log("Login Room Success");
      }
    }).onError(
          (error, stackTrace) {
            print('Login Room Error: $error');
        // log('error $error $stackTrace');
      },
    );
    print('handleEnterRoom2');
  }
}