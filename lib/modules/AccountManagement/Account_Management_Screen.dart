import 'package:LikLok/models/AppUser.dart';
import 'package:LikLok/models/HostAgency.dart';
import 'package:LikLok/shared/network/remote/AppUserServices.dart';
import 'package:LikLok/shared/styles/colors.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';


const List<String> scopes = <String>[
  'email',
  'profile',
];
GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: scopes,
);

class Account_Management_Screen extends StatefulWidget {
  const Account_Management_Screen({super.key});

  @override
  State<Account_Management_Screen> createState() => _Account_Management_ScreenState();
}

class _Account_Management_ScreenState extends State<Account_Management_Screen> {
  AppUser? user ;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(mounted){
      setState(() {
        user = AppUserServices().userGetter();

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
        title: Text("account_management_title".tr , style: TextStyle(color: MyColors.whiteColor,fontSize: 20.0) ,),
      ),
      body: Container(
        color: MyColors.darkColor,
        width: double.infinity,
        height: double.infinity,
        padding: EdgeInsets.all(15.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(color: Colors.white , borderRadius: BorderRadius.circular(15.0) , border: Border.all(color: MyColors.secondaryColor ,
              width: 2.0)),
              padding: EdgeInsets.all(15.0),
              child: Row(
                children: [
                  Image(image: AssetImage(getProviderImage()) , width: 60.0,),
                  SizedBox(width: 20.0,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(getProviderName() , style: TextStyle(color: Colors.black , fontSize: 18.0),),
                      SizedBox(height: 10.0,),
                      Text(getProviderValue() , style: TextStyle(color: MyColors.unSelectedColor , fontSize: 12.0),),
                    ],
                  )
                ],
              ),
            ),
            Expanded(child:
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap:(){
                    FirebaseMessaging.instance.unsubscribeFromTopic('all');
                    showAlertDialog(context);
                  } ,
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    margin: EdgeInsets.symmetric(horizontal: 20.0),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(15.0) , color: Colors.white),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('log_out'.tr , style: TextStyle(color: Colors.red , fontSize: 20.0 , fontWeight: FontWeight.bold),)
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20.0,),
                GestureDetector(
                  onTap:(){
                    showAlertDialog2(context);
                  } ,
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    margin: EdgeInsets.symmetric(horizontal: 20.0),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(15.0) , color: MyColors.primaryColor),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('delete_account'.tr , style: TextStyle(color: MyColors.secondaryColor , fontSize: 20.0 , fontWeight: FontWeight.bold),)
                      ],
                    ),
                  ),
                ),
              ],
            )
            )
          ],
        ),
      ),
    );
  }
  String getProviderImage(){
    if(user!.register_with == "GOOGLE") return 'assets/images/google_auth.png';
    else if(user!.register_with == "FACEBOOK") return 'assets/images/facebook_auth.png';
    else return 'assets/images/phone_Auth.png';
  }
  String getProviderName(){
    if(user!.register_with == "GOOGLE") return 'Gmail';
    else if(user!.register_with == "FACEBOOK") return 'Facebook';
    else return 'Phone Number';
  }
  String getProviderValue(){
    if(user!.register_with == "GOOGLE") return  user!.email;
    else if(user!.register_with == "FACEBOOK") return  user!.email;
    else return user!.phone;;
  }

  showAlertDialog(BuildContext context) {

    // set up the button
    Widget okButton = TextButton(
      child: Text("edit_ok".tr , style: TextStyle(color: MyColors.primaryColor),),
      onPressed: () async{
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setInt('userId', 0);
        if(user!.register_with == "GOOGLE"){
          _googleSignIn.disconnect();
        }

        SystemNavigator.pop();

      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
     backgroundColor: MyColors.darkColor,
      title: Text("log_out".tr , style: TextStyle(color: MyColors.primaryColor),),
      content: Text("logout_msg".tr , style: TextStyle(color: MyColors.whiteColor),),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showAlertDialog2(BuildContext context) {

    // set up the button
    Widget okButton = TextButton(
      child: Text("edit_ok" , style: TextStyle(color: MyColors.primaryColor),),
      onPressed: () { },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      backgroundColor: MyColors.darkColor,
      title: Text("delete_account" , style: TextStyle(color: MyColors.primaryColor),),
      content: Text("delete_Account_msg" , style: TextStyle(color: MyColors.whiteColor),),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
