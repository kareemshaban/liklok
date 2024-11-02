import 'package:LikLok/models/Announcement.dart';

class UserNotification {

final int id ;
final String type ;
final int notified_user ;
final int action_user ;
final String title ;
final String content ;
final String title_ar ;
final String content_ar ;
final int isRead ;
final int post_id ;
final String notified_user_name ;
final String notified_user_tag ;
final String notified_user_img ;
final String action_user_name ;
final String action_user_tag ;
final String action_user_img ;
final String created_at ;
final int notified_user_gender;
final int action_user_gender ;


UserNotification({required this.id, required this.type, required this.notified_user, required this.action_user, required this.title, required this.content, required this.title_ar, required this.content_ar,
  required this.isRead, required this.post_id, required this.notified_user_name, required this.notified_user_tag, required this.notified_user_img, required this.action_user_name,
  required this.action_user_tag, required this.action_user_img , required this.created_at , required this.notified_user_gender , required this.action_user_gender} );


factory UserNotification.fromJson(Map<String, dynamic> json) {
  return switch (json) {
    {
    'id': int id,
    'type': String type,
    'notified_user': int notified_user,
    'action_user': int action_user,
    'title': String title,
    'content': String content,
    'title_ar': String title_ar,
    'content_ar': String content_ar,
    'isRead': int isRead,
    'post_id': int post_id,
    'notified_user_name': String notified_user_name,
    'notified_user_tag': String notified_user_tag,
    'notified_user_img': String notified_user_img,
    'action_user_name': String action_user_name,
    'action_user_tag': String action_user_tag,
    'action_user_img': String action_user_img,
    'created_at': String created_at,
    'notified_user_gender': int notified_user_gender,
    'action_user_gender': int action_user_gender,

    } =>
        UserNotification(
          id: id,
          type: type,
          notified_user: notified_user,
          action_user: action_user,
          title: title,
          content: content,
          title_ar: title_ar,
          content_ar: content_ar,
          isRead: isRead,
          post_id: post_id,
          notified_user_name: notified_user_name,
          notified_user_tag: notified_user_tag,
          notified_user_img: notified_user_img,
          action_user_name: action_user_name,
          action_user_tag: action_user_tag,
          action_user_img: action_user_img,
          created_at: created_at,
          notified_user_gender: notified_user_gender,
          action_user_gender: action_user_gender
        ),
    _ => throw const FormatException('Failed to load Notification.'),
  };
}

}