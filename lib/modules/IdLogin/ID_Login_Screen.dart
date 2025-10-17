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

  Widget _buildInputField({
    required TextEditingController controller,
    required IconData icon,
    required String hint,
    bool obscureText = false,
  }) {
    return Container(
      height: 55,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(25),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        style: const TextStyle(color: Colors.white),
        cursorColor: Colors.amber,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white54),
          prefixIcon: Icon(icon, color: Colors.white),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: const BorderSide(color: Colors.amber),
          ),
          filled: true,
          fillColor: Colors.white.withOpacity(0.1),
        ),
      ),
    );
  }

  Widget _buildPrivacyAgreementSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // The Checkbox
          Padding(
            padding: const EdgeInsets.only(top: 2.0),
            child: Checkbox(
              value: isChecked,
              activeColor: MyColors.primaryColor,
              onChanged: (bool? value) {
                setState(() {
                  isChecked = value ?? false;
                });
              },
            ),
          ),

          // The wrap of texts and links
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(fontSize: 12.0, color: Colors.white),
                children: [
                  TextSpan(text: 'login_privacy'.tr + ' '),
                  WidgetSpan(
                    alignment: PlaceholderAlignment.middle,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const Privacy_Policy_Screen()),
                        );
                      },
                      child: Text(
                        "login_policy".tr,
                        style: TextStyle(
                          color: MyColors.secondaryColor,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                          fontSize: 12.0,
                        ),
                      ),
                    ),
                  ),
                  TextSpan(text: ' ${'login_and'.tr} '),
                  WidgetSpan(
                    alignment: PlaceholderAlignment.middle,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const Agreement_Screen()),
                        );
                      },
                      child: Text(
                        "login_services".tr,
                        style: TextStyle(
                          color: MyColors.secondaryColor,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                          fontSize: 12.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }





  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, // or MyColors.whiteColor
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [MyColors.blueDarkColor, MyColors.solidDarkColor],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          width: double.infinity,
          height: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: SingleChildScrollView(
            child: !_isLoading
                ? Column(
              children: [
                const SizedBox(height: 150),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40.0),
                    boxShadow: [
                      BoxShadow(color: Colors.black26, blurRadius: 10.0),
                    ],
                  ),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: const Image(
                    image: AssetImage("assets/images/logo_splash.png"),
                    width: 150,
                    height: 150,
                  ),
                ),
                const SizedBox(height: 40),
                _buildInputField(
                  controller: idController,
                  icon: Icons.perm_identity,
                  hint: "id_text".tr,
                ),
                const SizedBox(height: 20),
                _buildInputField(
                  controller: passwordController,
                  icon: Icons.lock,
                  hint: "account_password".tr,
                  obscureText: true,
                ),
                const SizedBox(height: 30),
                GestureDetector(
                  onTap: () {
                    if (isChecked) {
                      loginUserViaID();
                    } else {
                      Fluttertoast.showToast(
                        msg: "check_privacy".tr,
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        backgroundColor: Colors.black87,
                        textColor: MyColors.secondaryColor,
                      );
                    }
                  },
                  child: Container(
                    width: width * 0.6,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25.0),
                      gradient: const LinearGradient(
                        colors: [Colors.amber, Colors.orangeAccent],
                      ),
                      boxShadow: [
                        BoxShadow(color: Colors.black26, blurRadius: 5, offset: Offset(0, 2)),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'login'.tr,
                      style: const TextStyle(
                          color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                _buildPrivacyAgreementSection(),
              ],
            )
                : SizedBox(
              height: MediaQuery.of(context).size.height, // full screen height
              child:  Center(child: CircularProgressIndicator(color: MyColors.secondaryColor,)),
            ),
          ),
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
        print('user');
        print(user);
        if(user != null){
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
        } else {
          setState(() {
            _isLoading = false ;
          });
          Fluttertoast.showToast(
              msg: "ID or Password is not valid",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.black26,
              textColor: MyColors.secondaryColor,
              fontSize: 16.0);
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
