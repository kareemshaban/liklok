import 'package:LikLok/layout/tabs_screen.dart';
import 'package:LikLok/models/AppUser.dart';
import 'package:LikLok/modules/Agreement/Agreement_Screen.dart';
import 'package:LikLok/modules/Loading/loadig_screen.dart';
import 'package:LikLok/modules/PrivacyPolicy/Privacy_Policy_Screen.dart';
import 'package:LikLok/shared/network/remote/AppUserServices.dart';
import 'package:LikLok/shared/styles/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IdLoginScreen extends StatefulWidget {
  const IdLoginScreen({super.key});

  @override
  State<IdLoginScreen> createState() => _IdLoginScreenState();
}

class _IdLoginScreenState extends State<IdLoginScreen> {
  var idController = TextEditingController()  ;
  var passwordController = TextEditingController()  ;

  bool isChecked = false;
  bool _isLoading = false ;
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: MyColors.whiteColor, //change your color here
        ),
        centerTitle: true,
        backgroundColor: MyColors.solidDarkColor,
        title: Text("id_login".tr , style: TextStyle(color: MyColors.whiteColor),),
      ),
      body: Container(
        color: MyColors.blueDarkColor,
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          child: !_isLoading ? Column(
            children: [
              const SizedBox(height: 120.0,),
              Container(
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(40.0)),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: const Image(image: AssetImage("assets/images/logo_splash.png") , width: 200.0, height: 200.0,)),
              Container(
                height: 55.0 ,
                width: MediaQuery.sizeOf(context).width * .85,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(25.0) , color: MyColors.lightUnSelectedColor.withAlpha(100),),
                child: TextField( controller: idController, keyboardType: TextInputType.number,  decoration: InputDecoration( hintText: "id_text".tr ,  hintStyle: TextStyle(color: Colors.white), suffixIcon: IconButton(icon: const Icon(Icons.perm_identity , color: Colors.white, size: 25.0,),
                  onPressed: (){},) , fillColor: MyColors.primaryColor, focusColor: MyColors.primaryColor, focusedBorder: OutlineInputBorder( borderRadius: BorderRadius.circular(25.0) ,
                    borderSide: BorderSide(color: Colors.white) ) ,  border: OutlineInputBorder( borderRadius: BorderRadius.circular(25.0) ) , labelStyle: const TextStyle(color: Colors.black , fontSize: 13.0) ,  ),
                  style: const TextStyle(color: Colors.white , fontSize: 15.0) , cursorColor: MyColors.primaryColor,  ),
              ),
              SizedBox(height: 20.0,),
              Container(
                height: 55.0 ,
                width: MediaQuery.sizeOf(context).width * .85,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(25.0) , color: MyColors.lightUnSelectedColor.withAlpha(100),),
                child: TextField( controller: passwordController, keyboardType: TextInputType.visiblePassword,  decoration: InputDecoration( hintText: "account_password".tr ,  hintStyle: TextStyle(color: Colors.white), suffixIcon: IconButton(icon: const Icon(Icons.lock , color: Colors.white, size: 25.0,),
                  onPressed: (){},) , fillColor: MyColors.primaryColor, focusColor: MyColors.primaryColor, focusedBorder: OutlineInputBorder( borderRadius: BorderRadius.circular(25.0) ,
                    borderSide: BorderSide(color: Colors.white) ) ,  border: OutlineInputBorder( borderRadius: BorderRadius.circular(25.0) ) , labelStyle: const TextStyle(color: Colors.black , fontSize: 13.0) ,  ),
                  style: const TextStyle(color: Colors.white , fontSize: 15.0) , cursorColor: MyColors.primaryColor,  ),
              ),
              SizedBox(height: 20.0,),
              GestureDetector(
                onTap: () {
                  if(isChecked){
                    loginUserViaID();
                  }  else {
                    Fluttertoast.showToast(
                        msg: "check_privacy".tr,
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.black26,
                        textColor: MyColors.secondaryColor,
                        fontSize: 16.0);
                  }
                },
                child: Container(
                  width: MediaQuery.sizeOf(context).width * .50 ,
                  height: 50,
                  margin: EdgeInsets.symmetric(horizontal: 20.0),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(15.0) , color: Colors.yellow),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('login'.tr , style: TextStyle(color: Colors.black , fontSize: 20.0 , fontWeight: FontWeight.bold),)
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20.0,),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Checkbox(
                      activeColor: MyColors.primaryColor,
                      tristate: false,
                      value: isChecked,
                      onChanged: (bool? value) {
                        setState(() {
                          isChecked = value!;
                        });
                      },
                    ),
                    Text('login_privacy'.tr , style: TextStyle(fontSize: 12.0 , color: Colors.white)  ,),
                    TextButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context) => const Privacy_Policy_Screen(),));}, child:  Text("login_policy".tr , style: TextStyle(color:  MyColors.secondaryColor , fontSize: 12.0 , fontWeight: FontWeight.bold , decoration: TextDecoration.underline , decorationColor:  MyColors.secondaryColor,),) ),
                    Text('login_and'.tr , style: TextStyle(fontSize: 12.0 , color: Colors.white) ),
                    TextButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context) => const Agreement_Screen(),));}, child:  Text("login_services".tr , style: TextStyle(color:  MyColors.secondaryColor , fontSize: 12.0 , fontWeight: FontWeight.bold , decoration: TextDecoration.underline , decorationColor:  MyColors.secondaryColor,),)),
                  ],
                ),
              ),
            ],
          ) : Loading(),
        ),
      ),
    );
  }
  loginUserViaID() async{
      if(idController.text != "" && passwordController.text != "" ){
        setState(() {
          _isLoading = true ;
        });
        AppUser? user = await AppUserServices().LoginWithIdAndPassword(idController.text , passwordController.text);
        if(user!.id > 0){
          if(user.enable == 1 ) {
            setState(() {
              _isLoading = false ;
            });
            Fluttertoast.showToast(
                msg: 'login_welcome_msg'.tr,
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.black26,
                textColor: Colors.orange,
                fontSize: 16.0
            );
            final SharedPreferences prefs = await SharedPreferences
                .getInstance();

            await prefs.setInt('userId', user.id);
            AppUserServices().userSetter(user);
            Navigator.pushAndRemoveUntil(
                context ,
                MaterialPageRoute(builder: (context) => const TabsScreen()) ,   (route) => false
            );

          } else {
            setState(() {
              _isLoading = false ;
            });
            showAlertDialog(context);
          }
        }

      } else {
        Fluttertoast.showToast(
            msg: "Please Enter user ID and Password",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black26,
            textColor: MyColors.secondaryColor,
            fontSize: 16.0);
      }
  }
  showAlertDialog(BuildContext context) {

    // set up the button
    Widget okButton = TextButton(
      child: Text("edit_ok".tr , style: TextStyle(color: MyColors.primaryColor)),
      onPressed: () {
        SystemNavigator.pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      backgroundColor: Colors.white,
      title: Text("user_app_blocked_title".tr , style: TextStyle(color: Colors.black),),
      content: Text("user_app_blocked_msg".tr , style: TextStyle(color: Colors.black),),
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
