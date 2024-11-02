import 'package:LikLok/models/Badge.dart';

class ChatRoomMessage {
  final String message ;
  final String user_name;
  final String user_share_level_img ;
  final String user_img ;
  final int user_id ;
  final String type ;
  final String? vip ;
  final String? pubble ;
  List<UserBadge>? badges ;
  ChatRoomMessage({required this.message , required this.user_name , required this.user_share_level_img ,
    required this.user_img , required this.user_id , required this.type , this.vip , this.pubble , this.badges});
}