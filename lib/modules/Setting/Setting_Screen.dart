import 'package:LikLok/models/HostAgency.dart';
import 'package:LikLok/modules/About/About_Screen.dart';
import 'package:LikLok/modules/AccountManagement/Account_Management_Screen.dart';
import 'package:LikLok/modules/AgencyCharge/agency_charge_screen.dart';
import 'package:LikLok/modules/AgencyIncome/agency_income_screen.dart';
import 'package:LikLok/modules/AgencyMembers/Agency_Members_Screen.dart';
import 'package:LikLok/modules/AgencyStatics/Agency_Statics_Screen.dart';
import 'package:LikLok/modules/Agreement/Agreement_Screen.dart';

import 'package:LikLok/modules/BlockList/block_list_screen.dart';
import 'package:LikLok/modules/EditLanguage/Edit_Language_Screen.dart';
import 'package:LikLok/modules/NetworkDiagnosis/Network_Diagnosis_screen.dart';
import 'package:LikLok/modules/NotificationSetting/Notification_Setting_Screen.dart';
import 'package:LikLok/modules/PrivacyPolicy/Privacy_Policy_Screen.dart';
import 'package:LikLok/shared/network/remote/AppSettingsServices.dart';
import 'package:LikLok/shared/network/remote/AppUserServices.dart';
import 'package:LikLok/shared/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../../models/AppUser.dart';
import '../JoinHostAgency/join_host_agency_screen.dart';
import '../Loading/loadig_screen.dart';
import '../SelfWithdrawal/self_withdrawal.dart';



class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}


class _SettingScreenState extends State<SettingScreen> {

  AppUser? user ;
  bool isHostAgencyMember = false ;
  bool isLoaded = false  ;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    user = AppUserServices().userGetter();
    checkIsHostAgencyMember();
  }
  checkIsHostAgencyMember() async {
    HostAgency? res = await AppUserServices().checkUserISAgencyMember(user!.id);
    if(res == null){
      setState(() {
        isHostAgencyMember = false ;
        isLoaded = true ;
      });
    } else {
      setState(() {
        isHostAgencyMember = true ;
        isLoaded = true ;
      });
    }
  }
  @override

  Widget build(BuildContext context) {

    return  Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: MyColors.whiteColor, //change your color here
        ),
        centerTitle: true,
        backgroundColor: MyColors.solidDarkColor,
        title: Text("setting_title".tr , style: TextStyle(color: MyColors.whiteColor,fontSize: 20.0) ,),
      ),
      body: SafeArea(
        child: Container(
          color: MyColors.darkColor,
          width: double.infinity,
          height: double.infinity,
          padding: EdgeInsets.only(top: 15.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(color:  Colors.white, borderRadius: BorderRadius.circular(15.0)),
                  padding: EdgeInsets.all(15.0) ,
                  margin: EdgeInsetsDirectional.only(bottom: 10.0 , start: 10.0 , end: 10.0),
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (ctx) => const EditLanguageScreen(),),);
                    },
                    child: Row(
                      children: [
                        Text("setting_language".tr ,style:TextStyle(color: MyColors.whiteColor,fontSize: 15.0) ,),
                        Expanded(
                          child:Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(Icons.arrow_forward_ios_outlined , color: MyColors.whiteColor , size: 20.0,)
                          ]
                            //change your color here
                          ),
                    ),
                                ],
        
                                  ),
                  ),
              ),
                Container(
                  decoration: BoxDecoration(color:  Colors.white, borderRadius: BorderRadius.circular(15.0)),
                  padding: EdgeInsets.all(15.0) ,
                  margin: EdgeInsetsDirectional.only(bottom: 10.0 , start: 10.0 , end: 10.0),
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (ctx) => const NotificationSettingScreen()));
                    },
                    child: Row(
                      children: [
                        Text("setting_notification".tr ,style:TextStyle(color: MyColors.whiteColor,fontSize: 15.0) ,),
                        Expanded(
                          child:Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Icon(Icons.arrow_forward_ios_outlined , color: MyColors.whiteColor , size: 20.0,)
                              ]
                            //change your color here
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (ctx) => const BlockListScreen()));
                  },
                  child: Container(
                    decoration: BoxDecoration(color:  Colors.white, borderRadius: BorderRadius.circular(15.0)),
                    padding: EdgeInsets.all(15.0) ,
                    margin: EdgeInsetsDirectional.only(bottom: 10.0 , start: 10.0 , end: 10.0),
                    child: Row(
                      children: [
                        Text("setting_blocked_list".tr ,style:TextStyle(color: MyColors.whiteColor,fontSize: 15.0) ,),
                        Expanded(
                          child:Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Icon(Icons.arrow_forward_ios_outlined , color: MyColors.whiteColor, size: 20.0,)
                              ]
                            //change your color here
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        
        
        
                Container(
                  decoration: BoxDecoration(color:  Colors.white, borderRadius: BorderRadius.circular(15.0)),
                  padding: EdgeInsets.all(15.0) ,
                  margin: EdgeInsetsDirectional.only(bottom: 10.0 , start: 10.0 , end: 10.0),
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (ctx) => const About_Screen()));
                    },
                    child: Row(
                      children: [
                        Text("about_us_title".tr ,style:TextStyle(color: MyColors.whiteColor,fontSize: 15.0) ,),
                        Expanded(
                          child:Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Icon(Icons.arrow_forward_ios_outlined , color: MyColors.whiteColor , size: 20.0,)
                              ]
                            //change your color here
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(color:  Colors.white, borderRadius: BorderRadius.circular(15.0)),
                  padding: EdgeInsets.all(15.0) ,
                  margin: EdgeInsetsDirectional.only(bottom: 10.0 , start: 10.0 , end: 10.0),
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (ctx) => const Agreement_Screen()));
                    },
                    child: Row(
                      children: [
                        Text("agreement_title".tr ,style:TextStyle(color: MyColors.whiteColor,fontSize: 15.0) ,),
                        Expanded(
                          child:Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Icon(Icons.arrow_forward_ios_outlined , color: MyColors.whiteColor , size: 20.0,)
                              ]
                            //change your color here
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        
                Container(
                  decoration: BoxDecoration(color:  Colors.white, borderRadius: BorderRadius.circular(15.0)),
                  padding: EdgeInsets.all(15.0) ,
                  margin: EdgeInsetsDirectional.only(bottom: 10.0 , start: 10.0 , end: 10.0),
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (ctx) => const Privacy_Policy_Screen()));
                    },
                    child: Row(
                      children: [
                        Text("privacy_policy_title".tr ,style:TextStyle(color: MyColors.whiteColor,fontSize: 15.0) ,),
                        Expanded(
                          child:Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Icon(Icons.arrow_forward_ios_outlined , color: MyColors.whiteColor , size: 20.0,)
                              ]
                            //change your color here
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        
                Container(
        
                  decoration: BoxDecoration(color:  Colors.white, borderRadius: BorderRadius.circular(15.0)),
                  padding: EdgeInsets.all(15.0) ,
                  margin: EdgeInsetsDirectional.only(bottom: 10.0 , start: 10.0 , end: 10.0),
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (ctx) => const Network_Diagnosis_Screen()));
                    },
                    child: Row(
                      children: [
                        Text("network_title".tr ,style:TextStyle(color: MyColors.whiteColor,fontSize: 15.0) ,),
                        Expanded(
                          child:Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Icon(Icons.arrow_forward_ios_outlined , color: MyColors.whiteColor , size: 20.0,)
                              ]
                            //change your color here
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(color:  Colors.white, borderRadius: BorderRadius.circular(15.0)),
                  padding: EdgeInsets.all(15.0) ,
                  margin: EdgeInsetsDirectional.only(bottom: 10.0 , start: 10.0 , end: 10.0),
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () async{
                      showDialog(
                          context: context,
                        builder: (BuildContext context){
                            context = context;
                            return const Loading();
                          },
                      );
                      await Future.delayed(Duration(milliseconds: 3000));
                      Navigator.pop(context);
        
                      Fluttertoast.showToast(
                          msg: 'clear_cash_msg'.tr,
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.black26,
                          textColor: Colors.orange,
                          fontSize: 16.0
                      );
                      
                    },
                  child: Row(
                    children: [
                      Text("setting_clear_cache".tr ,style:TextStyle(color: MyColors.whiteColor,fontSize: 15.0) ,),
                      Expanded(
                        child:Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Icon(Icons.arrow_forward_ios_outlined , color: MyColors.whiteColor , size: 20.0,)
                            ]
                          //change your color here
                        ),
                      ),
                    ],
                  ),
                ),
                ),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (ctx) => const Account_Management_Screen()));
                  },
                  child: Container(
                    decoration: BoxDecoration(color:  Colors.white, borderRadius: BorderRadius.circular(15.0)),
                    padding: EdgeInsets.all(15.0) ,
                    margin: EdgeInsetsDirectional.only(bottom: 10.0 , start: 10.0 , end: 10.0),
                    child: Row(
                      children: [
                        Text("account_management_title".tr ,style:TextStyle( color: MyColors.whiteColor,fontSize: 15.0) ,),
                        Expanded(
                          child:Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Icon(Icons.arrow_forward_ios_outlined , color: MyColors.whiteColor , size: 20.0,)
                              ]
                            //change your color here
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10.0,),
                 user!.isChargingAgent == 1 ? GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (ctx) => const AgencyCharge()));
                  },
                  child: Container(
                    decoration: BoxDecoration(color:  Colors.white, borderRadius: BorderRadius.circular(15.0)),
                    padding: EdgeInsets.all(15.0) ,
                    margin: EdgeInsetsDirectional.only(bottom: 10.0 , start: 10.0 , end: 10.0),
                    child: Row(
                      children: [
                        Text("agency_charge_title".tr ,style:TextStyle( color: MyColors.whiteColor,fontSize: 15.0) ,),
                        Expanded(
                          child:Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Icon(Icons.arrow_forward_ios_outlined , color: MyColors.whiteColor , size: 20.0,)
                              ]
                            //change your color here
                          ),
                        ),
                      ],
                    ),
                  ),
                ): Container(),
                user!.isHostingAgent == 1 ? GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (ctx) => const AgencyMembsersScreen()));
                  },
                  child: Container(
                    decoration: BoxDecoration(color:  Colors.white, borderRadius: BorderRadius.circular(15.0)),
                    padding: EdgeInsets.all(15.0) ,
                    margin: EdgeInsetsDirectional.only(bottom: 10.0 , start: 10.0 , end: 10.0),
                    child: Row(
                      children: [
                        Text("agency_members_title".tr ,style:TextStyle( color: MyColors.whiteColor,fontSize: 15.0) ,),
                        Expanded(
                          child:Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Icon(Icons.arrow_forward_ios_outlined , color: MyColors.whiteColor , size: 20.0,)
                              ]
                            //change your color here
                          ),
                        ),
                      ],
                    ),
                  ),
                ): Container(),
                user!.isHostingAgent == 1 ? GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (ctx) => const AgencyStatics()));
                  },
                  child: Container(
                    decoration: BoxDecoration(color:  Colors.white, borderRadius: BorderRadius.circular(15.0)),
                    padding: EdgeInsets.all(15.0) ,
                    margin: EdgeInsetsDirectional.only(bottom: 10.0 , start: 10.0 , end: 10.0),
                    child: Row(
                      children: [
                        Text("agency_statics_title".tr ,style:TextStyle( color: MyColors.whiteColor,fontSize: 15.0) ,),
                        Expanded(
                          child:Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Icon(Icons.arrow_forward_ios_outlined , color: MyColors.whiteColor , size: 20.0,)
                              ]
                            //change your color here
                          ),
                        ),
                      ],
                    ),
                  ),
                ): Container(),
                (!isHostAgencyMember && isLoaded) ?   GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (ctx) => const JoinHostAgency()));
              },
              child: AppSettingsServices().appSettingGetter()!.isTest == 0 ?
              Container(
                decoration: BoxDecoration(color:  Colors.white, borderRadius: BorderRadius.circular(15.0)),
                padding: EdgeInsets.all(15.0) ,
                margin: EdgeInsetsDirectional.only(bottom: 10.0 , start: 10.0 , end: 10.0),
                child: Row(
                  children: [
                    Text("join_host_title".tr ,style:TextStyle( color: MyColors.whiteColor,fontSize: 15.0) ,),
                    Expanded(
                      child:Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(Icons.arrow_forward_ios_outlined , color: MyColors.whiteColor , size: 20.0,)
                          ]
                        //change your color here
                      ),
                    ),
                  ],
                ),
              ) : Container(),
            ) : isLoaded ? GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (ctx) => const AgencyIncome(user_id: 0,)));
                  },
                  child: Container(
                    decoration: BoxDecoration(color:  Colors.white, borderRadius: BorderRadius.circular(15.0)),
                    padding: EdgeInsets.all(15.0) ,
                    margin: EdgeInsetsDirectional.only(bottom: 10.0 , start: 10.0 , end: 10.0),
                    child: Row(
                      children: [
                        Text("agency_income_title".tr ,style:TextStyle( color: MyColors.whiteColor,fontSize: 15.0) ,),
                        Expanded(
                          child:Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Icon(Icons.arrow_forward_ios_outlined , color: MyColors.whiteColor , size: 20.0,)
                              ]
                            //change your color here
                          ),
                        ),
                      ],
                    ),
                  ),
                ) : Container(),
                SizedBox(height: 10.0,),
                // Container(
                //   decoration: BoxDecoration(color:  Colors.white, borderRadius: BorderRadius.circular(15.0)),
                //   padding: EdgeInsets.all(15.0) ,
                //   margin: EdgeInsetsDirectional.only(bottom: 10.0 , start: 10.0 , end: 10.0),
                //   child: GestureDetector(
                //     behavior: HitTestBehavior.opaque,
                //     onTap: (){
                //       Navigator.push(context, MaterialPageRoute(builder: (ctx) => const SelfWithdrawal(),),);
                //     },
                //     child: Row(
                //       children: [
                //         Text("self_withdrawal".tr ,style:TextStyle(color: MyColors.whiteColor,fontSize: 15.0) ,),
                //         Expanded(
                //           child:Row(
                //               mainAxisAlignment: MainAxisAlignment.end,
                //               children: [
                //                 Icon(Icons.arrow_forward_ios_outlined , color: MyColors.whiteColor , size: 20.0,)
                //               ]
                //             //change your color here
                //           ),
                //         ),
                //       ],
                //
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );

  }
}
