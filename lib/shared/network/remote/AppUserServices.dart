import 'dart:io';

import 'package:LikLok/helpers/DesigGiftHelper.dart';
import 'package:LikLok/models/AppUser.dart';
import 'package:LikLok/models/Block.dart';
import 'package:LikLok/models/Follower.dart';
import 'package:LikLok/models/Friends.dart';
import 'package:LikLok/models/Design.dart';
import 'package:LikLok/models/Follower.dart';
import 'package:LikLok/models/Friends.dart';
import 'package:LikLok/models/HostAgency.dart';
import 'package:LikLok/models/LevelStats.dart';
import 'package:LikLok/models/Mall.dart';
import 'package:LikLok/models/Medal.dart';
import 'package:LikLok/models/Tag.dart';
import 'package:LikLok/models/UserHoppy.dart';
import 'package:LikLok/models/Vip.dart';
import 'package:LikLok/models/Visitor.dart';
import 'package:LikLok/shared/components/Constants.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_ip_address/get_ip_address.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:path/path.dart';
import 'package:async/async.dart';

class AppUserServices {
  static AppUser? user  ;
  userSetter(AppUser u){
     user = u ;
  }
  AppUser? userGetter(){
    return user ;
  }



  Future<AppUser?> createAccount( name , register_with ,img,  phone , email  ,  password , token) async {
    AppUser? user = null ;
    String deviceId = await getId() ?? "";
    var data = await getIpAddress() ;
    var ipAddress = data['ip'] ?? "" ;
    var response = await http.post(
      Uri.parse('${BASEURL}Account/Create'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'name': name,
        'img': img  ?? "",
        'phone': phone  ?? "",
        'email': email ,
        'password': password,
        'register_with': register_with,
        'ipAddress': ipAddress,
        'macAddress': "2.0.0.0",
        'deviceId': deviceId,
        'token': token
      }),
    );
    print(response.body);
    if (response.statusCode == 200) {
      final Map jsonData = json.decode(response.body);
      if(jsonData['state'] == "success"){
        return mapUserData(jsonData);
      } else {
        return null ;
      }

    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  dynamic getIpAddress() async {
    try {
      /// Initialize Ip Address
      var ipAddress = IpAddress(type: RequestType.json);

      /// Get the IpAddress based on requestType.
      dynamic data = await ipAddress.getIpAddress();
      print(data['ip']);
      return data ;
    } on IpAddressException catch (exception) {
      /// Handle the exception.
      return "";
      print(exception.message);
    }
  }

  Future<String?> getId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) { // import 'dart:io'
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else if(Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;

      return androidDeviceInfo.id; // unique ID on Android
      
    }
  }


  Future<List<AppUser>> searchUser(txt) async {
    final response = await http.get(Uri.parse('${BASEURL}users/Search/${txt}'));
    List<AppUser> users  = [];
    if (response.statusCode == 200) {
      List<dynamic>  jsonData = json.decode(response.body);
      for( var i = 0 ; i < jsonData.length ; i ++ ){
        AppUser user = AppUser.fromJson(jsonData[i]);
        users.add(user);
      }
      return users ;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }

  }

  AppUser mapUserData(jsonData){
    AppUser user = AppUser.fromJson(jsonData['user']) ;
    List<Follower> followers = [];
    List<Follower> followings = [];
    List<Friends> friends = [];
    List<Visitor> visitors = [];
    List<Block> blocks = [];
    List<UserHoppy> hoppies = [] ;
    List<Vip> vips = [] ;
    List<Mall> designs = [] ;

    List<Medal> medals = [];
    for (var j = 0; j < jsonData['medals'].length; j ++) {
      Medal medal = Medal.fromJson(jsonData['medals'][j]);
      medals.add(medal);

    }

    for (var j = 0; j < jsonData['followers'].length; j ++) {
      Follower like = Follower.fromJson(jsonData['followers'][j]);
      followers.add(like);

    }
    for (var j = 0; j < jsonData['followings'].length; j ++) {
      Follower like = Follower.fromJson(jsonData['followings'][j]);
      followings.add(like);

    }
    for (var j = 0; j < jsonData['friends'].length; j ++) {
      Friends like = Friends.fromJson(jsonData['friends'][j]);
      friends.add(like);

    }
    for (var j = 0; j < jsonData['visitors'].length; j ++) {
      Visitor like = Visitor.fromJson(jsonData['visitors'][j]);
      visitors.add(like);
    }
    for (var j = 0; j < jsonData['blocks'].length; j ++) {
      Block like = Block.fromJson(jsonData['blocks'][j]);
      blocks.add(like);

    }
    for (var j = 0; j < jsonData['tags'].length; j ++) {
      UserHoppy hoppy = UserHoppy.fromJson(jsonData['tags'][j]);
      hoppies.add(hoppy);
    }

    for( var i = 0 ; i < jsonData['vips'].length ; i ++ ){
      Vip vip = Vip.fromJson(jsonData['vips'][i]);
      designs = [] ;
      for( var j = 0 ; j < jsonData['vips'][i]['designs'].length ; j ++ ){
        Mall design =  Mall.fromJson(jsonData['vips'][i]['designs'][j])  ;
        print(design.category_id);
        designs.add(design);
      }
      vip.designs = designs ;
      vips.add(vip);
    }

    user.friends = friends ;
    user.visitors = visitors ;
    user.followings = followings ;
    user.followers = followers ;
    user.hoppies = hoppies ;
    user.blocks = blocks ;
    user.medals = medals ;
    user.vips = vips ;
    return  user;
  }
  Future<AppUser?> getUser(id) async {
    final response = await http.get(Uri.parse('${BASEURL}Account/GetUser/${id}'));
    print(response.body);
    if (response.statusCode == 200) {
        final Map jsonData = json.decode(response.body);
        if(jsonData['state'] == "success"){
       return mapUserData(jsonData);
      } else {
        return null ;
      }

    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }

  }
  Future<List<Tag>> getAllHoppies() async {
    final response = await http.get(Uri.parse('${BASEURL}Account/hoppies'));
    List<Tag> tags  = [];

    if (response.statusCode == 200) {
      final Map jsonData = json.decode(response.body);
      for( var i = 0 ; i < jsonData['tags'].length ; i ++ ){
        Tag tag = Tag.fromJson(jsonData['tags'][i]);
        tags.add(tag);
      }
      return tags ;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load tags');
    }
  }
  Future<AppUser?> addHoppy(user_id , tag_id ,   state ) async {
    AppUser? user = null ;
    var response = await http.post(
      Uri.parse('${BASEURL}Account/hoppies/Add'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'user_id': user_id.toString(),
        'tag_id': tag_id.toString(),
        'state': state ,
        'id': '0'
      }),
    );
    if (response.statusCode == 200) {
      final Map jsonData = json.decode(response.body);
      if(jsonData['state'] == "success"){
        return mapUserData(jsonData);
      } else {
        return null ;
      }

    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }

  }
  Future<AppUser?> updateName(user_id , name  ) async {
    AppUser? user = null ;
    var response = await http.post(
      Uri.parse('${BASEURL}Account/name/update'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'user_id': user_id.toString(),
        'name': name.toString(),
      }),
    );
        if (response.statusCode == 200) {
      final Map jsonData = json.decode(response.body);
      if(jsonData['state'] == "success"){
        return mapUserData(jsonData);
      } else {
        return null ;
      }

    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }

  }
  Future<AppUser?> updateCountry(user_id , country  ) async {
    AppUser? user = null ;
    var response = await http.post(
      Uri.parse('${BASEURL}Account/country/update'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'user_id': user_id.toString(),
        'country': country.toString(),
      }),
    );
    if (response.statusCode == 200) {
      final Map jsonData = json.decode(response.body);
      if(jsonData['state'] == "success"){
        return mapUserData(jsonData);
      } else {
        return null ;
      }

    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }

  }
  Future<AppUser?> updateBirthdate(user_id , birth_date  ) async {
    AppUser? user = null ;
    var response = await http.post(
      Uri.parse('${BASEURL}Account/birthdate/update'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'user_id': user_id.toString(),
        'birth_date': birth_date.toString(),
      }),
    );
    if (response.statusCode == 200) {
      final Map jsonData = json.decode(response.body);
      if(jsonData['state'] == "success"){
        return mapUserData(jsonData);
      } else {
        return null ;
      }

    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }

  }
  Future<AppUser?> updateStatus(user_id , status  ) async {
    AppUser? user = null ;
    var response = await http.post(
      Uri.parse('${BASEURL}Account/status/update'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'user_id': user_id.toString(),
        'status': status.toString(),
      }),
    );
    if (response.statusCode == 200) {
      final Map jsonData = json.decode(response.body);
      if(jsonData['state'] == "success"){
        return mapUserData(jsonData);
      } else {
        return null ;
      }

    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }

  }
  Future<AppUser?> updateGender(user_id , gender  ) async {
    AppUser? user = null ;
    var response = await http.post(
      Uri.parse('${BASEURL}Account/updateUserGender'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'user_id': user_id.toString(),
        'gender': gender.toString(),
      }),
    );
    if (response.statusCode == 200) {
      final Map jsonData = json.decode(response.body);
      if(jsonData['state'] == "success"){
        return mapUserData(jsonData);
      } else {
        return null ;
      }

    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }

  }
  Future<AppUser?> updateProfileImg(user_id , File? imageFile   ) async {

    var stream = new http.ByteStream(DelegatingStream.typed(imageFile!.openRead()));
    var length = await imageFile.length();

    var uri = Uri.parse(BASEURL+'Account/img/update');

    var request = new http.MultipartRequest("POST", uri);
    var multipartFile = new http.MultipartFile('img', stream, length,
        filename: basename(imageFile.path));
    //contentType: new MediaType('image', 'png'));

    request.files.add(multipartFile);
    request.fields.addAll(<String, String>{
      'user_id': user_id.toString() ,
    });
    var response = await request.send();
    print(response.statusCode);
    response.stream.transform(utf8.decoder).listen((value) {
      print(value);
    });

  }
  Future<AppUser?> updateProfileCover(user_id , File? imageFile   ) async {

    var stream = new http.ByteStream(DelegatingStream.typed(imageFile!.openRead()));
    var length = await imageFile.length();

    var uri = Uri.parse(BASEURL+'Account/cover/update');

    var request = new http.MultipartRequest("POST", uri);
    var multipartFile = new http.MultipartFile('cover', stream, length,
        filename: basename(imageFile.path));
    //contentType: new MediaType('image', 'png'));

    request.files.add(multipartFile);
    request.fields.addAll(<String, String>{
      'user_id': user_id.toString() ,
    });
    var response = await request.send();
    print(response.statusCode);
    response.stream.transform(utf8.decoder).listen((value) {
      print(value);
    });

  }
  Future<DesignGiftHelper> getMyDesigns(id) async {
      final response = await http.get(Uri.parse('${BASEURL}Account/designs/all/${id}'));
    List<Design> designs  = [];
    List<Design> gifts  = [];
    DesignGiftHelper designGiftHelper = DesignGiftHelper(designs: designs , gifts:gifts );
    if (response.statusCode == 200) {
        final Map jsonData = json.decode(response.body);
      for( var i = 0 ; i < jsonData['designs'].length ; i ++ ){
        Design design = Design.fromJson(jsonData['designs'][i]);
        if(getRemainDays(design)){
          designs.add(design);
        }

      }
      for( var i = 0 ; i < jsonData['gifts'].length ; i ++ ){
        Design gift = Design.fromJson(jsonData['gifts'][i]);
        gifts.add(gift);
      }
      designGiftHelper.designs = designs ;
      designGiftHelper.gifts = gifts ;
      return designGiftHelper ;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load tags');
    }
  }
  bool getRemainDays(design){

    final DateTime dateOne = DateTime.parse(design.available_until);
    final DateTime dateTwo = DateTime.now() ;

    final Duration duration = dateOne.difference(dateTwo);
      print(duration.inDays );
     return duration.inDays > -1  ;
  }
  Future<void> reportUser(user_id , reported_user)async {
    var response = await http.post(
      Uri.parse('${BASEURL}Account/reportUser'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'user_id': user_id.toString(),
        'reported_user': reported_user.toString(),
        'category_id': '0' ,
        'description':'description',
      }),
    );
    print(response.body);
    if (response.statusCode == 200) {
      Fluttertoast.showToast(
          msg: 'remote_app_msg'.tr,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black26,
          textColor: Colors.orange,
          fontSize: 16.0
      );
    } else{
      Fluttertoast.showToast(
          msg: 'remote_app_msg_error'.tr,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black26,
          textColor: Colors.orange,
          fontSize: 16.0
      );
    }
  }
  Future<void> blockUser(user_id , blocke_user)async {
    var response = await http.post(
      Uri.parse('${BASEURL}Account/blockUser'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'user_id': user_id.toString(),
        'blocke_user': blocke_user.toString(),
      }),
    );
    if (response.statusCode == 200) {
      Fluttertoast.showToast(
          msg: 'remote_app_msg_blocked'.tr,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black26,
          textColor: Colors.orange,
          fontSize: 16.0
      );
    } else{
      Fluttertoast.showToast(
          msg: 'remote_app_msg_error'.tr,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black26,
          textColor: Colors.orange,
          fontSize: 16.0
      );
    }
  }
  Future<AppUser?> unblockUser(user_id , blocke_user)async {
    var response = await http.post(
      Uri.parse('${BASEURL}Account/unblockUser'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'user_id': user_id.toString(),
        'blocke_user': blocke_user.toString(),
      }),
    );
    print(response.body);
    if (response.statusCode == 200) {
      final Map jsonData = json.decode(response.body);
      if(jsonData['state'] == "success"){
        return mapUserData(jsonData);
      } else {
        return null ;
      }

    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }
  Future<AppUser?> followUser(user_id , follower_id)async {
    var response = await http.post(
      Uri.parse('${BASEURL}Account/followUser'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'user_id': user_id.toString(),
        'follower_id': follower_id.toString(),
      }),
    );
    print(response.body);
    if (response.statusCode == 200) {
      final Map jsonData = json.decode(response.body);
      if(jsonData['state'] == "success"){
        return mapUserData(jsonData);
      } else {
        return null ;
      }

    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }
  Future<AppUser?> unfollowkUser(user_id , follower_id)async {
    var response = await http.post(
      Uri.parse('${BASEURL}Account/unfollowkUser'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'user_id': user_id.toString(),
        'follower_id': follower_id.toString(),
      }),
    );
    print(response.body);
    if (response.statusCode == 200) {
      final Map jsonData = json.decode(response.body);
      if(jsonData['state'] == "success"){
        return mapUserData(jsonData);
      } else {
        return null ;
      }

    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }
  Future<AppUser?> updateUserToken(user_id , token)async {
    var response = await http.post(
      Uri.parse('${BASEURL}Account/updateToken'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'user_id': user_id.toString(),
        'token': token.toString(),
      }),
    );
    print(response.body);
    if (response.statusCode == 200) {
      final Map jsonData = json.decode(response.body);
      if(jsonData['state'] == "success"){
        return mapUserData(jsonData);
      } else {
        return null ;
      }

    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  Future<AppUser> getUserByTag(tag) async {
    final response = await http.get(Uri.parse('${BASEURL}Account/getUSerByTag/${tag}'));

    if (response.statusCode == 200) {
      List<dynamic>  jsonData = json.decode(response.body);

        AppUser user = AppUser.fromJson(jsonData[0]);

      return user ;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }

  }

  Future<HostAgency?> checkUserISAgencyMember(user_id) async {
    final response = await http.get(Uri.parse('${BASEURL}Account/checkUserISAgencyMember/${user_id}'));
    HostAgency agency ;
    if (response.statusCode == 200) {
      final Map jsonData = json.decode(response.body);
       if( jsonData['agency'] != null){
         agency = HostAgency.fromJson(jsonData['agency'] );
         return agency ;
       } else {
         return null ;
       }

    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }

  }
  Future<LevelStats?> getLevelStats(user_id) async {
    final response = await http.get(Uri.parse('${BASEURL}Account/getUserLevelsData/${user_id}'));
    if (response.statusCode == 200) {
      final Map jsonData = json.decode(response.body);
      if( jsonData['state'] == 'success'){
        int charging_value = jsonData['charging_value'];
        int charging_up_value = jsonData['charging_up_value'];
        double charging_percent = double.parse(jsonData['charging_percent'].toString()) ;
        int share_value = jsonData['share_value'];
        int share_up = jsonData['share_up'];
        double share_percent = double.parse(jsonData['share_percent'].toString());
        int karizma_value = jsonData['karizma_value'];
        int karizma_up = jsonData['karizma_up'];
        double karizma_percent = double.parse(jsonData['karizma_percent'].toString()) ;

        LevelStats levelStats = LevelStats(charging_value: charging_value, charging_up_value: charging_up_value, charging_percent: charging_percent,
            share_value: share_value, share_up: share_up, share_percent: share_percent, karizma_value: karizma_value, karizma_up: karizma_up, karizma_percent: karizma_percent);

        return levelStats ;
      } else {
        return null ;
      }

    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }

  }


  Future<bool> checkDeviceBan(device_id) async {
    final response = await http.get(Uri.parse('${BASEURL}app/deviceBan/${device_id}'));
    if (response.statusCode == 200) {

      final Map jsonData = json.decode(response.body);
      print(jsonData);
      if( jsonData['state'] == 'BANNED'){
          return false ;
      } else if(jsonData['state'] == 'LEGAL') {
        return true ;
      }

    } else {
      return false;
    }
    return false;

  }


}