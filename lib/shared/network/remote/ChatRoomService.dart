import 'dart:io';
import 'package:LikLok/helpers/RoomBasicDataHelper.dart';
import 'package:LikLok/helpers/RoomCupHelper.dart';
import 'package:LikLok/helpers/RoomHelper.dart';
import 'package:LikLok/models/AppUser.dart';
import 'package:LikLok/models/Badge.dart';
import 'package:LikLok/models/Category.dart';
import 'package:LikLok/models/ChatRoom.dart';
import 'package:LikLok/models/Emossion.dart';
import 'package:LikLok/models/Gift.dart';
import 'package:LikLok/models/LuckyCase.dart';
import 'package:LikLok/models/Mic.dart';
import 'package:LikLok/models/Rollet.dart';
import 'package:LikLok/models/RolletMember.dart';
import 'package:LikLok/models/RoomAdmin.dart';
import 'package:LikLok/models/RoomBlock.dart';
import 'package:LikLok/models/RoomCup.dart';
import 'package:LikLok/models/RoomFollow.dart';
import 'package:LikLok/models/RoomMember.dart';
import 'package:LikLok/models/RoomTheme.dart';
import 'package:LikLok/models/token_model.dart';
import 'package:LikLok/shared/components/Constants.dart';
import 'package:LikLok/shared/network/remote/AppUserServices.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:x_overlay/x_overlay.dart';

import '../../../models/ChatRoomMessage.dart';



class ChatRoomService {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  static final XOverlayController overlayController = XOverlayController();
  static final ChatRoomService _instance = ChatRoomService._internal();
  factory ChatRoomService() => _instance;
  ChatRoomService._internal();
  static bool isShow = false ;
  final List<ChatRoomMessage> _messages = [];
  List<ChatRoomMessage> get messages => _messages;
  static ChatRoom? room  ;
  static ChatRoom? savedRoom  ;
  static RtcEngine? engine ;
  static String userRole = "clientRoleAudience" ; // clientRoleBroadcaster , clientRoleAudience
  static int musicPlayedIndex = - 1 ;
  static bool showMsgInput = false ;
  static RoomBasicDataHelper? roomBasicDataHelper  ;
  static Set<String> displayedUsers = {};
  roomSetter(ChatRoom u){
    room = u ;
  }
  ChatRoom? roomGetter(){
    return room ;
  }

  savedRoomSetter(ChatRoom? u){
    savedRoom = u ;
  }
  ChatRoom? savedRoomGetter(){
    return savedRoom ;
  }

  roomBasicDataHelperSetter(RoomBasicDataHelper u){
    roomBasicDataHelper = u ;
  }
  RoomBasicDataHelper? roomBasicDataHelperGetter(){
    return roomBasicDataHelper ;
  }

  static List<ChatRoom> rooms = [] ;
  roomsSetter( List<ChatRoom> u){
    rooms = u ;
  }
  List<ChatRoom> roomsGetter(){
    return rooms ;
  }

  static List<ChatRoom>  userRoom = [] ;
  userRoomSetter(List<ChatRoom> u){
    userRoom = u ;
  }
  List<ChatRoom> userRoomGetter(){
    return userRoom ;
  }
  void addMessage(ChatRoomMessage message) {
    _messages.add(message);
    debugPrint('📩 تم حفظ الرسالة في ChatRoomService');
  }

  void clearMessages() {
    _messages.clear();
  }

  static void showOverlay() {
    overlayController.overlay(
      navigatorKey.currentContext!,
      data: XOverlayData(),
      rootNavigator: false,
    );
    isShow = true ;
  }

  static void restoreOverlay() {
    overlayController.restore(
      navigatorKey.currentContext!,
      rootNavigator: true,
      withSafeArea: false,
    );
    isShow = false ;
  }

  static void hideOverlay() {
    overlayController.hide();
  }

  Future<List<ChatRoom>> getAllChatRooms() async {
    final response = await http.get(Uri.parse('${BASEURL}chatRooms/getAll'));
    List<ChatRoom> rooms = [];
    print(response.body);
    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      for (var i = 0; i < jsonData.length; i ++) {
        ChatRoom room = ChatRoom.fromJson(jsonData[i]);
        rooms.add(room);
      }
      return rooms;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load chatroom');
    }
  }

  Future<List<ChatRoom>> getAdminChatRooms(id) async {
    final response = await http.get(Uri.parse('${BASEURL}chatRooms/getAdminRoom/${id}'));
    List<ChatRoom> rooms = [];
    print(response.body);
    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      for (var i = 0; i < jsonData.length; i ++) {
        ChatRoom room = ChatRoom.fromJson(jsonData[i]);
        rooms.add(room);
      }
      return rooms;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load chatroom');
    }
  }

  Future<List<ChatRoom>> searchRoom(txt) async {
    final response = await http.get(
        Uri.parse('${BASEURL}chatRooms/Search/${txt}'));
    List<ChatRoom> rooms = [];
    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      for (var i = 0; i < jsonData.length; i ++) {
        ChatRoom user = ChatRoom.fromJson(jsonData[i]);
        rooms.add(user);
      }
      return rooms;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  ChatRoom mapRoom(jsonData){
    ChatRoom room;
    List<Mic> mics = [] ;
    List<RoomMember> members = [] ;
    List<UserBadge> badges = [] ;
    List<RoomAdmin> admins = [] ;
    List<RoomFollow> followers = [] ;
    List<RoomBlock> blockers = [] ;
    room = ChatRoom.fromJson(jsonData['room']);
    int roomCup = jsonData['roomCup'] ;
    room.roomCup = roomCup.toString() ;

    for (var j = 0; j < jsonData['mics'].length; j ++) {
      Mic mic = Mic.fromJson(jsonData['mics'][j]);
      mics.add(mic);
    }
    for (var j = 0; j < jsonData['members'].length; j ++) {
      badges = [] ;
      RoomMember member = RoomMember.fromJson(jsonData['members'][j]);
      for(var n = 0; n < jsonData['members'][j]['badges'].length; n ++){
        UserBadge badge = UserBadge.fromJson(jsonData['members'][j]['badges'][n]);

        badges.add(badge);
      }
      member.badges = badges ;
      members.add(member);
    }
    for (var j = 0; j < jsonData['admins'].length; j ++) {
      RoomAdmin admin = RoomAdmin.fromJson(jsonData['admins'][j]);
      admins.add(admin);
    }

    for (var j = 0; j < jsonData['followers'].length; j ++) {
      RoomFollow follow = RoomFollow.fromJson(jsonData['followers'][j]);
      followers.add(follow);
    }
    for (var j = 0; j < jsonData['blockers'].length; j ++) {
      RoomBlock block = RoomBlock.fromJson(jsonData['blockers'][j]);
      if(checkBlockDate(block)){
        blockers.add(block);
      }

    }
    room.mics = mics ;
    room.blockers = blockers ;
    room.admins = admins ;
    room.members = members ;
    room.followers = followers ;


    return room;
  }
  bool checkBlockDate(RoomBlock block){

    final DateTime block_until = DateTime.parse(block.block_until);
   // final DateTime blocked_date = DateTime.parse(block.blocked_date);
    final DateTime currentDate = DateTime.now() ;

    final Duration duration = block_until.difference(currentDate);
    if(block.block_type == 'HOUR'){
      print('duration.inHours');
      print(duration.inMinutes);
      return duration.inMinutes > 0  ;
    } else if(block.block_type == 'DAY'){
      return duration.inHours > -1  ;
    } else {
      return duration.inDays > -1 ;
    }

  }

  Future<ChatRoom?> openMyRoom(admin_id) async {
    final response = await http.get(
        Uri.parse('${BASEURL}chatRooms/getRoom/${admin_id}'));

    print(response.body);
    if (response.statusCode == 200) {
      final Map jsonData = json.decode(response.body);
      if (jsonData['state'] == "success") {
        return mapRoom(jsonData);
      } else {
        Fluttertoast.showToast(
            msg: 'remote_chat_msg_failed'.tr,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black26,
            textColor: Colors.orange,
            fontSize: 16.0
        );
      }
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  Future<ChatRoom?> openRoomById(room_id) async {
    final response = await http.get(
        Uri.parse('${BASEURL}chatRooms/getRoomById/${room_id}'));
    if (response.statusCode == 200) {
      final Map jsonData = json.decode(response.body);
      if (jsonData['state'] == "success") {
        return mapRoom(jsonData);
      } else {
        Fluttertoast.showToast(
            msg: 'remote_chat_msg_failed'.tr,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black26,
            textColor: Colors.orange,
            fontSize: 16.0
        );
        return null ;
      }
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  Future<ChatRoom?> openRoomByAdminId(admin_id) async {
    final response = await http.get(
        Uri.parse('${BASEURL}chatRooms/getRoomByAdmin/${admin_id}'));
    print(response.body);
    if (response.statusCode == 200) {
      final Map jsonData = json.decode(response.body);
      if (jsonData['state'] == "success") {
        return mapRoom(jsonData);

      } else {
        print(jsonData['message']);

        return null ;
      }
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  Future<ChatRoom?> trackUser(user_id) async {
    final response = await http.get(
        Uri.parse('${BASEURL}chatRooms/trackUser/${user_id}'));
    if (response.statusCode == 200) {
      final Map jsonData = json.decode(response.body);
      if (jsonData['state'] == "success") {
        return mapRoom(jsonData);
      } else {
        print(jsonData['message']);

        return null ;
      }
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  Future<RoomBasicDataHelper?> getRoomBasicData() async {
    final response = await http.get(
        Uri.parse('${BASEURL}chatRooms/getBasicData'));

    List<Emossion> emossions = [];
    List<RoomTheme> themes = [];
    List<Gift> gifts = [];
    List<Category> categories = [];
    RoomBasicDataHelper helper = RoomBasicDataHelper(emossions: emossions, themes: themes, gifts: gifts, categories: categories);
    if (response.statusCode == 200) {
      final Map jsonData = json.decode(response.body);
      if (jsonData['state'] == "success") {
        for (var j = 0; j < jsonData['emossions'].length; j ++) {
          Emossion emossion = Emossion.fromJson(jsonData['emossions'][j]);
          emossions.add(emossion);
        }
        for (var j = 0; j < jsonData['themes'].length; j ++) {
          RoomTheme theme = RoomTheme.fromJson(jsonData['themes'][j]);
          themes.add(theme);
        }
        for (var j = 0; j < jsonData['gifts'].length; j ++) {
          Gift gift = Gift.fromJson(jsonData['gifts'][j]);
          gifts.add(gift);
        }

        for (var j = 0; j < jsonData['giftCategories'].length; j ++) {
          Category category = Category.fromJson(jsonData['giftCategories'][j]);
          categories.add(category);
        }

        helper.categories = categories ;
        helper.gifts = gifts ;
        helper.themes = themes ;
        helper.emossions = emossions ;


        return helper;
      } else {

      }
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  Future<ChatRoom?> updateRoomName(id , name , user_id) async {
    var response = await http.post(
      Uri.parse('${BASEURL}chatRooms/updateName'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'id': id.toString(),
        'name': name.toString(),
        'user_id': user_id.toString()
      }),
    );
    if (response.statusCode == 200) {
      final Map jsonData = json.decode(response.body);
      if (jsonData['state'] == "success") {
        return mapRoom(jsonData);
      } else {
        Fluttertoast.showToast(
            msg: jsonData['message'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black26,
            textColor: Colors.orange,
            fontSize: 16.0
        );
        throw Exception('Failed to load album');
      }
    }
  }

  Future<ChatRoom?> updateRoomHello(id , hello_message , user_id) async {
    var response = await http.post(
      Uri.parse('${BASEURL}chatRooms/updateHello'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'id': id.toString(),
        'hello_message': hello_message.toString(),
        'user_id': user_id.toString()
      }),
    );
    print(response.body);
    if (response.statusCode == 200) {
      final Map jsonData = json.decode(response.body);
      if (jsonData['state'] == "success") {
        return mapRoom(jsonData);
      } else {
        Fluttertoast.showToast(
            msg: 'remote_chat_msg_failed'.tr,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black26,
            textColor: Colors.orange,
            fontSize: 16.0
        );
      }

    } else {
      throw Exception('Failed to load album');
    }
  }

  Future<ChatRoom?> updateRoomPassword(id , password , user_id) async {
    var response = await http.post(
      Uri.parse('${BASEURL}chatRooms/updatePassword'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'id': id.toString(),
        'password': password.toString(),
        'user_id': user_id.toString()
      }),
    );
    print(response);
    if (response.statusCode == 200) {
      final Map jsonData = json.decode(response.body);
      if (jsonData['state'] == "success") {
        return mapRoom(jsonData);
      } else {
        Fluttertoast.showToast(
            msg: jsonData['message'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black26,
            textColor: Colors.orange,
            fontSize: 16.0
        );
      }

    } else {
      throw Exception('Failed to load album');
    }
  }

  Future<ChatRoom?> enterRoom(user_id , room_id) async {
    var response = await http.post(
      Uri.parse('${BASEURL}chatRooms/enterRoom'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'user_id': user_id.toString(),
        'room_id': room_id.toString(),
      }),
    );
    if (response.statusCode == 200) {
      final Map jsonData = json.decode(response.body);
      if (jsonData['state'] == "success") {
        room = ChatRoom.fromJson(jsonData['room']);
        return mapRoom(jsonData);
      } else {
        // Fluttertoast.showToast(
        //     msg: 'remote_chat_msg_failed'.tr,
        //     toastLength: Toast.LENGTH_SHORT,
        //     gravity: ToastGravity.CENTER,
        //     timeInSecForIosWeb: 1,
        //     backgroundColor: Colors.black26,
        //     textColor: Colors.orange,
        //     fontSize: 16.0
        // );
      }

    } else {
      throw Exception('Failed to load album');
    }
  }
  Future<ChatRoom?> exitRoom(user_id , room_id) async {

    var response = await http.post(
      Uri.parse('${BASEURL}chatRooms/exitRoom'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'user_id': user_id.toString(),
        'room_id': room_id.toString(),
      }),
    );
    print(response.body);
    if (response.statusCode == 200) {
      final Map jsonData = json.decode(response.body);
      if (jsonData['state'] == "success") {
        return mapRoom(jsonData);
      } else {
        // Fluttertoast.showToast(
        //     msg: 'remote_chat_msg_failed'.tr,
        //     toastLength: Toast.LENGTH_SHORT,
        //     gravity: ToastGravity.CENTER,
        //     timeInSecForIosWeb: 1,
        //     backgroundColor: Colors.black26,
        //     textColor: Colors.orange,
        //     fontSize: 16.0
        // );
      }

    } else {
      throw Exception('Failed to load album');
    }
  }


  Future<bool> exitAllRoom(user_id) async {

    var response = await http.post(
      Uri.parse('${BASEURL}chatRooms/exitAllRoom'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'user_id': user_id.toString(),
      }),
    );
    print(response.body);
    if (response.statusCode == 200) {
      final Map jsonData = json.decode(response.body);
      if (jsonData['state'] == "success") {
        return true ;
      } else {
        return false ;
      }

    } else {
      throw Exception('Failed to load album');
    }
  }



  Future<ChatRoom?> lockMic(user_id , room_id , mic , admin_id) async {
    var response = await http.post(
      Uri.parse('${BASEURL}chatRooms/lockMic'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'user_id': user_id.toString(),
        'room_id': room_id.toString(),
        'mic': mic.toString(),
        'admin_id': admin_id.toString()
      }),
    );
    print(response.body);
    if (response.statusCode == 200) {
      final Map jsonData = json.decode(response.body);
      if (jsonData['state'] == "success") {
        return mapRoom(jsonData);
      } else {
        Fluttertoast.showToast(
            msg: jsonData['message'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black26,
            textColor: Colors.orange,
            fontSize: 16.0
        );
      }

    } else {
      throw Exception('Failed to load album ${response.statusCode}');
    }
  }
  Future<ChatRoom?> unlockMic(user_id , room_id , mic , admin_id) async {

    var response = await http.post(
      Uri.parse('${BASEURL}chatRooms/unlockMic'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'user_id': user_id.toString(),
        'room_id': room_id.toString(),
        'mic': mic.toString(),
        'admin_id': admin_id.toString()
      }),
    );
    print(response.body);
    if (response.statusCode == 200) {
      final Map jsonData = json.decode(response.body);
      if (jsonData['state'] == "success") {
        return mapRoom(jsonData);
      } else {
        Fluttertoast.showToast(
            msg: jsonData['message'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black26,
            textColor: Colors.orange,
            fontSize: 16.0
        );
      }

    } else {
      throw Exception('Failed to load album');
    }
  }

  Future<ChatRoom?> useMic(user_id , room_id , mic) async {
    var response = await http.post(
      Uri.parse('${BASEURL}chatRooms/useMic'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'user_id': user_id.toString(),
        'room_id': room_id.toString(),
        'mic': mic.toString()
      }),
    );
    print('useMic' );
    print(user_id );
    print(room_id);
    print(mic);
    if (response.statusCode == 200) {
      final Map jsonData = json.decode(response.body);
      if (jsonData['state'] == "success") {
        return mapRoom(jsonData);
      } else {
        // Fluttertoast.showToast(
        //     msg: 'remote_chat_msg_failed'.tr,
        //     toastLength: Toast.LENGTH_SHORT,
        //     gravity: ToastGravity.CENTER,
        //     timeInSecForIosWeb: 1,
        //     backgroundColor: Colors.black26,
        //     textColor: Colors.orange,
        //     fontSize: 16.0
        // );
      }

    } else {
      throw Exception('Failed to load album');
    }
  }


  Future<ChatRoom?> leaveMic(user_id , room_id , mic , admin_id) async {
    var response = await http.post(
      Uri.parse('${BASEURL}chatRooms/leaveMic'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'user_id': user_id.toString(),
        'room_id': room_id.toString(),
        'mic': mic.toString(),
         'admin_id': admin_id.toString()
      }),
    );
    print(response.body);
    if (response.statusCode == 200) {
      final Map jsonData = json.decode(response.body);
      if (jsonData['state'] == "success") {
        print('leave mic success');
        return mapRoom(jsonData);
      } else {
        // Fluttertoast.showToast(
        //     msg: 'remote_chat_msg_failed'.tr,
        //     toastLength: Toast.LENGTH_SHORT,
        //     gravity: ToastGravity.CENTER,
        //     timeInSecForIosWeb: 1,
        //     backgroundColor: Colors.black26,
        //     textColor: Colors.orange,
        //     fontSize: 16.0
        // );
      }

    } else {
      throw Exception('Failed to load album');
    }
  }

  Future<ChatRoom?> changeTheme(bg , room_id) async {
    var response = await http.post(
      Uri.parse('${BASEURL}chatRooms/chnageRoomBg'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'room_id': room_id.toString(),
        'bg': bg.toString()
      }),
    );
    if (response.statusCode == 200) {
      final Map jsonData = json.decode(response.body);
      if (jsonData['state'] == "success") {
        return mapRoom(jsonData);
      } else {
        // Fluttertoast.showToast(
        //     msg: 'remote_chat_msg_failed'.tr,
        //     toastLength: Toast.LENGTH_SHORT,
        //     gravity: ToastGravity.CENTER,
        //     timeInSecForIosWeb: 1,
        //     backgroundColor: Colors.black26,
        //     textColor: Colors.orange,
        //     fontSize: 16.0
        // );
      }

    } else {
      throw Exception('Failed to load album');
    }
  }

  Future<int> sendGift(sender_id , recevier_id , owner_id , room_id , gift_id , count) async{


    var response = await http.post(
      Uri.parse('${BASEURL}gifts/sendGift'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'sender_id': sender_id.toString(),
        'recevier_id': recevier_id.toString(),
        'owner_id': owner_id.toString(),
        'room_id': room_id.toString(),
        'gift_id': gift_id.toString(),
        'count': count.toString(),
      }),
    );

    if (response.statusCode == 200) {
      final Map jsonData = json.decode(response.body);
      print(jsonData['message'] );
      if(jsonData['message'] == 'success'){
        print('reward');
         print(jsonData['reward']);
        return  jsonData['reward'];
      } else {
        Fluttertoast.showToast(
            msg: jsonData['message'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black26,
            textColor: Colors.orange,
            fontSize: 16.0
        );
        return -1 ;
      }


    } else {
      print(response.body);
      throw Exception('Failed to send gift');



    }
  }

  Future<int> sendGiftMicUsers(sender_id  , owner_id , room_id , gift_id , count) async{


    var response = await http.post(
      Uri.parse('${BASEURL}gifts/sendGiftToMicUsers'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'sender_id': sender_id.toString(),
        'owner_id': owner_id.toString(),
        'room_id': room_id.toString(),
        'gift_id': gift_id.toString(),
        'count': count.toString(),
      }),
    );

    if (response.statusCode == 200) {
      final Map jsonData = json.decode(response.body);
      print(jsonData['message'] );
      if(jsonData['message'] == 'success'){
        return  jsonData['reward'];
      } else {
        Fluttertoast.showToast(
            msg: jsonData['message'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black26,
            textColor: Colors.orange,
            fontSize: 16.0
        );
        return -1 ;
      }


    } else {
      print(response.body);
      throw Exception('Failed to send gift');



    }
  }

  Future<int> sendGiftMembers(sender_id  , owner_id , room_id , gift_id , count) async{


    var response = await http.post(
      Uri.parse('${BASEURL}gifts/sendGiftToRoomUsers'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'sender_id': sender_id.toString(),
        'owner_id': owner_id.toString(),
        'room_id': room_id.toString(),
        'gift_id': gift_id.toString(),
        'count': count.toString(),
      }),
    );

    if (response.statusCode == 200) {
      final Map jsonData = json.decode(response.body);
      print(jsonData['message'] );
      if(jsonData['message'] == 'success'){
        return  jsonData['reward'];
      } else {
        Fluttertoast.showToast(
            msg: jsonData['message'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black26,
            textColor: Colors.orange,
            fontSize: 16.0
        );
        return -1 ;
      }


    } else {
      print(response.body);
      throw Exception('Failed to send gift');



    }
  }

  Future<RoomCupHelper> getRoomCup($room_id) async {

    List<RoomCup> daily = [] ;
    List<RoomCup> weekly = [] ;
    List<RoomCup> monthly = [] ;
    RoomCupHelper helper = new RoomCupHelper(daily: daily , weekly: weekly , monthly: monthly);
    final response = await http.get(
        Uri.parse('${BASEURL}chatRooms/getRoomCup/${$room_id}'));
    if (response.statusCode == 200) {
      final Map jsonData = json.decode(response.body);
      AppUser? user ;
      for (var j = 0; j < jsonData['daily'].length; j ++) {
        RoomCup cup = RoomCup.fromJson(jsonData['daily'][j]);
        user = await AppUserServices().getUser(cup.sender_id);
        cup.user = user ;
        daily.add(cup);
      }
      for (var j = 0; j < jsonData['weekly'].length; j ++) {
        RoomCup cup = RoomCup.fromJson(jsonData['weekly'][j]);
        user = await AppUserServices().getUser(cup.sender_id);
        cup.user = user ;
        weekly.add(cup);
      }
      for (var j = 0; j < jsonData['monthly'].length; j ++) {
        RoomCup cup = RoomCup.fromJson(jsonData['monthly'][j]);
        user = await AppUserServices().getUser(cup.sender_id);
        cup.user = user ;
        monthly.add(cup);
      }
      helper.daily = daily ;
      helper.monthly = monthly ;
      helper.weekly = weekly ;

      return helper ;
    } else {
      throw Exception('Failed to load album');
    }

  }


  Future<ChatRoom?> updateRoomCategory(id , subject , user_id) async {
    var response = await http.post(
      Uri.parse('${BASEURL}chatRooms/updateRoomCategory'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'id': id.toString(),
        'subject': subject.toString(),
        'user_id': user_id.toString()
      }),
    );
    if (response.statusCode == 200) {
      final Map jsonData = json.decode(response.body);
      if (jsonData['state'] == "success") {
        return mapRoom(jsonData);
      } else {
        Fluttertoast.showToast(
            msg: jsonData['message'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black26,
            textColor: Colors.orange,
            fontSize: 16.0
        );
      }

    } else {
      throw Exception('Failed to load album');
    }
  }

  Future<AppUser?> updateRoomImg(id , File? imageFile , user_id  ) async {

    var stream = new http.ByteStream(DelegatingStream.typed(imageFile!.openRead()));
    var length = await imageFile.length();

    var uri = Uri.parse(BASEURL+'chatRooms/updateRoomImage');

    var request = new http.MultipartRequest("POST", uri);
    var multipartFile = new http.MultipartFile('img', stream, length,
        filename: basename(imageFile.path));
    //contentType: new MediaType('image', 'png'));

    request.files.add(multipartFile);
    request.fields.addAll(<String, String>{
      'id': id.toString() ,
      'user_id': user_id.toString()
    });
    var response = await request.send();
    print('upload image');
    print(response.statusCode);
    response.stream.transform(utf8.decoder).listen((value) {
      print(value);
    });

  }

  Future<ChatRoom?> addChatRoomAdmin(user_id , room_id , admin_id) async {
    ChatRoom room;
    List<Mic> mics = [] ;
    List<RoomMember> members = [] ;
    List<RoomAdmin> admins = [] ;
    List<RoomFollow> followers = [] ;
    List<RoomBlock> blockers = [] ;
    var response = await http.post(
      Uri.parse('${BASEURL}chatRooms/addAdmin'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'user_id': user_id.toString(),
        'room_id': room_id.toString(),
        'admin_id': admin_id.toString()
      }),
    );
    if (response.statusCode == 200) {
      final Map jsonData = json.decode(response.body);
      if (jsonData['state'] == "success") {
        return mapRoom(jsonData);
      } else {
        Fluttertoast.showToast(
            msg: jsonData['message'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black26,
            textColor: Colors.orange,
            fontSize: 16.0
        );
      }

    } else {
      throw Exception('Failed to load album');
    }
  }

  Future<ChatRoom?> removeChatRoomAdmin(user_id , room_id , admin_id) async {
    var response = await http.post(
      Uri.parse('${BASEURL}chatRooms/removeAdmin'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'user_id': user_id.toString(),
        'room_id': room_id.toString(),
        'admin_id': admin_id.toString()
      }),
    );
    if (response.statusCode == 200) {
      final Map jsonData = json.decode(response.body);
      if (jsonData['state'] == "success") {
        return mapRoom(jsonData);
      } else {
        Fluttertoast.showToast(
            msg: jsonData['message'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black26,
            textColor: Colors.orange,
            fontSize: 16.0
        );
      }

    } else {
      throw Exception('Failed to load album');
    }
  }

  Future<ChatRoom?> toggleRoomCounter(room_id) async {
    final response = await http.get(
        Uri.parse('${BASEURL}chatRooms/toggleCounter/${room_id}'));
    print(response.body);
    if (response.statusCode == 200) {
      final Map jsonData = json.decode(response.body);
      if (jsonData['state'] == "success") {
        return mapRoom(jsonData);
      } else {
        print(jsonData['message']);

        return null ;
      }
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }


  Future<ChatRoom?> blockRoomMember(user_id , room_id , block_type , admin_id) async {
    var response = await http.post(
      Uri.parse('${BASEURL}chatRooms/blockRoomMember'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'user_id': user_id.toString(),
        'room_id': room_id.toString(),
        'block_type': block_type.toString(),
        'admin_id': admin_id.toString()
      }),
    );
    print(response.body);
    if (response.statusCode == 200) {
      final Map jsonData = json.decode(response.body);
      if (jsonData['state'] == "success") {
        return mapRoom(jsonData);
      } else {
        Fluttertoast.showToast(
            msg: jsonData['message'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black26,
            textColor: Colors.orange,
            fontSize: 16.0
        );

        return null ;
      }
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  Future<ChatRoom?> unBlockRoomMember(user_id , room_id , admin_id) async {
    var response = await http.post(
      Uri.parse('${BASEURL}chatRooms/unBlockRoomMember'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'user_id': user_id.toString(),
        'room_id': room_id.toString(),
        'admin_id': admin_id.toString()
      }),
    );
    print(response.body);
    if (response.statusCode == 200) {
      final Map jsonData = json.decode(response.body);
      if (jsonData['state'] == "success") {
        return mapRoom(jsonData);
      } else {
        Fluttertoast.showToast(
            msg: jsonData['message'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black26,
            textColor: Colors.orange,
            fontSize: 16.0
        );

        return null ;
      }
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }


  Future<LuckyCase?> createLuckyCase(room_id , user_id  , type , value) async {
    var response = await http.post(
      Uri.parse('${BASEURL}chatRooms/luckyCase/craete'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'room_id': room_id.toString(),
        'user_id': user_id.toString(),
        'type': type.toString(),
        'value': value.toString(),
        'created_date': DateTime.now().toString()
      }),
    );
    print('responseresponse');
    print(response);

    if (response.statusCode == 200) {
      final Map jsonData = json.decode(response.body);
      print(jsonData['lucky']);
      if (jsonData['state'] == "success") {
        LuckyCase luckyCase = LuckyCase.fromJson(jsonData['lucky']);
        return luckyCase ;

      } else {
        Fluttertoast.showToast(
            msg: jsonData['message'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black26,
            textColor: Colors.orange,
            fontSize: 16.0
        );

        return null ;
      }
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  Future<LuckyCase?> useLuckyCase(room_id , user_id  , lucky_id , value) async {
    var response = await http.post(
      Uri.parse('${BASEURL}chatRooms/luckyCase/use'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'room_id': room_id.toString(),
        'user_id': user_id.toString(),
        'lucky_id': lucky_id.toString(),
        'value': value.toString()
      }),
    );
    if (response.statusCode == 200) {
      final Map jsonData = json.decode(response.body);
      if (jsonData['state'] == "success") {
        LuckyCase luckyCase = LuckyCase.fromJson(jsonData['lucky']);
        return luckyCase ;

      } else {
        print(jsonData['message']);

        return null ;
      }
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  Future<LuckyCase?> getLuckyCase(lucky_id) async {
    final response = await http.get(
        Uri.parse('${BASEURL}chatRooms/luckyCase/get/${lucky_id}'));
    if (response.statusCode == 200) {
      final Map jsonData = json.decode(response.body);
      if (jsonData['state'] == "success") {
        LuckyCase luckyCase = LuckyCase.fromJson(jsonData['lucky']);
        return luckyCase ;

      } else {
        Fluttertoast.showToast(
            msg: jsonData['message'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black26,
            textColor: Colors.orange,
            fontSize: 16.0
        );
        return null ;
      }
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  Future<LuckyCase?> getRoomLuckyCase(room_id) async {
    final response = await http.get(
        Uri.parse('${BASEURL}chatRooms/luckyCase/getLuckyRoom/${room_id}'));
    if (response.statusCode == 200) {
      final Map jsonData = json.decode(response.body);
      if (jsonData['state'] == "success") {
        LuckyCase luckyCase = LuckyCase.fromJson(jsonData['lucky']);
        return luckyCase ;

      } else {
        // Fluttertoast.showToast(
        //     msg: jsonData['message'],
        //     toastLength: Toast.LENGTH_SHORT,
        //     gravity: ToastGravity.CENTER,
        //     timeInSecForIosWeb: 1,
        //     backgroundColor: Colors.black26,
        //     textColor: Colors.orange,
        //     fontSize: 16.0
        // );
        return null ;
      }
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }


  Future<Rollet?> createRollet(room_id , user_id  , value , adminShare , member_count) async {
    print('adminShare');
    print(adminShare);
    var response = await http.post(
      Uri.parse('${BASEURL}chatRooms/rollet/craete'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'room_id': room_id.toString(),
        'user_id': user_id.toString(),
        'type': '0',
        'value': value.toString(),
        'adminShare': adminShare.toString(),
        'member_count': member_count.toString(),
      }),
    );
    print(response.body);
    if (response.statusCode == 200) {
      final Map jsonData = json.decode(response.body);
      if (jsonData['state'] == "success") {
        Rollet rollet = Rollet.fromJson(jsonData['rollet']);
        List<RolletMember> members = [] ;
        for (var j = 0; j < jsonData['members'].length; j ++) {
          RolletMember member = RolletMember.fromJson(jsonData['members'][j]);
          members.add(member);
        }
        rollet.members = members ;

        return rollet ;

      } else {
        print(jsonData['message']);

        return null ;
      }
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  Future<Rollet?> getRollet(rollet_id) async {
    final response = await http.get(
        Uri.parse('${BASEURL}chatRooms/rollet/get/${rollet_id}'));
    if (response.statusCode == 200) {
      final Map jsonData = json.decode(response.body);
      if (jsonData['state'] == "success") {
        Rollet rollet = Rollet.fromJson(jsonData['rollet']);
        List<RolletMember> members = [] ;
        for (var j = 0; j < jsonData['members'].length; j ++) {
          RolletMember member = RolletMember.fromJson(jsonData['members'][j]);
          members.add(member);
        }
        rollet.members = members ;

        return rollet ;


      } else {
        // Fluttertoast.showToast(
        //     msg: jsonData['message'],
        //     toastLength: Toast.LENGTH_SHORT,
        //     gravity: ToastGravity.CENTER,
        //     timeInSecForIosWeb: 1,
        //     backgroundColor: Colors.black26,
        //     textColor: Colors.orange,
        //     fontSize: 16.0
        // );
        return null ;
      }
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  Future<Rollet?> getRoomActiveRollet(room_id) async {
    final response = await http.get(
        Uri.parse('${BASEURL}chatRooms/rollet/getRoomActiveRollet/${room_id}'));
    if (response.statusCode == 200) {
      final Map jsonData = json.decode(response.body);
      if (jsonData['state'] == "success") {
        Rollet rollet = Rollet.fromJson(jsonData['rollet']);
        return rollet ;

      } else {
        // Fluttertoast.showToast(
        //     msg: jsonData['message'],
        //     toastLength: Toast.LENGTH_SHORT,
        //     gravity: ToastGravity.CENTER,
        //     timeInSecForIosWeb: 1,
        //     backgroundColor: Colors.black26,
        //     textColor: Colors.orange,
        //     fontSize: 16.0
        // );
        return null ;
      }
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  Future<Rollet?> addUserToRollet(rollet_id , user_id) async {
    final response = await http.get(
        Uri.parse('${BASEURL}chatRooms/rollet/subscripe/${rollet_id}/${user_id}'));
    if (response.statusCode == 200) {
      final Map jsonData = json.decode(response.body);
      if (jsonData['state'] == "success") {
        Rollet rollet = Rollet.fromJson(jsonData['rollet']);
        List<RolletMember> members = [] ;
        for (var j = 0; j < jsonData['members'].length; j ++) {
          RolletMember member = RolletMember.fromJson(jsonData['members'][j]);
          members.add(member);
        }
        rollet.members = members ;

        return rollet ;

      } else {
        // Fluttertoast.showToast(
        //     msg: jsonData['message'],
        //     toastLength: Toast.LENGTH_SHORT,
        //     gravity: ToastGravity.CENTER,
        //     timeInSecForIosWeb: 1,
        //     backgroundColor: Colors.black26,
        //     textColor: Colors.orange,
        //     fontSize: 16.0
        // );
        return null ;
      }
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  Future<Rollet?> startRollet(rollet_id ) async {
    final response = await http.get(
        Uri.parse('${BASEURL}chatRooms/rollet/start/${rollet_id}'));
    if (response.statusCode == 200) {
      final Map jsonData = json.decode(response.body);
      if (jsonData['state'] == "success") {
        Rollet rollet = Rollet.fromJson(jsonData['rollet']);
        List<RolletMember> members = [] ;
        for (var j = 0; j < jsonData['members'].length; j ++) {
          RolletMember member = RolletMember.fromJson(jsonData['members'][j]);
          members.add(member);
        }
        rollet.members = members ;

        return rollet ;

      } else {
        // Fluttertoast.showToast(
        //     msg: jsonData['message'],
        //     toastLength: Toast.LENGTH_SHORT,
        //     gravity: ToastGravity.CENTER,
        //     timeInSecForIosWeb: 1,
        //     backgroundColor: Colors.black26,
        //     textColor: Colors.orange,
        //     fontSize: 16.0
        // );
        return null ;
      }
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  Future<Rollet?> RolletLoser(rollet_id , user_id) async {
    print('RolletLoser');
    print(rollet_id);
    print(user_id);
    final response = await http.get(
        Uri.parse('${BASEURL}chatRooms/rollet/loser/${rollet_id}/${user_id}'));
    print(response.body);
    if (response.statusCode == 200) {
      final Map jsonData = json.decode(response.body);
      if (jsonData['state'] == "success") {
        Rollet rollet = Rollet.fromJson(jsonData['rollet']);
        List<RolletMember> members = [] ;
        for (var j = 0; j < jsonData['members'].length; j ++) {
          RolletMember member = RolletMember.fromJson(jsonData['members'][j]);
          members.add(member);
        }
        rollet.members = members ;

        return rollet ;

      } else {
        // Fluttertoast.showToast(
        //     msg: jsonData['message'],
        //     toastLength: Toast.LENGTH_SHORT,
        //     gravity: ToastGravity.CENTER,
        //     timeInSecForIosWeb: 1,
        //     backgroundColor: Colors.black26,
        //     textColor: Colors.orange,
        //     fontSize: 16.0
        // );
        return null ;
      }
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  Future<TokenModel> generateToken(id) async {
    final response = await  http.get(Uri.parse('${BASEURL}zekoToken?user_id=$id'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      print(response.body);
      return TokenModel.fromJson(data);
    } else {
      throw Exception('Failed to fetch token: ${response.statusCode}');
    }
  }

 //

}