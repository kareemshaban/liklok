import 'dart:convert';

import 'package:LikLok/helpers/zego_handler/zego_sdk_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:LikLok/shared/network/remote/ChatRoomService.dart';

class RoomHelper {
  final int room_id ;
  final int bg ;
  RoomHelper({required this.room_id , required this.bg});

  // changeTheme() async{
  //   await ChatRoomService().changeTheme(bg, room_id);
  //   await FirebaseFirestore.instance.collection("themes").add({
  //     'room_id': room_id,
  //     'theme': bg,
  //   });
  //
  // }

  Future<void> sendThemeChangeEvent(user_id) async {
    final themeData = {
      'room_id': room_id,
      'theme_id': bg,
      'user_id': user_id,
    };

    await ZEGOSDKManager().zimService.setRoomAttributes(
      {
        'theme_event': jsonEncode(themeData),
      },
      isForce: true,
      isUpdateOwner: false,
      isDeleteAfterOwnerLeft: false,
    );

    print('🎨 Theme change event sent: $themeData');
  }

}