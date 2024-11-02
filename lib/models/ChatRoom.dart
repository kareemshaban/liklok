import 'package:LikLok/models/Mic.dart';
import 'package:LikLok/models/RoomAdmin.dart';
import 'package:LikLok/models/RoomBlock.dart';
import 'package:LikLok/models/RoomFollow.dart';
import 'package:LikLok/models/RoomMember.dart';

class ChatRoom {
  final int id ;
  final String tag ;
  final String name ;
  final String img ;
  final int state ;
  final String password ;
  final int userId ;
  final String subject ;
  final int talkers_count ;
  final int starred ;
  final int isBlocked ;
  final String blockedDate ;
  final String blockedUntil ;
  final String createdDate ;
  final int isTrend ;
  final String details ;
  final int micCount ;
  final int enableMessages ;
  final int reportCount ;
  final int themeId ;
  final int country_id ;
  final String flag ;
  final String admin_tag ;
  final String admin_name ;
  final String admin_img ;
  final String? room_bg ;
  final String hello_message ;
  List<Mic>? mics ;
  List<RoomMember>? members ;
  List<RoomAdmin>? admins ;
  List<RoomFollow>? followers ;
  List<RoomBlock>? blockers ;
  String? roomCup ;
  final int isCounter ;
  final int memberCount ;
  final String country_name ;



  ChatRoom({required this.id, required this.tag,required this.name, required this.img,required  this.state, required this.password, required this.userId, required this.subject, required this.talkers_count,
    required this.starred,required this.isBlocked,required this.blockedDate, required this.blockedUntil, required this.createdDate, required this.isTrend, required this.details, required this.micCount,
    required this.enableMessages, required this.reportCount, required this.themeId , required this.flag , required this.admin_tag , required this.admin_name , required this .admin_img , required this.country_id ,
    this.members , this.followers , this.admins , this.blockers , this.mics , this.room_bg , required this.hello_message , this.roomCup , required this.isCounter , required this.memberCount , required this.country_name});


  factory ChatRoom.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
      'id': int id,
      'tag': String tag,
      'name': String name,
      'img': String img,
      'state': int state,
      'password': String password,
      'userId': int userId,
      'subject': String subject,
      'talkers_count': int talkers_count,
      'starred': int starred,
      'isBlocked': int isBlocked,
      'blockedDate': String blockedDate,
      'blockedUntil': String blockedUntil,
      'createdDate': String createdDate,
      'isTrend': int isTrend,
      'details': String details,
      'micCount': int micCount,
      'enableMessages': int enableMessages,
      'reportCount': int reportCount,
      'themeId': int themeId,
      'country_id': int country_id,
      'flag': String flag,
      'admin_tag': String admin_tag,
      'admin_name': String admin_name,
      'admin_img': String admin_img,
      'room_bg' : String? room_bg,
      'hello_message': String hello_message ,
      'isCounter': int isCounter,
      'memberCount': int memberCount,
      'country_name': String country_name ,



      } =>
          ChatRoom(
              id: id,
              tag: tag,
              name: name,
              img: img,
              state: state,
              password: password,
              userId: userId,
              subject: subject,
              talkers_count: talkers_count,
              starred: starred,
              isBlocked: isBlocked,
              blockedDate: blockedDate,
              blockedUntil: blockedUntil,
              createdDate: createdDate,
              isTrend: isTrend,
              details: details,
              micCount: micCount,
              enableMessages: enableMessages,
              reportCount: reportCount,
              themeId: themeId,
              flag: flag,
              admin_tag: admin_tag,
              admin_name: admin_name,
              admin_img: admin_img,
              country_id: country_id,
              room_bg: room_bg,
              hello_message: hello_message,
              isCounter: isCounter,
              memberCount: memberCount,
              country_name: country_name

          ),
      _ => throw const FormatException('Failed to load Room.'),
    };
  }

}