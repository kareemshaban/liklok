import 'package:LikLok/models/Category.dart';
import 'package:LikLok/models/Emossion.dart';
import 'package:LikLok/models/Gift.dart';
import 'package:LikLok/models/RoomTheme.dart';

class RoomBasicDataHelper {
   List<Emossion> emossions ;
   List<RoomTheme> themes ;
   List<Gift> gifts ;
   List<Category> categories ;

  RoomBasicDataHelper({required this.emossions , required this.themes , required this.gifts , required this.categories});

}