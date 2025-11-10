import 'package:LikLok/helpers/ExitRoomHelper.dart';
import 'package:LikLok/helpers/MicHelper.dart';
import 'package:LikLok/models/AppUser.dart';
import 'package:LikLok/models/ChatRoom.dart';
import 'package:LikLok/models/Intro.dart';
import 'package:LikLok/modules/Chats/Chats_Screen.dart';
import 'package:LikLok/modules/Home/Home_Screen.dart';
import 'package:LikLok/modules/Moments/Moments_Screen.dart';
import 'package:LikLok/modules/Profile/Profile_Screen.dart';
import 'package:LikLok/modules/Room/Room_Screen.dart';
import 'package:LikLok/shared/components/Constants.dart';
import 'package:LikLok/shared/network/remote/AppUserServices.dart';
import 'package:LikLok/shared/network/remote/ChatRoomService.dart';
import 'package:LikLok/shared/network/remote/IntroServices.dart';
import 'package:LikLok/shared/styles/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() => TabsScreenState();
}

class TabsScreenState extends State<TabsScreen> {
  //vars
     int activeIndex = 0 ;
     double x1 = 100.0, x2 = 200.0, y1 = 100.0,
         y2 = 200.0, x1Prev = 100.0, x2Prev = 200.0, y1Prev = 100.0,
         y2Prev = 100.0;
     List<Widget> tabs = [HomeScreen() , MomentsScreen() , ChatsScreen() , ProfileScreen()];

     bool showDelete = false ;
     ChatRoom? savedRoom ;
      AlertDialog? alert  ;
     late Intro? intro ;


     @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      savedRoom = ChatRoomService().savedRoomGetter();
      intro = IntroServices().introGetter() ;
    });
    Future.delayed(const Duration(milliseconds: 5000), () {
      setState(() {
        IntroServices().introSetter(null);
        intro = null ;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return (intro == null ) ? Stack(
      children: [
        Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Scaffold(
              body: tabs[activeIndex],
              bottomNavigationBar: BottomNavigationBar(
                backgroundColor: MyColors.solidDarkColor,
                fixedColor: MyColors.primaryColor,
                unselectedItemColor: MyColors.unSelectedColor,
                showUnselectedLabels: false,

                type: BottomNavigationBarType.fixed,
                currentIndex: activeIndex,
                onTap: (index){
                 setState(() {
                   activeIndex = index ;
                 });
                },
                items:  [
                  BottomNavigationBarItem(icon: Icon(FontAwesomeIcons.houseChimneyWindow) , label: "home".tr ),
                  BottomNavigationBarItem(icon: Icon(FontAwesomeIcons.globe) , label: "moments".tr),
                  BottomNavigationBarItem(icon: Icon(FontAwesomeIcons.message) , label: "chats".tr),
                  BottomNavigationBarItem(icon: Icon(FontAwesomeIcons.user) , label: "me".tr),
              ],),
            ),
            showDelete ?  Container(
              width: double.infinity,
              height: 70.0,
              color: Colors.red.withOpacity(.9),
              child: Icon(Icons.delete_forever_sharp , color: Colors.white , size: 40.0,),

            ): Container()

          ],
        ),
        savedRoom != null?  Positioned(
          left: x1,
          top: y1,

          child: GestureDetector(
            onPanDown:(d){
              x1Prev = x1;
              y1Prev = y1;
            },
            onPanUpdate: (details) {
              if(x1Prev + details.localPosition.dx < (MediaQuery.sizeOf(context).width - 100) &&
                  y1Prev + details.localPosition.dy >  100 &&
                  y1Prev + details.localPosition.dy <  (MediaQuery.sizeOf(context).height - 100) ){
                print(y1Prev + details.localPosition.dy);
                setState(() {
                  x1 = x1Prev + details.localPosition.dx;
                  y1 = y1Prev + details.localPosition.dy;
                });
                if(y1Prev + details.localPosition.dy >=  MediaQuery.sizeOf(context).height - 150 ){
                  setState(() {
                    showDelete = true ;
                  });
                  if(alert == null){
                    showAlertDialog(context);
                  }

                } else {
                  setState(() {
                    showDelete = false ;
                  });
                }
              }

            },
            child: GestureDetector(
              onTap: (){
                print(savedRoom!.mics);
                ChatRoomService().roomSetter(savedRoom!);
                setState(() {
                  showDelete = false ;
                  savedRoom = null ;
                });
                Navigator.push(context, MaterialPageRoute(builder: (context) => RoomScreen(),));
              },
              child: Container(
                width: 90.0,
                height: 90.0,
                decoration: BoxDecoration(color: MyColors.primaryColor , borderRadius: BorderRadius.circular(15.0) ,
                    image: DecorationImage(image: getRoomImage(savedRoom), fit: BoxFit.cover,
                        colorFilter:  ColorFilter.mode(Colors.grey.withOpacity(.9), BlendMode.dstATop)
                    ),


                ),
              ),
            ),
          ),
        ) : Container(),

      ],
    ) : Container(
      width: MediaQuery.sizeOf(context).width,
      height: MediaQuery.sizeOf(context).height,
      decoration: BoxDecoration(image: DecorationImage(
          image: CachedNetworkImageProvider( '${ASSETSBASEURL}Intros/${intro!.img}'),
          fit: BoxFit.cover) ),
    ) ;
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

     showAlertDialog(BuildContext context) {
       AppUser? user = AppUserServices().userGetter();
       // set up the button
       Widget okButton = TextButton(
         child: Text("edit_ok".tr , style: TextStyle(color: MyColors.primaryColor),),
         onPressed: () async {
           // await ChatRoomService.engine!.leaveChannel();
           // await ChatRoomService.engine!.release();
            MicHelper( user_id:  user!.id , room_id:  savedRoom!.id , mic: 0 , user).leaveMic();
            ExitRoomHelper(user.id , savedRoom!.id);
            setState(() {
              showDelete = false ;
              savedRoom = null ;
            });

            ChatRoomService().savedRoomSetter(null);
           Navigator.pop(context);


         },
       );

       // set up the AlertDialog

        alert = AlertDialog(
         backgroundColor: MyColors.darkColor,
         title: Text("room_save_dialog_title".tr , style: TextStyle(color: MyColors.primaryColor),),
         content: Text("room_save_dialog_msg".tr , style: TextStyle(color: MyColors.whiteColor),),
         actions: [
           okButton,
         ],
       );

       // show the dialog
       showDialog(
         context: context,
         builder: (BuildContext context) {
           return alert!;
         },
       );
     }
}
