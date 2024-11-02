import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:LikLok/models/AppUser.dart';
import 'package:LikLok/models/ChatRoom.dart';
import 'package:LikLok/models/RoomAdmin.dart';
import 'package:LikLok/models/RoomMember.dart';
import 'package:LikLok/shared/components/Constants.dart';
import 'package:LikLok/shared/network/remote/AppUserServices.dart';
import 'package:LikLok/shared/network/remote/ChatRoomService.dart';
import 'package:LikLok/shared/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class AddAdminModal extends StatefulWidget {
  const AddAdminModal({super.key});

  @override
  State<AddAdminModal> createState() => _AddAdminModalState();
}

class _AddAdminModalState extends State<AddAdminModal> {

  List<RoomAdmin>? admins = [];
  List<RoomMember>? members = [];
  AppUser? user ;
  ChatRoom? room ;
  bool _isLoading = false ;

  @override
  Widget build(BuildContext context) {
    setState(() {
      user = AppUserServices().userGetter();
      room = ChatRoomService().roomGetter();
      admins = room!.admins ;
      members = room!.members!.where((element) => element.user_id != room!.userId  ).toList() ;
    });
    loadData() async {
      ChatRoom? res = await ChatRoomService().openRoomById(room!.id);
      setState(() {
        setState(() {
          room = res ;
          admins = room!.admins ;
          members = room!.members!.where((element) => element.user_id != room!.userId  ).toList() ;
        });
        ChatRoomService().roomSetter(room!);
      });
    }

    Future<void> _refresh()async{
      await loadData() ;
    }

    return Container(
      padding: EdgeInsets.symmetric(vertical: 50.0 , horizontal: 10.0),
      color: Colors.white.withAlpha(200),

      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(onPressed: (){
                Navigator.pop(context);
              }, icon: Icon(Icons.arrow_back_ios , color: Colors.black, size: 25.0,)),
              Expanded(child: Text('add_admin_title'.tr , style: TextStyle(color: Colors.black , fontSize: 20.0), textAlign: TextAlign.center,)),
            ],
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refresh,
              color: MyColors.primaryColor,
              child: ListView.separated(itemBuilder: (ctx , index) =>itemListBuilder(index) ,
                  separatorBuilder: (ctx , index) =>itemSperatorBuilder(), itemCount: members!.length),
            ),
          ),

        ],

      ),
    );
  }
  Widget itemListBuilder(index) => Column(
    children: [
      Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              children: [
                CircleAvatar(
                  backgroundColor: members![index].mic_user_gender == 0 ? MyColors.blueColor : MyColors.pinkColor ,

                  backgroundImage: members![index].mic_user_img != "" ?
                  CachedNetworkImageProvider('${ASSETSBASEURL}AppUsers/${members![index].mic_user_img}') : null,
                  radius: 25,
                  child: members![index].mic_user_img == "" ?
                  Text(members![index].mic_user_name!.toUpperCase().substring(0 , 1) +
                      (members![index].mic_user_name!.contains(" ") ? members![index].mic_user_name!.substring(members![index].mic_user_name!.indexOf(" ")).toUpperCase().substring(1 , 2) : ""),
                    style: const TextStyle(color: Colors.white , fontSize: 22.0 , fontWeight: FontWeight.bold),) : null,
                )
              ],
            ),
            const SizedBox(width: 10.0,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(members![index].mic_user_name! , style: TextStyle(color: MyColors.whiteColor , fontSize: 16.0),),
                    const SizedBox(width: 5.0,),
                    CircleAvatar(
                      backgroundColor: members![index].mic_user_gender == 0 ? MyColors.blueColor : MyColors.pinkColor ,
                      radius: 10.0,
                      child: members![index].mic_user_gender == 0 ?  const Icon(Icons.male , color: Colors.white, size: 15.0,) :  const Icon(Icons.female , color: Colors.white, size: 15.0,),
                    )
                  ],
                ),
                Row(

                  children: [
                    Image(image: CachedNetworkImageProvider(ASSETSBASEURL + 'Levels/' + members![index].mic_user_share_level!) , width: 30,),
                    const SizedBox(width: 5.0,),
                    Image(image: CachedNetworkImageProvider(ASSETSBASEURL + 'Levels/' + members![index].mic_user_karizma_level!) , width: 30,),
                    const SizedBox(width: 5.0,),
                    Image(image: CachedNetworkImageProvider(ASSETSBASEURL + 'Levels/' + members![index].mic_user_charging_level!) , width: 30,),

                  ],
                ),

                Text("ID:${members![index].mic_user_tag}" , style: TextStyle(color: MyColors.whiteColor , fontSize: 11.0),),


              ],

            ),
           admins!.where((element) => element.user_id == members![index].user_id).toList().length == 0 ? Expanded(child:
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                  onPressed: (){
                   // uploadCoverPhoto();
                   addAdmin(members![index].user_id);
                  },
                  style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 8.0) , backgroundColor: MyColors.primaryColor ,
                  ),
                  icon: _isLoading
                      ? Container(
                    width: 18,
                    height: 18,
                    padding: const EdgeInsets.all(2.0),
                    child: const CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 3,
                    ),
                  )
                      :  Icon(Icons.add_circle_outline , color: MyColors.darkColor , size: 15.0,),
                  label:  Text('add_admin'.tr , style: TextStyle(color: MyColors.darkColor , fontSize: 15.0), ),
                )
              ],
            )
            ): Container()

          ]),
      Container(
        width: double.infinity,
        height: 1.0,
        color: MyColors.lightUnSelectedColor,
        margin: EdgeInsetsDirectional.only(start: 50.0),
        child: const Text(""),
      )
    ],
  );

  Widget itemSperatorBuilder() => SizedBox(height: 5.0,);

  addAdmin(user_id) async{
    setState(() {
      _isLoading = true ;
    });
    ChatRoom? res = await ChatRoomService().addChatRoomAdmin(user_id, room!.id);
    setState(() {
  _isLoading = false ;
  room = res ;
  admins = room!.admins ;
  members = room!.members!.where((element) => element.user_id != room!.userId  ).toList() ;
  });
  ChatRoomService().roomSetter(room!);

    await FirebaseFirestore.instance.collection("roomAdmins").add({
      'room_id': room!.id,
      'user_id': user_id,
    });
  Fluttertoast.showToast(
  msg: 'admin_added'.tr,
  toastLength: Toast.LENGTH_SHORT,
  gravity: ToastGravity.CENTER,
  timeInSecForIosWeb: 1,
  backgroundColor: Colors.black26,
  textColor: Colors.orange,
  fontSize: 16.0
  );
  }
}
