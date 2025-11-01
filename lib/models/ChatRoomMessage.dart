import 'Badge.dart';

class ChatRoomMessage {
  int? roomId; // تم الإضافة
  final String message;
  final String user_name;
  final String user_share_level_img;
  final String user_img;
  final int user_id;
  final String type;
  final String? vip;
  final String? pubble;
  List<UserBadge>? badges;

  ChatRoomMessage({
    this.roomId, // تم الإضافة
    required this.message,
    required this.user_name,
    required this.user_share_level_img,
    required this.user_img,
    required this.user_id,
    required this.type,
    this.vip,
    this.pubble,
    this.badges,
  });

  Map<String, dynamic> toJson() {
    return {
      'room_id': roomId, // تم الإضافة
      'message': message,
      'user_name': user_name,
      'user_share_level_img': user_share_level_img,
      'user_img': user_img,
      'user_id': user_id,
      'type': type,
      'vip': vip,
      'pubble': pubble,
      'badges': badges?.map((badge) => badge.toJson()).toList(),
    };
  }

  factory ChatRoomMessage.fromJson(Map<String, dynamic> json) {
    return ChatRoomMessage(
      roomId: json['room_id'] is int
          ? json['room_id']
          : int.tryParse(json['room_id'].toString()) ?? 0,
      message: json['message'] ?? '',
      user_name: json['user_name'] ?? '',
      user_share_level_img: json['user_share_level_img'] ?? '',
      user_img: json['user_img'] ?? '',
      user_id: json['user_id'] is int
          ? json['user_id']
          : int.tryParse(json['user_id'].toString()) ?? 0,
      type: json['type'] ?? '',
      vip: json['vip'],
      pubble: json['pubble'],
      badges: json['badges'] != null
          ? (json['badges'] as List)
          .map((item) => UserBadge.fromJson(item))
          .toList()
          : null,
    );
  }
}
