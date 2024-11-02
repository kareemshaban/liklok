import 'package:LikLok/helpers/RoomBasicDataHelper.dart';
import 'package:LikLok/models/AppUser.dart';
import 'package:LikLok/models/ChatRoom.dart';
import 'package:LikLok/models/RoomAdmin.dart';
import 'package:LikLok/modules/Room/Components/add_admin_modal.dart';
import 'package:LikLok/shared/network/remote/AppUserServices.dart';
import 'package:LikLok/shared/network/remote/ChatRoomService.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../../../models/Follower.dart';
import '../../../shared/components/Constants.dart';
import '../../../shared/styles/colors.dart';

class RoomAdminsModal extends StatefulWidget {
  const RoomAdminsModal({super.key});

  @override
  State<RoomAdminsModal> createState() => _RoomAdminsModalState();
}

class _RoomAdminsModalState extends State<RoomAdminsModal> {
    List<RoomAdmin>? admins = [];
    AppUser? user ;
    ChatRoom? room ;
    bool _isLoading = false ;

    @override
    void initState() {
      // TODO: implement initState
      super.initState();

      setState(() {
        user = AppUserServices().userGetter();
        room = ChatRoomService().roomGetter();
        admins = room!.admins ;
      });
    }

  Future<void> _refresh()async{
    await loadData() ;
  }
  loadData() async {
    ChatRoom? res = await ChatRoomService().openRoomById(room!.id);
    setState(() {
      setState(() {
        room = res ;
        admins = room!.admins ;
      });
      ChatRoomService().roomSetter(room!);
    });
  }

  Widget build(BuildContext context) {
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
              Expanded(child: Text('room_settings_room_admins'.tr , style: TextStyle(color: Colors.black , fontSize: 20.0), textAlign: TextAlign.center,)),
              IconButton(onPressed: (){
                Navigator.pop(context);
                showModalBottomSheet(
                    isScrollControlled: true ,
                    context: context,
                    builder: (ctx) => addAdminsBottomSheet());

              }, icon: Icon(Icons.add_circle_outline , color: Colors.black, size: 25.0,)),
            ],
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refresh,
              color: MyColors.primaryColor,
              child: ListView.separated(itemBuilder: (ctx , index) =>itemListBuilder(index) ,
                  separatorBuilder: (ctx , index) =>itemSperatorBuilder(), itemCount: admins!.length),
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
                  backgroundColor: admins![index].mic_user_gender == 0 ? MyColors.blueColor : MyColors.pinkColor ,

                  backgroundImage: admins![index].mic_user_img != "" ?
                  CachedNetworkImageProvider('${ASSETSBASEURL}AppUsers/${admins![index].mic_user_img}') : null,
                  radius: 25,
                  child: admins![index].mic_user_img == "" ?
                  Text(admins![index].mic_user_name!.toUpperCase().substring(0 , 1) +
                      (admins![index].mic_user_name!.contains(" ") ? admins![index].mic_user_name!.substring(admins![index].mic_user_name!.indexOf(" ")).toUpperCase().substring(1 , 2) : ""),
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
                    Text(admins![index].mic_user_name! , style: TextStyle(color: MyColors.whiteColor , fontSize: 16.0),),
                    const SizedBox(width: 5.0,),
                    CircleAvatar(
                      backgroundColor: admins![index].mic_user_gender == 0 ? MyColors.blueColor : MyColors.pinkColor ,
                      radius: 10.0,
                      child: admins![index].mic_user_gender == 0 ?  const Icon(Icons.male , color: Colors.white, size: 15.0,) :  const Icon(Icons.female , color: Colors.white, size: 15.0,),
                    )
                  ],
                ),
                Row(

                  children: [
                    Image(image: CachedNetworkImageProvider(ASSETSBASEURL + 'Levels/' + admins![index].mic_user_share_level!) , width: 35,),
                    const SizedBox(width: 10.0,),
                    Image(image: CachedNetworkImageProvider(ASSETSBASEURL + 'Levels/' + admins![index].mic_user_karizma_level!) , width: 35,),
                    const SizedBox(width: 10.0,),
                    Image(image: CachedNetworkImageProvider(ASSETSBASEURL + 'Levels/' + admins![index].mic_user_charging_level!) , width: 35,),

                  ],
                ),

                Text("ID:${admins![index].mic_user_tag}" , style: TextStyle(color: Colors.black , fontSize: 11.0),),


              ],

            ),
            Expanded(child:
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                  onPressed: (){
                    // uploadCoverPhoto();
                  removeAdmin(admins![index].user_id);
                  },
                  style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 8.0) , backgroundColor: Colors.white ,
                  ),
                  icon: _isLoading
                      ? Container(
                    width: 18,
                    height: 18,
                    padding: const EdgeInsets.all(2.0),
                    child: const CircularProgressIndicator(
                      color: Colors.black54,
                      strokeWidth: 3,
                    ),
                  )
                      :  Icon(Icons.remove_circle_outline , color: Colors.red , size: 18.0,),
                  label:  Text('remove_btn'.tr , style: TextStyle(color: Colors.red , fontSize: 13.0), ),
                )
              ],
            )
            )

          ]),
      Container(
        width: double.infinity,
        height: 1.0,
        color: MyColors.whiteColor,
        margin: EdgeInsetsDirectional.only(start: 50.0),
        child: const Text(""),
      )
    ],
  );

  Widget itemSperatorBuilder() => SizedBox(height: 5.0,);

    Widget addAdminsBottomSheet() => AddAdminModal();

    removeAdmin(user_id) async{
      setState(() {
        _isLoading = true ;
      });
      ChatRoom? res = await ChatRoomService().removeChatRoomAdmin(user_id, room!.id);
      setState(() {
        _isLoading = false ;
        room = res ;
        admins = room!.admins ;
      });
      ChatRoomService().roomSetter(room!);

      Fluttertoast.showToast(
          msg: 'admin_deleted'.tr,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black26,
          textColor: Colors.orange,
          fontSize: 16.0
      );
    }

}
