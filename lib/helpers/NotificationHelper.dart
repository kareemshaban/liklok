import 'package:LikLok/models/Announcement.dart';
import 'package:LikLok/models/Notification.dart';

class NotificationHelper {
  List<UserNotification>? notifications = [];
  List<Announcement>?   announcements  = [];

  NotificationHelper({this.notifications , this.announcements});
}