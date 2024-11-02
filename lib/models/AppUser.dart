import 'package:LikLok/models/Block.dart';
import 'package:LikLok/models/Follower.dart';
import 'package:LikLok/models/Friends.dart';
import 'package:LikLok/models/Medal.dart';
import 'package:LikLok/models/UserHoppy.dart';
import 'package:LikLok/models/Vip.dart';
import 'package:LikLok/models/Visitor.dart';

class AppUser {
   final int id ;
   final String tag ;
   final String name ;
   final String img ;
   final int share_level_id ;
   final int karizma_level_id ;
   final int charging_level_id ;
   final String phone ;
   final String email ;
   final String password ;
   final int isChargingAgent ;
   final int isHostingAgent ;
   final String registered_at ;
   final String last_login ;
   final String birth_date ;
   final int enable ;
   final String ipAddress ;
   final String macAddress ;
   final String deviceId ;
   final int isOnline ;
   final int isInRoom ;
   final int country ;
   final String register_with ;
   final int gender ;
   final String gold ;
   final String diamond ;
   final String share_level_order ;
   final int share_level_points ;
   final String share_level_icon ;
   final String karizma_level_order ;
   final int karizma_level_points ;
   final String karizma_level_icon ;
   final String charging_level_order ;
   final int charging_level_points ;
   final String charging_level_icon ;
   List<Follower>? followers = [] ;
   List<Follower>? followings = [] ;
   List<Friends>? friends = [] ;
   List<Visitor>? visitors = [] ;
   List<Block>? blocks = [] ;
   final String cover ;
   final String status ;
   final String country_name ;
   final String country_flag ;
   List<UserHoppy>? hoppies = [] ;
   List<Medal>? medals = [] ;
   final String token ;
   final int banDevice ;
   List<Vip>? vips  = [];


   AppUser({ required this.id, required this.tag, required this.name, required this.img, required this.share_level_id,required this.karizma_level_id, required this.charging_level_id,required  this.phone,
     required this.email, required this.password, required this.isChargingAgent, required this.isHostingAgent, required this.registered_at,
     required this.last_login, required this.birth_date, required this.enable, required this.ipAddress,required  this.macAddress, required this.deviceId, required this.isOnline, required this.isInRoom, required this.country,
     required this.register_with , required this.gender , required this.gold , required this.diamond , required this.share_level_order , required this.share_level_points ,required this.share_level_icon ,
     required  this.karizma_level_order , required this.karizma_level_points , required this.karizma_level_icon ,required this.charging_level_order , required this.charging_level_points , required this.charging_level_icon ,
     this.followers , this.followings , this.visitors , this.friends , this.blocks , this.hoppies , this.medals , this.vips , required this.cover , required this.status , required this.country_name , required this.country_flag , required this.token , required this.banDevice});

   factory AppUser.fromJson(Map<String, dynamic> json) {
      return switch (json) {
         {
         'id': int id,
         'tag': String tag,
         'name': String name,
         'img': String img,
         'share_level_id': int share_level_id,
         'karizma_level_id': int karizma_level_id,
         'charging_level_id': int charging_level_id,
         'phone': String phone,
         'email': String email,
         'password': String password,
         'isChargingAgent': int isChargingAgent,
         'isHostingAgent': int isHostingAgent,
         'registered_at': String registered_at,
         'last_login': String last_login,
         'birth_date': String birth_date,
         'enable': int enable,
         'ipAddress': String ipAddress,
         'macAddress': String macAddress,
         'deviceId': String deviceId,
         'isOnline': int isOnline,
         'isInRoom': int isInRoom,
         'country': int country,
         'register_with': String register_with,
         'gender': int gender,
         'gold': String gold,
         'diamond': String diamond,
         'share_level_order': String share_level_order,
         'share_level_points': int share_level_points,
         'share_level_icon': String share_level_icon,
         'karizma_level_order': String karizma_level_order,
         'karizma_level_points': int karizma_level_points,
         'karizma_level_icon': String karizma_level_icon,
         'charging_level_order': String charging_level_order,
         'charging_level_points': int charging_level_points,
         'charging_level_icon': String charging_level_icon,
         'cover': String cover,
         'status': String status,
         'country_name': String country_name,
         'country_flag': String country_flag,
         'token': String token,
         'banDevice': int banDevice


         } =>
             AppUser(
                 id: id,
                 tag: tag,
                 name: name,
                 img: img,
                 share_level_id: share_level_id,
                 karizma_level_id: karizma_level_id,
                 charging_level_id: charging_level_id,
                 phone: phone,
                 email: email,
                 password: password,
                 isChargingAgent: isChargingAgent,
                 isHostingAgent: isHostingAgent,
                 registered_at: registered_at,
                 last_login: last_login,
                 birth_date: birth_date,
                 enable: enable,
                 ipAddress: ipAddress,
                 macAddress: macAddress,
                 deviceId: deviceId,
                 isOnline: isOnline,
                 isInRoom: isInRoom,
                 country: country,
                 register_with: register_with,
                 gender: gender,
                 gold: gold,
                 diamond: diamond,
                 share_level_order: share_level_order,
                share_level_points: share_level_points,
                share_level_icon: share_level_icon,
                karizma_level_order: karizma_level_order,
                karizma_level_points: karizma_level_points,
                karizma_level_icon: karizma_level_icon,
                charging_level_order: charging_level_order,
                charging_level_points: charging_level_points,
                charging_level_icon: charging_level_icon,
               cover: cover,
               status: status,
               country_name: country_name,
               country_flag: country_flag,
                 token: token,
                 banDevice: banDevice


             ),
         _ => throw const FormatException('Failed to load User.'),
      };
   }

}