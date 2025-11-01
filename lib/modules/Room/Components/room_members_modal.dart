import 'package:LikLok/models/AppUser.dart';
import 'package:LikLok/models/ChatRoom.dart';
import 'package:LikLok/models/RoomMember.dart';
import 'package:LikLok/shared/network/remote/AppUserServices.dart';
import 'package:LikLok/shared/network/remote/ChatRoomService.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/Follower.dart';
import '../../../shared/components/Constants.dart';
import '../../../shared/styles/colors.dart';

class RoomMembersModal extends StatefulWidget {
  late final List<RoomMember> members ;
  RoomMembersModal({super.key, required this.members});

  @override
  State<RoomMembersModal> createState() => _RoomMembersModalState();
}

class _RoomMembersModalState extends State<RoomMembersModal> {
  AppUser? user ;
  ChatRoom? room ;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setState(() {
      user = AppUserServices().userGetter();
      room = ChatRoomService().roomGetter();

      //widget.members = room!.widget.members ;
    });
  }


  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
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
                Expanded(child: Text('room_members'.tr , style: TextStyle(color: Colors.black , fontSize: 20.0), textAlign: TextAlign.center,))
              ],
            ),
            Expanded(
              child: ListView.separated(itemBuilder: (ctx , index) =>itemListBuilder(index) ,
                  separatorBuilder: (ctx , index) =>itemSperatorBuilder(), itemCount: widget.members.length),
            ),
          ],
        ),
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
                  backgroundColor: widget.members[index].mic_user_gender == 0 ? MyColors.blueColor : MyColors.pinkColor ,

                  backgroundImage: widget.members[index].mic_user_img != "" ?
                  CachedNetworkImageProvider('${ASSETSBASEURL}AppUsers/${widget.members![index].mic_user_img}') : null,
                  radius: 25,
                  child: widget.members[index].mic_user_img == "" ?
                  Text(widget.members[index].mic_user_name!.toUpperCase().substring(0 , 1) +
                      (widget.members[index].mic_user_name!.contains(" ") ? widget.members![index].mic_user_name!.substring(widget.members![index].mic_user_name!.indexOf(" ")).toUpperCase().substring(1 , 2) : ""),
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
                    Text(widget.members[index].mic_user_name! , style: TextStyle(color: MyColors.whiteColor , fontSize: 18.0),),
                    const SizedBox(width: 5.0,),
                    CircleAvatar(
                      backgroundColor: widget.members[index].mic_user_gender == 0 ? MyColors.blueColor : MyColors.pinkColor ,
                      radius: 10.0,
                      child: widget.members[index].mic_user_gender == 0 ?  const Icon(Icons.male , color: Colors.white, size: 15.0,) :  const Icon(Icons.female , color: Colors.white, size: 15.0,),
                    )
                  ],
                ),
                Row(

                  children: [
                    Image(image: CachedNetworkImageProvider(ASSETSBASEURL + 'Levels/' + widget.members![index].mic_user_share_level!) , width: 35,),
                    const SizedBox(width: 5.0,),
                    Image(image: CachedNetworkImageProvider(ASSETSBASEURL + 'Levels/' + widget.members![index].mic_user_karizma_level!) , width: 35,),
                    const SizedBox(width: 5.0,),
                    Image(image: CachedNetworkImageProvider(ASSETSBASEURL + 'Levels/' + widget.members![index].mic_user_charging_level!) , width: 35,),

                  ],
                ),

                Text("ID:${widget.members[index].mic_user_tag}" , style: TextStyle(color: MyColors.unSelectedColor , fontSize: 11.0),),


              ],

            ),

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

}
