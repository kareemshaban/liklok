import 'package:LikLok/shared/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
        title: Text("help_title".tr , style: TextStyle(color: MyColors.whiteColor,fontSize: 20.0) ,),
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
                    Text("LikLok Help Center",style: TextStyle(color: MyColors.whiteColor,fontSize: 18.0)),
                    SizedBox(height: 3.0,),
                    Text("about_us_version".tr + "1.8.0",style: TextStyle(color: MyColors.unSelectedColor,fontSize: 14.0)),

                  ],
                ),
              ),
              Container(
                color: Colors.white,
                padding: EdgeInsets.all(15.0) ,
                margin: EdgeInsetsDirectional.only(bottom: 10.0),
                child: GestureDetector(
                  onTap: () async{
                    await launch('https://t.me/Iiklok');
                  },
                  child: Row(
                    children: [
                      Text("help_center_whatssapp".tr ,style:TextStyle(color: MyColors.unSelectedColor,fontSize: 15.0) ,),
                      Expanded(
                        child:Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Icon(Icons.arrow_forward_ios_outlined , color: MyColors.unSelectedColor, size: 20.0,)
                            ]
                          //change your color here
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () async{
                  final Uri url = Uri.parse('https://liklok.live/en');
                  if (!await launchUrl(url)) {
                    throw Exception('Could not launch $url');
                  }
                },
                child: Container(
                  color: Colors.white,
                  margin: EdgeInsetsDirectional.only(bottom: 10.0),
                  padding: EdgeInsets.all(15.0) ,
                  child: Row(
                    children: [
                      Text("help_center_website".tr ,style:TextStyle(color: MyColors.unSelectedColor,fontSize: 15.0) ,),
                      Expanded(
                        child:Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Icon(Icons.arrow_forward_ios_outlined , color: MyColors.unSelectedColor, size: 20.0,)
                            ]
                          //change your color here
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () async{
                  await launch('https://liklok.live');
                },
                child: Container(
                  color: Colors.white,
                  padding: EdgeInsets.all(15.0) ,
                  margin: EdgeInsetsDirectional.only(bottom: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("help_center_email".tr ,style:TextStyle(color: MyColors.unSelectedColor,fontSize: 16.0) ,),
                          SizedBox(height: 10.0,),
                          Text("support@liklok.live".tr ,style: TextStyle(color: MyColors.unSelectedColor,fontSize: 14.0)),

                        ],
                      )


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
}
