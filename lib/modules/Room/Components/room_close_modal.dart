import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:LikLok/helpers/ExitRoomHelper.dart';
import 'package:LikLok/helpers/MicHelper.dart';
import 'package:LikLok/layout/tabs_screen.dart';
import 'package:LikLok/models/AppUser.dart';
import 'package:LikLok/models/ChatRoom.dart';
import 'package:LikLok/modules/Home/Home_Screen.dart';
import 'package:LikLok/shared/network/remote/AppUserServices.dart';
import 'package:LikLok/shared/network/remote/ChatRoomService.dart';
import 'package:LikLok/shared/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RoomCloseModal extends StatefulWidget {
  final BuildContext pcontext ;
  final RtcEngine engine ;
  const RoomCloseModal({super.key , required this.pcontext , required this.engine});

  @override
  State<RoomCloseModal> createState() => _RoomCloseModalState();
}

class _RoomCloseModalState extends State<RoomCloseModal> {
  AppUser? user ;
  ChatRoom? room ;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      user = AppUserServices().userGetter();
      room = ChatRoomService().roomGetter();
    });
  }
  @override
  Widget build(BuildContext context) {
    return  SafeArea(
      child: Container(
        height: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 50.0 , horizontal: 10.0),
        color: Colors.black.withAlpha(180),
        child: Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    GestureDetector(
                      onTap: (){
                        keepRoom();
                      },
                      child: CircleAvatar(
                        radius: 35.0,
                        backgroundColor: MyColors.secondaryColor,
                        child: Image(image: AssetImage('assets/images/minimize.png'), width: 40.0 , height: 40.0,),
                      ),
                    ),
                    SizedBox(height: 5.0,),
                    Text("room_close_keep".tr , style: TextStyle(color: Colors.white , fontSize: 18.0),)
                  ],
                ),
                SizedBox(height: 20.0,),
                Column(
                  children: [
                    GestureDetector(
                      onTap: (){
                        exitRoom();
                      },
                      child: CircleAvatar(
                        radius: 35.0,
                        backgroundColor: MyColors.primaryColor,
                        child: Image(image: AssetImage('assets/images/power-off.png'), width: 45.0 , height: 45.0,),
                      ),
                    ),
                    SizedBox(height: 5.0,),
                    Text("room_close_exit".tr , style: TextStyle(color: Colors.white , fontSize: 18.0),)
                  ],
                ),
              ],
            ),
          ),
        ) ,
      ),
    );
  }

  keepRoom(){
    ChatRoomService().savedRoomSetter(room!);
    ChatRoomService.engine = widget.engine ;
   // ChatRoomService().savedRoomSetter(null);
    Navigator.pushAndRemoveUntil(
        context ,
        MaterialPageRoute(builder: (context) => const TabsScreen()) ,   (route) => false
    );

  }
  exitRoom() async {
    ChatRoomService().savedRoomSetter(null);
    MicHelper( user_id:  user!.id , room_id:  room!.id , mic: 0).leaveMic();
    ExitRoomHelper(user!.id , room!.id);
    await widget.engine.leaveChannel();
    await widget.engine.release();
    Navigator.pushAndRemoveUntil(
        context ,
        MaterialPageRoute(builder: (context) => const TabsScreen()) ,   (route) => false
    );
  }
}
