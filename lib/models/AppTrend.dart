import 'package:LikLok/models/TrendRoom.dart';
import 'package:LikLok/models/TrendUser.dart';

class AppTrend {
    List<TrendUser>  dailyShareFans = [];
    List<TrendUser> weekShareFanss = [] ;
    List<TrendUser> monthShareFans = [] ;

    List<TrendUser> dailyKarizmaFans = [] ;
    List<TrendUser> weekKarizmaFans = [] ;
    List<TrendUser> monthKarizmaFans = [ ] ;

     List<TrendRoom>  dailyRoomFans = [] ;
    List<TrendRoom>  weekRoomFans = [] ;
    List<TrendRoom> monthRoomFans = [];

   AppTrend({ required this.dailyShareFans ,  required this.weekShareFanss ,  required this.monthShareFans ,  required this.dailyKarizmaFans ,  required this.weekKarizmaFans ,  required this.monthKarizmaFans,
    required this.dailyRoomFans ,  required this.weekRoomFans ,  required this.monthRoomFans });


}