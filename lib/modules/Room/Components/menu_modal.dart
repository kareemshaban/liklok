import 'dart:math';
import 'package:LikLok/modules/Room/Components/games_modal.dart';
import 'package:LikLok/modules/Room/Components/room_info_modal.dart';
import 'package:LikLok/modules/Room/Components/room_settings_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:LikLok/helpers/ChatRoomMessagesHelper.dart';
import 'package:LikLok/models/AppUser.dart';
import 'package:LikLok/models/ChatRoom.dart';
import 'package:LikLok/modules/Room/Components/lucky_case_modal.dart';
import 'package:LikLok/modules/Room/Components/themes_modal.dart';
import 'package:LikLok/shared/network/remote/AppUserServices.dart';
import 'package:LikLok/shared/network/remote/ChatRoomService.dart';
import 'package:LikLok/shared/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import '../../../helpers/zego_handler/internal/internal.dart';
import '../../../models/RoomMember.dart';
import '../../../shared/components/Constants.dart';
import 'musics_modal.dart';

class MenuModal extends StatefulWidget {
  final ZegoExpressEngine zegoEngine;
  final ScrollController scrollController;
  final ZegoMediaPlayer audioPlayer ;

  const MenuModal({super.key, required this.scrollController, required this.zegoEngine, required this.audioPlayer});

  @override
  State<MenuModal> createState() => _MenuModalState();
}

class _MenuModalState extends State<MenuModal> {
  ChatRoom? room;

  AppUser? user;

  bool isAdmin = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      room = ChatRoomService().roomGetter();
      user = AppUserServices().userGetter();
      isAdmin = room!.userId == user!.id;
    });
    print('room!.isCounter');
    print(room!.isCounter);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: 300,
        padding: EdgeInsets.symmetric(vertical: 20.0),
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(180),
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20.0),
            topLeft: Radius.circular(15.0),
          ),
          border: Border(
            top: BorderSide(width: 4.0, color: MyColors.secondaryColor),
          ),
        ),
        child: Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                user!.id == room!.userId
                    ? Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                            showModalBottomSheet(
                              context: context,
                              builder: (ctx) => ThemesBottomSheet(),
                            );
                          },
                          child: Column(
                            children: [
                              Image(
                                image: AssetImage('assets/images/theme.png'),
                                width: 40.0,
                              ),
                              SizedBox(height: 8.0),
                              Text(
                                'menu_theme'.tr,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : Container(),
                Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      if (room!.mics!
                              .where((element) => element.user_id == user!.id)
                              .toList()
                              .length >
                          0) {
                        Navigator.pop(context);
                        showModalBottomSheet(
                          context: context,
                          builder: (ctx) => MusicBottomSheet(),
                        );
                      } else {
                        Fluttertoast.showToast(
                          msg: 'should_be_on_mic'.tr,
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.black26,
                          textColor: Colors.orange,
                          fontSize: 16.0,
                        );
                      }
                    },
                    child: Column(
                      children: [
                        Image(
                          image: AssetImage('assets/images/music.png'),
                          width: 40.0,
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          'menu_music'.tr,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      numberGame();
                    },
                    child: Column(
                      children: [
                        Image(
                          image: AssetImage('assets/images/numbers.png'),
                          width: 40.0,
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          'menu_lucky_number'.tr,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      nurdGame();
                    },
                    child: Column(
                      children: [
                        Image(
                          image: AssetImage('assets/images/3d-dice.png'),
                          width: 40.0,
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          'menu_dice'.tr,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 15.0),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      showModalBottomSheet(
                        context: context,
                        builder: (ctx) => LuckyCaseBottomSheet(),
                      );
                    },
                    child: Column(
                      children: [
                        Image(
                          image: AssetImage('assets/images/luckyCaseIcon.png'),
                          width: 40.0,
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          'menu_lucky_bag'.tr,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      showModalBottomSheet(
                        isScrollControlled: true,
                        context: context,
                        builder: (ctx) => roomSettingsBottomSheet(),
                      );
                    },
                    child: Column(
                      children: [
                        Image(
                          image: AssetImage('assets/images/settings.png'),
                          width: 40.0,
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          'menu_settings'.tr,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                user!.id == room!.userId
                    ? Expanded(
                        child: GestureDetector(
                          onTap: () {
                            toggleRoomCounter();
                          },
                          child: Column(
                            children: [
                              Image(
                                image: AssetImage('assets/images/counter.png'),
                                width: 40.0,
                              ),
                              SizedBox(height: 8.0),
                              Text(
                                room!.isCounter == 0
                                    ? 'counter_off'.tr
                                    : 'counter_on'.tr,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : Container(),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      paperGame();
                    },
                    child: Column(
                      children: [
                        Image(
                          image: AssetImage('assets/images/game.png'),
                          width: 40.0,
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          'game1'.tr,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 15.0),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      showModalBottomSheet(
                        context: context,
                        builder: (ctx) => GamesBottomSheet(),
                      );
                    },
                    child: Column(
                      children: [
                        Image(
                          image: AssetImage('assets/images/game_icon.png'),
                          width: 40.0,
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          'games'.tr,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {},
                    child: Column(children: []),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {},
                    child: Column(children: []),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {},
                    child: Column(children: []),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget ThemesBottomSheet() => ThemesModal();

  Widget MusicBottomSheet() => MusicsModal(zegoEngine: widget.zegoEngine, audioPlayer: widget.audioPlayer,);

  Widget LuckyCaseBottomSheet() => LuckyCaseModal();

  nurdGame() async {
    RoomMember member = room!.members!
        .where((element) => element.user_id == user!.id)
        .toList()[0];

    String pubble = "";
    if (member.pubble != "") {
      pubble = ASSETSBASEURL + 'Designs/Motion/' + member.pubble.toString();
    }
    var rng = Random();
    int rand = rng.nextInt(6);
    await ChatRoomMessagesHelper(
      room_id: room!.id,
      user_id: user!.id,
      message: (rand + 1).toString(),
      type: 'NURD',
      user_name: user!.name,
      user_share_level_img: user!.share_level_icon,
      user_img: user!.img,
      vip: user!.vips!.length > 0 ? user!.vips![0].icon : "",
      pubble: pubble,
      badges: member.badges,
    ).sendRoomEvent();
    Future.delayed(Duration(seconds: 2)).then(
      (value) => {
        widget.scrollController.animateTo(
          widget.scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 1),
          curve: Curves.fastOutSlowIn,
        ),
      },
    );
    Navigator.pop(context);
  }

  numberGame() async {
    RoomMember member = room!.members!
        .where((element) => element.user_id == user!.id)
        .toList()[0];

    String pubble = "";
    if (member.pubble != "") {
      pubble = ASSETSBASEURL + 'Designs/Motion/' + member.pubble.toString();
    }
    var rng = Random();
    int num1 = rng.nextInt(10);
    int num2 = rng.nextInt(10);
    int num3 = rng.nextInt(10);
    String val = num1.toString() + num2.toString() + num3.toString();
    await ChatRoomMessagesHelper(
      room_id: room!.id,
      user_id: user!.id,
      message: val,
      type: 'LUCKY',
      user_name: user!.name,
      user_share_level_img: user!.share_level_icon,
      user_img: user!.img,
      vip: user!.vips!.length > 0 ? user!.vips![0].icon : "",
      pubble: pubble,
      badges: member.badges,
    ).sendRoomEvent();
    Future.delayed(Duration(seconds: 2)).then(
      (value) => {
        widget.scrollController.animateTo(
          widget.scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 1),
          curve: Curves.fastOutSlowIn,
        ),
      },
    );

    Navigator.pop(context);
  }

  paperGame() async {
    RoomMember member = room!.members!
        .where((element) => element.user_id == user!.id)
        .toList()[0];

    String pubble = "";
    if (member.pubble != "") {
      pubble = ASSETSBASEURL + 'Designs/Motion/' + member.pubble.toString();
    }
    var rng = Random();
    int rand = rng.nextInt(3);
    String msg = "";
    if (rand == 0)
      msg = 'paper';
    else if (rand == 1)
      msg = 'stone';
    else if (rand == 2)
      msg = 'knife';
    else
      msg = 'knife';
    await ChatRoomMessagesHelper(
      room_id: room!.id,
      user_id: user!.id,
      message: msg,
      type: 'PAPER',
      user_name: user!.name,
      user_share_level_img: user!.share_level_icon,
      user_img: user!.img,
      vip: user!.vips!.length > 0 ? user!.vips![0].icon : "",
      pubble: pubble,
      badges: member.badges,
    ).sendRoomEvent();
    Future.delayed(Duration(seconds: 2)).then(
      (value) => {
        widget.scrollController.animateTo(
          widget.scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 1),
          curve: Curves.fastOutSlowIn,
        ),
      },
    );
    Navigator.pop(context);
  }

  toggleRoomCounter() async {
    ChatRoom? res = await ChatRoomService().toggleRoomCounter(room!.id);
    await FirebaseFirestore.instance.collection("mic-counter").add({
      'room_id': room!.id,
    });

    setState(() {
      room = res;
    });
    ChatRoomService().roomSetter(room!);
  }

  Widget roomSettingsBottomSheet() =>
      isAdmin ? RoomSettingsModal() : RoomInfoModal();

  Widget GamesBottomSheet() => GamesModal();
}
