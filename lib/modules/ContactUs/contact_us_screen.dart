import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../shared/styles/colors.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({super.key});


  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: MyColors.whiteColor, //change your color here
        ),
        centerTitle: true,
        backgroundColor: MyColors.solidDarkColor,
        title: Text("contact_Us_title".tr , style: TextStyle(color: MyColors.whiteColor,fontSize: 20.0) ,),
      ),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: MyColors.darkColor,
            padding: EdgeInsets.symmetric(horizontal: 10.0 , vertical: 10.0),
            child:
              Column(
                children: [
                  Text("contact_Us_club_chat".tr,style: TextStyle(color: MyColors.whiteColor,fontSize: 20.0 ),textAlign:TextAlign.center,),
                  SizedBox(height: 40.0,),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 28.0,
                        child: Image(image: AssetImage('assets/images/gmail.png') , width: 35.0, height: 35.0,),
                      ),
                      SizedBox(width: 14.0,),
                      Text("support@chat.apps",style: TextStyle(fontSize: 17.0,color: Colors.black),)
                    ],
                  ),
                  SizedBox(height: 20.0,),
                  GestureDetector(
                    onTap: () async{
                      await launch('https://t.me/llklok');
                    },
                    child: Row(
                      children: [
                      CircleAvatar(
                      radius: 28.0,
                      child: Image(image: AssetImage('assets/images/telegram.png') , width: 57.0, height: 57.0,),
                    ),
                    SizedBox(width: 14.0,),
                    Text("TELEGRAM",style: TextStyle(fontSize: 17.0,color: Colors.black),),
                                  ],
                                ),
                  ),
                  SizedBox(height: 30.0,),
                  Column(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10.0 , vertical: 10.0),
                        child: Column(
                          children: [
                            Text('contact_Us_social_media'.tr,style: TextStyle(fontSize: 18.0,color: Colors.black),textAlign: TextAlign.center,),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 50.0,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () async{
                          await launch('https://t.me/Iiklok');
                        },
                        child: CircleAvatar(
                          radius: 29.0,
                          child: Image(image: AssetImage('assets/images/facebook-logo.png') , width: 58.0, height: 58.0,),
                        ),
                      ),
                      SizedBox(width: 20.0,),
                      GestureDetector(
                        onTap: () async{
                          await launch('https://t.me/Iiklok');
                        },
                        child: CircleAvatar(
                          radius: 35.0,backgroundColor: MyColors.darkColor,
                          child: Image(image: AssetImage('assets/images/instagram.png') , width: 58.0, height: 58.0,),
                        ),
                      ),
                      SizedBox(width: 20.0,),
                      GestureDetector(
                        onTap: () async{
                          await launch('https://t.me/Iiklok');
                        },
                        child: CircleAvatar(
                          radius: 35.0,backgroundColor: MyColors.darkColor,
                          child: Image(image: AssetImage('assets/images/twitter2.png') , width: 58.0, height: 58.0,),
                        ),
                      ),
                    ],
                  )
                ],
              ),
        ),
      ),
    );
  }
}
