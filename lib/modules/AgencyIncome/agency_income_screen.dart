
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:LikLok/helpers/AgencyMemberIncomeHelper.dart';
import 'package:LikLok/models/AppUser.dart';
import 'package:LikLok/models/HostAgency.dart';
import 'package:LikLok/modules/Loading/loadig_screen.dart';
import 'package:LikLok/shared/network/remote/AppUserServices.dart';
import 'package:LikLok/shared/network/remote/HostAgencyService.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../shared/styles/colors.dart';

class AgencyIncome extends StatefulWidget {
  final int user_id ;
  const AgencyIncome({super.key , required this.user_id});

  @override
  State<AgencyIncome> createState() => _AgencyIncomeState();
}

class _AgencyIncomeState extends State<AgencyIncome> {
  AppUser? user ;
  HostAgency? agency ;
  AgencyMemberIncomeHelper? helper ;
  bool loading = false ;
  int totalPoints = 0 ;
  int needTotalPoints = 0 ;
  int totalMinues = 0 ;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      user = AppUserServices().userGetter();
    });
     getMyStatics();


  }

  getMyStatics() async {
    AgencyMemberIncomeHelper? res = await HostAgencyService().getMemberStatics(widget.user_id == 0 ? user!.id : widget.user_id);
    setState(() {
      helper = res ;
    });
    getUserAgency();
    int? ps = 0 ;
    // for(int i = 0 ; i < helper!.points.length ; i++ ){
    //   ps += helper!.points[i].points ;
    // }



    setState(() {
      ps = helper!.points  ;
      totalPoints = ps ??  0;
      needTotalPoints = double.parse(helper!.nextTarget!.gold).floor()   -  int.parse(helper!.points.toString())    ;
    });
  }
  getUserAgency() async {
    HostAgency? res = await AppUserServices().checkUserISAgencyMember(user!.id);
    setState(() {
      agency = res ;
      loading = true ;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: MyColors.whiteColor, //change your color here
        ),
        centerTitle: true,
        backgroundColor: MyColors.solidDarkColor,
        title: Text(
          "agency_income_title".tr,
          style: TextStyle(color: MyColors.whiteColor, fontSize: 20.0),
        ),
      ),
      body: SafeArea(
        child: Container(
          color: MyColors.darkColor,
          width: double.infinity,
          height: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: loading ?  SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.calendar_month ,size: 50.0,color: MyColors.secondaryColor,),
                      SizedBox(width: 30.0,),
                      Text(helper!.member!.joining_date,style: TextStyle(fontSize: 18.0,color: Colors.black),
                      )
                    ],
                  ),
                  SizedBox(height: 30.0,),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text( helper!.currentTarget != null ? '${'current_target'.tr} : ' + helper!.currentTarget!.order : "${'current_target'.tr} : ${'non'.tr}" ,style: TextStyle(fontSize: 20.0,color: Colors.green,fontWeight: FontWeight.bold ),),
                        ],
                      ),
                      SizedBox(height: 10.0,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text( helper!.currentTarget != null ? '${'salary'.tr} : ' + helper!.currentTarget!.dollar_amount : "${'salary'.tr} : 0" ,style: TextStyle(fontSize: 20.0,color: Colors.green,fontWeight: FontWeight.bold ),),
                        ],
                      ),
                      SizedBox(height: 10.0,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('${'next_target'.tr} : ' + helper!.nextTarget!.order ,style: TextStyle(fontSize: 20.0,color: Colors.red,fontWeight: FontWeight.bold ),),
                        ],
                      ),
                      Container(
                        width: double.infinity,
                        height: 1.0,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 30.0,),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('agency_income_work_points'.tr,style: TextStyle(fontSize: 14.0,color: MyColors.whiteColor),),
                                SizedBox(height: 40.0,),
                                Text(totalPoints.toString(),style: TextStyle(fontSize: 20.0,color: MyColors.whiteColor),),
                              ],
                            ),
                          ),
                          SizedBox(width: 10.0,),
                          Container(
                            width: 1.0 ,
                            height: MediaQuery.of(context).size.width / 2.5 ,
                            color: Colors.grey,
                          ),
                          SizedBox(width: 10.0,),
                          Expanded(
                            child: Column(
                              children: [
                                Text('agency_income_next_achieve_target'.tr,style: TextStyle(fontSize: 14.0,color: Colors.black), textAlign: TextAlign.center,),
                                SizedBox(height: 20.0,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(needTotalPoints.toString(),style: TextStyle(fontSize: 20.0,color: Colors.black),),
                                  ],
                                ),
                                SizedBox(height: 20.0,),
              
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 30.0,),
                  Container(
                    width: double.infinity,
                    height: 1.0,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 30.0,),
                  Column(
                    children: [
                      Row(
                        children: [
        
                          Expanded(
                            child: Column(
                              children: [
                                Text('total_work_days'.tr,style: TextStyle(fontSize: 14.0,color: Colors.black), textAlign: TextAlign.center,),
                                SizedBox(height: 40.0,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text( helper!.totalDay.toString() ,style: TextStyle(fontSize: 20.0,color: Colors.black),),
                                  ],
                                ),
                                SizedBox(height: 20.0,),
        
                              ],
                            ),
                          ),
                        ],
                      ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: [
                      //     Text('Total Work Minutes : ' + totalMinues.toString() ,style: TextStyle(fontSize: 20.0,color: Colors.green,fontWeight: FontWeight.bold ),),
                      //
                      //   ],
                      // ),
                      // SizedBox(height: 10.0,),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: [
                      //     Text('Total Work Hours : ' + (totalMinues > 0 ? (totalMinues / 60).toString() : "0")  ,style: TextStyle(fontSize: 20.0,color: Colors.red,fontWeight: FontWeight.bold ),),
                      //   ],
                      // ),
        
        
                    ],
                  ),
                ],
              ),
            ) : Loading(),
          ),
        ),
      ),
    );
  }
}
