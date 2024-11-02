import 'package:LikLok/shared/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BlockedScreen extends StatefulWidget {
  final int block_type ;
  const BlockedScreen({super.key , required this.block_type});

  @override
  State<BlockedScreen> createState() => _BlockedScreenState();
}

class _BlockedScreenState extends State<BlockedScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   // showAlertDialog(context);
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
          appBar: AppBar(
             title:  Text( widget.block_type == 0 ?   "account_ban_title".tr : "device_ban_title".tr , style: TextStyle(color: Colors.red),),
            iconTheme: IconThemeData(
              color: MyColors.whiteColor, //change your color here
            ),
            centerTitle: true,
            backgroundColor: MyColors.solidDarkColor,
          ),
        body: Container(
        color: MyColors.darkColor,
        width: double.infinity,
        height: double.infinity,
         padding: EdgeInsets.all(20.0),
         child: Column(
           children: [
             Image(image: AssetImage('assets/images/logo_round.png') , width: 200.0,),
             Text( widget.block_type == 0 ?  "account_ban_msg".tr : "device_ban_msg".tr , style: TextStyle(color: Colors.black , fontSize: 25.0), textAlign: TextAlign.center,),
             SizedBox(height: 20.0,),
             GestureDetector(
               onTap: () async{
                 final SharedPreferences prefs = await SharedPreferences.getInstance();
                 await prefs.setInt('userId', 0);

                 SystemNavigator.pop();
               },
               child: Container(
                 width: 100.0,
                 child: Center(child: Text("edit_ok".tr , style: TextStyle(color: MyColors.whiteColor , fontSize: 25.0),)),
                  padding: EdgeInsets.all(10.0), decoration: BoxDecoration(color: MyColors.primaryColor, borderRadius: BorderRadius.all(Radius.circular(15.0))),  ),
             )
           ],
         ),
        )
    );
  }

}
