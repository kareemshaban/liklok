import 'package:LikLok/models/AgencyMember.dart';
import 'package:LikLok/models/AgencyMemberPoints.dart';
import 'package:LikLok/models/AgencyMemberStatics.dart';
import 'package:LikLok/models/AgencyTarget.dart';

class AgencyMemberIncomeHelper {
   AgencyMember? member ;
   List<AgencyMemberStatics>  statics ;
   List<AgencyMemberPoints> points ;
   AgencyTarget? currentTarget ;
   AgencyTarget? nextTarget ;
   double? totalDay ;
  AgencyMemberIncomeHelper({required this.member , required this.statics , required this.points ,
    required this.currentTarget , required this.nextTarget , required this.totalDay});
}