
import 'package:LikLok/shared/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class About_Screen extends StatefulWidget {
  const About_Screen({super.key});

  @override
  State<About_Screen> createState() => _About_ScreenState();
}

class _About_ScreenState extends State<About_Screen> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: MyColors.whiteColor, //change your color here
        ),
        centerTitle: true,
        backgroundColor: MyColors.solidDarkColor,
        title: Text("about_us_title".tr , style: TextStyle(color: MyColors.whiteColor,fontSize: 20.0) ,),
        // actions: [
        //   IconButton(onPressed: (){}, icon: Icon(FontAwesomeIcons.sync))
        // ],
      ),
      body: Container(
        color: MyColors.darkColor,
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: Colors.white,
              padding: EdgeInsets.all(15.0) ,
              margin: EdgeInsetsDirectional.only(bottom: 10.0),
              width: double.infinity,
              child: Column(
                children: [
                  Container(
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(15.0)),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: Image(image: AssetImage('assets/images/logo_round.png') , width: 100.0, height: 100.0,)),
                  SizedBox(height: 5.0,),
                  Text("LikLok",style: TextStyle(color: MyColors.whiteColor,fontSize: 18.0)),
                  SizedBox(height: 3.0,),
                  Text("about_us_version".tr + "1.8.0",style: TextStyle(color: MyColors.whiteColor,fontSize: 14.0)),

                ],
              ),
            ),
            Container(
              color: Colors.white,
              padding: EdgeInsets.all(15.0) ,
              child: GestureDetector(
                onTap: (){
                  Fluttertoast.showToast(
                      msg: "No available updates!".tr,
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
                    Text("about_us_update_version".tr ,style:TextStyle(color: MyColors.whiteColor,fontSize: 15.0) ,),
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
            GestureDetector(
              onTap: (){
                openWebsite();
              },
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.all(15.0) ,
                child: Row(
                  children: [
                    Text("about_us_official_website".tr ,style:TextStyle(color: MyColors.whiteColor,fontSize: 15.0) ,),
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
          ],
        ),
        ),
      ),
      );
  }
  void openWebsite() async {
    final Uri url = Uri.parse('https://liklok.live/en');
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

}
