import 'dart:convert';

import 'package:LikLok/helpers/zego_handler/zego_sdk_manager.dart';
import 'package:LikLok/models/AppUser.dart';
import 'package:LikLok/shared/network/remote/AppUserServices.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:LikLok/shared/network/remote/ChatRoomService.dart';

class MicHelper {
  final int user_id;

  final int room_id;

  final int mic;

  final AppUser user;

  MicHelper(
    this.user, {
    required this.user_id,
    required this.room_id,
    required this.mic,
  });

  // lockMic() async{
  //   await ChatRoomService().lockMic(user_id, room_id, mic , AppUserServices().userGetter()!.id);
  //   await FirebaseFirestore.instance.collection("mic-state").add({
  //     'room_id': room_id,
  //     'user_id': user_id,
  //     'mic': mic,
  //     'state': 0
  //   });
  // }

  lockMic() async {
    final micData = {
      'mic_state': 0,
      'user_id': user_id,
      'mic': mic,
      'room_id': room_id,
    };

    await ZEGOSDKManager().zimService.setRoomAttributes(
      {'lock_event': jsonEncode(micData)},
      isForce: true,
      isUpdateOwner: false,
      isDeleteAfterOwnerLeft: false,
    );
    print("🔒 تم قفل المايك بنجاح");
  }

  unlockMic() async {
    final micData = {
      'mic_state': 0,
      'user_id': user_id,
      'mic': mic,
      'room_id': room_id,
    };

    await ZEGOSDKManager().zimService.setRoomAttributes(
      {'unlock_event': jsonEncode(micData)},
      isForce: true,
      isUpdateOwner: false,
      isDeleteAfterOwnerLeft: false,
    );
  }

  // unlockMic() async{
  //   await ChatRoomService().unlockMic(user_id, room_id, mic , AppUserServices().userGetter()!.id);
  //   await FirebaseFirestore.instance.collection("mic-state").add({
  //     'room_id': room_id,
  //     'user_id': user_id,
  //     'mic': mic,
  //     'state': 1
  //   });
  // }

  Future<void> sendMicEvent() async {
    final micData = {
      'id': mic - 1,
      'room_id': room_id,
      'order': mic,
      'user_id': user_id,
      'isClosed': 0,
      'isMute': 0,
      'counter': 0,
      'mic_user_charging_level': user.charging_level_icon,
      'mic_user_karizma_level': user.karizma_level_icon,
      'mic_user_birth_date': user.birth_date,
      'mic_user_share_level': user.share_level_icon,
      'mic_user_tag': user.tag,
      'mic_user_name': user.name,
      'mic_user_img': user.img,
      'mic_user_gender': user.gender,
      'fram': '',
    };

    await ZEGOSDKManager().zimService.setRoomAttributes(
      {'mic_event': jsonEncode(micData)},
      isForce: true,
      isUpdateOwner: false,
      isDeleteAfterOwnerLeft: false,
    );

    print('🎤 Mic event sent: $micData');
  }

  Future<void> sendMicLeaveEvent(audioPlayer, zegoEngine) async {
    final micLeaveData = {
      'id': mic - 1,
      'room_id': room_id,
      'order': mic,
      'user_id': user_id,
      'isClosed': 0,
      'isMute': 0,
      'counter': 0,
      'mic_user_charging_level': user.charging_level_icon,
      'mic_user_karizma_level': user.karizma_level_icon,
      'mic_user_birth_date': user.birth_date,
      'mic_user_share_level': user.share_level_icon,
      'mic_user_tag': user.tag,
      'mic_user_name': user.name,
      'mic_user_img': user.img,
      'mic_user_gender': user.gender,
      'fram': '',
    };

    await ZEGOSDKManager().zimService.setRoomAttributes(
      {'mic_leave_event': jsonEncode(micLeaveData)},
      isForce: true,
      isUpdateOwner: false,
      isDeleteAfterOwnerLeft: false,
    );
    final state = await audioPlayer!.getCurrentState();

    if (state == ZegoMediaPlayerState.Playing) {
      await audioPlayer!.stop();
      print("🛑 Media player stopped successfully");
    } else {
      print("ℹ️ No media currently playing");
    }
    print('📴 Mic leave event sent: $micLeaveData');
  }

  leaveMic() async {
    await ChatRoomService().leaveMic(user_id, room_id, mic, 0);
    await FirebaseFirestore.instance.collection("mic-usage").add({
      'room_id': room_id,
      'user_id': user_id,
      'mic': mic,
      'using': 0,
    });
  }

  // removeFromMic(admin_id) async {
  //   await ChatRoomService().leaveMic(user_id, room_id, mic, admin_id);
  //   await FirebaseFirestore.instance.collection("mic-remove").add({
  //     'room_id': room_id,
  //     'admin_id': admin_id,
  //     'user_id': user_id,
  //     'mic': mic,
  //     'using': 0,
  //   });
  // }

  removeFromMic(adminId) async {
    print('adminId');
    print(adminId);
    final removeData = {
      'room_id': room_id,
      'admin_id': adminId,
      'user_id': user_id,
      'mic': mic,
      'using': 0,
    };

    await ZEGOSDKManager().zimService.setRoomAttributes(
      {
        'remove_event': jsonEncode(removeData),
      },
      isForce: true,
      isUpdateOwner: false,
      isDeleteAfterOwnerLeft: false,
    );

    print("🚫 تم إزالة المستخدم من المايك");
  }


  // kickOut(block_type) async {
  //   await ChatRoomService().blockRoomMember(
  //     user_id,
  //     room_id,
  //     block_type,
  //     AppUserServices().userGetter()!.id,
  //   );
  //   await FirebaseFirestore.instance.collection("room-block").add({
  //     'room_id': room_id,
  //     'block_type': block_type,
  //     'user_id': user_id,
  //   });
  // }

  kickOut(blockType) async {
    final kickData = {
      'room_id': room_id,
      'block_type': blockType,
      'user_id': user_id,
      'mic': mic,
    };

    await ZEGOSDKManager().zimService.setRoomAttributes(
      {
        'kick_event': jsonEncode(kickData),
      },
      isForce: true,
      isUpdateOwner: false,
      isDeleteAfterOwnerLeft: false,
    );

    print("🚨 تم طرد المستخدم من الغرفة");
  }


  showEmoj(String emoj) async {
    try {
      final emojiData = {
        'type': 'emoji_event',
        'room_id': room_id,
        'mic': mic,
        'user_id': user_id,
        'emoj': emoj,
        'time': DateTime.now().toIso8601String(),
      };

      await ZEGOSDKManager().zimService.setRoomAttributes(
        {'emoji_event': jsonEncode(emojiData)},
        isForce: true,
        isUpdateOwner: false,
        isDeleteAfterOwnerLeft: false,
      );

      print('🎉 Emoji event sent: $emojiData');
    } catch (e) {
      print('❌ Failed to send emoji event: $e');
    }
  }
}
