import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../shared/styles/colors.dart';

class NotificationSettingScreen extends StatefulWidget {
  const NotificationSettingScreen({super.key});

  @override
  State<NotificationSettingScreen> createState() => _NotificationSettingScreenState();
}

class _NotificationSettingScreenState extends State<NotificationSettingScreen> {
  bool _ChatValue = true;
  bool _FollowersValue = true;
  bool _MessageValue = true;
  bool _MomentsValue = true;

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: MyColors.whiteColor, //change your color here
        ),
        centerTitle: true,
        backgroundColor: MyColors.solidDarkColor,
        title: Text("notification_setting_title".tr , style: TextStyle(color: MyColors.whiteColor,fontSize: 20.0) ,),
      ),
      body: Container(
        color: MyColors.darkColor,
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            Column(
              children: [
                Container(
                  decoration: BoxDecoration(color: Colors.white , borderRadius: BorderRadius.all(Radius.circular(15.0))),
                  margin:EdgeInsets.only(top: 15.0 , right: 15.0 , left: 15.0 , bottom: 5.0) ,
                  padding: EdgeInsets.all(15.0) ,

                  child: Row(
                    children: [
                      Text("notification_setting_private_chat".tr ,style:TextStyle(color: Colors.black,fontSize: 15.0) ,),
                      Expanded(
                        child:Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            CupertinoSwitch(activeColor: MyColors.primaryColor,value: _ChatValue,
                              onChanged: (value) {
                                setState(() {
                                  _ChatValue = value;
                                });
                              },
                            ),
                          ],
                          //change your color here
                        ),
                      ),
                    ],

                  ),
                ),
                Container(
                  decoration: BoxDecoration(color: Colors.white , borderRadius: BorderRadius.all(Radius.circular(15.0))),
                  margin:EdgeInsets.only( right: 15.0 , left: 15.0 , bottom: 5.0) ,
                  padding: EdgeInsets.all(15.0) ,

                  child: Row(
                    children: [
                      Text("notification_setting_new_followers".tr ,style:TextStyle(color: Colors.black,fontSize: 15.0) ,),
                      Expanded(
                        child:Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            CupertinoSwitch(activeColor: MyColors.primaryColor,value: _FollowersValue,
                              onChanged: (value) {
                                setState(() {
                                  _FollowersValue = value;
                                });
                              },
                            ),
                          ],
                          //change your color here
                        ),
                      ),
                    ],

                  ),
                ),
                Container(
                  decoration: BoxDecoration(color: Colors.white , borderRadius: BorderRadius.all(Radius.circular(15.0))),
                  margin:EdgeInsets.only( right: 15.0 , left: 15.0 , bottom: 5.0) ,
                  padding: EdgeInsets.all(15.0) ,

                  child: Row(
                    children: [
                      Text("notification_setting_invitation_message".tr ,style:TextStyle(color: Colors.black,fontSize: 15.0) ,),
                      Expanded(
                        child:Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            CupertinoSwitch(activeColor: MyColors.primaryColor,value: _MessageValue,
                              onChanged: (value) {
                                setState(() {
                                  _MessageValue = value;
                                });
                              },
                            ),
                          ],
                          //change your color here
                        ),
                      ),
                    ],

                  ),
                ),
                Container(
                  decoration: BoxDecoration(color: Colors.white , borderRadius: BorderRadius.all(Radius.circular(15.0))),
                  margin:EdgeInsets.only( right: 15.0 , left: 15.0 , bottom: 5.0) ,
                  padding: EdgeInsets.all(15.0) ,

                  child: Row(
                    children: [
                      Text("notification_setting_moments_notification".tr ,style:TextStyle(color: Colors.black,fontSize: 15.0) ,),
                      Expanded(
                        child:Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            CupertinoSwitch(activeColor: MyColors.primaryColor,value: _MomentsValue,
                              onChanged: (value) {
                                setState(() {
                                  _MomentsValue = value;
                                });
                              },
                            ),
                          ],
                          //change your color here
                        ),
                      ),
                    ],

                  ),
                ),
              ],
            ),
            Container(
                 padding: EdgeInsets.all(30.0),
                child: FloatingActionButton(onPressed: (){} , backgroundColor: MyColors.primaryColor, mini: true, child: const Icon(FontAwesomeIcons.save , color: Colors.white),))

          ],
        ),
      ),
    );
  }
}
