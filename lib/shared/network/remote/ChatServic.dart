import 'dart:convert';

import 'package:LikLok/models/Chat.dart';
import 'package:LikLok/shared/components/Constants.dart';
import 'package:http/http.dart' as http;

class ChatApiService {
Future<List<Chat>> getuserChats(user_id)async{
  List<Chat> chats  = [];
  var response = await http.get(
    Uri.parse('${BASEURL}chats/all/${user_id}'),
    headers: <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
  },
  );

  if (response.statusCode == 200) {
    final Map jsonData = json.decode(response.body);
    for( var i = 0 ; i < jsonData['chats'].length ; i ++ ){
      Chat tag = Chat.fromJson(jsonData['chats'][i]);
      chats.add(tag);
    }
    return chats ;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load tags');
  }
}

Future<void> send_Message(user_id,reciver_id,message)async{
  var response = await http.post(
     Uri.parse('${BASEURL}chats/sendMsg'),
    headers: <String,String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      "user_id": user_id.toString(),
      "reciver_id": reciver_id.toString(),
      "message": message.toString(),
      }
  )
  );
  print('response.body') ;
  print(response.body) ;
  if (response.statusCode == 200) {

  } else {
    throw Exception('Failed to load album');
  }

}
}