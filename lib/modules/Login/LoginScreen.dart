import 'dart:async';
import 'package:LikLok/modules/IdLogin/ID_Login_Screen.dart';
import 'package:LikLok/modules/Login/OtpVerificationDialog.dart';
import 'package:LikLok/modules/Login/PhoneInputDialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:LikLok/firebase_options.dart';
import 'package:LikLok/layout/tabs_screen.dart';
import 'package:LikLok/models/AppUser.dart';
import 'package:LikLok/modules/Agreement/Agreement_Screen.dart';
import 'package:LikLok/modules/PrivacyPolicy/Privacy_Policy_Screen.dart';
import 'package:LikLok/shared/network/remote/AppUserServices.dart';
import 'package:LikLok/shared/styles/colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';



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
  var phoneController = TextEditingController();
  var codeController = TextEditingController();
  bool _isLoading = false ;
  bool isLoading1 = false ;

  FirebaseAuth? auth ;
  FirebaseFirestore? _firestore ;

  void createNewDocument(email , uid , name , img ,phone , id){
    print('database created') ;
    _firestore!.collection('users').doc(uid).set({
      'email':email,
      'uid': uid ,
      'name': name,
      'img': img,
      'phone':email,
      'id': id
    },SetOptions(merge: true));

  }

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

  Widget _socialLoginButton({required String icon, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(50),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: Image.asset(icon, width: 35, height: 35),
      ),
    );
  }

  void _showPrivacyToast() {
    Fluttertoast.showToast(
      msg: "check_privacy".tr,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      backgroundColor: Colors.black26,
      textColor: MyColors.secondaryColor,
      fontSize: 16.0,
    );
  }


  Future<void> _handleSignIn() async {
    setState(() {
      isLoading1 = true ;
    });
    try {
      var googleUser  = await _googleSignIn.signIn();
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      UserCredential userCredential =await FirebaseAuth.instance.signInWithCredential(credential);
      setState(() {
        isLoading1 = true ;
      });
      var token = await FirebaseMessaging.instance.getToken();


      final prefs = await SharedPreferences.getInstance();

      print('googleUserId');
      print(_googleSignIn.currentUser!.id);

      await prefs.setString('googleUserId', _googleSignIn.currentUser!.id);


      postUser(_googleSignIn.currentUser?.displayName , 'GOOGLE' ,
          "" , _googleSignIn.currentUser?.email , _googleSignIn.currentUser?.email , _googleSignIn.currentUser?.id , token ,
          userCredential.user!.uid);


    } catch (error) {
      print('Error signing in: $error');
    }
  }

  void _showPhoneInputDialog(BuildContext context) {
    final rootContext = context;
    showDialog(
      context: context,
      builder: (context) => PhoneInputDialog(
        onSendOtp: (phone) {
          Navigator.of(context).pop();

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('OTP sent to $phone')),
          );

          Future.delayed(const Duration(milliseconds: 300), () {
            showDialog(
              context: rootContext,
              barrierDismissible: false,
              builder: (context) => OtpVerificationDialog(
                onVerify: (otp) async{
                  print('Verify OTP: $otp');
                   setState(() {
                     isLoading1 = true ;
                   });
                  bool verified = await AppUserServices().verifyOtp(phone, otp);
                  if(verified){
                    var token = await FirebaseMessaging.instance.getToken();
                    postUser('new user' , 'PHONE' ,
                        "" , phone , phone, phone , token ,phone );
                    setState(() {
                      isLoading1 = false ;
                    });
                    ScaffoldMessenger.of(rootContext).showSnackBar(
                      SnackBar(content: Text('phone verified success')),
                    );
                  } else {
                    setState(() {
                      isLoading1 = false ;
                    });
                    ScaffoldMessenger.of(rootContext).showSnackBar(
                      SnackBar(content: Text('phone verified failed')),
                    );
                  }
                },
              ),
            );
          });
        },
      ),
    );
  }

  postUser(userName , register_with , img , phone , email , password , token , uid) async {
    print('postUser');
    AppUser? user = await AppUserServices().createAccount(
        userName,
        register_with,
        img,
        phone,
        email,
        password,
        token);

    print('user');
    print(user);

    if (user!.id > 0) {
      print('user id');
      setState(() {
        isLoading1 = false;
      });
      if (user.enable == 1) {
        createNewDocument(user.email , uid ,user.name ,user.img, user.email , user.id) ;
        FirebaseMessaging.instance.subscribeToTopic('all');
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
       // showAlertDialog(context);
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                MyColors.darkColor,
                Colors.black,
              ],
            ),
          ),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 120),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 800),
                        curve: Curves.easeOut,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 10,
                              offset: Offset(0, 8),
                            )
                          ],
                        ),
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: Image.asset(
                          "assets/images/logo_splash.png",
                          width: 180,
                          height: 180,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "login_title".tr,
                        style: TextStyle(
                          fontSize: 28.0,
                          color: MyColors.primaryColor,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              color: Colors.black45,
                              offset: Offset(2, 2),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      if(isLoading1)
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: SizedBox(
                            height: 30,
                            width: 30,
                            child: CircularProgressIndicator(
                              color: MyColors.secondaryColor,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              Container(
                height: MediaQuery.sizeOf(context).height / 2.5,
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _socialLoginButton(
                          icon: 'assets/images/phone.png',
                          onTap: () {
                            if (isChecked) {
                              _showPhoneInputDialog(context);
                            } else {
                              _showPrivacyToast();
                            }
                          },
                        ),
                        const SizedBox(width: 40),
                        _socialLoginButton(
                          icon: 'assets/images/gmail.png',
                          onTap: () {
                            if (isChecked) {
                              _handleSignIn();
                            } else {
                              _showPrivacyToast();
                            }
                          },
                        ),
                        const SizedBox(width: 40),
                        _socialLoginButton(
                          icon: 'assets/images/id_login.png',
                          onTap: () {
                            if (isChecked) {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (_) => IdLoginScreen()));
                            } else {
                              _showPrivacyToast();
                            }
                          },
                        ),
                      ],
                    ),
        
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 4,
                        runSpacing: 4,
                        children: [
                          Checkbox(
                            activeColor: MyColors.secondaryColor,
                            value: isChecked,
                            onChanged: (bool? value) {
                              setState(() {
                                isChecked = value ?? false;
                              });
                            },
                          ),
                          Text("login_privacy".tr,
                              style:
                              const TextStyle(color: Colors.white, fontSize: 12)),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const Privacy_Policy_Screen()),
                              );
                            },
                            child: Text(
                              "login_policy".tr,
                              style: TextStyle(
                                color: MyColors.secondaryColor,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                          Text("login_and".tr,
                              style:
                              const TextStyle(color: Colors.white, fontSize: 12)),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const Agreement_Screen()),
                              );
                            },
                            child: Text(
                              "login_services".tr,
                              style: TextStyle(
                                color: MyColors.secondaryColor,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }







}
