import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:LikLok/models/AppUser.dart';
import 'package:LikLok/models/ChatRoom.dart';
import 'package:LikLok/models/LuckyCase.dart';
import 'package:LikLok/shared/network/remote/AppUserServices.dart';
import 'package:LikLok/shared/network/remote/ChatRoomService.dart';
import 'package:LikLok/shared/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../helpers/zego_handler/zego_sdk_manager.dart';

class LuckyCaseModal extends StatefulWidget {
  const LuckyCaseModal({super.key});

  @override
  State<LuckyCaseModal> createState() => _LuckyCaseModalState();
}

class _LuckyCaseModalState extends State<LuckyCaseModal> with TickerProviderStateMixin{

  int selectedValue = 270 ;
  int type = 0 ;
  late TabController _tabController;
  ChatRoom? room ;
  AppUser? user ;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = new TabController(length: 2, vsync: this);
    setState(() {
      room = ChatRoomService().roomGetter();
      user = AppUserServices().userGetter() ;
    });
    _tabController.addListener(() {
      setState(() {
        type = _tabController.index ;
      });
      if(type == 0){
        setState(() {
          selectedValue = 270 ;
        });
      } else {
        setState(() {
          selectedValue = 4777 ;
        });
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: MediaQuery.sizeOf(context).height * .5,
        padding: EdgeInsets.all(7.0),
        decoration: BoxDecoration(color: Colors.transparent,
            image: DecorationImage(image: AssetImage('assets/images/lucky_bg.png') , fit: BoxFit.cover),
            borderRadius: BorderRadius.only(topRight: Radius.circular(20.0) , topLeft: Radius.circular(15.0)) ,
            border: Border(top: BorderSide(width: 4.0, color: MyColors.secondaryColor),)
        ),
        child: Column(
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Container(
                    margin: EdgeInsets.all(5),
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(width: 2, color: Colors.white)),
                    child: Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 15.0,
                    ),
                  ),
                ),
                Expanded(child:
                Transform.translate(
                 offset: Offset(0 , -30.0),
                  child: Container(
                    height: 60,
                    decoration: BoxDecoration(color: MyColors.luckyTabsColor , borderRadius: BorderRadius.circular(25.0) ,
                        border: Border.all(width: 3.0, color: MyColors.secondaryColor,)),
                    child: TabBar(
                      controller: _tabController,
                      dividerColor: Colors.transparent,
                      tabAlignment: TabAlignment.center,
                      isScrollable: true ,
                      indicatorColor: MyColors.secondaryColor,
                      labelColor: MyColors.secondaryColor,
                      unselectedLabelColor: Colors.white,
                      labelStyle: const TextStyle(fontSize: 14.0 , fontWeight: FontWeight.w900),
      
      
                      tabs:  [
                        Tab(child: Text("local_lucky_case".tr , style: TextStyle(fontSize: 15.0),), ),
                        Tab(child: Text("global_lucky_case".tr , style: TextStyle(fontSize: 15.0),), ),
                      ],
                    ),
                  ),
                ) ),
                GestureDetector(
                  onTap: (){
                    //Navigator.pop(context);
                  },
                  child: Container(
                    margin: EdgeInsets.all(5),
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(width: 2, color: Colors.white)),
                    child: Icon(
                      Icons.question_mark,
                      color: Colors.white,
                      size: 15.0,
                    ),
                  ),
                ),
              ],
      
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: 20.0,),
                        Row(
                          children: [
                            SizedBox(width: 10.0,),
                            Expanded(
                              child: Column(
                                children: [
                                  GestureDetector(
                                    onTap: (){
                                      setState(() {
                                        selectedValue = 270 ;
                                      });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color:  selectedValue == 270 ? MyColors.luckyselecteBtnColor.withAlpha(200) : MyColors.luckyunselecteBtnColor.withAlpha(50) ,
                                          borderRadius: BorderRadius.circular(15.0)
                                      ),
                                      height: 50.0,
                                      width: (MediaQuery.sizeOf(context).width * .5 ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Image(image: AssetImage('assets/images/gold.png') , width: 35.0,),
                                          SizedBox(width: 5.0,),
                                          Text('270' , style: TextStyle(color: selectedValue == 270 ?  MyColors.luckyunsTextColor : Colors.white , fontSize: 24.0 , fontWeight: FontWeight.bold),)
                                        ],
      
                                      ),
                                    ),
                                  )
                                ],
      
                              ),
                            ),
                            SizedBox(width: 20.0,),
                            Expanded(
                              child: Column(
                                children: [
                                  GestureDetector(
                                    onTap: (){
                                      setState(() {
                                        selectedValue = 770 ;
                                      });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration( color:  selectedValue == 770 ? MyColors.luckyselecteBtnColor.withAlpha(200) : MyColors.luckyunselecteBtnColor.withAlpha(100) ,
                                      borderRadius: BorderRadius.circular(15.0)) ,
                                      height: 50.0,
                                      margin: EdgeInsets.symmetric(horizontal: 1.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Image(image: AssetImage('assets/images/gold.png') , width: 35.0,),
                                          SizedBox(width: 5.0,),
                                          Text('770' , style: TextStyle(color: selectedValue == 770 ?  MyColors.luckyunsTextColor : Colors.white , fontSize: 24.0 , fontWeight: FontWeight.bold),)
                                        ],
      
                                      ),
                                    ),
                                  )
                                ],
      
                              ),
                            ),
                            SizedBox(width: 10.0,),
                          ],
                        ),
                        SizedBox(height: 30.0,),
                        Row(
                          children: [
                            SizedBox(width: 20.0,),
                            Text('benner_local_hint'.tr , style: TextStyle(color: Colors.white , fontSize: 13.0 , fontWeight: FontWeight.normal),)
                          ],
                        ),
                        SizedBox(height: 10.0,),
                        Text('Box Value' + selectedValue.toString()  , style: TextStyle(color: MyColors.primaryColor , fontSize: 15.0 , fontWeight: FontWeight.w700),),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Stack(
                              alignment: Alignment.centerRight,
                              children: [
                                Stack(
                                  alignment: Alignment.centerLeft  ,
                                  children: [
                                    Image(image: AssetImage('assets/images/global_bag_banner.png') , width: MediaQuery.sizeOf(context).width * .9),
                                    Container(
                                        padding: EdgeInsets.symmetric(horizontal: 15.0),
                                        child: Image(image: AssetImage('assets/images/luckyCaseIcon.png') , width: 40.0,))
                                  ],
                                ),
                                Container(
                                     padding: EdgeInsets.symmetric(horizontal: 15.0),
                                    child: Image(image: AssetImage('assets/images/avatar.png') , width: 35.0,))
                              ],
                            )
                          ],
                        ),
      
      
                      ],
                    ),
                  ),
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: 20.0,),
                        Row(
                          children: [
                            SizedBox(width: 10.0,),
                            Expanded(
                              child: Column(
                                children: [
                                  GestureDetector(
                                    onTap: (){
                                      setState(() {
                                        selectedValue = 4777 ;
                                      });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color:  selectedValue == 4777 ? MyColors.luckyselecteBtnColor.withAlpha(200) : MyColors.luckyunselecteBtnColor.withAlpha(50) ,
                                          borderRadius: BorderRadius.circular(15.0)
                                      ),
                                      height: 50.0,
                                      width: (MediaQuery.sizeOf(context).width * .5 ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Image(image: AssetImage('assets/images/gold.png') , width: 35.0,),
                                          SizedBox(width: 5.0,),
                                          Text('4777' , style: TextStyle(color: selectedValue == 4777 ?  MyColors.luckyunsTextColor : Colors.white , fontSize: 24.0 , fontWeight: FontWeight.bold),)
                                        ],
      
                                      ),
                                    ),
                                  )
                                ],
      
                              ),
                            ),
                            SizedBox(width: 20.0,),
                            Expanded(
                              child: Column(
                                children: [
                                  GestureDetector(
                                    onTap: (){
                                      setState(() {
                                        selectedValue = 7777 ;
                                      });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration( color:  selectedValue == 7777 ? MyColors.luckyselecteBtnColor.withAlpha(200) : MyColors.luckyunselecteBtnColor.withAlpha(100) ,
                                          borderRadius: BorderRadius.circular(15.0)) ,
                                      height: 50.0,
                                      margin: EdgeInsets.symmetric(horizontal: 1.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Image(image: AssetImage('assets/images/gold.png') , width: 35.0,),
                                          SizedBox(width: 5.0,),
                                          Text('7777' , style: TextStyle(color: selectedValue == 7777 ?  MyColors.luckyunsTextColor : Colors.white , fontSize: 24.0 , fontWeight: FontWeight.bold),)
                                        ],
      
                                      ),
                                    ),
                                  )
                                ],
      
                              ),
                            ),
                            SizedBox(width: 10.0,),
                          ],
                        ),
                        SizedBox(height: 10.0,),
                        Row(
                          children: [
                            SizedBox(width: 10.0,),
                            Expanded(
                              child: Column(
                                children: [
                                  GestureDetector(
                                    onTap: (){
                                      setState(() {
                                        selectedValue = 15000 ;
                                      });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color:  selectedValue == 15000 ? MyColors.luckyselecteBtnColor.withAlpha(200) : MyColors.luckyunselecteBtnColor.withAlpha(50) ,
                                          borderRadius: BorderRadius.circular(15.0)
                                      ),
                                      height: 50.0,
                                      width: (MediaQuery.sizeOf(context).width * .5 ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Image(image: AssetImage('assets/images/gold.png') , width: 35.0,),
                                          SizedBox(width: 5.0,),
                                          Text('15000' , style: TextStyle(color: selectedValue == 15000 ?  MyColors.luckyunsTextColor : Colors.white , fontSize: 24.0 , fontWeight: FontWeight.bold),)
                                        ],
      
                                      ),
                                    ),
                                  )
                                ],
      
                              ),
                            ),
                            SizedBox(width: 20.0,),
                            Expanded(
                              child: Column(
                                children: [
                                  GestureDetector(
                                    onTap: (){
                                      setState(() {
                                        selectedValue = 30000 ;
                                      });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration( color:  selectedValue == 30000 ? MyColors.luckyselecteBtnColor.withAlpha(200) : MyColors.luckyunselecteBtnColor.withAlpha(100) ,
                                          borderRadius: BorderRadius.circular(15.0)) ,
                                      height: 50.0,
                                      margin: EdgeInsets.symmetric(horizontal: 1.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Image(image: AssetImage('assets/images/gold.png') , width: 35.0,),
                                          SizedBox(width: 5.0,),
                                          Text('30000' , style: TextStyle(color: selectedValue == 30000 ?  MyColors.luckyunsTextColor : Colors.white , fontSize: 24.0 , fontWeight: FontWeight.bold),)
                                        ],
      
                                      ),
                                    ),
                                  )
                                ],
      
                              ),
                            ),
                            SizedBox(width: 10.0,),
                          ],
                        ),
                        SizedBox(height: 30.0,),
                        Row(
                          children: [
                            SizedBox(width: 20.0,),
                            Text('benner_global_hint'.tr , style: TextStyle(color: Colors.white , fontSize: 13.0 , fontWeight: FontWeight.normal),),
      
                          ],
                        ),
                        SizedBox(height: 10.0,),
      
                        Text('Box Value' + selectedValue.toString()  , style: TextStyle(color: MyColors.primaryColor , fontSize: 15.0 , fontWeight: FontWeight.w700),),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Stack(
                              alignment: Alignment.centerRight,
                              children: [
                                Stack(
                                  alignment: Alignment.centerLeft  ,
                                  children: [
                                    Image(image: AssetImage('assets/images/global_bag_banner.png') , width: MediaQuery.sizeOf(context).width * .9),
                                    Container(
                                        padding: EdgeInsets.symmetric(horizontal: 15.0),
                                        child: Image(image: AssetImage('assets/images/luckyCaseIcon.png') , width: 40.0,))
                                  ],
                                ),
                                Container(
                                    padding: EdgeInsets.symmetric(horizontal: 15.0),
                                    child: Image(image: AssetImage('assets/images/avatar.png') , width: 35.0,))
                              ],
                            )
                          ],
                        ),
      
      
                      ],
                    ),
                  ),
                ],
              ),
            ),
      
            GestureDetector(
              onTap: (){
                createLuckyBag();
              },
              child: Center(
                child: Container(
                  width: MediaQuery.sizeOf(context).width * .6,
                  height: 60.0,
                  decoration: BoxDecoration(color: MyColors.primaryColor , borderRadius: BorderRadius.circular(30.0)),
                  child: Center(child: Text('gift_send'.tr , style: TextStyle(color: MyColors.luckyunsTextColor , fontSize: 22.0 , fontWeight: FontWeight.bold) ,)),
                ),
      
              ),
            ),
      
      
          ],
        ),
      
      
      ),
    );
  }
  // createLuckyBag() async{
  //   LuckyCase? luckyCase =  await ChatRoomService().createLuckyCase(room!.id , user!.id , type , selectedValue);
  //   if(luckyCase!.id > 0){
  //     await FirebaseFirestore.instance.collection("luckyCase").add({
  //       'room_id': room!.id,
  //       'user_id': user!.id,
  //       'user_img':user!.img,
  //       'lucky_id': luckyCase.id,
  //       'type': luckyCase.type,
  //       'room_name': room!.name ,
  //       'user_name': user!.name,
  //       'available_untill':DateTime.now().add(Duration(minutes: 2))
  //     });
  //   }
  // }
  createLuckyBag() async {
    LuckyCase? luckyCase = await ChatRoomService()
        .createLuckyCase(room!.id, user!.id, type, selectedValue);

    if (luckyCase != null && luckyCase.id > 0) {
      final luckyData = {
        'room_id': room!.id,
        'user_id': user!.id,
        'user_img': user!.img,
        'lucky_id': luckyCase.id,
        'type': luckyCase.type,
        'room_name': room!.name ,
        'user_name': user!.name ,
        'available_until': DateTime.now()
            .add(const Duration(minutes: 2)).toString()
      };

      await ZEGOSDKManager().zimService.setRoomAttributes(
        {
          'lucky_event': jsonEncode(luckyData),
        },
        isForce: true,
        isUpdateOwner: false,
        isDeleteAfterOwnerLeft: false,
      );

      print('🎁 Lucky bag event sent via Zego: $luckyData');
    }
  }


}
