import 'dart:convert';

import 'package:LikLok/helpers/NotificationHelper.dart';
import 'package:LikLok/models/Announcement.dart';
import 'package:LikLok/models/Notification.dart';
import 'package:LikLok/shared/components/Constants.dart';
import 'package:http/http.dart' as http;
class NotificationServices {

  Future<NotificationHelper> getAllNotifications(user_id) async {
    final res = await http.get(Uri.parse('${BASEURL}notifications/all/${user_id}'));
    List<Announcement> announcements = [];
    List<UserNotification> notifications = [];
    NotificationHelper helper = new NotificationHelper(notifications: [] , announcements:[]) ;
    if (res.statusCode == 200) {
      final Map resonse = json.decode(res.body);
      for (var i = 0; i < resonse['notifications'].length; i ++) {
        UserNotification notification = UserNotification.fromJson(resonse['notifications'][i]);
        notifications.add(notification);
      }
      for (var j = 0; j < resonse['announcements'].length; j ++) {

        Announcement announcement = Announcement.fromJson(resonse['announcements'][j]);
        announcements.add(announcement);

      }
      helper.notifications = notifications ;
      helper.announcements = announcements ;
      return helper;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load post');
    }
  }


  Future<List<Announcement>> getAppNotifications() async {
    final res = await http.get(Uri.parse('${BASEURL}app/appNotifications'));
    List<Announcement> announcements = [];
    List<UserNotification> notifications = [];
    if (res.statusCode == 200) {
      final Map resonse = json.decode(res.body);
      for (var j = 0; j < resonse['notifications'].length; j ++) {

        Announcement announcement = Announcement.fromJson(resonse['notifications'][j]);
        announcements.add(announcement);

      }

      return announcements;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load post');
    }
  }



}