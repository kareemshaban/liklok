import 'dart:io';

import 'package:LikLok/models/AppUser.dart';
import 'package:LikLok/models/ChatRoom.dart';
import 'package:LikLok/modules/Room/Components/room_admins_modal.dart';
import 'package:LikLok/modules/Room/Components/room_block_modal.dart';
import 'package:LikLok/shared/components/Constants.dart';
import 'package:LikLok/shared/network/remote/AppUserServices.dart';
import 'package:LikLok/shared/network/remote/ChatRoomService.dart';
import 'package:LikLok/shared/styles/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class RoomSettingsModal extends StatefulWidget {
  const RoomSettingsModal({super.key});

  @override
  State<RoomSettingsModal> createState() => _RoomSettingsModalState();
}

class _RoomSettingsModalState extends State<RoomSettingsModal> {
  ChatRoom? room ;
  AppUser? user ;
  bool _isLoading1 =false ;
  bool _isLoading2 =false ;
  bool _isLoading3 =false ;
  bool _isLoading4 =false ;

  List<String> chatRoomCats = ['CHAT' , 'FRIENDS' , 'QURAN' , 'GAMES' , 'ENTERTAINMENT'];
  String selectedChatRoomCategory = 'CHAT' ;

  var roomTitleController = TextEditingController();
  var roomHelloController = TextEditingController();
  var roomPasswordController = TextEditingController();
  File? _image;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      room = ChatRoomService().roomGetter();
      user = AppUserServices().userGetter();
      roomTitleController.text = room!.name ;
      roomHelloController.text = room!.hello_message ;
      roomPasswordController.text = room!.password ;
      selectedChatRoomCategory = room!.subject ;

    });
  }
  @override
  Widget build(BuildContext context) {
    return  SafeArea(
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
                }, icon: Icon(Icons.arrow_back_ios , color: Colors.black, size: 30.0,)),
                Expanded(child: Text('room_settings'.tr , style: TextStyle(color: Colors.black , fontSize: 20.0), textAlign: TextAlign.center,))
              ],
            ),
            SizedBox(height: 10.0,),
            Row(
              children: [
                Container(
                  width: 6.0,
                  height: 30.0,
                  decoration: BoxDecoration(color: MyColors.secondaryColor , borderRadius: BorderRadius.circular(3.0)),
                ),
                SizedBox(width: 10.0,),
                Text("room_settings_room_title".tr, style: TextStyle(color: Colors.black , fontSize: 16.0 , fontWeight: FontWeight.bold),)
              ],
            ),
            SizedBox(height: 8.0,),
            Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
      
                    children: [
                      Container(
                        height: 70.0,
                        child: TextFormField(
                          controller: roomTitleController,
                          style: TextStyle(color: Colors.black),
                          cursorColor: MyColors.primaryColor,
                          maxLength: 20,
                          decoration: InputDecoration(
                              hintText: "room_settings_room_title".tr,
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(color: MyColors.whiteColor)),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0))),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 15.0,),
                ElevatedButton.icon(
                  onPressed: (){
                    updateRoomName();
                  },
                  style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 10.0 , vertical: 5.0) , backgroundColor: MyColors.primaryColor ,
                  ),
                  icon: _isLoading1
                      ? Container(
                    width: 20,
                    height: 20,
                    padding: const EdgeInsets.all(2.0),
                    child: const CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 3,
                    ),
                  )
                      :  Icon(Icons.check_circle , color: MyColors.darkColor , size: 20.0,),
                  label:  Text('room_settings_update'.tr , style: TextStyle(color: MyColors.darkColor , fontSize: 13.0), ),
                )
              ],
            ),
      
      
            Row(
              children: [
                Container(
                  width: 6.0,
                  height: 30.0,
                  decoration: BoxDecoration(color: MyColors.secondaryColor , borderRadius: BorderRadius.circular(3.0)),
                ),
                SizedBox(width: 10.0,),
                Text("room_settings_hello".tr, style: TextStyle(color: Colors.black , fontSize: 16.0 , fontWeight: FontWeight.bold),)
              ],
            ),
            SizedBox(height: 8.0,),
            Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
      
                    children: [
                      Container(
                        height: 70.0,
                        child: TextFormField(
                          controller: roomHelloController,
                          style: TextStyle(color: Colors.black),
                          cursorColor: MyColors.primaryColor,
                          maxLength: 20,
                          decoration: InputDecoration(
                              hintText: "room_settings_room_title".tr,
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(color: MyColors.whiteColor)),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0))),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 15.0,),
                ElevatedButton.icon(
                  onPressed: (){
                    updateRoomHello();
                  },
                  style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 10.0 , vertical: 5.0) , backgroundColor: MyColors.primaryColor ,
                  ),
                  icon: _isLoading2
                      ? Container(
                    width: 20,
                    height: 20,
                    padding: const EdgeInsets.all(2.0),
                    child: const CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 3,
                    ),
                  )
                      :  Icon(Icons.check_circle , color: MyColors.darkColor , size: 20.0,),
                  label:  Text('room_settings_update'.tr , style: TextStyle(color: MyColors.darkColor , fontSize: 13.0), ),
                )
              ],
            ),
            Row(
              children: [
                Container(
                  width: 6.0,
                  height: 30.0,
                  decoration: BoxDecoration(color: MyColors.secondaryColor , borderRadius: BorderRadius.circular(3.0)),
                ),
                SizedBox(width: 10.0,),
                Text("room_settings_room_password".tr, style: TextStyle(color: Colors.black , fontSize: 16.0 , fontWeight: FontWeight.bold),)
              ],
            ),
            SizedBox(height: 8.0,),
            Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
      
                    children: [
                      Container(
                        height: 70.0 ,
                        child: TextFormField(
                          controller: roomPasswordController,
                          style: TextStyle(color: Colors.black),
                          cursorColor: MyColors.primaryColor,
                          maxLength: 20,
                          decoration: InputDecoration(
                            prefixIcon: room!.state == 1 ? Icon(Icons.lock , color: MyColors.primaryColor, size: 20.0,) :
                            Icon(Icons.lock_open , color: MyColors.whiteColor, size: 20.0,) ,
                              hintText: "room_settings_room_password".tr,
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(color: MyColors.whiteColor)),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0))),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 15.0,),
                ElevatedButton.icon(
                  onPressed: (){
                    updateRoomPassword();
                  },
                  style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 10.0 , vertical: 5.0) , backgroundColor: MyColors.primaryColor ,
                  ),
                  icon: _isLoading3
                      ? Container(
                    width: 20,
                    height: 20,
                    padding: const EdgeInsets.all(2.0),
                    child: const CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 3,
                    ),
                  )
                      :  Icon(Icons.check_circle , color: MyColors.darkColor , size: 20.0,),
                  label:  Text('room_settings_update'.tr , style: TextStyle(color: MyColors.darkColor , fontSize: 13.0), ),
                )
              ],
            ),
            Row(
              children: [
                Container(
                  width: 6.0,
                  height: 30.0,
                  decoration: BoxDecoration(color: MyColors.secondaryColor , borderRadius: BorderRadius.circular(3.0)),
                ),
                SizedBox(width: 10.0,),
                Text("room_settings_room_subject".tr, style: TextStyle(color: Colors.black , fontSize: 16.0 , fontWeight: FontWeight.bold),)
              ],
            ),
      
            SizedBox(height: 15.0,),
      
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              height:40.0,
              child: ListView.separated(itemBuilder: (ctx , index) => chatRoomCategoryListItem(index)  , separatorBuilder: (ctx , index) => countryListSpacer(), itemCount: chatRoomCats.length , scrollDirection: Axis.horizontal,),
      
            ),
            SizedBox(height: 15.0,),
            Row(
              children: [
                Container(
                  width: 6.0,
                  height: 30.0,
                  decoration: BoxDecoration(color: MyColors.secondaryColor , borderRadius: BorderRadius.circular(3.0)),
                ),
                SizedBox(width: 10.0,),
                Text("room_settings_room_img".tr, style: TextStyle(color: Colors.black , fontSize: 16.0 , fontWeight: FontWeight.bold),)
              ],
            ),
            SizedBox(height: 15.0,),
            Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
      
                    children: [
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                         // showPickImageOptions('PHOTO');
                        },
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            Container(
                                width: 60.0,
                                height: 60.0,
                                child: SizedBox(),
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(10.0),
                                    image:
                                        DecorationImage(
                                        image: _image == null ? getRoomImage() : Image.file(
                                      _image!,
                                      width: 100,
                                    ).image,
                                        fit: BoxFit.cover)
      
                                )),
                            GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () {
                                showPickImageOptions('PHOTO');
                              },
                              child: Transform.translate(
                                offset: Offset(0, 10.0),
                                child: CircleAvatar(
                                  radius: 18.0,
                                  backgroundColor: Colors.black54,
                                  child: Icon(
                                    Icons.camera_alt_outlined,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 15.0,),
                ElevatedButton.icon(
                  onPressed: (){
                    uploadRoomImg();
                  },
                  style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 10.0 , vertical: 5.0) , backgroundColor: MyColors.primaryColor ,
                  ),
                  icon: _isLoading4
                      ? Container(
                    width: 20,
                    height: 20,
                    padding: const EdgeInsets.all(2.0),
                    child: const CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 3,
                    ),
                  )
                      :  Icon(Icons.check_circle , color: MyColors.darkColor , size: 20.0,),
                  label:  Text('room_settings_update'.tr , style: TextStyle(color: MyColors.darkColor , fontSize: 13.0), ),
                )
              ],
            ),
      
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                children: [
                  Text("room_settings_room_admins".tr , style: TextStyle(fontSize: 16.0 , color: MyColors.whiteColor , fontWeight: FontWeight.bold),),
                  Expanded(child:
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(onPressed: (){
                            Navigator.pop(context);
                            showModalBottomSheet(
                                isScrollControlled: true ,
                                context: context,
                                builder: (ctx) => roomAdminsBottomSheet());
                          }, icon: Icon(Icons.arrow_forward_ios_outlined , color: Colors.black , size: 20.0,) ,)
                        ],
                      )                          ],
                  )
      
                  )
                ],
              ),
            ),
            SizedBox(height: 15.0,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                children: [
                  Text("room_settings_room_block_list".tr , style: TextStyle(fontSize: 16.0 , color: MyColors.whiteColor , fontWeight: FontWeight.bold),),
                  Expanded(child:
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(onPressed: (){
                            Navigator.pop(context);
                            showModalBottomSheet(
                                isScrollControlled: true ,
                                context: context,
                                builder: (ctx) => roomBlockBottomSheet());
                          }, icon: Icon(Icons.arrow_forward_ios_outlined , color: Colors.black , size: 20.0,) ,)
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
    void updateRoomName() async {
      setState(() {
        _isLoading1 = true ;
      });
      ChatRoom? res = await ChatRoomService().updateRoomName(room!.id , roomTitleController.text , user!.id );
      setState(() {
        room = res ;
        ChatRoomService().roomSetter(room!);
        setState(() {
          _isLoading1 = false ;
        });
      });
    }

  void updateRoomHello() async {
    setState(() {
      _isLoading2 = true ;
    });
      ChatRoom? res = await ChatRoomService().updateRoomHello(room!.id , roomHelloController.text , user!.id);
    setState(() {
      room = res ;
      ChatRoomService().roomSetter(room!);
      setState(() {
        _isLoading2 = false ;
      });
    });
  }

  void updateRoomPassword() async {
    setState(() {
      _isLoading3 = true ;
    });

    ChatRoom? res = await ChatRoomService().updateRoomPassword(room!.id , roomPasswordController.text , user!.id);
    setState(() {
      room = res ;
      ChatRoomService().roomSetter(room!);
      setState(() {
        _isLoading3 = false ;
      });
    });

  }

  void updateRoomCategory(subject) async {
    ChatRoom? res = await ChatRoomService().updateRoomCategory(room!.id , subject , user!.id);
    setState(() {
      room = res ;
      ChatRoomService().roomSetter(room!);

    });
  }

  Widget roomAdminsBottomSheet() => RoomAdminsModal();
  Widget roomBlockBottomSheet() => RoomBlockModal();

  Widget chatRoomCategoryListItem(index) => chatRoomCats.isNotEmpty ?  GestureDetector(
    onTap: (){
      setState(() {
        selectedChatRoomCategory = chatRoomCats[index];
      });
      updateRoomCategory(chatRoomCats[index]);
    },
    child: Container(
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(border: Border.all(color: Colors.transparent , width: 1.0 , style: BorderStyle.solid) , borderRadius: BorderRadius.circular(25.0) ,
          color: chatRoomCats[index] == selectedChatRoomCategory ? MyColors.primaryColor : MyColors.lightUnSelectedColor),
      child:  Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text('#${chatRoomCats[index].toLowerCase()}' , style: TextStyle(color: chatRoomCats[index] == selectedChatRoomCategory ?  MyColors.darkColor : MyColors.whiteColor , fontSize: 15.0),)
        ],),
    ),
  ) : Container();

  Widget countryListSpacer() => const SizedBox(width: 5.0,);

  ImageProvider getRoomImage(){
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
    return  CachedNetworkImageProvider(room_img);
  }

  Future showPickImageOptions(which) async {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            child: Text('add_photo_gallery'.tr),
            onPressed: () {
              // close the options modal
              Navigator.of(context).pop();
              // get image from gallery
              getImageFromGalleryOrCamera(ImageSource.gallery , which);
            },
          ),
          CupertinoActionSheetAction(
            child: Text('add_camera'.tr),
            onPressed: () {
              // close the options modal
              Navigator.of(context).pop();
              // get image from camera
              getImageFromGalleryOrCamera(ImageSource.camera , which);
            },
          ),
        ],
      ),
    );
  }

  Future getImageFromGalleryOrCamera(ImageSource _source , which) async {
    final pickedFile = await ImagePicker().pickImage(source: _source);

    setState(() {
      if (pickedFile != null) {

          _image = File(pickedFile.path);


      }
    });
  }
  uploadRoomImg() async {
    setState(() {
      _isLoading4 = true ;
    });
    await ChatRoomService().updateRoomImg(room!.id, _image , user!.id);

    setState(() {
      _isLoading4 = false
      ;
    });
  }
}

