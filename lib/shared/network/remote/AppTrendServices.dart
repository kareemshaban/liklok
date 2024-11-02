import 'dart:convert';

import 'package:LikLok/models/AppTrend.dart';
import 'package:LikLok/models/TrendRoom.dart';
import 'package:LikLok/models/TrendUser.dart';
import 'package:LikLok/shared/components/Constants.dart';
import 'package:http/http.dart' as http;

class AppTrendService {

  Future<AppTrend?> getAppTrend() async{
    List<TrendUser> dailyFans = [];
    List<TrendUser> weekFans  = [];
    List<TrendUser> monthFans = [];
    List<TrendUser> dailyFanKs = [];
    List<TrendUser> weekFanKs  = [];
    List<TrendUser> monthFanKs  = [];
    List<TrendRoom> dailyRooms = [];
    List<TrendRoom> weekRooms = [];
    List<TrendRoom> monthRooms = [];

    AppTrend appTrend = AppTrend(dailyShareFans: dailyFans, weekShareFanss: weekFans, monthShareFans: monthFans,
        dailyKarizmaFans: dailyFanKs, weekKarizmaFans: weekFanKs, monthKarizmaFans: monthFanKs, dailyRoomFans: dailyRooms, weekRoomFans: weekRooms, monthRoomFans: monthRooms);
    final response = await http.get(Uri.parse('${BASEURL}app/appCup'));
    print(response.body);
    if (response.statusCode == 200){
      final Map jsonData = json.decode(response.body);
      if(jsonData['state'] == "success"){

        for( var i = 0 ; i < jsonData['dailyFans'].length ; i ++ ){
          TrendUser user = TrendUser.fromJson(jsonData['dailyFans'][i]['user']);
          dailyFans.add(user);

        }
        for( var i = 0 ; i < jsonData['weekFans'].length ; i ++ ){
          TrendUser user = TrendUser.fromJson(jsonData['weekFans'][i]['user']);
          weekFans.add(user);

        }
        for( var i = 0 ; i < jsonData['monthFans'].length ; i ++ ){
          TrendUser user = TrendUser.fromJson(jsonData['monthFans'][i]['user']);
          monthFans.add(user);
        }

        for( var i = 0 ; i < jsonData['dailyFanKs'].length ; i ++ ){
          TrendUser user = TrendUser.fromJson(jsonData['dailyFanKs'][i]['user']);
          dailyFanKs.add(user);
        }
        for( var i = 0 ; i < jsonData['weekFanK'].length ; i ++ ){
          if(jsonData['weekFanK'][i]['user'] != null) {
            TrendUser user = TrendUser.fromJson(
                jsonData['weekFanK'][i]['user']);
            weekFanKs.add(user);
          }
        }
        for( var i = 0 ; i < jsonData['monthFanKs'].length ; i ++ ){
          if(jsonData['monthFanKs'][i]['user'] != null){
            TrendUser user = TrendUser.fromJson(jsonData['monthFanKs'][i]['user']);
            monthFanKs.add(user);
          }

        }

        for( var i = 0 ; i < jsonData['dailyRooms'].length ; i ++ ){
          TrendRoom room = TrendRoom.fromJson(jsonData['dailyRooms'][i]['room']);
          dailyRooms.add(room);
        }
        for( var i = 0 ; i < jsonData['weeklyRs'].length ; i ++ ){
          TrendRoom room = TrendRoom.fromJson(jsonData['weeklyRs'][i]['room']);
          weekRooms.add(room);
        }
        for( var i = 0 ; i < jsonData['monthRooms'].length ; i ++ ){
          TrendRoom room = TrendRoom.fromJson(jsonData['monthRooms'][i]['room']);
          monthRooms.add(room);
        }





            appTrend.dailyShareFans = dailyFans ;
            appTrend.weekShareFanss = weekFans ;
            appTrend.monthShareFans = monthFans ;
            appTrend.dailyKarizmaFans = dailyFanKs ;
            appTrend.weekKarizmaFans = weekFanKs ;
            appTrend.monthKarizmaFans = monthFanKs ;
            appTrend.dailyRoomFans = dailyRooms ;
            appTrend.weekRoomFans = weekRooms ;
            appTrend.monthRoomFans = monthRooms ;

          return appTrend ;

        }

    } else {
      throw Exception('Failed to load album');
    }
    return appTrend ;
  }



}