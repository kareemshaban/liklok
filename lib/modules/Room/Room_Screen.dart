import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:LikLok/helpers/GiftHelper.dart';
import 'package:LikLok/models/Badge.dart';
import 'package:LikLok/models/Settings.dart';
import 'package:LikLok/shared/network/remote/AppSettingsServices.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:circular_countdown_timer/countdown_text_format.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:LikLok/helpers/ChatRoomMessagesHelper.dart';
import 'package:LikLok/helpers/DesigGiftHelper.dart';
import 'package:LikLok/helpers/EnterRoomHelper.dart';
import 'package:LikLok/helpers/ExitRoomHelper.dart';
import 'package:LikLok/helpers/MicHelper.dart';
import 'package:LikLok/helpers/RoomBasicDataHelper.dart';
import 'package:LikLok/layout/tabs_screen.dart';
import 'package:LikLok/models/AppUser.dart';
import 'package:LikLok/models/Category.dart' as Cat;
import 'package:LikLok/models/Chat.dart';
import 'package:LikLok/models/ChatRoom.dart';
import 'package:LikLok/models/ChatRoomMessage.dart';
import 'package:LikLok/models/Design.dart';
import 'package:LikLok/models/Emossion.dart';
import 'package:LikLok/models/Gift.dart';
import 'package:LikLok/models/LuckyCase.dart';
import 'package:LikLok/models/Rollet.dart';
import 'package:LikLok/models/RoomMember.dart';
import 'package:LikLok/models/RoomTheme.dart';
import 'package:LikLok/modules/Chats/Chats_Screen.dart';
import 'package:LikLok/modules/Loading/loadig_screen.dart';
import 'package:LikLok/modules/Room/Components/emoj_modal.dart';
import 'package:LikLok/modules/Room/Components/gift_modal.dart';
import 'package:LikLok/modules/Room/Components/menu_modal.dart';
import 'package:LikLok/modules/Room/Components/rollet_create_modal.dart';
import 'package:LikLok/modules/Room/Components/rollet_modal.dart';
import 'package:LikLok/modules/Room/Components/room_close_modal.dart';
import 'package:LikLok/modules/Room/Components/room_cup_modal.dart';
import 'package:LikLok/modules/Room/Components/room_info_modal.dart';
import 'package:LikLok/modules/Room/Components/room_members_modal.dart';
import 'package:LikLok/modules/SmallProfile/Small_Profile_Screen.dart';
import 'package:LikLok/shared/components/Constants.dart';
import 'package:LikLok/shared/network/remote/AppUserServices.dart';
import 'package:LikLok/shared/network/remote/ChatRoomService.dart';
import 'package:LikLok/shared/styles/colors.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:svgaplayer_flutter/player.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:simple_ripple_animation/simple_ripple_animation.dart';
import 'package:flutter/services.dart';


//const appId = "f26e793582cb48359a4cb36dba3a9d3f";
//const appId = "36fdda9bf58b40caa90d34b1893909f0";



class RoomScreen extends StatefulWidget {
  const RoomScreen({super.key});

  @override
  State<RoomScreen> createState() => _RoomScreenState();
}

class _RoomScreenState extends State<RoomScreen> with TickerProviderStateMixin{
  String appId = "" ;
  AppUser? user;
  List<Design> designs = [];
  String frame = "";
  ChatRoom? room;
  String room_img = "";
  List<Emossion> emossions = [];
  List<RoomTheme> themes = [];
  List<Gift> gifts = [];
  List<Cat.Category> categories = [];
  TabController? _tabController ;
  List<Widget> giftTabs = [] ;
  List<Widget> giftViews = [] ;
  String sendGiftReceiverType = "";
  int? selectedGift  ;
  String userRole = 'USER';
  List<ChatRoomMessage> messages = [] ;
  late RtcEngine _engine;
  bool showMsgInput = false ;
  final TextEditingController _messageController = TextEditingController();
  FocusNode focusNode = FocusNode();
  String token = "";
  String channel = "";
  bool emojiShowing = false;
  String entery = "";
  String giftImg = "";
  List<String> micEmojs = ["" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , ""  ];
  bool _localUserJoined = false;
  bool _localUserMute = true ;
  int bannerState = 0 ;
  bool showBanner = false ;
  bool showBannerSmallWin = false ;
  bool showBannerBigWin = false ;
  bool showCounterButton = false ;
  int bannerRoom = 0 ;
  bool showLuckyBanner = false ;
  String luckySenderimg = "" ;
  String bannerMsg = "" ;
  String bannerMsg2 = "" ;
  String giftImgSmall = "" ;
  ScrollController _scrollController = new ScrollController();
  List<int> speakers = [] ;
  String enteryBanner = "";
  String enteryMessage = "";
  bool showEnteryBanner = false ;
  bool showRainLuckyCase = false ;
  bool showLuckyCase = false ;
  int lucky_id = 0 ;
  bool canOpenLuckyCase = true ;
  final player = AudioPlayer();
  late Timer timer ;
  var passwordController = TextEditingController();
  String local = '' ;
  bool isNewCommer =  false ;
  final CountDownController _countDownController = CountDownController();
  final int _duration = 5;
  int luckyGiftId = 0 ;
  int luckyGiftCount = 0 ;
  int luckyGiftReciver = 0 ;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  if(mounted){
    setState(() {
       appId = AppSettingsServices().appSettingGetter()!.agora_id ;
    });

    setState(() {
      isNewCommer = false ;
      sendGiftReceiverType = "select_one_ore_more";
      user = AppUserServices().userGetter();
      room = ChatRoomService().roomGetter();
      setState(() {
        channel = room!.tag ;
      });
      if(user!.id == room!.userId){
        setState(() {
          userRole = 'OWNER';
        });
      } else if(room!.admins!.where((element) => element.user_id == user!.id).length > 0){
        setState(() {
          userRole = 'ADMIN';
        });
      } else {
        setState(() {
          userRole = 'USER';
        });
      }

    });
  }

    checkRoomBlock();
    getRoomImage();
    EnterRoomHelper(user!.id , room!.id);

    geAdminDesigns();

    //listeners//
    RolletCreatListner();
    enterRoomListener();
    exitRoomListener();
    micListener();
    micUsageListener();
    themesListener();
    micEmossionListener();
    giftListener();
    micCounterListener();
    micRemoveListener();
    blockRoomListener();
    luckyCaseListener();
    RoomAdminsListener();
    messagesListener();


    if(ChatRoomService.savedRoom == null){
      setState(() {
        isNewCommer = true;
      });
      initAgora();


    } else {
      ChatRoomService().savedRoomSetter(null);
      String role = ChatRoomService.userRole ;
      if(mounted){
        setState(() {
          _localUserJoined = true;
          isNewCommer = false;
          _engine = ChatRoomService.engine! ;
          if(role ==  'clientRoleAudience'){
            _localUserMute = true ;
          } else {
            _localUserMute = false ;
          }

        });
      }

    }


    getRoomBasicData();
    focusNode.addListener(() {
      if(!focusNode.hasFocus){
        FocusScope.of(context).unfocus();
        if(mounted){
          setState(() {
            emojiShowing = false ;
          });
        }

        toggleMessageInput();
      }
    });


    luckyCaseForNewComers();
  }

  getLocal() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? l = await prefs.getString('local_lang') ;
    if(l == null) l = 'en' ;
    if(l == '') l = 'en' ;
    if(mounted) {
      setState(() {
        local = l!;
      });
    }

  }
  checkRoomBlock(){
    if(room!.blockers!.where((element) => element.user_id == user!.id).length > 0 ){
    //  checkBlockDate(room!.blockers!.where((element) => element.user_id == user!.id).)
      //blocked
      Fluttertoast.showToast(
          msg: 'room_blocked_msg'.tr,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black26,
          textColor: Colors.orange,
          fontSize: 16.0);
      exitRoom();
    } else {
      // not blocked
    }
  }



  getRoomImage(){
    String img = '';
    if(room!.img == room!.admin_img){
      if(room!.admin_img != ""){
        img = '${ASSETSBASEURL}AppUsers/${room?.img}' ;
      } else {
        img = '${ASSETSBASEURL}Defaults/room_default.png' ;
      }

    } else {
      if(room?.img != ""){
        img = '${ASSETSBASEURL}Rooms/${room?.img}' ;
      } else {
        img = '${ASSETSBASEURL}Defaults/room_default.png' ;
      }

    }
    if(mounted){
      setState(() {
        room_img =  img ;
      });
    }

  }



  RoomAdminsListener(){
    CollectionReference reference = FirebaseFirestore.instance.collection('roomAdmins');
    reference.snapshots().listen((querySnapshot) {
      if(querySnapshot.docChanges.length > 0) {
        DocumentChange change = querySnapshot.docChanges[0];
        if (change.newIndex > 0) {
          Map<String, dynamic>? data = change.doc.data() as Map<String,
              dynamic>;
          int room_id = data['room_id'];
          if (room_id == room!.id) {
            refreshRoom(0);
          }
        }
      }
    });
  }

  enterRoomListener(){
    CollectionReference reference = FirebaseFirestore.instance.collection('enterRoom');
    reference.snapshots().listen((querySnapshot) async{
      if(querySnapshot.docChanges.length > 0) {
      DocumentChange change =   querySnapshot.docChanges[0] ;


      if(change.newIndex > 0) {
        Map<String, dynamic>? data = change.doc.data() as Map<String, dynamic>;
        int room_id = data['room_id'];
        int user_id = data['user_id'];
        if (room_id == room!.id) {
          await refreshRoom(0);

          if (isNewCommer == true) {
            userJoinRoomWelcome(user_id);
          }
        }
      }
      }
    });
  }
  exitRoomListener(){
    CollectionReference reference = FirebaseFirestore.instance.collection('exitRoom');
    reference.snapshots().listen((querySnapshot) {
      if(querySnapshot.docChanges.length > 0) {
        DocumentChange change = querySnapshot.docChanges[0];
        if (change.newIndex > 0) {
          reference.doc(change.doc.id).delete();
          Map<String, dynamic>? data = change.doc.data() as Map<String,
              dynamic>;
          int room_id = data['room_id'];
          if (room_id == room!.id || room_id == 0) {
            refreshRoom(0);
          }
        }
      }
    });
  }
  micListener(){
    CollectionReference reference = FirebaseFirestore.instance.collection('mic-state');
    reference.snapshots().listen((querySnapshot) {
      if(querySnapshot.docChanges.length > 0) {
        DocumentChange change = querySnapshot.docChanges[0];
        if (change.newIndex > 0) {
          Map<String, dynamic>? data = change.doc.data() as Map<String,
              dynamic>;
          int room_id = data['room_id'];
          if (room_id == room!.id) {
            refreshRoom(0);
          }
        }
      }
    });
  }
  luckyCaseListener() {
    CollectionReference reference = FirebaseFirestore.instance.collection('luckyCase');
    reference.snapshots().listen((querySnapshot) async{
      if(querySnapshot.docChanges.length > 0) {
        DocumentChange change = querySnapshot.docChanges[0];
        print('luckyCaseListener');
        if (change.newIndex > 0) {
          Map<String, dynamic>? data = change.doc.data() as Map<String,
              dynamic>;
          int room_id = data['room_id'];
          int lucky = data['lucky_id'];
          String type = data['type'];
          String user_name = data['user_name'];
          String room_name = data['room_name'];
          String user_img = data['user_img'];
          dynamic available_untill = data['available_untill'];
          if (checkLuckyCaseShow(available_untill)) {
            LuckyCase? luckyCase = await ChatRoomService().getLuckyCase(lucky);
            if (luckyCase != null) {
              int duration = getLuckyCaseDuration(luckyCase, available_untill);

              if (duration > 0) {
                if (room!.id == room!.id) {
                  if (mounted) {
                    setState(() {
                      if (room_id == room!.id) {
                        showLuckyCase = true;
                        showRainLuckyCase = true;
                        lucky_id = lucky;
                      }
                    });
                  }

                  Future.delayed(Duration(seconds: duration)).then((value) =>
                      setState(() {
                        showLuckyCase = false;
                        lucky_id = 0;
                        canOpenLuckyCase = true;
                      })
                  );
                }

                if (type == "1") {
                  if (mounted) {
                    setState(() {
                      bannerRoom = room_id;
                      showLuckyBanner = true;
                      luckySenderimg = user_img;
                      lucky_id = lucky;
                      bannerMsg =
                      '${user_name} sent a Lucky Case inside  ${room_name}';
                    });
                  }
                }


                Future.delayed(Duration(seconds: 20)).then((value) {
                  if (type == "1") {
                    if (mounted) {
                      setState(() {
                        showLuckyBanner = false;
                        luckySenderimg = "";
                        bannerRoom = 0;
                        giftImgSmall = '';
                        bannerMsg = '';
                      });
                    }
                  }
                  if (mounted) {
                    setState(() {
                      showRainLuckyCase = false;
                    });
                  }
                }

                );
              } else {
                if (mounted) {
                  setState(() {
                    showLuckyCase = false;
                    showRainLuckyCase = false;
                  });
                }
              }
            }
          }
        }
      }
    });
  }

  luckyCaseForNewComers() async{
    LuckyCase? luckyCase = await ChatRoomService().getRoomLuckyCase(room!.id);
    if(luckyCase != null){
      DateTime available_untill =  DateTime.parse(luckyCase.created_date).add(Duration(minutes: 2));
       int duration = getRoomLuckyCaseDuration(luckyCase , available_untill);
      print('luckyCaseduration');
       print(duration);

      if(duration > 0){
        if(mounted) {
          setState(() {
            showLuckyCase = true;
            lucky_id = luckyCase.id;
          });
        }
        await Future.delayed(Duration(seconds: duration));
        if(mounted) {
          setState(() {
            showLuckyCase = false;
            lucky_id = 0;
            canOpenLuckyCase = true;
          });
        }

      } else {
        if(mounted) {
          setState(() {
            showLuckyCase = false;
          });
        }


      }
    }
  }
  micCounterListener(){
    CollectionReference reference = FirebaseFirestore.instance.collection('mic-counter');
    reference.snapshots().listen((querySnapshot) {
      if(querySnapshot.docChanges.length > 0) {
        DocumentChange change = querySnapshot.docChanges[0];
        if (change.newIndex > 0) {
          Map<String, dynamic>? data = change.doc.data() as Map<String,
              dynamic>;
          int room_id = data['room_id'];
          if (room_id == room!.id) {
            refreshRoom(0);
          }
        }
      }
    });
  }
  micUsageListener(){
    CollectionReference reference = FirebaseFirestore.instance.collection('mic-usage');
    reference.snapshots().listen((querySnapshot) {
      if(querySnapshot.docChanges.length > 0) {
        DocumentChange change = querySnapshot.docChanges[0];
        if (change.newIndex > 0) {
          Map<String, dynamic>? data = change.doc.data() as Map<String,
              dynamic>;
          int room_id = data['room_id'];
          if (room_id == room!.id) {
            refreshRoom(0);
          }
        }
      }
    });
  }
  micRemoveListener() {
    CollectionReference reference = FirebaseFirestore.instance.collection('mic-remove');
    reference.snapshots().listen((querySnapshot) async{
      if(querySnapshot.docChanges.length > 0) {
        DocumentChange change = querySnapshot.docChanges[0];
        if (change.newIndex > 0) {
          Map<String, dynamic>? data = change.doc.data() as Map<String,
              dynamic>;
          int room_id = data['room_id'];
          int user_id = data['user_id'];
          print(room_id);
          if (room_id == room!.id) {
            refreshRoom(0);
          }
          if (user_id == user!.id) {
            // if this is the user
            // show toast and stop publish
            try {
              await _engine.setClientRole(
                  role: ClientRoleType.clientRoleAudience);
              ChatRoomService.userRole = 'clientRoleAudience';
              if (mounted) {
                setState(() {
                  _localUserMute = true;
                });
              }
            } catch (err) {

            }
            Fluttertoast.showToast(
                msg: 'room_remove_mic'.tr,
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.black26,
                textColor: Colors.orange,
                fontSize: 16.0);
          }
        }
      }
    });
  }
  blockRoomListener(){
    CollectionReference reference = FirebaseFirestore.instance.collection('room-block');
    reference.snapshots().listen((querySnapshot) {
      if(querySnapshot.docChanges.length > 0) {
        DocumentChange change = querySnapshot.docChanges[0];
        if (change.newIndex > 0) {
          Map<String, dynamic>? data = change.doc.data() as Map<String,
              dynamic>;
          int room_id = data['room_id'];
          int user_id = data['user_id'];
          String block_type = data['block_type'];
          String kickout_period = "";
          if (block_type == "HOUR") {
            kickout_period = 'kick_out_hour'.tr;
          } else if (block_type == "DAY") {
            kickout_period = 'kick_out_day'.tr;
          } else {
            kickout_period = 'kick_out_forever'.tr;
          }
          if (room_id == room!.id) {
            if (user_id == user!.id) {
              Fluttertoast.showToast(
                  msg: 'kickout_msg'.tr + ' ' + kickout_period,
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.black26,
                  textColor: Colors.orange,
                  fontSize: 16.0);
              exitRoom();
            }
            refreshRoom(0);
          }
        }
      }
    });
  }

  exitRoom() async {
    MicHelper( user_id:  user!.id , room_id:  room!.id , mic: 0).leaveMic();
    ExitRoomHelper(user!.id , room!.id);
    await _engine.leaveChannel();
    await _engine.release();
    Navigator.pushAndRemoveUntil(
        context ,
        MaterialPageRoute(builder: (context) => const TabsScreen()) ,   (route) => false
    );
  }
  themesListener(){
    CollectionReference reference = FirebaseFirestore.instance.collection('themes');
    reference.snapshots().listen((querySnapshot) {
      if(querySnapshot.docChanges.length > 0) {
        DocumentChange change = querySnapshot.docChanges[0];
        if (change.newIndex > 0) {
          Map<String, dynamic>? data = change.doc.data() as Map<String,
              dynamic>;
          int room_id = data['room_id'];
          if (room_id == room!.id) {
            refreshRoom(0);
          }
        }
      }
    });
  }
  micEmossionListener() async {
    CollectionReference reference = FirebaseFirestore.instance.collection('emossions');
    reference.snapshots().listen((querySnapshot) async{
     if(querySnapshot.docChanges.length > 0) {
       DocumentChange change = querySnapshot.docChanges[0];
       if (change.newIndex > 0) {
         Map<String, dynamic>? data = change.doc.data() as Map<String, dynamic>;
         int room_id = data['room_id'];
         int mic = data['mic'];
         int user = data['user'];
         String emoj = data['emoj'];
         if (room_id == room!.id) {
           if (mounted) {
             setState(() {
               micEmojs[mic - 1] = emoj;
             });
           }

           await Future.delayed(Duration(seconds: 5));
           if (mounted) {
             setState(() {
               micEmojs[mic - 1] = "";
             });
           }
         }
       }
     }
      // });
    });
  }
  messagesListener() async{

    CollectionReference reference = FirebaseFirestore.instance.collection('RoomMessages');
    reference.snapshots().listen((querySnapshot) async{
      if(querySnapshot.docChanges.length > 0) {
        DocumentChange change = querySnapshot.docChanges[0];

        if (change.newIndex > 0) {
          Map<String, dynamic>? data = change.doc.data() as Map<String,
              dynamic>;
          int room_id = data['room_id'];
          int user_id = data['user_id'];
          String msg = data['message'];
          String type = data['type'];

          print('room_idroom_idroom_id');
          ChatRoom? res = await ChatRoomService().openRoomById(room!.id);
          if (mounted) {
            setState(() {
              room = res;
              ChatRoomService().roomSetter(room!);
            });
          }
          RoomMember member = room!.members!.where((element) =>
          element.user_id == user_id).toList()[0];
          AppUser? sender = await AppUserServices().getUser(user_id);
          String pubble = "";
          if (member.pubble != "") {
            pubble =
                ASSETSBASEURL + 'Designs/Motion/' + member.pubble.toString();
          }


          if (room_id == room!.id) {
            ChatRoomMessage message = ChatRoomMessage(message: msg.tr,
                user_name: sender!.name.toString(),
                user_share_level_img: sender.share_level_icon.toString(),
                user_img: sender.img.toString(),
                user_id: sender.id,
                type: type,
                vip: sender.vips!.length > 0 ? sender.vips![0].icon : "",
                pubble: pubble,
                badges: member.badges!);
            List<ChatRoomMessage> old = [...messages];
            old.add(message);
            if (mounted) {
              setState(() {
                messages = old;
              });
            }

            await Future.delayed(Duration(seconds: 2));
            if(_scrollController.hasClients){
              _scrollController.animateTo(
                  _scrollController.position.maxScrollExtent,
                  duration: const Duration(milliseconds: 1),
                  curve: Curves.fastOutSlowIn);
            }

          }
        }
      }

    });
  }
  giftListener() async{
    //gifts
    CollectionReference reference = FirebaseFirestore.instance.collection('gifts');
    reference.snapshots().listen((querySnapshot) async{
      if(querySnapshot.docChanges.length > 0){
      DocumentChange change =   querySnapshot.docChanges[0] ;

      if(change.newIndex > 0) {
        Map<String, dynamic>? data = change.doc.data() as Map<String, dynamic>;
        int room_id = data['room_id'];
        int sender_id = data['sender_id'];
        String sender_name = data['sender_name'];
        String sender_img = data['sender_img'];
        int receiver_id = data['receiver_id'];
        String receiver_name = data['receiver_name'];
        String receiver_img = data['receiver_img'];
        String gift_name = data['gift_name'];
        String gift_img = data['gift_img'];
        int count = data['count'];
        String gift_audio = data['gift_audio'];
        String sender_share_level = data['sender_share_level'];
        String small_gift = data['giftImgSmall'];
        dynamic available_untill = data['available_untill'];
        int gift_category_id = data['gift_category_id'];
        int reward = data['reward'];
        int gift_id = data['gift_id'];

        print('gift_audio');
        print(gift_audio);


        if (checkGiftShow(available_untill)) {
          AppUser? sender = await AppUserServices().getUser(sender_id);


          if (room_id == room!.id) {
            refreshRoom(0);
          }
          if (gift_img.toLowerCase().endsWith('.svga')) {
            if(giftImg == ''){
              svgaImagesListener(
                  room_id,
                  gift_img,
                  gift_name,
                  receiver_name,
                  sender_name,
                  sender_share_level,
                  sender_img,
                  sender_id,
                  gift_audio,
                  small_gift,
                  sender,
                  gift_category_id,
                  reward,
                  gift_id,
                  receiver_id,
                  count);
            } else {
              await Future.delayed(Duration(seconds: gift_category_id != 5 ? 5 : 8)).then((value) => {
                          svgaImagesListener(
                          room_id,
                          gift_img,
                          gift_name,
                          receiver_name,
                          sender_name,
                          sender_share_level,
                          sender_img,
                          sender_id,
                          gift_audio,
                          small_gift,
                          sender,
                          gift_category_id,
                          reward,
                          gift_id,
                          receiver_id,
                          count)

              });

            }

          }
        }
      }
      }

    });
  }
  svgaImagesListener(room_id , gift_img , gift_name , receiver_name , sender_name , sender_share_level , sender_img , sender_id , gift_audio , small_gift , AppUser? sender , gift_category_id , reward , gift_id , receiver_id , count) async{
    if(room_id == room!.id){
      RoomMember member = room!.members!.where((element) =>  element.user_id == sender_id).toList()[0] ;
      //show gift
      if(mounted) {
        setState(()  {
          giftImg = '${ASSETSBASEURL}Designs/Motion/${gift_img}';
          if(gift_category_id == 5){
            showCounterButton = true ;
            luckyGiftId = gift_id ;
            luckyGiftCount = count ;
            luckyGiftReciver = receiver_id ;
            if(!_countDownController.isStarted)
            _countDownController.start();
          } else {
            showCounterButton = false ;
          }

        });
      }

     await Future.delayed(Duration(seconds: 1));
      if(gift_audio != ""){
        final duration = await player.setUrl(gift_audio);
        player.play();
      }
      if(gift_category_id != 5){
        Future.delayed(Duration(seconds: 8)).then((value) => {
          if(mounted){
            setState(() {
              giftImg = '';
            })
          }
        });
        await player.stop();
      }

      // show on tetx
      String pubble = "" ;
      if(member.pubble != ""){
        pubble = ASSETSBASEURL + 'Designs/Motion/' + member.pubble.toString() ;
      }


      ChatRoomMessage message = ChatRoomMessage(message:  'sent a ${gift_name} to ${receiver_name}' , user_name: sender_name.toString(),
          user_share_level_img: sender_share_level.toString(), user_img: sender_img.toString(), user_id: sender_id , type:'GIFT' , vip:  user!.vips!.length > 0 ? user!.vips![0].icon : ""  , pubble: pubble , badges: member.badges!);
      List<ChatRoomMessage>  old = [...messages];
      old.add(message);
      if(mounted){
        setState(() {
          messages = old ;
        });
      }

    }



   if(mounted){
     setState(() {
       if(gift_category_id != 5){
         showBanner = true ;
         bannerRoom = room_id ;
         bannerMsg = '${sender_name} sent a ${gift_name} to ${receiver_name}';
       } else {
         if(reward == 1 || reward == 2 || reward == 5 || reward == 10 || reward == 20  ){
           showBannerSmallWin = true ;
           bannerRoom = room_id ;
           bannerMsg = "Get X" + reward.toString() ;

         } else if(reward == 30 || reward == 40 || reward == 50 || reward == 100) {
           showBannerBigWin = true ;
           bannerRoom = room_id ;
           bannerMsg = '${sender_name} Get X${reward} from Lucky Gift ${gift_name}'; "Get X" + reward ;
         }
       }

       giftImgSmall = small_gift ;

     });
   }
    await Future.delayed(Duration(seconds: 5)).then((value) => {
      if(mounted){
        setState(() {
          showBannerSmallWin = false ;

        })
      }



    } );


    //show banner in all rooms
    await Future.delayed(Duration(seconds: 5)).then((value) => {
      if(mounted){
        setState(() {
          showBanner = false ;
          bannerState = 0 ;
          bannerRoom = 0 ;
          bannerMsg = "";
          giftImgSmall = "" ;
          showBannerBigWin = false ;
        })
      }

    } );
  }
  mp4GiftsListener(room_id , gift_img , gift_name , receiver_name , sender_name , sender_share_level , sender_img , sender_id) async{
    if(room_id == room!.id){
      //show gift



      // show on tetx
      ChatRoomMessage message = ChatRoomMessage(message:  'sent a ${gift_name} to ${receiver_name}' , user_name: sender_name.toString(),
          user_share_level_img: sender_share_level.toString(), user_img: sender_img.toString(), user_id: sender_id , type:'GIFT' );
      List<ChatRoomMessage>  old = [...messages];
      old.add(message);
      if(mounted){
        setState(() {
          messages = old ;
        });
      }

    }
    //show banner in all rooms
    if(mounted) {
      setState(() {
        showBanner = true;
        giftImgSmall = gift_img;
        bannerMsg = '${sender_name} sent a ${gift_name} to ${receiver_name}';
      });
    }
    await Future.delayed(Duration(seconds: 10)).then((value) => {
    if(mounted){
      setState(() {
        showBanner = false;
        bannerState = 0;
        bannerMsg = "";
        giftImgSmall = "";
      })
    }
    } );
  }
  smallGiftsListener(room_id , gift_img , gift_name , receiver_name , sender_name , sender_share_level , sender_img , sender_id) async{
    if(room_id == room!.id){
      //show gift
      if(mounted) {
        setState(() {
          giftImg = gift_img;
        });
      }
      await Future.delayed(Duration(seconds: 5)).then((value) => {
      if(mounted){
        setState(() {
          giftImg = '';
        })
      }
      });
      // show on tetx
      ChatRoomMessage message = ChatRoomMessage(message:  'sent a ${gift_name} to ${receiver_name}' , user_name: sender_name.toString(),
          user_share_level_img: sender_share_level.toString(), user_img: sender_img.toString(), user_id: sender_id , type:'GIFT' );
      List<ChatRoomMessage>  old = [...messages];
      old.add(message);
      if(mounted) {
        setState(() {
          messages = old;
        });
      }
    }
    //show banner in all rooms

  }

  RolletCreatListner() async{
    CollectionReference reference = FirebaseFirestore.instance.collection('roulette');
    reference.snapshots().listen((querySnapshot) {
      if(querySnapshot.docChanges.length > 0){
        DocumentChange change =    querySnapshot.docChanges[0] ;
        if(change.newIndex > 0){
          Map<String , dynamic>? data = change.doc.data() as Map<String,dynamic>;
          int room_id = data['room_id'] ;
          int rollet_id = data['rollet_id'] ;
          if(room_id == room!.id){
            showRolletWheal(rollet_id);

          }
        }
      }

    });
  }

  showRolletWheal(rollet_id) async {
    Rollet? rollet = await ChatRoomService().getRollet(rollet_id);
    showModalBottomSheet(
        isScrollControlled: true ,
        context: context,
        builder: (ctx) => roomRolletModal(rollet!));
  }


  refreshRoom(joiner_id) async{
    ChatRoom? res = await ChatRoomService().openRoomById(room!.id);

    if(mounted){
      setState(() {
        room = res ;
        ChatRoomService().roomSetter(room!);

      });
    }

    getRoomImage();
  }
  userJoinRoomWelcome(joiner_id) async{

    RoomMember joiner = room!.members!.where((element) =>  element.user_id == joiner_id).toList()[0] ;
    if(joiner.entery !=""){
      if(mounted) {
        setState(() {
          entery =
              ASSETSBASEURL + 'Designs/Motion/' + joiner.entery! + '?raw=true';
        });
      }
      if(joiner.banner != ""){
        if(mounted) {
          setState(() {
            enteryBanner = ASSETSBASEURL + 'Designs/Motion/' + joiner.banner! +
                '?raw=true';
            enteryMessage =
            '${joiner.mic_user_name}  enter the room driving a ${joiner
                .entery_name} ';
          });
        }
      }
      if(joiner.entery_audio != "" && isNewCommer ){
        await player.setUrl(ASSETSBASEURL + 'Designs/Audio/' + joiner.entery_audio! );
      }

      await Future.delayed(Duration(seconds: 1)).then((value)  {

      if(joiner.entery_audio != "" && isNewCommer && entery != ""){
        showEnteryBanner = true ;
        player.play();
      }
      });



      await Future.delayed(Duration(seconds: 9)).then((value) => {
      if(mounted){
        setState(() {
          entery = '';
          enteryBanner = '';
          enteryMessage = '';
          showEnteryBanner = false;
        })
      }
      });
      await player.stop();
    } else {
      if(joiner.banner != ""){
        if(mounted) {
          setState(() {
            enteryBanner = ASSETSBASEURL + 'Designs/Motion/' + joiner.banner! +
                '?raw=true';
            enteryMessage = '${joiner.mic_user_name}  enter the room';
          });
        }

        await Future.delayed(Duration(seconds: 9)).then((value) => {
        if(mounted){
          setState(() {
            enteryBanner = '';
            enteryMessage = '';
            showEnteryBanner = false;
          })
        }
        });
      }

    }




  }

  geAdminDesigns() async {
    DesignGiftHelper _helper =
    await AppUserServices().getMyDesigns(room!.userId);
    if(mounted) {
      setState(() {
        designs = _helper.designs!;
      });
    }
    if (designs
        .where((element) =>
    (element.category_id == 4 && element.isDefault == 1))
        .toList()
        .length >
        0) {
      String icon = designs
          .where(
              (element) => (element.category_id == 4 && element.isDefault == 1))
          .toList()[0]
          .motion_icon;
      if(mounted) {
        setState(() {
          frame = ASSETSBASEURL + 'Designs/Motion/' + icon + '?raw=true';
          print(frame);
        });
      }
    }
  }

  getRoomBasicData() async {
    RoomBasicDataHelper? helper = await ChatRoomService().getRoomBasicData();
    ChatRoomService().roomBasicDataHelperSetter(helper!);
    if(mounted) {
      setState(() {
        emossions = helper!.emossions;
        themes = helper.themes;
        gifts = helper.gifts;
        categories = helper.categories;
        _tabController =
        new TabController(vsync: this, length: categories.length);
      });
    }
  }

  Future<void> initAgora() async {
    //create the engine
    print('initAgora');
    print(AppSettingsServices().appSettingGetter()!.agora_id);
    _engine = createAgoraRtcEngine();
    await _engine.initialize( RtcEngineContext(
      appId: appId,
      channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
    ));
    print('_engine.initialize end');
    //audio indicator
    await _engine.enableAudioVolumeIndication(interval: 1000, smooth: 5, reportVad: false);



    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed)  async{


          if(mounted) {
            setState(() {
              _localUserJoined = true;
            });
            print('_localUserJoined');
            print(_localUserJoined);
          }

            ChatRoomMessage message = ChatRoomMessage(message: 'room_msg'.tr, user_name: 'APP', user_share_level_img: '', user_img: '', user_id: 0 , type: "TEXT");
            List<ChatRoomMessage>  old = [...messages];
            old.add(message);
            if(room!.hello_message != ""){
              message = ChatRoomMessage(message: room!.hello_message , user_name: 'ROOM', user_share_level_img: '', user_img: '', user_id: 0 ,type: "TEXT");
              old.add(message);
            }
            if(mounted) {
              setState(() {
                messages = old;
              });
            }
// remove await from refreshRoom
             ChatRoomMessagesHelper(room_id: room!.id , user_id: user!.id , message: 'user_enter_message' , type: 'TEXT').handleSendRoomMessage();

             // remove await from refreshRoom
            refreshRoom(connection.localUid);

        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          debugPrint("remote user $remoteUid joined");




        },
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) async {
          debugPrint("remote user $remoteUid left channel");
          try{
            await ExitRoomHelper(remoteUid , room!.id);
            refreshRoom(0);

          }catch(err){

          }
          if(mounted) {
            setState(() {
              // _remoteUid = null;

            });
          }
        },
        onTokenPrivilegeWillExpire: (RtcConnection connection, String token) {
          debugPrint(
              '[onTokenPrivilegeWillExpire] connection: ${connection.toJson()}, token: $token');
        },

        onAudioVolumeIndication:(connection, _speakers, speakerNumber, totalVolume){
          List<int> sp = [] ;
          if(mounted) {
            setState(() {
              speakers = sp;
            });
          }
          _speakers.forEach((element) { sp.add(element.uid!);});
          if(mounted) {
            setState(() {
              speakers = sp;
            });
          }
        },
        onAudioMixingFinished: (){
          print('onAudioMixingFinished' );
        },
        onAudioMixingStateChanged: ( AudioMixingStateType state,
            AudioMixingReasonType reason){
          print( 'audioMixingStateChanged state:${state.toString()}, reason: ${reason.toString()}}');
        },
        onAudioMixingPositionChanged: (pos){
          // print('onAudioMixingPositionChanged' );

        },


      ),
    );


    // await _engine.enableVideo();
    // await _engine.startPreview();

    await _engine.joinChannel(
      token: token,
      channelId: channel,
      uid: int.parse(user!.tag) ,

      options: const ChannelMediaOptions( clientRoleType: ClientRoleType.clientRoleAudience),
    );

    ChatRoomService.engine = _engine ;
  }
  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
    _dispose();
    try{
      player.stop();
    }catch(err){

    }

  }

  Future<void> _dispose() async {
    if(ChatRoomService.savedRoom == null){
      MicHelper( user_id:  user!.id , room_id:  room!.id , mic: 0).leaveMic();
      ExitRoomHelper(user!.id , room!.id);
      await _engine.leaveChannel();
      await _engine.release();
    }

  }

  toggleMessageInput(){
    if(mounted) {
      setState(() {
        showMsgInput = !showMsgInput;
      });
    }


  }

  sendMessage() async{
    if(_messageController.text.isNotEmpty){
      await ChatRoomMessagesHelper(room_id: room!.id , user_id: user!.id , message: _messageController.text , type: 'TEXT').handleSendRoomMessage();
      _messageController.clear();
      toggleMessageInput();
      if(!showMsgInput){
        if(mounted) {
          setState(() {
            emojiShowing = false;
          });
        }

      }
      await Future.delayed(Duration(seconds: 2));
      _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 1),
          curve: Curves.fastOutSlowIn);
    }

  }

  Future<void> _refresh()async{
    await refreshRoom(0) ;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: MyColors.primaryColor, //or set color with: Color(0xFF0000FF)
    ));
    return WillPopScope(
      onWillPop: () async {
        showModalBottomSheet(
            isScrollControlled: true ,
            context: context,
            builder: (ctx) => roomCloseModal());
        return false;
      },
      child: Scaffold(
        body: DefaultTextStyle(
          style: TextStyle(decoration: TextDecoration.none),
          child: Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: CachedNetworkImageProvider(ASSETSBASEURL + 'Themes/' + room!.room_bg!),
                    fit: BoxFit.cover)),
            padding: EdgeInsetsDirectional.only(top: 5.0),
            child: SafeArea(
              child: Stack(
                alignment: AlignmentDirectional.bottomEnd,
                children: [
                  Stack(
                    alignment: Alignment.topCenter,
                    children: [

                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Column(
                                children: [
                                  Expanded(
                                    flex: 57,
                                    child: RefreshIndicator(
                                      onRefresh: _refresh,
                                      color: MyColors.primaryColor,
                                      child: SingleChildScrollView(
                                        physics: AlwaysScrollableScrollPhysics(),
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                GestureDetector(
                                                  onTap: (){
                                                    showModalBottomSheet(
                                                        context: context,
                                                        builder: (ctx) => RoomInfoBottomSheet());
                                                  },
                                                  child: Container(
                                                    padding: EdgeInsets.symmetric(
                                                        horizontal: 10.0, vertical: 5.0),
                                                    decoration: BoxDecoration(
                                                      color: Colors.black26,
                                                      borderRadius: BorderRadius.circular(10.0),
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                            width: 40.0,
                                                            height: 40.0,
                                                            child: SizedBox(),
                                                            clipBehavior: Clip.antiAliasWithSaveLayer,
                                                            decoration: BoxDecoration(
                                                                color: Colors.red,
                                                                borderRadius:
                                                                BorderRadius.circular(10.0),
                                                                image: room_img == ""
                                                                    ? DecorationImage(
                                                                    image: AssetImage(
                                                                        'assets/images/user.png'),
                                                                    fit: BoxFit.cover)
                                                                    : DecorationImage(
                                                                    image: CachedNetworkImageProvider(room_img),
                                                                    fit: BoxFit.cover))),
                                                        SizedBox(
                                                          width: 10.0,
                                                        ),
                                                        Column(
                                                          children: [
                                                            Text(
                                                              room!.name,
                                                              style: TextStyle(
                                                                  color: Colors.white, fontSize: 14.0),
                                                            ),
                                                            SizedBox(
                                                              height: 5.0,
                                                            ),
                                                            Text(
                                                              'ID:' + room!.tag,
                                                              style: TextStyle(
                                                                  color: MyColors.unSelectedColor,
                                                                  fontSize: 11.0),
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                    children: [
                                                      GestureDetector(
                                                        onTap:(){
                                                          showModalBottomSheet(
                                                              isScrollControlled: true ,
                                                              context: context,
                                                              builder: (ctx) => RoomCup());
                                                        },

                                                        child: Container(
                                                          padding: EdgeInsets.all(5.0),
                                                          decoration: BoxDecoration(
                                                              color: Colors.black26,
                                                              borderRadius:
                                                              BorderRadius.circular(10.0)),
                                                          child: Row(
                                                            children: [
                                                              Image(
                                                                image: AssetImage(
                                                                    'assets/images/chatroom_rank_ic.png'),
                                                                height: 18.0,
                                                                width: 18.0,
                                                              ),
                                                              SizedBox(
                                                                width: 5.0,
                                                              ),
                                                              Text(
                                                                double.parse(room!.roomCup.toString()).floor().toString()  ,
                                                                style: TextStyle(
                                                                    color: Colors.white,
                                                                    fontSize: 13.0),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 7.0,
                                                      ),
                                                      GestureDetector(
                                                          child: Container(
                                                              margin: EdgeInsets.symmetric(
                                                                  horizontal: 10.0),
                                                              child: Icon(
                                                                FontAwesomeIcons.shareFromSquare,
                                                                color: Colors.white,
                                                                size: 20.0,
                                                              ))),
                                                      GestureDetector(
                                                          onTap: (){
                                                            showModalBottomSheet(
                                                                isScrollControlled: true ,
                                                                context: context,
                                                                builder: (ctx) => roomCloseModal());
                                                          },
                                                          child: Container(
                                                            margin:
                                                            EdgeInsets.symmetric(horizontal: 10.0),
                                                            child: Icon(
                                                              FontAwesomeIcons.powerOff,
                                                              color: Colors.white,
                                                              size: 20.0,
                                                            ),
                                                          )),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                Row(
                                                  children: room!.members!.where((element) => element.user_id == room!.userId).map((e) => roomMemberItmeBuilder(e)).toList(),
                                                ),


                                                GestureDetector(
                                                  onTap: (){
                                                    showModalBottomSheet(
                                                        isScrollControlled: true ,
                                                        context: context,
                                                        builder: (ctx) => roomMembersModal());
                                                  },
                                                  child: Container(
                                                    width: 60.0,
                                                    padding: EdgeInsets.all(5.0),
                                                    decoration: BoxDecoration(
                                                        color: Colors.black26,
                                                        borderRadius: BorderRadius.circular(10.0)),
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                          Icons.people_alt,
                                                          color: MyColors.primaryColor,
                                                          size: 20.0,
                                                        ),
                                                        SizedBox(
                                                          width: 5.0,
                                                        ),
                                                        Text(
                                                          room!.members!.length.toString(),
                                                          style: TextStyle(
                                                              color: MyColors.primaryColor,
                                                              fontSize: 13.0),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5.0,
                                            ),
                                            GridView.count(
                                              shrinkWrap: true,
                                              crossAxisCount: 4,
                                              children:
                                              room!.mics!.map((mic) => micListItem(mic)).toList(),
                                              mainAxisSpacing: 0.0,
                                            ),


                                          ],
                                        ),
                                      ),
                                    ),
                                  ),

                                  Expanded(
                                    flex: 43,
                                    child: Row(
                                      children: [
                                        Container(
                                            padding: EdgeInsetsDirectional.only(start: 10.0),
                                            width: MediaQuery.sizeOf(context).width * .8 ,


                                            child: ListView.separated(   itemBuilder:(context, index) => roomMessageBuilder(index), separatorBuilder: (context, index) => roomMessageSeperator(), itemCount: messages.length ,  controller: _scrollController,) ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 10.0 , vertical: 10.0),
                                    child: !showMsgInput ? Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Column(
                                          children: [
                                            Row(
                                              children: [
                                                GestureDetector(
                                                  onTap: (){
                                                    toggleMessageInput();
                                                  },
                                                  child: Image(
                                                    image: AssetImage('assets/images/messages.png'),
                                                    width: 40.0,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 5.0,
                                                ),
                                                GestureDetector(
                                                  onTap: (){
                                                    showModalBottomSheet(

                                                        context: context,
                                                        builder: (ctx) => ChatBottomSheet());
                                                  },
                                                  child: Image(
                                                    image: AssetImage('assets/images/chats.png'),
                                                    width: 40.0,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 5.0,
                                                ),
                                                GestureDetector(
                                                  onTap: (){
                                                    showModalBottomSheet(

                                                        context: context,
                                                        builder: (ctx) => MenuBottomSheet());
                                                  },
                                                  child: Image(
                                                    image: AssetImage('assets/images/menu.png'),
                                                    width: 40.0,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 5.0,
                                                ),
                                                GestureDetector(
                                                  onTap: () async{
                                                    if(room!.mics!.where((element) => element.user_id == user!.id).toList().length > 0){
                                                      if(_localUserMute){
                                                        await _engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
                                                        ChatRoomService.userRole = 'clientRoleBroadcaster';
                                                        if(mounted) {
                                                          setState(() {
                                                            _localUserMute =
                                                            false;
                                                          });
                                                        }
                                                      } else {
                                                        await _engine.setClientRole(role: ClientRoleType.clientRoleAudience);
                                                        ChatRoomService.userRole = 'clientRoleAudience';
                                                        if(mounted) {
                                                          setState(() {
                                                            _localUserMute =
                                                            true;
                                                          });
                                                        }
                                                      }
                                                    } else {
                                                      Fluttertoast.showToast(
                                                          msg: 'You are not using any mic !',
                                                          toastLength: Toast.LENGTH_SHORT,
                                                          gravity: ToastGravity.CENTER,
                                                          timeInSecForIosWeb: 1,
                                                          backgroundColor: Colors.black26,
                                                          textColor: Colors.orange,
                                                          fontSize: 16.0);
                                                    }
                                                  },
                                                  child: Image(
                                                    image: _localUserMute ? AssetImage('assets/images/mic_off.png') :  AssetImage('assets/images/mic_on.png'),
                                                    width: 40.0,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 5.0,
                                                ),
                                                GestureDetector(
                                                    onTap: (){
                                                      showModalBottomSheet(

                                                          context: context,
                                                          builder: (ctx) => EmojBottomSheet());
                                                    },
                                                    child: Image(
                                                      image: AssetImage('assets/images/emoj.png'),
                                                      width: 40.0,
                                                    )),
                                              ],
                                            )
                                          ],
                                        ),
                                        Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              children: [
                                              showCounterButton ?  GestureDetector(
                                                  onTap: (){
                                                    if(showCounterButton){
                                                      RoomBasicDataHelper? helper = ChatRoomService().roomBasicDataHelperGetter();
                                                      gifts = helper!.gifts ;
                                                      GiftHelper(gift_id: luckyGiftId, user_id: user!.id , room_id: room!.id , receiver: luckyGiftReciver , room_owner: room!.userId , sendGiftCount: luckyGiftCount , gifts: gifts).sendGift();
                                                    }

                                                  },
                                                  child: CircularCountDownTimer(
                                                    duration: _duration,
                                                    initialDuration: 0,
                                                    controller: _countDownController,
                                                    width: 50.0,
                                                    height: 50.0,
                                                    ringColor: Colors.grey[300]!,
                                                    ringGradient: null,
                                                    fillColor: Colors.purpleAccent[100]!,
                                                    fillGradient: null,
                                                    backgroundColor: Colors.purple[500],
                                                    backgroundGradient: null,
                                                    strokeWidth: 5.0,
                                                    strokeCap: StrokeCap.round,
                                                    textStyle: const TextStyle(
                                                      fontSize: 25.0,
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.bold,
                                                    ),

                                                    textFormat: CountdownTextFormat.S,
                                                    isReverse: true,
                                                    isReverseAnimation: true,
                                                    isTimerTextShown: true,
                                                    autoStart: true,
                                                    onStart: () {
                                                      // Here, do whatever you want
                                                      debugPrint('Countdown Started');
                                                    },
                                                    onComplete: () async{
                                                      // Here, do whatever you want
                                                      debugPrint('Countdown Ended');
                                                      setState(() {
                                                        showCounterButton = false ;
                                                          giftImg = '';
                                                        luckyGiftId = 0 ;
                                                        luckyGiftCount = 0 ;
                                                        luckyGiftReciver = 0 ;

                                                      });

                                                      await player.stop();
                                                    },
                                                    onChange: (String timeStamp) {
                                                      // Here, do whatever you want
                                                      debugPrint('Countdown Changed $timeStamp');
                                                    },
                                                    timeFormatterFunction: (defaultFormatterFunction, duration) {


                                                        // other durations by it's default format
                                                        return Function.apply(defaultFormatterFunction, [duration]);

                                                    },
                                                  ),

                                                ): SizedBox(),
                                                SizedBox( height: 5.0,),
                                                GestureDetector(
                                                  onTap: (){
                                                    showModalBottomSheet(

                                                        context: context,
                                                        builder: (ctx) => giftBottomSheet());
                                                  },
                                                  child: Image(
                                                    image: AssetImage('assets/images/gift_box.webp'),
                                                    width: 40.0,
                                                  ),
                                                )
                                              ],
                                            ))
                                      ],
                                    ) :     Row(
                                      children: [
                                        Expanded(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.grey[600],
                                                  borderRadius: BorderRadius.circular(13.0)
                                              ),
                                              height: 45.0,
                                              child: TextFormField(
                                                  controller: _messageController,
                                                  autofocus: true,
                                                  focusNode: focusNode,
                                                  cursorColor: Colors.grey,
                                                  style: TextStyle(color: Colors.white),
                                                  decoration: InputDecoration(
                                                      hintText: 'chat_hint_text_form'.tr,
                                                      hintStyle: TextStyle(
                                                          color: Colors.white, fontSize: 14),
                                                      border: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(13.0),
                                                        borderSide: BorderSide(
                                                            color: Colors.grey),
                                                      ),
                                                      focusedBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: Colors.grey,),
                                                        borderRadius: BorderRadius.circular(13.0),
                                                      ),
                                                      suffixIcon: IconButton(
                                                        onPressed: () {
                                                          if(mounted) {
                                                            setState(() {
                                                              emojiShowing =
                                                              !emojiShowing;
                                                            });
                                                          }
                                                        },
                                                        icon: Icon(Icons.emoji_emotions_outlined,
                                                          color: Colors.white,), iconSize: 30.0,
                                                      )
                                                  )
                                              ),
                                            )
                                        ),
                                        SizedBox(width: 15.0,),
                                        Container(
                                          decoration: BoxDecoration(
                                              color: MyColors.primaryColor,
                                              borderRadius: BorderRadius.circular(10.0)
                                          ),
                                          height: 45.0,
                                          width: 80.0,
                                          child: MaterialButton(
                                            onPressed: () {
                                              sendMessage();

                                            }, //sendMessage
                                            child: Text('gift_send'.tr, style: TextStyle(
                                                color: MyColors.darkColor,
                                                fontSize: 15.0,
                                                fontWeight: FontWeight.bold),),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Offstage(
                                      offstage: !emojiShowing,
                                      child: SizedBox(
                                          height: 250,
                                          child: EmojiPicker(
                                              textEditingController: _messageController,
                                              onBackspacePressed: () {
                                                print('clicked');
                                              },
                                              config: Config(
                                                columns: 7,
                                                // Issue: https://github.com/flutter/flutter/issues/28894
                                                emojiSizeMax: 32 *
                                                    (foundation.defaultTargetPlatform ==
                                                        TargetPlatform.iOS
                                                        ? 1.30
                                                        : 1.0),
                                                verticalSpacing: 0,
                                                horizontalSpacing: 0,
                                                gridPadding: EdgeInsets.zero,
                                                initCategory: Category.RECENT,
                                                bgColor: MyColors.darkColor,
                                                indicatorColor: MyColors.primaryColor,
                                                iconColor: Colors.grey,
                                                iconColorSelected: MyColors.primaryColor,
                                                backspaceColor: MyColors.primaryColor,
                                                skinToneDialogBgColor: MyColors.darkColor,
                                                skinToneIndicatorColor: Colors.grey,
                                                enableSkinTones: true,
                                                recentTabBehavior: RecentTabBehavior.RECENT,
                                                recentsLimit: 28,
                                                replaceEmojiOnLimitExceed: false,
                                                noRecents: Text(
                                                  'chat_no_resents'.tr ,
                                                  style: TextStyle(fontSize: 20,
                                                      color: Colors.black26),
                                                  textAlign: TextAlign.center,
                                                ),
                                                loadingIndicator: const SizedBox.shrink(),
                                                tabIndicatorAnimDuration: kTabScrollDuration,
                                                categoryIcons: const CategoryIcons(),
                                                buttonMode: ButtonMode.MATERIAL,
                                                checkPlatformCompatibility: true,
                                              )
                                          )
                                      )
                                  ),

                                ],
                              ),
                              entery != ""  ? SVGASimpleImage(   resUrl: entery) : Container() ,
                              giftImg != "" ?  SVGASimpleImage(   resUrl: giftImg) : Container() ,

                              showRainLuckyCase ?  Stack(

                                 alignment: Alignment.center,
                                 children: [
                                   SVGASimpleImage(   resUrl: ASSETSBASEURL + 'AppBanners/lucky_bags.svga?raw=true'),
                                   Container(
                                     width: MediaQuery.sizeOf(context).width,
                                     height: MediaQuery.sizeOf(context).height,
                                     color: Colors.black12,
                                   )
                                 ],
                               ) : Container() ,

                                AnimatedPositioned(
                                top: MediaQuery.sizeOf(context).height * .5,
                                left: !showEnteryBanner  ? -300.0 : MediaQuery.sizeOf(context).width ,
                                duration: const Duration(seconds: 3),
                                curve: Curves.slowMiddle,
                                child: showEnteryBanner ? Stack(
                                   alignment: Alignment.center,
                                  children: [
                                    Container( width:200.0 , child: SVGASimpleImage(   resUrl: enteryBanner)),
                                    Container(
                                        padding: EdgeInsets.only(left: 70.0 , right: 10.0),
                                        width: 190.0,
                                        child: Text(enteryMessage , style: TextStyle(fontSize: 10.0), softWrap: true, maxLines: 3,) , ),

                                  ],
                                ) : SizedBox(),
                              )


                            ],
                          ),
                          !_localUserJoined ? Loading() : Container()
                        ],
                      ),
                      showBanner ? GestureDetector(
                        onTap: (){
                          openBannerRoom(bannerRoom);
                        },
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            SVGASimpleImage(   resUrl: ASSETSBASEURL + 'AppBanners/gift_red_banner.svga?raw=true'),
                            SizedBox(height: 100,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(bannerMsg , style: TextStyle(fontSize: 11.0),),
                                SizedBox(width: 10.0,),
                                SizedBox(height: 40.0, width: 40.0,  child: Image(image: CachedNetworkImageProvider(giftImgSmall))) ,

                              ],
                            )
                          ],
                        ),
                      ) : Container(),
                      showLuckyBanner ? GestureDetector(
                        onTap: (){
                          openBannerRoom(bannerRoom);
                        },
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(height: 150.0,),
                            SVGASimpleImage(   resUrl: local == 'en' ? ASSETSBASEURL + 'AppBanners/lucky_case_banner.svga?raw=true' : ASSETSBASEURL + 'AppBanners/luckybox-banar-ar.svga?raw=true'),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                 width: 100,
                                  height: 40,
                                ),
                                Expanded(child: Text(bannerMsg , style: TextStyle(fontSize: 11.0),)),
                                Container(
                                  child:  CircleAvatar(
                                    backgroundColor: user!.gender == 0 ? MyColors.blueColor : MyColors.pinkColor ,
                                    backgroundImage: luckySenderimg != "" ?  CachedNetworkImageProvider('${ASSETSBASEURL}AppUsers/${luckySenderimg}')  :    null,
                                    radius: 20,
                                    child: user?.img== "" ?
                                    Text( "LC" ,style: const TextStyle(color: Colors.white , fontSize: 22.0 , fontWeight: FontWeight.bold),) : null,
                                  ),

                                    //Image(image: CachedNetworkImageProvider(ASSETSBASEURL + 'AppUsers/' + luckySenderimg ) , width: 50.0 , height: 50.0,),
                                ),
                                Container(
                                  width: 50,
                                  height: 40,
                                ),
                              ],
                            )
                          ],
                        ),
                      ) : Container(),
                      showBannerBigWin ? GestureDetector(
                        onTap: (){

                        },
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            SVGASimpleImage(   resUrl: ASSETSBASEURL + 'AppBanners/banar_big_win.svga?raw=true'),
                            SizedBox(height: 100,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(bannerMsg , style: TextStyle(fontSize: 11.0),),
                                SizedBox(width: 10.0,),
                                SizedBox(height: 40.0, width: 40.0,  child: Image(image: CachedNetworkImageProvider(giftImgSmall))) ,

                              ],
                            )
                          ],
                        ),
                      ) : Container(),

                    ],
                  ),
                  Stack(
                    alignment: AlignmentDirectional.topEnd,

                    children: [
                      showBannerSmallWin ? GestureDetector(
                        onTap: (){

                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,

                          children: [
                            Container(
                            margin: EdgeInsets.only(bottom: MediaQuery.sizeOf(context).height / 2) ,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  SizedBox(width: 200,  child: SVGASimpleImage(   resUrl: ASSETSBASEURL + 'AppBanners/banar_small_win.svga?raw=true')),
                                  SizedBox(height: 100,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(bannerMsg , style: TextStyle(fontSize: 18.0),),


                                    ],
                                  ),

                                ],
                              ),
                            ),
                          ],
                        ),
                      ) : Container(),
                    ],
                  ),

                 showLuckyCase ?  GestureDetector(
                       onTap: () async{
                         if(canOpenLuckyCase){
                           if(mounted) {
                             setState(() {
                               canOpenLuckyCase = false;
                             });
                           }
                           var rng = Random();
                           int rand = rng.nextInt(30);
                           LuckyCase? res = await ChatRoomService().useLuckyCase(room!.id , user!.id ,lucky_id ,  rand);
                           if(res!.id > 0){
                             Fluttertoast.showToast(
                                 msg: 'lucky_case_msg'.tr  + ' ' + rand.toString(),
                                 toastLength: Toast.LENGTH_SHORT,
                                 gravity: ToastGravity.CENTER,
                                 timeInSecForIosWeb: 1,
                                 backgroundColor: Colors.black26,
                                 textColor: Colors.orange,
                                 fontSize: 16.0);
                           }
                         }


                       },
                      child: Container( margin: EdgeInsetsDirectional.only(bottom: 60.0 , end: 10.0 ),  child: Image(image: AssetImage('assets/images/luckyCaseIcon.png') , width: 45,))) : SizedBox(),

                  // GestureDetector(
                  //     onTap: (){
                  //
                  //       openRollet();
                  //     },
                  //     child: Container( margin: EdgeInsetsDirectional.only(bottom: 60.0 , end: 10.0 ),  child: Image(image: AssetImage('assets/images/rollet_icon.png') , width: 45,))),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  Widget ProfileBottomSheet( user )  {
   ChatRoomService.showMsgInput = showMsgInput ;
   return SmallProfileModal(visitor: user , type: 1);
  }

  openRollet() async{
    Rollet? rollet = await ChatRoomService().getRoomActiveRollet(room!.id);
    if(rollet == null){
      if(userRole == 'ADMIN' || userRole == 'OWNER'){
        showModalBottomSheet(

            context: context,
            builder: (ctx) => RolletBottomSheet());
      } else {
        Fluttertoast.showToast(
            msg: 'no_active_rollet'.tr,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black26,
            textColor: Colors.orange,
            fontSize: 16.0);
      }

    } else {
      showRolletWheal(rollet.id);

    }
  }

  Widget micListItem( mic) => StreamBuilder<Object>(
      stream: null,
      builder: (context, snapshot) {
        return Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Column(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            mic!.mic_user_img == null ? RippleAnimation(
                              color:  MyColors.primaryColor ,
                              delay: const Duration(milliseconds: 300),
                              repeat: true,
                              minRadius: speakers.where((element) => element.toString() == mic!.mic_user_tag ).toList().length > 0 ? 25 : 0,
                              ripplesCount: 6,
                              duration: const Duration(milliseconds: 6 * 300),
                              child: CircleAvatar(
                                backgroundColor: Colors.transparent,
                                radius: 25,
                                backgroundImage: getMicUserImg(mic),
                              ),
                            ) :     RippleAnimation(
                              color:  MyColors.primaryColor ,
                              delay: const Duration(milliseconds: 300),
                              repeat: true,
                              minRadius: speakers.where((element) => element.toString() == mic!.mic_user_tag ).toList().length > 0 ? 25 : 0,
                              ripplesCount: 6,
                              duration: const Duration(milliseconds: 6 * 300),
                              child: CircleAvatar(
                                backgroundColor:  mic.mic_user_gender == 0 ? MyColors.blueColor : MyColors.pinkColor ,
                                backgroundImage:  mic!.mic_user_img != "" ? ( mic!.mic_user_img.startsWith('https') ? CachedNetworkImageProvider( mic!.mic_user_img)  :  CachedNetworkImageProvider('${ASSETSBASEURL}AppUsers/${ mic!.mic_user_img}'))  :    null,
                                radius: 22,
                                child:  mic!.mic_user_img== "" ?
                                Text(mic!.mic_user_name.toUpperCase().substring(0 , 1) +
                                    (mic!.mic_user_name.contains(" ") ? mic!.mic_user_name.substring(mic!.mic_user_name.indexOf(" ")).toUpperCase().substring(1 , 2) : ""),
                                  style: const TextStyle(color: Colors.white , fontSize: 22.0 , fontWeight: FontWeight.bold),) : null,
                              ),
                            ),
                            Container(height: 70.0, width: 70.0, child: mic!.frame != "" ? SVGASimpleImage(   resUrl: ASSETSBASEURL + 'Designs/Motion/' + mic!.frame +'?raw=true') : null),
                           // Image(image: AssetImage('assets/images/mute.png') , width: 25 , height: 25,)
                            // Container(height: 70.0, width: 70.0,
                            // child: speakers.where((element) => element.toString() == mic!.mic_user_tag ).toList().length > 0  ?
                            // SizedBox( height: 50.0, width: 50.0,
                            //     child: SVGASimpleImage(   resUrl: ASSETSBASEURL + 'Defaults/wave.svga')) : null),


                            //frame
                          ],
                        ),
                        micEmojs[mic.order -1] != "" ?    Container(height: 70.0, width: 70.0, child: SVGASimpleImage(   resUrl: micEmojs[mic.order -1] +'?raw=true') ) : Container()

                      ],
                    ),
                    Text(
                      mic!.mic_user_name == null
                          ? mic!.order.toString()
                          : mic!.mic_user_name,
                      style: TextStyle(color: Colors.white, fontSize: 13.0),
                      overflow: TextOverflow.ellipsis,
                    )
                  ],
                ),
                PopupMenuButton(
                    position: PopupMenuPosition.under,
                    shadowColor: MyColors.unSelectedColor,
                    elevation: 4.0,

                    color: MyColors.secondaryColor,
                    icon: Container(),
                    onSelected: (int result) {
                      micActions(result , mic);
                    },
                    itemBuilder: (BuildContext context) =>  AdminMicListItems(mic)
                ),
              ],
            ),
            (mic.user_id > 0 && room!.isCounter == 1) ? Transform.translate(
              offset: Offset(0, 8.0),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                decoration: BoxDecoration(color: MyColors.primaryColor , borderRadius: BorderRadius.circular(20.0)),
                child: Text(mic.counter.toString() , style: TextStyle(color: MyColors.darkColor , fontSize: 14.0),),
              ),
            ): SizedBox()
          ],
        );
      }
  );


  micActions(result , mic) async {
    if(result == 1){
      //use_mic
      await MicHelper( user_id:  user!.id , room_id:  room!.id , mic: mic.order).useMic();
      await _engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
      ChatRoomService.userRole = 'clientRoleBroadcaster';
      if(mounted) {
        setState(() {
          _localUserMute = false;
        });
      }
    }
    else if(result == 2){
      //lock_mic
      MicHelper( user_id:  user!.id , room_id:  room!.id , mic: mic.order).lockMic();
    }
    else if(result == 3){
      //lock_all_mics
      MicHelper( user_id:  user!.id , room_id:  room!.id , mic: 0).lockMic();
    }
    else if(result == 4){
      //unlock_mic
      MicHelper( user_id:  user!.id , room_id:  room!.id , mic: mic.order).unlockMic();
    }
    else if(result == 5){
      //unlock_all_mic
      MicHelper( user_id:  user!.id , room_id:  room!.id , mic: 0).unlockMic();
    }
    else if(result == 6){
      //remove_from_mic
      MicHelper(user_id:  mic!.user_id , room_id:  room!.id , mic: mic.order).removeFromMic(user!.id);

    }
    else if(result == 7){
      //un_use_mic
      MicHelper( user_id:  user!.id , room_id:  room!.id , mic: mic.order).leaveMic();
      await _engine.setClientRole(role: ClientRoleType.clientRoleAudience);
      ChatRoomService.userRole = 'clientRoleAudience';
      try{
        _engine = ChatRoomService.engine! ;
        await _engine.stopAudioMixing();
      }catch(err){

      }
      if(mounted) {
        setState(() {
          _localUserMute = true;
        });
      }

    }
    else if(result == 8){
      //mute
      if(_localUserMute){
        await _engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
        ChatRoomService.userRole = 'clientRoleBroadcaster';
        if(mounted) {
          setState(() {
            _localUserMute = false;
          });
        }
      } else {
        await _engine.setClientRole(role: ClientRoleType.clientRoleAudience);
        ChatRoomService.userRole = 'clientRoleAudience';
        if(mounted) {
          setState(() {
            _localUserMute = true;
          });
        }
      }

    }
    else if(result == 9){
      //showprofile
      AppUser? res =  await AppUserServices().getUser(mic!.user_id);
      showModalBottomSheet(

          context: context,
          builder: (ctx) => ProfileBottomSheet(res)).whenComplete(() {
        if(mounted) {
          setState(() {
            showMsgInput = ChatRoomService.showMsgInput;
          });
        }
            if(showMsgInput){
              _messageController.text = "@" + res!.name + '.';
            }
      });

    }
    else if(result == 10){
      //kickout
      showCupertinoModalPopup(
        context: context,
        builder: (context) => CupertinoActionSheet(

          actions: [
            Container(
              color: MyColors.darkColor,
              child: CupertinoActionSheetAction(
                child: Text('kick_out_hour'.tr , style: TextStyle(color: MyColors.primaryColor)),
                onPressed: ()  {
                 MicHelper(user_id: mic!.user_id , room_id: room!.id ,mic: 0 ).kickOut('HOUR');
                },
              ),
            ),
            Container(
              color: MyColors.darkColor,
              child: CupertinoActionSheetAction(
                child: Text('kick_out_day'.tr , style: TextStyle(color: MyColors.primaryColor)),
                onPressed: () {
                  MicHelper(user_id: mic!.user_id , room_id: room!.id ,mic: 0 ).kickOut('DAY');
                },
              ),
            ),
            Container(
              color: MyColors.darkColor,
              child: CupertinoActionSheetAction(
                child: Text('kick_out_forever'.tr , style: TextStyle(color: MyColors.primaryColor),),
                onPressed: () {
                  MicHelper(user_id: mic!.user_id , room_id: room!.id ,mic: 0 ).kickOut('ALL');
                },
              ),
            ),
          ],
        ),
      );
    }
  }


  ImageProvider getMicUserImg(mic) {
    //if (mic!.mic_user_img == null) {
    if(mic.isClosed == 0)
      return AssetImage('assets/images/mic_open.png');
    else
      return AssetImage('assets/images/mic_close.png');
    // } else {
    //
    //   return CachedNetworkImageProvider(ASSETSBASEURL + 'AppUsers/' + mic!.mic_user_img);
    // }
  }


  Widget RoomCup( ) => RoomCupModal();

  Widget EmojBottomSheet( ) => EmojModal();
  Widget giftBottomSheet() => GiftModal(reciverId: 0,);
  Widget MenuBottomSheet() => MenuModal(scrollController: _scrollController,);
  Widget ChatBottomSheet() => ChatsScreen();
  Widget RoomInfoBottomSheet() => RoomInfoModal();
  Widget roomCloseModal() => RoomCloseModal(pcontext: context, engine: _engine);
  Widget roomMembersModal() => RoomMembersModal();
  Widget roomRolletModal(Rollet rollet) => RolletModal(rollet: rollet,);
  List<PopupMenuEntry<int>> AdminMicListItems(mic) {
    if(userRole == 'OWNER'  || userRole == 'ADMIN'){
      if(mic.user_id == 0){
        if(mic.isClosed == 0){
          return
            [
              PopupMenuItem<int>(
                value: 1,
                child: Text('use_mic'.tr , style: TextStyle(color: Colors.black),),
              ),
              PopupMenuItem<int>(
                value: 2,
                child: Text('lock_mic'.tr , style: TextStyle(color: Colors.black),),
              ),
              PopupMenuItem<int>(
                value: 3,
                child: Text('lock_all_mics'.tr , style: TextStyle(color: Colors.black),),
              ),
            ];

        } else {
          return
            [
              PopupMenuItem<int>(
                value: 4,
                child: Text('unlock_mic'.tr , style: TextStyle(color: Colors.black),),
              ),
              PopupMenuItem<int>(
                value: 5,
                child: Text('unlock_all_mic'.tr , style: TextStyle(color: Colors.black),),
              ),

            ];
        }
      } else {
        if(mic.user_id != user!.id){
          return
            [
              PopupMenuItem<int>(
                value: 6,
                child: Text('remove_from_mic'.tr , style: TextStyle(color: Colors.black),),
              ),
              PopupMenuItem<int>(
                value: 10,
                child: Text('kick_out'.tr , style: TextStyle(color: Colors.black),),
              ),
              PopupMenuItem<int>(
                value: 9,
                child: Text('show_user'.tr , style: TextStyle(color: Colors.black),),
              ),


            ];
        } else {
          return
            [
              PopupMenuItem<int>(
                value: 7,
                child: Text('un_use_mic'.tr , style: TextStyle(color: Colors.black),),
              ),
              PopupMenuItem<int>(
                value: 8,
                child: _localUserMute ? Text('unmute'.tr , style: TextStyle(color: Colors.black),) :  Text('mute'.tr , style: TextStyle(color: Colors.black),),
              ),

            ];

        }
      }
    } else {
      // not admin
      if(mic.user_id == 0){
        if(mic.isClosed == 0){
          if(mic.order > 1){
            return [
              PopupMenuItem<int>(
                value: 1,
                child: Text('use_mic'.tr , style: TextStyle(color: Colors.white),),
              ),
            ];
          } else {
            Fluttertoast.showToast(
                msg: 'admin_mic_alert'.tr,
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.black26,
                textColor: Colors.orange,
                fontSize: 16.0);
            return [];
          }

        } else {
          Fluttertoast.showToast(
              msg: 'room_close_mic'.tr,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.black26,
              textColor: Colors.orange,
              fontSize: 16.0);
          return [];
        }
      } else {
        if(mic.user_id != user!.id){
          return
            [
              PopupMenuItem<int>(
                value: 9,
                child: Text('show_user'.tr , style: TextStyle(color: Colors.white),),
              ),


            ];
        } else {
          return
            [
              PopupMenuItem<int>(
                value: 7,
                child: Text('un_use_mic'.tr , style: TextStyle(color: Colors.white),),
              ),
              PopupMenuItem<int>(
                value: 8,
                child: _localUserMute ? Text('unmute'.tr , style: TextStyle(color: Colors.white),) :  Text('mute'.tr , style: TextStyle(color: Colors.white),),
              ),

            ];
        }

      }
    }

  }

  Widget roomMessageBuilder(index) => messages[index].user_id == 0 ? Flex(
    direction: Axis.horizontal,
    children: [
      Container( padding: EdgeInsets.symmetric(horizontal: 10.0 , vertical: 5.0 ),   decoration: BoxDecoration(borderRadius: BorderRadius.circular(15.0) , color: Colors.black54),   constraints: BoxConstraints(
        maxWidth: (MediaQuery.of(context).size.width * 0.8) - 20.0,
      ),
        child: messages[index].user_name == 'APP' ? Text( messages[index].message , style: TextStyle(color: MyColors.secondaryColor , fontSize: 11.0),) :
        Text( 'notice'.tr +  messages[index].message , style: TextStyle(color: MyColors.secondaryColor , fontSize: 13.0),),
      ),
    ],
  ) : Flex(
    direction: Axis.horizontal,

    children: [
      Container(decoration:
        BoxDecoration(borderRadius: BorderRadius.circular(15.0) ,
            color: messages[index].pubble == ""  ? Colors.black.withOpacity(.5) : Colors.transparent ,
            image: messages[index].pubble != ""  ?  DecorationImage(image:   CachedNetworkImageProvider(messages[index].pubble.toString() ) , fit: BoxFit.fill) : null) ,

           padding: EdgeInsets.symmetric(horizontal: 5.0 , vertical: 10.0 ),
          constraints: BoxConstraints(
        maxWidth: (MediaQuery.of(context).size.width * 0.7) - 20.0,
      ),
        child:
        GestureDetector(
          onTap: () async{
            AppUser? res =  await AppUserServices().getUser(messages[index].user_id);
            showModalBottomSheet(

                context: context,
                builder: (ctx) => ProfileBottomSheet(res)).whenComplete(() {
                if(mounted) {
                  setState(() {
                    showMsgInput = ChatRoomService.showMsgInput;
                  });
                }
              if(showMsgInput){
                _messageController.text = "@" + res!.name + '.' ;
              }
            });
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Row(
                    children: [
                      Image(image: CachedNetworkImageProvider('${ASSETSBASEURL}Levels/${messages[index].user_share_level_img}') , width: 30,),
                      messages[index].vip != ""  ? SizedBox(width: 5.0,) : SizedBox(),
                      messages[index].vip != ""  ? Image(image: CachedNetworkImageProvider('${ASSETSBASEURL}VIP/${messages[index].vip}') , width: 30,) : SizedBox(),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      for (var item in  messages[index].badges!) Image(image: CachedNetworkImageProvider('${ASSETSBASEURL}Badges/${item.badge}') , width: 30,),
                    ],
                  )

                ],
              ),

              SizedBox(width: 5.0,),
              getMessageContent(messages[index])

            ],
          ),
        ),
      ),
    ],
  );
  Widget roomMessageSeperator() => SizedBox(height: 5.0,);

  Widget getMessageContent(ChatRoomMessage message) {
    if(message.type == "TEXT"  || message.type == "GIFT"){
      return   Expanded(child: Text(message.user_name + ': '  + message.message , style: TextStyle(color: Colors.white , fontSize: 13.0),  overflow: TextOverflow.ellipsis,
          maxLines: 4,
          textAlign: TextAlign.start));
    } else if(message.type == "NURD"){
      return Column(
        children: [
          Text(message.user_name , style: TextStyle(color: Colors.white , fontSize: 13.0 ) , overflow: TextOverflow.ellipsis, ),
          SizedBox(height: 10.0,),
          Image(image: CachedNetworkImageProvider(ASSETSBASEURL + 'Nurd/' + message.message + '.webp' ) , width: 40.0,)
        ],
      );
    }
    else if(message.type == "PAPER"){
      return Column(
        children: [
          Text(message.user_name , style: TextStyle(color: Colors.white , fontSize: 13.0 ) , overflow: TextOverflow.ellipsis, ),
          SizedBox(height: 10.0,),
          Image(image: CachedNetworkImageProvider(ASSETSBASEURL + 'rock-paper-scissors/' + message.message + '.webp' ) , width: 40.0,)
        ],
      );
    }
    else if(message.type == "LUCKY"){
      return Column(
        children: [
          Text(message.user_name , style: TextStyle(color: Colors.white , fontSize: 13.0 ) , overflow: TextOverflow.ellipsis, ),
          SizedBox(height: 10.0,),
          Text(message.message , style: TextStyle(color: MyColors.primaryColor , fontSize: 30.0 , fontWeight: FontWeight.bold  ) , overflow: TextOverflow.ellipsis, ),
        ],
      );

    }
    else {
      return Container();
    }
  }



Widget roomMemberItmeBuilder(RoomMember user) =>    GestureDetector(
  onTap: () async{
    AppUser? res =  await AppUserServices().getUser(user.user_id);
    showModalBottomSheet(

        context: context,
        builder: (ctx) => ProfileBottomSheet(res)).whenComplete(() {
        if(mounted) {
          setState(() {
            showMsgInput = ChatRoomService.showMsgInput;
          });
        }
      if(showMsgInput){
        _messageController.text = "@" + res!.name + '.';
      }
    });
  },
  child: Stack(
    alignment: Alignment.center,
    children: [
      CircleAvatar(
          radius: 15.0,
          backgroundImage: getUserAvatar(user)),
      user.user_id == room!.userId  ? Image(
        image: AssetImage(
            'assets/images/room_user_small_border.png'),
        width: 50,
        height: 50,
      ): SizedBox()
    ],
  ),
);

  ImageProvider getUserAvatar(RoomMember user) {

    if (user.mic_user_img == '') {
      return AssetImage('assets/images/user.png');
    } else {
      return CachedNetworkImageProvider('${ASSETSBASEURL}AppUsers/${user.mic_user_img}');
    }
  }

  Widget RolletBottomSheet() => CreateRolletModal();


  int getLuckyCaseDuration(LuckyCase luckyCase , Timestamp available_untill ){
    final DateTime luckyCaseCreatedDate = DateTime.parse(luckyCase.created_date);

    var dateTwo = DateTime.parse(available_untill.toDate().toString())  ;
    print(luckyCaseCreatedDate );
    print(dateTwo );

    final Duration duration = dateTwo.difference(luckyCaseCreatedDate);
    print(duration.inSeconds );
    return duration.inSeconds  ;
  }

  int getRoomLuckyCaseDuration(LuckyCase luckyCase , DateTime available_untill ){
    final DateTime luckyCaseCreatedDate = DateTime.parse(luckyCase.created_date);
    final DateTime currentDate = DateTime.now();
    print('getRoomLuckyCaseDuration' );
    print(available_untill);
    print(currentDate );
    final Duration duration = available_untill.difference(currentDate);
    print(duration.inSeconds );
    return duration.inSeconds  ;
  }

  bool checkGiftShow(  Timestamp available_untill ){
    final DateTime giftAvaliable = DateTime.parse(available_untill.toDate().toString());
    final DateTime currentDate = DateTime.now();

    final Duration duration = giftAvaliable.difference(currentDate);
     print('checkGiftShow');
     print(duration);
    return duration.inSeconds  < 60;
  }


  bool checkLuckyCaseShow(  Timestamp available_untill ){
    final DateTime giftAvaliable = DateTime.parse(available_untill.toDate().toString());
    final DateTime currentDate = DateTime.now();

    final Duration duration = giftAvaliable.difference(currentDate);
    print('checkLuckyCaseShow');
    print(duration);
    return duration.inSeconds  < 120;
  }

  openBannerRoom(room_id) async{
    if(room_id != room!.id){
      MicHelper( user_id:  user!.id , room_id:  room!.id , mic: 0).leaveMic();
      ExitRoomHelper(user!.id , room!.id);
      await _engine.leaveChannel();
      await _engine.release();
      ChatRoom? res = await ChatRoomService().openRoomById(room_id);
      if (res != null) {
        if (res.password.isEmpty || res.userId == user!.id) {
          ChatRoomService().roomSetter(res);
        //  Navigator.pop(context);
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RoomScreen(),
              ));
        } else {
          //showPassword popup
          _displayTextInputDialog(context, res);
        }
      }

    }
  }

  Future<void> _displayTextInputDialog(
      BuildContext context, ChatRoom room) async {
    return showDialog(
      context: context,
      builder: (context) {
        return Container(
          child: AlertDialog(
            backgroundColor: MyColors.darkColor,
            title: Text(
              'room_password_label'.tr,
              style: TextStyle(color: Colors.white, fontSize: 20.0),
              textAlign: TextAlign.center,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 70.0,
                  child: TextField(
                    controller: passwordController,
                    style: TextStyle(color: Colors.white),
                    cursorColor: MyColors.primaryColor,
                    maxLength: 20,
                    keyboardType: TextInputType.visiblePassword,
                    decoration: InputDecoration(
                        hintText: "XXXXXXX",
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
              Container(
                decoration: BoxDecoration(
                    color: MyColors.primaryColor,
                    borderRadius: BorderRadius.circular(15.0)),
                child: MaterialButton(
                  child: Text(
                    'OK',
                    style: TextStyle(color: MyColors.darkColor),
                  ),
                  onPressed: () async {
                    if (passwordController.text == room.password) {
                      ChatRoomService().roomSetter(room);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RoomScreen(),
                          ));
                    } else {
                      Fluttertoast.showToast(
                          msg: "room_password_wrong".tr,
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.black26,
                          textColor: Colors.orange,
                          fontSize: 16.0);
                    }
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }


  Widget getUserBadges(UserBadge badge) =>  Container() ;


}
