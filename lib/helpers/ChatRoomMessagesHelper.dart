import 'dart:convert';
import 'package:LikLok/helpers/zego_handler/zego_sdk_manager.dart';

import '../models/Badge.dart';

class ChatRoomMessagesHelper {
  final int room_id;
  final int user_id;
  final String message;
  final String type;
  final String user_name;
  final String user_share_level_img;
  final String user_img;
  final String? vip;
  final String? pubble;
  final List<UserBadge>? badges;

  ChatRoomMessagesHelper({
    required this.room_id,
    required this.user_id,
    required this.message,
    required this.type,
    required this.user_name,
    required this.user_share_level_img,
    required this.user_img,
    required this.vip,
    required this.pubble,
    required this.badges,
  });

  Future<void> sendRoomEvent() async {
      try {
        final eventData = {
          'user_id': user_id,
          'room_id': room_id,
          'message': message,
          'type': type,
          'user_name': user_name,
          'user_share_level_img': user_share_level_img,
          'user_img': user_img,
          'vip': vip,
          'pubble': pubble,
          'badges': badges?.map((badge) => badge.toJson()).toList(),
          'timestamp': DateTime.now().toIso8601String(),
        };

        await ZEGOSDKManager().zimService.setRoomAttributes(
          {
            'room_event': jsonEncode(eventData),
          },
          isForce: true,
          isUpdateOwner: true,
          isDeleteAfterOwnerLeft: false,
        );

        print('✅ Room event sent: $eventData');
      } catch (e) {
        print('⚠️ Failed to send room event: $e');
      }
    }
}
