import 'package:LikLok/layout/tabs_screen.dart';
import 'package:LikLok/models/AppUser.dart';
import 'package:LikLok/shared/network/remote/AppUserServices.dart';
import 'package:LikLok/shared/styles/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class SetPasswordScreen extends StatefulWidget {
  final int askForCurrentPassword  ;
  const SetPasswordScreen({super.key , required this.askForCurrentPassword});

  @override
  State<SetPasswordScreen> createState() => _SetPasswordScreenState();
}

class _SetPasswordScreenState extends State<SetPasswordScreen> {
  var contentController = TextEditingController()  ;
  var contentController2 = TextEditingController()  ;
  AppUser? user ;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
        user = AppUserServices().userGetter() ;
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
        title: Text("account_password".tr , style: TextStyle(color: MyColors.whiteColor,fontSize: 20.0) ,),
      ),
      body: SafeArea(
        child: Container(
              color: MyColors.darkColor,
              width: double.infinity,
              height: double.infinity,
              padding: EdgeInsets.all(15.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: TextField(
                      controller: contentController,
                      keyboardType: TextInputType.visiblePassword,
                      cursorColor: MyColors.primaryColor,
                      decoration: InputDecoration(  labelText: "enter_password".tr , labelStyle: TextStyle(color: Colors.grey , fontSize: 18.0)),
                      style: TextStyle(color: MyColors.whiteColor ),
                    ),
                  ),
                  SizedBox(height: 15.0,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: TextField(
                      controller: contentController2,
                      keyboardType: TextInputType.visiblePassword,
                      cursorColor: MyColors.primaryColor,
                      decoration: InputDecoration(  labelText: "re_enter_password".tr , labelStyle: TextStyle(color: Colors.grey , fontSize: 18.0)),
                      style: TextStyle(color: MyColors.whiteColor ),
                    ),
                  ),
                  SizedBox(height: 50.0,),
                  GestureDetector(
                    onTap: (){
                      updateMyPassword();
                    },
                    child: Container(
                      width: double.infinity,
                      height: 50,
                      margin: EdgeInsets.symmetric(horizontal: 20.0),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(15.0) , color: MyColors.primaryColor),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('verify_btn'.tr , style: TextStyle(color: Colors.white , fontSize: 20.0 , fontWeight: FontWeight.bold),)
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

  updateMyPassword() async{
    if(contentController.text ==  contentController2.text){
        AppUser? res = await AppUserServices().updateUserPassword(user!.id, contentController.text, 1);
         setState(() {
              user = res ;
         });
         AppUserServices().userSetter(user!);
        Fluttertoast.showToast(
            msg: widget.askForCurrentPassword == 0 ? "Login With Password has been enabled" :
            "Account Password has been updated",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black26,
            textColor: Colors.orange,
            fontSize: 16.0);
        Navigator.pushAndRemoveUntil(
            context ,
            MaterialPageRoute(builder: (context) => const TabsScreen()) ,   (route) => false
        );
    } else {
      Fluttertoast.showToast(
          msg: "Password does not match !",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black26,
          textColor: Colors.orange,
          fontSize: 16.0);
    }
  }
}
