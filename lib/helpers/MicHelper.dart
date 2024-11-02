import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:LikLok/shared/network/remote/ChatRoomService.dart';

class MicHelper {
  final int user_id ;
  final int room_id ;
  final int mic ;
  MicHelper({required this.user_id , required this.room_id , required this.mic});

  lockMic() async{
    await ChatRoomService().lockMic(user_id, room_id, mic);
    await FirebaseFirestore.instance.collection("mic-state").add({
      'room_id': room_id,
      'user_id': user_id,
      'mic': mic,
      'state': 0
    });
  }
  unlockMic() async{
    await ChatRoomService().unlockMic(user_id, room_id, mic);
    await FirebaseFirestore.instance.collection("mic-state").add({
      'room_id': room_id,
      'user_id': user_id,
      'mic': mic,
      'state': 1
    });
  }

  useMic() async{
    await ChatRoomService().useMic(user_id, room_id, mic);
    await FirebaseFirestore.instance.collection("mic-usage").add({
      'room_id': room_id,
      'user_id': user_id,
      'mic': mic,
      'using': 1
    });
  }
  leaveMic() async{
    await ChatRoomService().leaveMic(user_id, room_id, mic);
    await FirebaseFirestore.instance.collection("mic-usage").add({
      'room_id': room_id,
      'user_id': user_id,
      'mic': mic,
      'using': 0
    });
  }


  removeFromMic(admin_id) async{
    await ChatRoomService().leaveMic(user_id, room_id, mic);
    await FirebaseFirestore.instance.collection("mic-remove").add({
      'room_id': room_id,
      'admin_id': admin_id,
      'user_id': user_id,
      'mic': mic,
      'using': 0
    });
  }

  kickOut(block_type) async{
    await ChatRoomService().blockRoomMember(user_id , room_id , block_type);
    await FirebaseFirestore.instance.collection("room-block").add({
      'room_id': room_id,
      'block_type': block_type,
      'user_id': user_id,
    });
  }


  showEmoj(emoj) async {
    await FirebaseFirestore.instance.collection("emossions").add({
      'room_id': room_id,
      'mic': mic,
      'user': user_id,
      'emoj':emoj
    });
  }

}