import 'package:LikLok/helpers/DesigGiftHelper.dart';
import 'package:LikLok/helpers/ExitRoomHelper.dart';
import 'package:LikLok/helpers/MicHelper.dart';
import 'package:LikLok/models/AppUser.dart';
import 'package:LikLok/models/ChatRoom.dart';
import 'package:LikLok/models/Design.dart';
import 'package:LikLok/models/Mall.dart';
import 'package:LikLok/models/Medal.dart';
import 'package:LikLok/models/Relation.dart';
import 'package:LikLok/modules/InnerProfile/Inner_Profile_Screen.dart';
import 'package:LikLok/modules/Room/Components/gift_modal.dart';
import 'package:LikLok/modules/Room/Room_Screen.dart';
import 'package:LikLok/modules/chat/chat.dart';
import 'package:LikLok/shared/components/Constants.dart';
import 'package:LikLok/shared/network/remote/AppUserServices.dart';
import 'package:LikLok/shared/network/remote/ChatRoomService.dart';
import 'package:LikLok/shared/styles/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svga/flutter_svga.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';

class SmallProfileModal extends StatefulWidget {
  final AppUser? visitor ;
  final int? type ;
  final RtcEngine? engine ;
  const SmallProfileModal({super.key , required this.visitor , this.type , this.engine});

  @override
  State<SmallProfileModal> createState() => _SmallProfileModalState();
}

class _SmallProfileModalState extends State<SmallProfileModal> {
  AppUser? user ;
  AppUser? currentUser ;
  String frame = "" ;
  String bg = "" ;
  int type = 0 ; // 0 from any where 1 from room
  var passwordController = TextEditingController();
  ChatRoom? room ;
  List<Design> designs = [] ;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setState(() {
      user = widget.visitor ;
      currentUser = AppUserServices().userGetter();
      if(widget.type != null){
        type = widget.type! ;
        room = ChatRoomService().roomGetter();
      } else {
        type = 0 ;
        room = null ;
      }
    });
    getDesigns();
    if(user!.vips!.length > 0){
      List<Mall>? vipDesigns = user!.vips![0].designs;

      final b = vipDesigns!.where((element) => int.parse(element.category_id.toString())  == 9).toList()[0].icon;
      setState(() {
        bg = b ;
      });
    }


  }
  getDesigns () async {
    DesignGiftHelper helper = await AppUserServices().getMyDesigns(user!.id);
    setState(() {
       designs = helper.designs! ;
      // gifts = helper.gifts! ;

    });

    if(helper.designs!.where((element) => (element.category_id == 4 && element.isDefault == 1)).toList().length > 0){
      String icon = helper.designs!.where((element) => (element.category_id == 4 && element.isDefault == 1)).toList()[0].motion_icon ;

      setState(() {
      //  designs = helper.designs! ;
        frame = ASSETSBASEURL + 'Designs/Motion/' + icon +'?raw=true' ;

      });
    }
  }
  Widget getVipProfileFrame(){
    if(user!.vips!.length > 0){
      List<Mall>? vipDesigns = user!.vips![0].designs;
      final profile_frame = vipDesigns!.where((element) => element.category_id == 8).toList()[0].motion_icon;
      return   Transform.translate(
          offset: Offset(0 , -160),
          child: SVGAEasyPlayer(resUrl:(ASSETSBASEURL + 'Designs/Motion/' + profile_frame)));
    } else {
      return SizedBox();
    }

  }
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: MediaQuery.sizeOf(context).height * .38,
          padding: EdgeInsets.only(top: 10.0),
          decoration: BoxDecoration(color:  Colors.white.withAlpha(210)  ,
              borderRadius: BorderRadius.only(topRight: Radius.circular(20.0) , topLeft: Radius.circular(20.0)) ,
              border: Border(top: BorderSide(width: 4.0, color: MyColors.secondaryColor),),
              image: bg != "" ? DecorationImage(image: CachedNetworkImageProvider(ASSETSBASEURL + 'Designs/' + bg) , fit: BoxFit.cover ,
              colorFilter:  ColorFilter.mode(Colors.black54, BlendMode.lighten)) : null
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      PopupMenuButton<int>(
                        color: Colors.white,
                        onSelected: (item) => {
                          if(item == 0){
                            reportUser()
                          } else {
                            blockUser()
                          }
                        },
                        iconColor: Colors.black,
                        iconSize: 25.0,
                        itemBuilder: (context) => [
                          PopupMenuItem<int>(value: 0, child: Row(
                            children: [
                              Icon(Icons.block , color: MyColors.whiteColor , size: 18.0,),
                              SizedBox(width: 5.0,),
                              Text("inner_report".tr , style: TextStyle(color: MyColors.whiteColor , fontSize: 15.0),)
                            ],
                          )),
                          PopupMenuItem<int>(value: 1, child: Row(
                            children: [
                              Icon(Icons.report , color: MyColors.whiteColor , size: 18.0,),
                              SizedBox(width: 5.0,),
                              Text("inner_block".tr , style: TextStyle(color: MyColors.whiteColor , fontSize: 15.0),)
                            ],
                          )),
                        ],
                      ),

                    ],
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Stack(
                          alignment: Alignment.center,

                          children: [
                            CircleAvatar(
                              backgroundColor: user!.gender == 0 ? MyColors.blueColor : MyColors.pinkColor ,
                              backgroundImage: user?.img != "" ?  CachedNetworkImageProvider(getUserImage()!) : null,
                              radius: 35,
                              child: user?.img== "" ?
                              Text(user!.name.toUpperCase().substring(0 , 1) +
                                  (user!.name.contains(" ") ? user!.name.substring(user!.name.indexOf(" ")).toUpperCase().substring(1 , 2) : ""),
                                style: const TextStyle(color: Colors.white , fontSize: 24.0 , fontWeight: FontWeight.bold),) : null,
                            ),
                            Container(height: 100.0, width: 100.0, child: frame != "" ? SVGAEasyPlayer(   resUrl: frame) : null),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                     IconButton(onPressed: (){ openUserProfile();}, icon: Icon(Icons.person  , color: Colors.black,)),
                    ],
                  )
                ],
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(user!.name , style: TextStyle(color: Colors.black , fontSize: 15.0 , fontWeight: FontWeight.bold),),
                      const SizedBox(width: 5.0,),
                      CircleAvatar(
                        backgroundColor: user!.gender == 0 ? MyColors.blueColor : MyColors.pinkColor ,
                        radius: 12.0,
                        child: user!.gender == 0 ?  const Icon(Icons.male , color: Colors.white, size: 15.0,) :  const Icon(Icons.female , color: Colors.white, size: 15.0,),
                      )
                    ],
                  ),
                  SizedBox(height: 5.0,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      user!.vips!.length > 0 ?  Image(image: CachedNetworkImageProvider('${ASSETSBASEURL}VIP/${user!.vips![0].icon}') , width: 50,) : Container(),
                      user!.vips!.length > 0 ?  const SizedBox(width: 5.0,):  Container(),
                      Image(image: CachedNetworkImageProvider('${ASSETSBASEURL}Levels/${user!.share_level_icon}') , width: 50,),
                      const SizedBox(width: 5.0,),
                      Image(image: CachedNetworkImageProvider('${ASSETSBASEURL}Levels/${user!.karizma_level_icon}') , width: 50,),
                      const SizedBox(width: 5.0,),
                      Image(image: CachedNetworkImageProvider('${ASSETSBASEURL}Levels/${user!.charging_level_icon}') , width: 50,),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      user!.vips!.length > 0  && designs.where((element) => element.category_id == 10).toList().length > 0  ?  Container(width: 50.0 , height: 50.0, child: SVGAEasyPlayer( resUrl: ASSETSBASEURL + 'Designs/Motion/' + designs.where((element) => element.category_id == 10).toList()[0].motion_icon +'?raw=true')) : Container(),
                      Row(
                          children:  user!.medals!.map((medal) =>  getMedalItem(medal)).toList()

                      ),
                      Row(
                          children:  user!.relations!.map((medal) =>  getRelationItem(medal)).toList()

                      ),



                    ],
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("ID:" + user!.tag , style: TextStyle(color: MyColors.whiteColor , fontSize: 15.0),),
                          const SizedBox(width: 5.0,),
                          Icon(Icons.copy_outlined , color: MyColors.whiteColor , size: 20.0,)
                        ],
                      ),
                      const SizedBox(width: 15.0,),
                      Row(

                        children: [
                          Text("followers_title".tr, style: TextStyle(color: MyColors.whiteColor , fontSize: 15.0),),


                          Icon(Icons.people_outlined , color: MyColors.whiteColor , size: 20.0,),

                          Text(user!.followers!.length.toString(), style: TextStyle(color: MyColors.whiteColor , fontSize: 15.0),),

                        ],
                      ),
                      const SizedBox(width: 10.0,),

                    ],
                  ),


                  Text(user!.status !="" ? user!.status  : "Nothing here" , style: TextStyle(color: MyColors.unSelectedColor , fontSize: 15.0),),


                  const SizedBox(height: 5.0,),
                  user!.id != currentUser!.id ?
                  type == 0 ? Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            getFollowBtn()
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: (){openChat();},
                                child: Image(image: AssetImage('assets/images/message.png') , width: 70.0)),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: (){openUserRoom();}, child: Image(image: AssetImage('assets/images/home.png') , width: 70.0)),
                          ],
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: (){trackUser();},
                          child: Column(
                            children: [
                              Image(image: AssetImage('assets/images/tracking.png') , width: 70.0),
                            ],
                          ),
                        ),
                      ),

                    ],
                  ) : Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            getFollowBtn()
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: (){mention();},
                                child: Image(image: AssetImage('assets/images/mention.png') , width: 70.0)),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: (){sendGift();}, child: Image(image: AssetImage('assets/images/profile_gift.png') , width: 70.0)),
                          ],
                        ),
                      ),

                    ],
                  ) : Container() ,


                ],
              )


            ],
          )

        ),
        getVipProfileFrame()
      ],
    );
  }

  reportUser() async{
    AppUser? currentUser = AppUserServices().userGetter();
    await AppUserServices().reportUser(currentUser!.id, user!.id);
    Navigator.pop(context);
  }
  blockUser() async{
    AppUser? currentUser = AppUserServices().userGetter();
    await AppUserServices().blockUser(currentUser!.id, user!.id);
    currentUser = await AppUserServices().getUser(currentUser!.id);
    AppUserServices().userSetter(currentUser!);
    Navigator.pop(context);
  }
  String? getUserImage(){
    if(user!.img.startsWith('https')){
      return user!.img.toString() ;
    } else {
      return '${ASSETSBASEURL}AppUsers/${user?.img}' ;
    }
  }
  openUserRoom() async{

    ChatRoom? res = await ChatRoomService().openRoomByAdminId(user!.id);
    if(res != null){
      await checkForSavedRoom(res);
      if(res.password.isEmpty || res.userId == currentUser!.id){
        ChatRoomService().roomSetter(res);
        Navigator.push(context, MaterialPageRoute(builder: (context) => RoomScreen(),));
      } else {
        _displayTextInputDialog(context , res);
      }

    } else {
      print('clicked');
      Fluttertoast.showToast(
          msg: 'inner_msg_no_room'.tr,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black26,
          textColor: Colors.orange,
          fontSize: 16.0
      );
    }


  }

  checkForSavedRoom(ChatRoom room) async {
    ChatRoom? savedRoom = ChatRoomService().savedRoomGetter();
    if(savedRoom != null){
      if(savedRoom.id == room.id){

      } else {
        // close the savedroom
        ChatRoomService().savedRoomSetter(null);
        await ChatRoomService.engine!.leaveChannel();
        await ChatRoomService.engine!.release();
        MicHelper( user_id:  user!.id , room_id:  savedRoom!.id , mic: 0).leaveMic();
        ExitRoomHelper(user!.id , savedRoom.id);

      }
    }

  }

  Future<void> _displayTextInputDialog(BuildContext context , ChatRoom room) async {
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
                    if(passwordController.text == room.password){
                      ChatRoomService().roomSetter(room);
                      Navigator.push(context, MaterialPageRoute(builder: (context) => RoomScreen(),));
                    } else {
                      Fluttertoast.showToast(
                          msg: "room_password_wrong".tr,
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.black26,
                          textColor: Colors.orange,
                          fontSize: 16.0
                      );
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

  Widget getFollowBtn(){
    AppUser? currentUser = AppUserServices().userGetter();
    if(currentUser!.followings!.where((element) => element.follower_id == user!.id).length == 0 ){
      return  GestureDetector(onTap: () {followUser();},  child: Image(image: AssetImage('assets/images/add-user.png') , width: 70.0,));
    } else {
      return  GestureDetector(onTap: () {unFollowUser();},  child: Image(image: AssetImage('assets/images/remove-user.png') , width: 70.0,));
    }
  }

  followUser() async{
    AppUser? currentUser = AppUserServices().userGetter();
    AppUser? res = await AppUserServices().followUser(currentUser!.id, user!.id);

    AppUserServices().userSetter(res!);
    Fluttertoast.showToast(
        msg: 'inner_msg_followed'.tr,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black26,
        textColor: Colors.orange,
        fontSize: 16.0
    );
    Navigator.pop(context);
  }
  unFollowUser() async{
    AppUser? currentUser = AppUserServices().userGetter();
    AppUser? res = await AppUserServices().unfollowkUser(currentUser!.id, user!.id);
    AppUserServices().userSetter(res!);
    Fluttertoast.showToast(
        msg: 'inner_msg_unfollowed'.tr,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black26,
        textColor: Colors.orange,
        fontSize: 16.0
    );
    Navigator.pop(context);
  }

  openChat(){
    print('visitor');
    print(user);

    Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen(receiverUserEmail: user!.email, receiverUserID: user!.id , receiver: user!,),));
  }

  trackUser() async {
    ChatRoom? res = await ChatRoomService().trackUser(user!.id);
    if(res != null){
      await checkForSavedRoom(res);
      if(res.password.isEmpty|| res.userId == currentUser!.id){
        ChatRoomService().roomSetter(res);
        Navigator.push(context, MaterialPageRoute(builder: (context) => RoomScreen(),));
      } else {
        _displayTextInputDialog(context , res);
      }

    } else {
      print('clicked');
      Fluttertoast.showToast(
          msg: 'inner_msg_not_any_room'.tr,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black26,
          textColor: Colors.orange,
          fontSize: 16.0
      );
    }
  }
  openUserProfile(){
    if(type == 0){
      Navigator.push(context, MaterialPageRoute(builder: (ctx) =>  InnerProfileScreen(visitor_id: user!.id)));
    } else {
      keepRoom();
    }

  }

  keepRoom() async {
    ChatRoomService().savedRoomSetter(room!);
    ChatRoomService.engine = widget.engine ;
    Navigator.push(
        context ,
        MaterialPageRoute(builder: (context) =>  InnerProfileScreen(visitor_id: user!.id)));
  }

  Widget getMedalItem(Medal medal){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.0 , vertical: 5.0),
      child: Column(
          children:[
            Image(image: CachedNetworkImageProvider('${ASSETSBASEURL}Badges/${medal.icon}') , width: 50, height: 50,),

          ]

      ),
    );
  }
  Widget getRelationItem(RelationModel relation){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.0 , vertical: 5.0),
      child: Column(
          children:[
            Image(image: CachedNetworkImageProvider('${ASSETSBASEURL}Relations/${relation.icon}') , width: 40,),

          ]

      ),
    );
  }
  mention(){
     ChatRoomService.showMsgInput = true ;
     Navigator.pop(context);
  }
  sendGift(){
    Navigator.pop(context);
    showModalBottomSheet(

        context: context,
        builder: (ctx) => GiftModal(reciverId: user!.id,));
  }


}
