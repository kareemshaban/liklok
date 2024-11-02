import 'package:LikLok/helpers/RoomBasicDataHelper.dart';
import 'package:LikLok/helpers/RoomHelper.dart';
import 'package:LikLok/models/AppUser.dart';
import 'package:LikLok/models/ChatRoom.dart';
import 'package:LikLok/models/RoomTheme.dart';
import 'package:LikLok/shared/components/Constants.dart';
import 'package:LikLok/shared/network/remote/AppUserServices.dart';
import 'package:LikLok/shared/network/remote/ChatRoomService.dart';
import 'package:LikLok/shared/styles/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemesModal extends StatefulWidget {
  const ThemesModal({super.key});

  @override
  State<ThemesModal> createState() => _ThemesModalState();
}

class _ThemesModalState extends State<ThemesModal> {
  List<RoomTheme> themes = [] ;
  AppUser? user ;
  ChatRoom? room ;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      user = AppUserServices().userGetter();
      room = ChatRoomService().roomGetter();
      RoomBasicDataHelper? helper = ChatRoomService().roomBasicDataHelperGetter();
      themes = helper!.themes ;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      decoration: BoxDecoration(color: Colors.white.withAlpha(180),
          borderRadius: BorderRadius.only(topRight: Radius.circular(20.0) , topLeft: Radius.circular(15.0)) ,
          border: Border(top: BorderSide(width: 4.0, color: MyColors.secondaryColor),) ),
      child:  GridView.count(
        shrinkWrap: true,
        crossAxisCount: 3,
        childAspectRatio: .7,

        children:
        themes.map((theme) => themeListItem(theme)).toList(),
        mainAxisSpacing: 10.0,
      ),

    );
  }

  Widget themeListItem(theme) => Container(
    child: Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Column(
          children: [
            GestureDetector(
                onTap: () {
                   changeTheme(theme.id);

                },
                child: Image(image: CachedNetworkImageProvider(ASSETSBASEURL + 'Themes/' + theme.img) , width: 100.0,))
          ],
        ),
        theme.id == room!.themeId ? Icon(Icons.check_circle , color: MyColors.primaryColor , size: 30,) : SizedBox(height: 1,)
      ],
    ),
  );

  changeTheme(theme_id) async{
    await RoomHelper(room_id: room!.id , bg: theme_id).changeTheme();

  }
  Widget musicListItem(theme) => Container(
    child: Text('mmmmmm')
  );
}
