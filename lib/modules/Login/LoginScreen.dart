import 'dart:async';
import 'package:LikLok/modules/IdLogin/ID_Login_Screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:LikLok/firebase_options.dart';
import 'package:LikLok/layout/tabs_screen.dart';
import 'package:LikLok/models/AppUser.dart';
import 'package:LikLok/modules/Agreement/Agreement_Screen.dart';
import 'package:LikLok/modules/PrivacyPolicy/Privacy_Policy_Screen.dart';
import 'package:LikLok/shared/network/remote/AppUserServices.dart';
import 'package:LikLok/shared/styles/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
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

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {

  bool isChecked = false;

  GoogleSignInAccount? _currentUser;
  bool _isAuthorized = false; // has granted permissions?
  String _contactText = '';
  var phoneController = TextEditingController();
  var codeController = TextEditingController();
  bool _isLoading = false ;
  FirebaseAuth? auth ;
   FirebaseFirestore? _firestore ;

  void createNewDocument(email , credintial , name , img ,phone , id){
    print('database created') ;
    _firestore!.collection('users').doc(credintial.user!.uid).set({
      'email':email,
      'uid':credintial.user!.uid,
      'name': name,
      'img': img,
      'phone':email,
      'id': id
    },SetOptions(merge: true));

  }
  bool isLoading1 = false ;

  @override
  void initState()  {
    super.initState();

    intializeFireBase();
    _googleSignIn.onCurrentUserChanged
        .listen((GoogleSignInAccount? account) async {
      bool isAuthorized = account != null;
      if (kIsWeb && account != null) {
        isAuthorized = await _googleSignIn.canAccessScopes(scopes);
      }
      setState(() {
        _currentUser = account;
        _isAuthorized = isAuthorized;

        // Navigator()
      });


    });


    _googleSignIn.signInSilently();

  }
  void intializeFireBase() async{
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
     auth = FirebaseAuth.instance;
    _firestore = FirebaseFirestore.instance;
  }
  Future<void> _handleSignIn() async {

    try {
    // await   _googleSignIn.disconnect();
     var googleUser  = await _googleSignIn.signIn();
     final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
     final credential = GoogleAuthProvider.credential(
       accessToken: googleAuth?.accessToken,
       idToken: googleAuth?.idToken,
     );

     UserCredential userCredential =await auth!.signInWithCredential(credential);
     setState(() {
       isLoading1 = true ;
     });
     var token = await FirebaseMessaging.instance.getToken();
     AppUser? user = await AppUserServices().createAccount(_googleSignIn.currentUser?.displayName , 'GOOGLE' ,
        "" , _googleSignIn.currentUser?.email , _googleSignIn.currentUser?.email , _googleSignIn.currentUser?.id , token);
     print('user' ) ;
    print(user ) ;
     if(user!.id > 0){

       setState(() {
         isLoading1 = false ;
       });
       if(user.enable == 1 ){
         createNewDocument(user.email , userCredential ,user.name ,user.img, user.email , user.id) ;
         FirebaseMessaging.instance.subscribeToTopic('all') ;
         Fluttertoast.showToast(
             msg: 'login_welcome_msg'.tr,
             toastLength: Toast.LENGTH_SHORT,
             gravity: ToastGravity.CENTER,
             timeInSecForIosWeb: 1,
             backgroundColor: Colors.black26,
             textColor: Colors.orange,
             fontSize: 16.0
         );
         final SharedPreferences prefs = await SharedPreferences.getInstance();

         await prefs.setInt('userId', user.id);
         AppUserServices().userSetter(user);
         Navigator.pushReplacement(
           context,
           MaterialPageRoute(builder: (context) => const TabsScreen()),
         );
       } else {
         showAlertDialog(context);
       }

     }

    } catch (error) {
      print('firebase error');
      print(error);
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



  @override
  Widget build(BuildContext context) {
    return     Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.zero,
        child: AppBar(
          backgroundColor: MyColors.darkColor,
          elevation: 0,
        ),
      ),
      body: Container(
        width: double.infinity,
         color: MyColors.blueDarkColor,
        child:  Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 120.0,),
                    Container(
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(40.0)),
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: const Image(image: AssetImage("assets/images/logo_splash.png") , width: 200.0, height: 200.0,)),
                    SizedBox(height: 10.0,),
                    Text("login_title".tr , style: TextStyle(fontSize: 25.0 , color: MyColors.primaryColor , fontWeight: FontWeight.bold),),
                    SizedBox(height: 20.0,),
                    isLoading1 ? CircularProgressIndicator(color: MyColors.primaryColor) : Container(),
                  ],
                ),
              ),
            ),
            Container(
              height: MediaQuery.sizeOf(context).height / 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap:(){

                          if(isChecked){
                            _displayTextInputDialog(context);
                          } else {
                            Fluttertoast.showToast(
                                msg: "check_privacy".tr,
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.black26,
                                textColor: Colors.orange,
                                fontSize: 16.0);
                          }
                        },
                        child: CircleAvatar(
                          radius: 30.0,
                          backgroundColor: Colors.grey.withOpacity(.4),
                          child: const Image(image: AssetImage('assets/images/phone.png') , width: 35.0 , height: 35.0,),
                        ),
                      ),
                      const SizedBox(width: 40.0,),
                      GestureDetector(
                        onTap: (){
                          if(isChecked){
                            _handleSignIn();
                          } else {
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
                        child: CircleAvatar(
                          backgroundColor: Colors.grey.withOpacity(.4),
                          radius: 30.0,
                          child: const Image(image: AssetImage('assets/images/gmail.png') , width: 35.0 , height: 35.0,),
                        ),
                      ),
                      // const SizedBox(width: 40.0,),
                      // CircleAvatar(
                      //   backgroundColor: Colors.grey.withOpacity(.4),
                      //   radius: 30.0,
                      //   child: const Image(image: AssetImage('assets/images/facebook.png') , width: 40.0 , height: 40.0,),
                      // ),
                    ],
                  ),
                  const SizedBox(height: 20.0,),
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => IdLoginScreen()));
                    },
                    child: Container(
                      width: MediaQuery.sizeOf(context).width * .8 ,
                      height: 40,
                      margin: EdgeInsets.symmetric(horizontal: 20.0),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(15.0) , color: Colors.yellow),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('id_login'.tr , style: TextStyle(color: Colors.black , fontSize: 20.0 , fontWeight: FontWeight.bold),)
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0,),
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
                  const SizedBox(height: 20.0,),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  phoneAuthLogin() async{
    _isLoading = true ;
    await auth!.verifyPhoneNumber(
      phoneNumber: phoneController.text,
      verificationCompleted: (PhoneAuthCredential credential) {
         print(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        _isLoading = false;
        Fluttertoast.showToast(
            msg: "login_verify_phone".tr,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black26,
            textColor: Colors.orange,
            fontSize: 16.0);
      },
      codeSent: (String verificationId, int? resendToken) {
        _isLoading = false;
        Navigator.pop(context);

        Fluttertoast.showToast(
            msg: "login_code_msg".tr,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black26,
            textColor: Colors.orange,
            fontSize: 16.0);
        _displayTextInputDialog2(context , verificationId);
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  verifyCode(verificationId) async{
    setState(() {
      _isLoading = true ;
    });


    PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: codeController.text);
    UserCredential userCredential = await auth!.signInWithCredential(credential);
    var token = await FirebaseMessaging.instance.getToken();
    AppUser? user = await AppUserServices().createAccount('new user' , 'PHONE' ,
        "" , phoneController.text , phoneController.text, credential.verificationId , token);


    Navigator.pop(context);

    if(user!.id > 0){

      setState(() {
        isLoading1 = false ;
      });
      if(user.enable == 1 ){
        createNewDocument(user.email , userCredential ,user.name ,user.img, user.email , user.id) ;
        FirebaseMessaging.instance.subscribeToTopic('all') ;
        Fluttertoast.showToast(
            msg: 'login_welcome_msg'.tr,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black26,
            textColor: Colors.orange,
            fontSize: 16.0
        );
        final SharedPreferences prefs = await SharedPreferences.getInstance();

        await prefs.setInt('userId', user.id);
        AppUserServices().userSetter(user);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const TabsScreen()),
        );
      } else {
        showAlertDialog(context);
      }

    }
  }

  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return Container(
          child:
          AlertDialog(
            backgroundColor: MyColors.darkColor,
            title: Text(
              'login_phone_title'.tr,
              style: TextStyle(color: Colors.white, fontSize: 20.0),
              textAlign: TextAlign.center,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "login_phone_hint".tr,
                      style: TextStyle(
                          color: MyColors.unSelectedColor, fontSize: 13.0),
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
                Container(
                  height: 70.0,
                  child: TextField(
                    controller: phoneController,
                    style: TextStyle(color: Colors.white),
                    keyboardType: TextInputType.phone,
                    cursorColor: MyColors.primaryColor,
                    decoration: InputDecoration(
                        hintText: "+20XXXXXXXXXX",
                        hintStyle: TextStyle(color: Colors.white),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(color: MyColors.whiteColor)),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0))),
                  ),
                ),
              ],
            ),
            actions: <Widget>[
              Container(
                decoration: BoxDecoration(
                    color: MyColors.solidDarkColor,
                    borderRadius: BorderRadius.circular(15.0)),
                child: MaterialButton(
                  child: Text(
                    'edit_profile_cancel'.tr,
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    Navigator.pop(context);
                  },
                ),
              ),
              ElevatedButton.icon(
                onPressed: (){
                  _isLoading = true ;
                  phoneAuthLogin();
                },
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 10.0 , vertical: 5.0) , backgroundColor: MyColors.primaryColor ,
                ),
                icon: _isLoading
                    ? Container(
                  width: 20,
                  height: 20,
                  padding: const EdgeInsets.all(2.0),
                       child:  CircularProgressIndicator(
                    color: MyColors.darkColor,
                    strokeWidth: 3,
                  ),
                )
                    :  Icon(Icons.send_to_mobile , color: MyColors.darkColor , size: 20.0,),
                label:  Text('send_btn'.tr , style: TextStyle(color: MyColors.darkColor , fontSize: 13.0), ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _displayTextInputDialog2(BuildContext context , verificationId) async {
    return showDialog(
      context: context,
      builder: (context) {
        return Container(
          child: AlertDialog(
            backgroundColor: MyColors.darkColor,
            title: Text(
              'verify_phone_title'.tr,
              style: TextStyle(color: Colors.white, fontSize: 20.0),
              textAlign: TextAlign.center,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "verify_phone_hint".tr,
                      style: TextStyle(
                          color: MyColors.unSelectedColor, fontSize: 13.0),
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
                Container(
                  height: 70.0,
                  child: TextField(
                    controller: codeController,
                    style: TextStyle(color: Colors.white),
                    keyboardType: TextInputType.phone,
                    cursorColor: MyColors.primaryColor,
                    maxLength: 6,
                    decoration: InputDecoration(
                        hintText: "XXXXXX",
                        hintStyle: TextStyle(color: Colors.white),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(color: MyColors.whiteColor)),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0))),
                  ),
                ),
              ],
            ),
            actions: <Widget>[
              Container(
                decoration: BoxDecoration(
                    color: MyColors.solidDarkColor,
                    borderRadius: BorderRadius.circular(15.0)),
                child: MaterialButton(
                  child: Text(
                    'edit_profile_cancel'.tr,
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    Navigator.pop(context);
                  },
                ),
              ),
              ElevatedButton.icon(
                onPressed: (){
                  _isLoading = true ;
                  verifyCode(verificationId);
                },
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 10.0 , vertical: 5.0) , backgroundColor: MyColors.primaryColor ,
                ),
                icon: _isLoading
                    ? Container(
                        width: 20,
                        height: 20,
                        padding: const EdgeInsets.all(2.0),
                      child:  CircularProgressIndicator(
                    color: MyColors.darkColor,
                    strokeWidth: 3,
                  ),
                )
                    :  Icon(Icons.check_circle , color: MyColors.darkColor , size: 20.0,),
                label:  Text('verify_btn'.tr , style: TextStyle(color: MyColors.darkColor , fontSize: 13.0), ),
              ),
            ],
          ),
        );
      },
    );
  }
}
