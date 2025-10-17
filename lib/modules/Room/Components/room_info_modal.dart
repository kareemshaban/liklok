import 'package:LikLok/models/AppUser.dart';
import 'package:LikLok/models/ChatRoom.dart';
import 'package:LikLok/modules/Room/Components/room_settings_screen.dart';
import 'package:LikLok/shared/components/Constants.dart';
import 'package:LikLok/shared/network/remote/AppUserServices.dart';
import 'package:LikLok/shared/network/remote/ChatRoomService.dart';
import 'package:LikLok/shared/styles/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class RoomInfoModal extends StatefulWidget {
  const RoomInfoModal({super.key});

  @override
  State<RoomInfoModal> createState() => _RoomInfoModalState();
}

class _RoomInfoModalState extends State<RoomInfoModal> {
  ChatRoom? room;
  String? room_img;
  AppUser? user ;
  bool isAdmin = false ;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setState(() {
      room = ChatRoomService().roomGetter();
      user = AppUserServices().userGetter();
     checkAdmin();
      if (room!.img == room!.admin_img) {
        room_img = '${ASSETSBASEURL}AppUsers/${room?.img}';
      } else {
        room_img = '${ASSETSBASEURL}Rooms/${room?.img}';
      }
    });
  }
  checkAdmin() async {
    ChatRoom? res = await ChatRoomService().openRoomById(room!.id) ;
    ChatRoomService().roomSetter(res!);
    AppUser? res2 = await AppUserServices().getUser(user!.id);
    AppUserServices().userSetter(res2!);
    setState(() {
      room = ChatRoomService().roomGetter();
      user = AppUserServices().userGetter();
      isAdmin = room!.userId == user!.id ;
    });
    print('isAdmin');
    print(isAdmin);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: MediaQuery.of(context).size.height / 2,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        padding: EdgeInsets.all(15.0),
        decoration: BoxDecoration(color: Colors.white.withAlpha(180),
            borderRadius: BorderRadius.only(topRight: Radius.circular(20.0) , topLeft: Radius.circular(15.0)) ,
            border: Border(top: BorderSide(width: 4.0, color: MyColors.secondaryColor),) ),
            child: Column(
              children: [
                Row(
                  children: [
                    Column(
                      children: [
                        Row(
                          children: [
                            Container(
                                width: 40.0,
                                height: 40.0,
                                child: SizedBox(),
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(10.0),
                                    image: room!.img == ""
                                        ? DecorationImage(
                                        image: AssetImage('assets/images/user.png'),
                                        fit: BoxFit.cover)
                                        : DecorationImage(
                                        image: CachedNetworkImageProvider(room_img!),
                                        fit: BoxFit.cover))),
                            SizedBox(
                              width: 10.0,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  room!.name,
                                  style: TextStyle(color: Colors.black, fontSize: 14.0),
                                ),
                                SizedBox(
                                  height: 2.0,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'ID:' + room!.tag,
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 11.0),
                                    ),
                                    SizedBox(
                                      width: 5.0,
                                    ),
                                    Text(
                                      '|',
                                      style: TextStyle(
                                          color: MyColors.unSelectedColor, fontSize: 14.0),
                                    ),
                                    SizedBox(
                                      width: 5.0,
                                    ),
                                    Container(
                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0)),
                                        clipBehavior: Clip.antiAliasWithSaveLayer,
                                        child: Image(
                                          image: CachedNetworkImageProvider(
                                              ASSETSBASEURL + 'Countries/' + room!.flag),
                                          width: 25.0,
                                        )),
                                    SizedBox(
                                      width: 5.0,
                                    ),
                                    Text(
                                      '|',
                                      style: TextStyle(
                                          color: MyColors.unSelectedColor, fontSize: 14.0),
                                    ),
                                    SizedBox(
                                      width: 5.0,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0) ,
                                          color: getTagColor()),
                                      padding: EdgeInsets.all(3.0),
                                      child: Text('#' + room!.subject , style: TextStyle(fontSize: 9.0 , color: Colors.white),),
                                    )
                                  ],
                                ),
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                    Expanded(
      
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          isAdmin ? IconButton(onPressed: (){
                              Navigator.pop(context);
                              showModalBottomSheet(
                                  isScrollControlled: true ,
                                  context: context,
                                  builder: (ctx) => roomSettingsBottomSheet());
      
                          }, icon: Icon(Icons.settings , size: 25.0, color: MyColors.secondaryColor,) , color: MyColors.unSelectedColor, ) : SizedBox(width: 1.0,),
      
                        ],
                      ),
                    )
      
                  ],
                ),
                SizedBox(height: 20.0),
                  Row(
                    children: [
                      Container(
                        width: 8.0,
                        height: 30.0,
                        decoration: BoxDecoration(color: MyColors.secondaryColor , borderRadius: BorderRadius.circular(3.0)),
                      ),
                      SizedBox(width: 10.0,),
                      Text("edit_profile_basic_information".tr, style: TextStyle(color: Colors.black , fontSize: 16.0 , fontWeight: FontWeight.bold),)
                    ],
                  ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    children: [
                      Text("ID" , style: TextStyle(fontSize: 14.0 , color: MyColors.whiteColor , fontWeight: FontWeight.bold),),
                      Expanded(child:
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(room!.tag , style: TextStyle(fontSize: 14.0 , color: Colors.black),),
                              SizedBox(width: 5.0,),
                              IconButton(onPressed: (){}, icon: Icon(FontAwesomeIcons.tag , color: Colors.black , size: 18.0,) ,)
                            ],
                          )                          ],
                      )
      
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    children: [
                      Text("room_info_room_name".tr , style: TextStyle(fontSize: 14.0 , color: MyColors.whiteColor , fontWeight: FontWeight.bold),),
                      Expanded(child:
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(room!.name , style: TextStyle(fontSize: 14.0 , color: Colors.black),),
                              SizedBox(width: 5.0,),
                              IconButton(onPressed: (){}, icon: Icon(FontAwesomeIcons.signature , color: Colors.black , size: 18.0,) ,)
                            ],
                          )                          ],
                      )
      
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    children: [
                      Text("room_info_room_admin".tr , style: TextStyle(fontSize: 14.0 , color: MyColors.whiteColor , fontWeight: FontWeight.bold),),
                      Expanded(child:
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Column(
                                children: [
                                  Text(room!.admin_name , style: TextStyle(fontSize: 14.0 , color: Colors.black),),
                                  Text(room!.admin_tag , style: TextStyle(fontSize: 12.0 , color: MyColors.whiteColor),),
                                ],
                              ),
      
                              SizedBox(width: 5.0,),
                              IconButton(onPressed: (){}, icon: Icon(FontAwesomeIcons.idBadge , color: Colors.black , size: 18.0,) ,)
                            ],
                          )                          ],
                      )
      
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    children: [
                      Text("room_info_room_country".tr , style: TextStyle(fontSize: 14.0 , color: MyColors.whiteColor , fontWeight: FontWeight.bold),),
                      Expanded(child:
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Image(image: CachedNetworkImageProvider(ASSETSBASEURL + 'Countries/' + room!.flag) , width: 25.0,),
                              SizedBox(width: 5.0,),
                              IconButton(onPressed: (){}, icon: Icon(FontAwesomeIcons.flag , color: Colors.black , size: 18.0,) ,)
                            ],
                          )                          ],
                      )
      
                      )
                    ],
                  ),
                ),
              ],
            ),
      
      
      ),
    );
  }
  Color getTagColor(){
    if(room!.subject == "CHAT"){
      return MyColors.primaryColor.withOpacity(.8) ;
    } else if(room!.subject == "FRIENDS"){
      return MyColors.successColor.withOpacity(.8) ;
    }else if(room!.subject == "GAMES"){
      return MyColors.blueColor.withOpacity(.8) ;
    }
    else {
      return MyColors.primaryColor.withOpacity(.8) ;
    }

  }

  Widget roomSettingsBottomSheet() => RoomSettingsModal();
}
