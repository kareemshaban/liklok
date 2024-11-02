import 'dart:convert';
import 'package:http/http.dart' as http;

class NotificationService{
  Future<void> send_notification(token,message,user)async{
    var response = await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization':'key=AAAAsUVSRRQ:APA91bH5pDo1aESqOjsK1e6ET65R2Oz8lwJDdJo7D9YHt5KPD0QBy6xC-aGFv7VFiYumU5ak1IV_JTKrJcrO3OzHnEDeZsdySQqIlu7hS7_tH7KXZsv2Vb8ZX54anC21Tg3O-0DA0w_1'
      },
      body: jsonEncode(<String, dynamic>{
          "to":token,

          "notification":{
            "title":"you have recieved a message from ${user}",
            "body":message,
            "sound":"default"
          },

          "android": {
            "priority": "HEIG",
            "notification": {
              "notification_priority" : "PRIORITY_MAX" ,
              "sound":"default",
              "default_sound": true ,
              "default_vibrate_timings":true ,
              "default_light_settings":true,
            }
          },
          "data":{
            "type":"order",
            "id":"87" ,
            "click_action":"FLUTTER_NOTIFICATION_CLICK"
          }
      }),
    );
    print(response..body);
  }
}