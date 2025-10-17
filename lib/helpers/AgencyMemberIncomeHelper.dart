import 'package:LikLok/models/AgencyMember.dart';
import 'package:LikLok/models/AgencyTarget.dart';

class AgencyMemberIncomeHelper {
   AgencyMember? member ;
   int? points ;
   AgencyTarget? currentTarget ;
   AgencyTarget? nextTarget ;
   double? totalDay ;
  AgencyMemberIncomeHelper({required this.member , required this.points ,
    required this.currentTarget , required this.nextTarget , required this.totalDay});
}