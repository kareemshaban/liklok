import 'package:LikLok/modules/Room/Room_Screen.dart';
import 'package:LikLok/shared/network/remote/ChatRoomService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:x_overlay/x_overlay.dart';

import '../../../models/ChatRoom.dart';
import '../../../shared/components/Constants.dart';
import '../../../shared/styles/colors.dart';

class RoomOverlayWidget extends StatefulWidget {
  const RoomOverlayWidget({super.key});

  @override
  State<RoomOverlayWidget> createState() => _RoomOverlayWidgetState();
}

class _RoomOverlayWidgetState extends State<RoomOverlayWidget> {
  ChatRoom? savedRoom ;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      savedRoom = ChatRoomService().savedRoomGetter();
    });
  }
  ImageProvider getRoomImage(room){
    String room_img = '';
    if(room!.img == room!.admin_img){
      if(room!.admin_img != ""){
        room_img = '${ASSETSBASEURL}AppUsers/${room?.img}' ;
      } else {
        room_img = '${ASSETSBASEURL}Defaults/room_default.png' ;
      }

    } else {
      if(room?.img != ""){
        room_img = '${ASSETSBASEURL}Rooms/${room?.img}' ;
      } else {
        room_img = '${ASSETSBASEURL}Defaults/room_default.png' ;
      }

    }
    return  NetworkImage(room_img);
  }

  @override
  Widget build(BuildContext context) {
    return XOverlayPage(
      controller: ChatRoomService.overlayController,
      restoreWidgetQuery: (XOverlayData data) {
        return const RoomScreen();
      },
      contextQuery: (){
        return ChatRoomService.navigatorKey.currentState!.context;
      },
      builder: (XOverlayData data){
        return GestureDetector(
          onTap: (){
            if(mounted){
              setState(() {
                ChatRoomService.restoreOverlay();
              });
            }
          },
          child: SizedBox(
            width: 150,
            height: 150,
            child:  Container(
              width: 90.0,
              height: 90.0,
              decoration: BoxDecoration(color: MyColors.primaryColor , borderRadius: BorderRadius.circular(15.0) ,
                // image: DecorationImage(image: getRoomImage(savedRoom), fit: BoxFit.cover,
                //     colorFilter:  ColorFilter.mode(Colors.grey.withOpacity(.9), BlendMode.dstATop)
                // ),
              ),
            ),
          ),
        );
      },
    );
  }
}
