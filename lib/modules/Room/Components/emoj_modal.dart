import 'package:LikLok/helpers/MicHelper.dart';
import 'package:LikLok/helpers/RoomBasicDataHelper.dart';
import 'package:LikLok/models/AppUser.dart';
import 'package:LikLok/models/ChatRoom.dart';
import 'package:LikLok/models/Emossion.dart';
import 'package:LikLok/shared/components/Constants.dart';
import 'package:LikLok/shared/network/remote/AppUserServices.dart';
import 'package:LikLok/shared/network/remote/ChatRoomService.dart';
import 'package:LikLok/shared/styles/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class EmojModal extends StatefulWidget {
  const EmojModal({super.key});

  @override
  State<EmojModal> createState() => _EmojModalState();
}

class _EmojModalState extends State<EmojModal> {
  List<Emossion> emossions = [];
  AppUser? user ;
  ChatRoom? room ;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    RoomBasicDataHelper? helper = ChatRoomService().roomBasicDataHelperGetter();
    emossions = helper!.emossions;
    user = AppUserServices().userGetter();
    room = ChatRoomService().roomGetter();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      decoration: BoxDecoration(color: Colors.white.withAlpha(180),
          borderRadius: BorderRadius.only(topRight: Radius.circular(20.0) , topLeft: Radius.circular(15.0)) ,
          border: Border(top: BorderSide(width: 4.0, color: MyColors.secondaryColor),) ),
      child:      GridView.count(
        shrinkWrap: true,
        crossAxisCount: 5,
        children:
        emossions.map((emoj) => emojListItem(emoj)).toList(),
        mainAxisSpacing: 0.0,
      ),

    );
  }

  Widget emojListItem(emoj) => Container(
    child: GestureDetector(
        onTap: (){
          useEmoj(ASSETSBASEURL + 'Emossions/' + emoj.img);
        },
      child: Column(
        children: [
          Image(image: CachedNetworkImageProvider(ASSETSBASEURL + 'Emossions/' + emoj.icon) , width: 60.0,)
        ],
      ),
    ),
  );

  useEmoj(emoj) async {
    if(room!.mics!.where((element) => element.user_id == user!.id).length > 0){
      await MicHelper(user_id: user!.id , room_id: room!.id , mic: room!.mics!.where((element) => element.user_id == user!.id).toList()[0].order ).showEmoj(emoj);
    } else {
      Fluttertoast.showToast(
          msg: 'you should be on mic !',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black26,
          textColor: Colors.orange,
          fontSize: 16.0);
    }
  }
}
