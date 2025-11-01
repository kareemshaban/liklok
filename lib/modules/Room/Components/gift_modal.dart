
import 'package:LikLok/helpers/GiftHelper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:LikLok/helpers/RoomBasicDataHelper.dart';
import 'package:LikLok/models/AppUser.dart';
import 'package:LikLok/models/Category.dart';
import 'package:LikLok/models/ChatRoom.dart';
import 'package:LikLok/models/Gift.dart';
import 'package:LikLok/models/RoomMember.dart';
import 'package:LikLok/shared/components/Constants.dart';
import 'package:LikLok/shared/network/remote/AppUserServices.dart';
import 'package:LikLok/shared/network/remote/ChatRoomService.dart';
import 'package:LikLok/shared/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class GiftModal extends StatefulWidget {
  final int reciverId ;
  const GiftModal({super.key , required this.reciverId});

  @override
  State<GiftModal> createState() => _GiftModalState();
}

class _GiftModalState extends State<GiftModal> with TickerProviderStateMixin{
  String sendGiftReceiverType = "";
  AppUser? user ;
  ChatRoom? room ;
  TabController? _tabController ;
  List<Category> categories = [];
  List<Gift> gifts = [] ;
  List<Widget> giftTabs = [] ;
  List<Widget> giftViews = [] ;
  int? selectedGift ;
  int? sendGiftCount ;
  int? receiver = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      sendGiftCount = 1 ;
      receiver = widget.reciverId ;
      sendGiftReceiverType = "select_one_ore_more";
      user = AppUserServices().userGetter();
      room = ChatRoomService().roomGetter();
      RoomBasicDataHelper? helper = ChatRoomService().roomBasicDataHelperGetter();
      categories = helper!.categories ;
      categories.sort((a, b) => a.order.compareTo(b.order));
      gifts = helper.gifts ;
      selectedGift = gifts.where((element) => element.gift_category_id == categories[0].id).toList()[0].id ;
      _tabController = new TabController(vsync: this, length: categories.length);
      getGiftCatsTabs();
      getGiftViewTabs();
    });
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: MediaQuery.of(context).size.height / 2,
        decoration: BoxDecoration(color: Colors.white.withAlpha(220),
            borderRadius: BorderRadius.only(topRight: Radius.circular(20.0) , topLeft: Radius.circular(15.0)) ,
            border: Border(top: BorderSide(width: 4.0, color: MyColors.secondaryColor),) ),
        child:  Column(
          children: [
            Container(
              height: 50.0,
              padding: EdgeInsetsDirectional.only(start: 10.0 , end: 10.0),
              width: double.infinity,
              child: Row(
                children: [
                Text(getTypeValue(sendGiftReceiverType) , style: TextStyle(color: MyColors.primaryColor), ),
                PopupMenuButton(
                  position: PopupMenuPosition.under,
                  shadowColor: MyColors.whiteColor,
                  elevation: 4.0,

                  color: Colors.white,
                  icon: Icon(Icons.expand_circle_down , color: MyColors.primaryColor,),
                  onSelected: (String result) {
                    setState(() {
                      sendGiftReceiverType = result ;
                    });
                  },
                  itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                    PopupMenuItem<String>(
                      value: 'select_one_ore_more',
                      child: Text('gift_one_or_more_user'.tr , style: TextStyle(color: sendGiftReceiverType == 'select_one_ore_more' ?  MyColors.primaryColor  : Colors.black),),
                    ),
                    PopupMenuItem<String>(
                      value: 'all_mic_users',
                      child: Text('gift_all_mic_users'.tr , style: TextStyle(color:  sendGiftReceiverType == 'all_mic_users' ?  MyColors.primaryColor  : Colors.black),),
                    ),
                    PopupMenuItem<String>(
                      value: 'all_room_members',
                      child: Text('gift_all_room_users'.tr , style: TextStyle(color:  sendGiftReceiverType == 'all_room_members' ?  MyColors.primaryColor  : Colors.black),),

                    )
                  ],
                ),

                Expanded(child:
                sendGiftReceiverType == "select_one_ore_more" ?
                ListView.separated(itemBuilder: (ctx , index) => giftBoxMicUserListItem(index),
                  separatorBuilder:  (ctx , index) => giftBoxMicUserSperator() , itemCount: room!.members!.where((e) => e.user_id > 0 ).length ,
                  scrollDirection: Axis.horizontal,) :
                sendGiftReceiverType == "all_room_members" ?
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("gift_send_to_all_room_members".tr , style: TextStyle(color: MyColors.whiteColor),)
                  ],
                ) :  Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("gift_all_mic_users".tr , style: TextStyle(color: MyColors.whiteColor),)
                  ],
                )
                ),
              ],),
            ),
            Container(
              height: 1.0,
              width: double.infinity,
              color: MyColors.lightUnSelectedColor,
            ),
            TabBar(
              dividerColor: MyColors.lightUnSelectedColor,
              tabAlignment: TabAlignment.start,
              isScrollable: true ,
              unselectedLabelColor: MyColors.whiteColor,
              labelColor: MyColors.primaryColor,
              indicatorColor: MyColors.primaryColor,
              controller: _tabController,
              labelStyle: const TextStyle(fontSize: 17.0 , fontWeight: FontWeight.w700),
              tabs:  giftTabs,
            ),
            SizedBox(height: 5.0,),
            Expanded(child: TabBarView(children: giftViews ,   controller: _tabController,)),

          ],
        ),
      ),
    );
  }

  Widget giftBoxMicUserListItem(index) => GestureDetector(
    onTap: () {
       setState(() {
         if(receiver == room!.members![index].user_id){
           receiver = 0 ;
         } else {
           receiver = receiver = room!.members![index].user_id ;
         }

       });
    },
    child: CircleAvatar(
      radius: 18.0,
      backgroundColor: receiver == room!.members![index].user_id ? MyColors.primaryColor : Colors.transparent,
      child: CircleAvatar(
          radius: 15.0,
          backgroundImage: getGiftBoxMicUserImage(index) ,

      ),
    ),
  );
  ImageProvider getGiftBoxMicUserImage(index){
    if(room!.members![index].mic_user_img != null){
      if(room!.members![index].mic_user_img != ""){
        return CachedNetworkImageProvider(ASSETSBASEURL + 'AppUsers/' + room!.members![index].mic_user_img!  );
      } else {
        return AssetImage('assets/images/user.png');
      }
    }else {
      return AssetImage('assets/images/user.png');
    }

  }
  Widget giftBoxMicUserSperator() => SizedBox(width: 10.0,);

  getGiftCatsTabs(){
    List<Widget> t = [] ;
    for(var i = 0 ; i < categories.length ; i++){
      Widget tab = Tab(text: categories[i].name);
      t.add(tab);
      setState(() {
        giftTabs = t ;
      });
    }

  }

  getGiftViewTabs() {
    List<Widget> t = [] ;
    for(var i = 0 ; i < categories.length ; i++){
      Widget tab = getGiftViewTab(categories[i].id);
      t.add(tab);
    }
    setState(() {
      giftViews = t ;
    });
  }
  Widget getGiftViewTab(id) {
    List<Gift> _gifts = gifts.where((element) => element.gift_category_id == id).toList();
    if(id == 7){
      _gifts.sort((a, b) => a.id.compareTo(b.id));
    }


    return
      Column(
        children: [
          Expanded(
            child: GridView.count(
              shrinkWrap: true,
              crossAxisCount: 4,
              childAspectRatio: .8,
              children: _gifts.map((gift) => giftListItem(gift)).toList() ,
              mainAxisSpacing: 3.0,
              crossAxisSpacing: 3.0,
            ),
          ),
          Container(
            color: Colors.white.withAlpha(50),
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            height: 50.0,
            child: Row(
              children: [
                Column(
                  children: [
                    Row(
                      children: [
                        Image(image: AssetImage('assets/images/gold.png'),
                          width: 25.0,),
                        SizedBox(width: 5.0,),
                        Text(double.parse(user!.gold).floor().toString(),
                          style: TextStyle(color: MyColors.primaryColor,
                              fontSize: 13.0,
                              fontWeight: FontWeight.bold),),
                        IconButton(onPressed: () {},
                            icon: Icon(Icons.arrow_forward_ios_outlined,
                              color: MyColors.primaryColor, size: 20.0,))
                      ],
                    ),
                  ],
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        width: 160.0,
                        height: 40.0,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(22.0),
                            border: Border.all(
                                color: MyColors.primaryColor, width: 2.0)),
                        child: Row(
                          children: [
                            Container(
                              width: 96.0,
                              child: Row(
                                children: [
                                  PopupMenuButton(
                                    position: PopupMenuPosition.over,
                                    shadowColor: MyColors.unSelectedColor,
                                    elevation: 4.0,

                                    color: Colors.white,
                                    icon: Icon(Icons.arrow_drop_down,
                                      color: MyColors.whiteColor,),
                                    onSelected: (int result) {
                                      setState(() {
                                        sendGiftCount = result;
                                        getGiftViewTabs();
                                      });
                                    },
                                    itemBuilder: (BuildContext context) =>
                                    <PopupMenuEntry<int>>[
                                      PopupMenuItem<int>(
                                        value: 1,
                                        child: Text('X 1', style: TextStyle(
                                            color: Colors.black),),
                                      ),
                                      PopupMenuItem<int>(
                                        value: 7,
                                        child: Text('X 7', style: TextStyle(
                                            color: Colors.black),),
                                      ),
                                      PopupMenuItem<int>(
                                        value: 17,
                                        child: Text('X 17', style: TextStyle(
                                            color: Colors.black),),

                                      ),
                                      PopupMenuItem<int>(
                                        value: 77,
                                        child: Text('X 77', style: TextStyle(
                                            color: Colors.black),),

                                      )
                                    ],
                                  ),
                                  Container(child: Text(
                                    sendGiftCount.toString(), style: TextStyle(
                                      color: Colors.black, fontSize: 12.0),))
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                sendGift();
                              },
                              child: Container(
                                width: 60.0,
                                height: 40.0,
                                decoration: BoxDecoration(
                                    color: MyColors.primaryColor,
                                    borderRadius: BorderRadiusDirectional.only(
                                        topEnd: Radius.circular(20.0),
                                        bottomEnd: Radius.circular(20.0))),
                                child: Center(child: Text("gift_send".tr,
                                  style: TextStyle(color: MyColors.darkColor,
                                      fontSize: 15.0),)),
                              ),
                            ),

                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ) ;
  }

  Widget giftListItem (gift) => GestureDetector(
    onTap: (){
      print(selectedGift);
      setState(() {
        selectedGift = gift.id;
        getGiftViewTabs ();
      });
    },
    child: Container(
      decoration: BoxDecoration(border: gift.id == selectedGift ? Border.all(color: MyColors.primaryColor , width: 1.0) : Border.all(color: Colors.transparent , width: 1.0) ,
        borderRadius: BorderRadius.circular(15.0) ,  ),
      child: Column(
        children: [
          Image(image: CachedNetworkImageProvider(ASSETSBASEURL + 'Designs/' + gift.icon) , width: 70.0,),
          Text(gift.name , style: TextStyle(color: Colors.black , fontSize: 12.0),),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(image: AssetImage('assets/images/gold.png') , width: 20.0,),
              Text( double.parse(gift!.price).floor().toString(), style: TextStyle(color: MyColors.primaryColor , fontSize: 12.0 , fontWeight: FontWeight.bold),)                      ],
          ),

        ],
      ),
    ),
  );


  sendGiftToSingleUser() async{
    GiftHelper(gift_id: selectedGift! , user_id: user!.id , room_id: room!.id , receiver: receiver! , room_owner: room!.userId , sendGiftCount: sendGiftCount! , gifts: gifts).sendGiftEvent();
  }
  sendGiftToAllMicUsers() async{
    GiftHelper(gift_id: selectedGift! , user_id: user!.id , room_id: room!.id , receiver: 0 , room_owner: room!.userId , sendGiftCount: sendGiftCount! , gifts: gifts).sendGiftMicUser();

    // bool res = await ChatRoomService().sendGiftMicUsers(user!.id  , room!.userId , room!.id ,  selectedGift , sendGiftCount );
      // if(res == true){
      //   AppUser? ress = await AppUserServices().getUser(user!.id);
      //   setState(() {
      //     user = ress ;
      //     AppUserServices().userSetter(user!);
      //   });
      //
      //   Gift gift = gifts.where((element) => element.id == selectedGift).toList()[0] ;
      //   await FirebaseFirestore.instance.collection("gifts").add({
      //     'room_id': room!.id,
      //     'sender_id': user!.id ,
      //     'sender_name': user!.name ,
      //     'sender_img': '${ASSETSBASEURL}AppUsers/${user!.img}'  ,
      //     'receiver_id':0 ,
      //     'receiver_name': "Mic Users" ,
      //     'receiver_img': '',
      //     'gift_name':  gift.name ,
      //     'gift_audio': gift.audio_url != "" ? '${ASSETSBASEURL}Designs/Audio/${gift.audio_url}' : "" ,
      //     'gift_img': '${gift.motion_icon}',
      //     'giftImgSmall':'${ASSETSBASEURL}Designs/${gift.icon}',
      //     'count' : sendGiftCount,
      //     'sender_share_level': user!.share_level_icon ,
      //     'available_untill':DateTime.now().add(Duration(minutes: 1)),
      //     'gift_category_id': gift.gift_category_id
      //
      //   });
      // }

  }
  sendGiftToAllRoomMembers() async{
    GiftHelper(gift_id: selectedGift! , user_id: user!.id , room_id: room!.id , receiver: 0 , room_owner: room!.userId , sendGiftCount: sendGiftCount! , gifts: gifts).sendGiftMicUser();

    // bool res = await ChatRoomService().sendGiftMembers(user!.id  , room!.userId , room!.id ,  selectedGift , sendGiftCount );
    // if(res == true){
    //   AppUser? ress = await AppUserServices().getUser(user!.id);
    //   setState(() {
    //     user = ress ;
    //     AppUserServices().userSetter(user!);
    //   });
    //
    //   Gift gift = gifts.where((element) => element.id == selectedGift).toList()[0] ;
    //   await FirebaseFirestore.instance.collection("gifts").add({
    //     'room_id': room!.id,
    //     'sender_id': user!.id ,
    //     'sender_name': user!.name ,
    //     'sender_img': '${ASSETSBASEURL}AppUsers/${user!.img}'  ,
    //     'receiver_id':0 ,
    //     'receiver_name': "Room Members" ,
    //     'receiver_img': '',
    //     'gift_name':  gift.name ,
    //     'gift_audio': gift.audio_url != "" ? '${ASSETSBASEURL}Designs/Audio/${gift.audio_url}' : "" ,
    //     //'gift_img': '${ASSETSBASEURL}Designs/Motion/${gift.motion_icon}',
    //     'gift_img': '${gift.motion_icon}',
    //     'giftImgSmall':'${ASSETSBASEURL}Designs/${gift.icon}',
    //     'count' : sendGiftCount,
    //     'sender_share_level': user!.share_level_icon,
    //     'available_untill':DateTime.now().add(Duration(minutes: 1)),
    //     'gift_category_id': gift.gift_category_id
    //
    //   });
    // }
  }
  sendGift(){
  if(selectedGift! > 0){
    if( sendGiftReceiverType == 'select_one_ore_more'){
      sendGiftToSingleUser();
    } else if(sendGiftReceiverType == 'all_mic_users'){
      sendGiftToAllMicUsers();
    } else if(sendGiftReceiverType == 'all_room_members'){
      sendGiftToAllRoomMembers();
    }
  } else {
    Fluttertoast.showToast(
        msg: 'choose_gift'.tr,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black26,
        textColor: Colors.orange,
        fontSize: 16.0
    );
  }

  }
  getTypeValue(val) {
    if(val == 'select_one_ore_more') return 'gift_one_or_more_user'.tr ;
    else if(val == 'all_mic_users') return 'gift_all_mic_users'.tr ;
    else if(val == 'all_room_members') return 'gift_all_room_users'.tr ;
  }
}
