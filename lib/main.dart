import 'dart:io';
import 'package:LikLok/firebase_options.dart';
import 'package:LikLok/models/AppSettings.dart';
import 'package:LikLok/models/AppUser.dart';
import 'package:LikLok/models/Intro.dart';
import 'package:LikLok/modules/BlockedScreen/blocked_screen.dart';
import 'package:LikLok/shared/network/remote/AppSettingsServices.dart';
import 'package:LikLok/shared/network/remote/AppUserServices.dart';
import 'package:LikLok/layout/tabs_screen.dart';
import 'package:LikLok/modules/Login/LoginScreen.dart';
import 'package:LikLok/shared/network/remote/ChatRoomService.dart';
import 'package:LikLok/shared/network/remote/IntroServices.dart';
import 'package:LikLok/shared/styles/colors.dart';
import 'package:LikLok/translation.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:x_overlay/x_overlay.dart';

import 'modules/Room/Components/room_overlay_widget.dart';


Future<void> FirebaseBackgroundMessage(RemoteMessage message)async {
  print('on background message') ;
  print(message.data.toString()) ;
}







Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: WidgetsFlutterBinding.ensureInitialized()  );
  try{
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    var token = await FirebaseMessaging.instance.getToken();



    FirebaseMessaging.onMessage.listen((event) {
      AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: 10,
            channelKey: 'basic_channel',
            actionType: ActionType.Default,
            title: event.notification!.title.toString(),
            body: event.notification!.body.toString(),

          )
      );
    });

    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: 10,
            channelKey: 'basic_channel',
            actionType: ActionType.Default,
            title: event.notification!.title.toString(),
            body: event.notification!.body.toString(),

          )
      );
    });

    FirebaseMessaging.onBackgroundMessage(FirebaseBackgroundMessage) ;
  }catch(err){
     print(err);
  }

  AwesomeNotifications().initialize(
    // set the icon to null if you want to use the default app icon
      null ,
      [
        NotificationChannel(
            channelGroupKey: 'basic_channel_group',
            channelKey: 'basic_channel',
            channelName: 'Basic notifications',
            channelDescription: 'Notification channel for basic tests',
            defaultColor: MyColors.primaryColor,
            ledColor: Colors.white)
      ],
      // Channel groups are only visual and are not required
      channelGroups: [
        NotificationChannelGroup(
            channelGroupKey: 'basic_channel_group',
            channelGroupName: 'Basic group')
      ],
      debug: true
  );

  runApp(const MyApp());
}





class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
   Widget startPage  = LoginScreen();
   String local_lang  = 'en' ;
   var token ;
  void initState() {
    super.initState();
      getAppSettings();
      getRandomIntro();
      getDeviceToken();
      intialize();



  }
  getRandomIntro() async{
    Intro? res = await IntroServices().getRandomIntro();
    IntroServices().introSetter(res!);
  }
  getAppSettings() async{
    AppSettings? res = await AppSettingsServices().getAppSettings();
    AppSettingsServices().appSettingSetter(res!);
    IntroServices().setFirstShow(1);

  }
  getDeviceToken() async {
    var res = await FirebaseMessaging.instance.getToken();
    setState(() {
      token = res ;
    });
    checkDeviceBan();
  }

   updateMyToken(user_id) async{

     AppUser? res = await AppUserServices().updateUserToken(user_id, token);
     AppUserServices().userSetter(res!);
   }

  void intialize() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int? id = await prefs.getInt('userId');

    String? l = await prefs.getString('local_lang') ;

    if(l == null) l = 'en' ;
    if(l == '') l = 'en' ;
    print('lang cashed');
    print(l);
    setState(() {

      local_lang = l! ;
    });
    Get.updateLocale(Locale(local_lang));
    print(local_lang);
    if(id == null){
      FlutterNativeSplash.remove();
      setState(() {
        startPage = LoginScreen();
      });
    } else {
      if(id == 0){
        FlutterNativeSplash.remove();
        setState(() {
          startPage = LoginScreen();
        });
      } else {
        AppUser? user = await AppUserServices().getUser(id);
        if(user != null){
          if(user.enable == 1 ){
            setState(() {
              AppUserServices().userSetter(user);
              updateMyToken(user.id);
              startPage = TabsScreen();
            });
            FlutterNativeSplash.remove();
          } else {

            setState(() {
              startPage = BlockedScreen(block_type: user.banDevice );
            });
            FlutterNativeSplash.remove();

          }


        } else {
          setState(() {
            startPage = LoginScreen();
          });
          FlutterNativeSplash.remove();
        }

      }
    }





  }

  // FlutterNativeSplash.remove();
  
  @override
  Widget build(BuildContext context) {
    return  GetMaterialApp(
      theme: ThemeData(
        fontFamily: 'arabFont',
          primarySwatch: Colors.orange ,
          primaryColor:  MyColors.primaryColor ,
          bottomSheetTheme: BottomSheetThemeData(
            backgroundColor: Colors.black.withOpacity(0)
          )

      ),
      debugShowCheckedModeBanner: false,
      home: startPage,
      navigatorKey: ChatRoomService.navigatorKey,
      translations:  Translation(),
      locale:Locale(local_lang),
      builder: (context, child) {
        return XOverlayPopScope(
          child: Stack(
            children: [
              child!,
              const RoomOverlayWidget(),
            ],
          ),
        );
      },
    );
  }

   Future<String?> getId() async {
     var deviceInfo = DeviceInfoPlugin();
     if (Platform.isIOS) { // import 'dart:io'
       var iosDeviceInfo = await deviceInfo.iosInfo;
       return iosDeviceInfo.identifierForVendor; // unique ID on iOS
     } else if(Platform.isAndroid) {
       var androidDeviceInfo = await deviceInfo.androidInfo;

       return androidDeviceInfo.id; // unique ID on Android

     }
   }

  checkDeviceBan() async{
    //String deviceId = await getId() ?? "";
    print('token');
    print(token);
    bool res = await AppUserServices().checkDeviceBan(token);
    print(res);
    if(res){
      intialize();

    } else {
      setState(() {
        startPage = BlockedScreen(block_type: 1 );
      });
      FlutterNativeSplash.remove();
    }
    
  }
}


