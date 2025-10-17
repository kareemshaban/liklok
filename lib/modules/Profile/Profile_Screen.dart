import 'package:LikLok/helpers/DesigGiftHelper.dart';
import 'package:LikLok/helpers/ExitRoomHelper.dart';
import 'package:LikLok/helpers/MicHelper.dart';
import 'package:LikLok/models/AppUser.dart';
import 'package:LikLok/models/ChargingOperation.dart';
import 'package:LikLok/models/ChatRoom.dart';
import 'package:LikLok/models/Design.dart';
import 'package:LikLok/modules/AddStatus/Add_Status_Screen.dart';
import 'package:LikLok/modules/Agreement/Agreement_Screen.dart';
import 'package:LikLok/modules/EditProfile/Edit_Profile_Screen.dart';
import 'package:LikLok/modules/Followers/Followers_Screen.dart';
import 'package:LikLok/modules/FollowingScreen/Following_Screen.dart';
import 'package:LikLok/modules/FriendsScreen/Friends_Screen.dart';
import 'package:LikLok/modules/InnerProfile/Inner_Profile_Screen.dart';
import 'package:LikLok/modules/InviteScreen/invite_screen.dart';
import 'package:LikLok/modules/Mall/Mall_Screen.dart';
import 'package:LikLok/modules/MyGifts/My_Gifts_Screen.dart';
import 'package:LikLok/modules/MyLevel/My_Level_Screen.dart';
import 'package:LikLok/modules/MyPosts/My_Posts_Screen.dart';
import 'package:LikLok/modules/PrivacyPolicy/Privacy_Policy_Screen.dart';
import 'package:LikLok/modules/Room/Room_Screen.dart';
import 'package:LikLok/modules/Setting/Setting_Screen.dart';
import 'package:LikLok/modules/VIP/Vip_Screen.dart';
import 'package:LikLok/modules/VisitorsScreen/Visitors_Screen.dart';
import 'package:LikLok/modules/WalletScreen/wallet_screen.dart';
import 'package:LikLok/shared/components/Constants.dart';
import 'package:LikLok/shared/network/remote/AppUserServices.dart';
import 'package:LikLok/shared/network/remote/ChatRoomService.dart';
import 'package:LikLok/shared/network/remote/WalletServices.dart';
import 'package:LikLok/shared/styles/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svga/flutter_svga.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

import '../ContactUs/contact_us_screen.dart';
import '../Loading/loadig_screen.dart';
import '../modols/medals_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  AppUser? user ;
  List<Design> designs = [] ;
  String frame = "" ;
  List<ChargingOperation> operatins = [] ;
  bool loading = false ;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      user = AppUserServices().userGetter();
    });
    getMyOperations();
    getMyDesigns();

  }
  loadData() async {
   await getMyDesigns();
   await getUser();
   await getMyOperations();
  }
  getMyOperations() async{
    setState(() {
      loading = true ;
    });
    List<ChargingOperation> res = await WalletServices().getUserChargingOperations(user!.id);
    setState(() {
      operatins = res ;
      loading = false ;
    });
  }
  Future<void> _refresh()async{
    await loadData();
  }
  getUser() async{
    AppUser? res = await AppUserServices().getUser(user!.id);
    AppUserServices().userSetter(res!);
    setState(() {
      user = res ;
    });
  }
  getMyDesigns() async{
    setState(() {
      loading = true ;
    });
    DesignGiftHelper _helper =  await AppUserServices().getMyDesigns(user!.id);
    setState(() {
      designs = _helper.designs! ;
    });
    if(designs.where((element) => (element.category_id == 4 && element.isDefault == 1)).toList().length > 0){
      String icon = designs.where((element) => (element.category_id == 4 && element.isDefault == 1)).toList()[0].motion_icon ;

      setState(() {
        frame = ASSETSBASEURL + 'Designs/Motion/' + icon +'?raw=true' ;
        print(frame);
       });
    }
    setState(() {
      loading = false ;
    });
  }

  void openMyRoom() async{
    ChatRoom? room =  await ChatRoomService().openMyRoom(user!.id);
    await checkForSavedRoom(room!);
    ChatRoomService().roomSetter(room!);
    print(room);
    Navigator.push(context, MaterialPageRoute(builder: (ctx) => const RoomScreen()));
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

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(85.0),
        child: AppBar(
          toolbarHeight: 85.0,
          backgroundColor: MyColors.solidDarkColor,
          title: Row(
            children: [
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (ctx) => const EditProfileScreen()));
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        CircleAvatar(
                          backgroundColor: user!.gender == 0 ? MyColors.blueColor : MyColors.pinkColor ,
                          backgroundImage: user?.img != "" ? (user!.img.startsWith('https') ? CachedNetworkImageProvider(user!.img)  :  CachedNetworkImageProvider('${ASSETSBASEURL}AppUsers/${user?.img}'))  :    null,
                          radius: 30,
                          child: user?.img== "" ?
                          Text(user!.name.toUpperCase().substring(0 , 1) +
                              (user!.name.contains(" ") ? user!.name.substring(user!.name.indexOf(" ")).toUpperCase().substring(1 , 2) : ""),
                            style: const TextStyle(color: Colors.white , fontSize: 22.0 , fontWeight: FontWeight.bold),) : null,
                        ),
                        CircleAvatar(
                          radius: 12.0,
                          backgroundColor: Colors.black54 ,
                          child: Icon(Icons.edit_outlined ,color: Colors.white, size: 15,),
                        )
                      ],
                    ),
                    Container(height: 90.0, width: 90.0, child: frame != "" ? SVGAEasyPlayer(   resUrl: frame) : null),
                  ],
                ),
              ),

              SizedBox(width: 5.0,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Row(
                    children: [
                      Text(user!.name , style: TextStyle(color: Colors.black , fontSize: 18.0 , fontWeight: FontWeight.bold),),
                      const SizedBox(width: 10.0,),
                      CircleAvatar(
                        backgroundColor: user!.gender == 0 ? MyColors.blueColor : MyColors.pinkColor ,
                        radius: 12.0,
                        child: user!.gender == 0 ?  const Icon(Icons.male , color: Colors.white, size: 15.0,) :  const Icon(Icons.female , color: Colors.white, size: 15.0,),
                      )
                    ],
                  ),
                  SizedBox(height: 3.0,),
                  Row(
                    children: [
                      Image(image: CachedNetworkImageProvider('${ASSETSBASEURL}Levels/${user!.share_level_icon}') , width: 50,),
                      const SizedBox(width: 10.0,),
                      Image(image: CachedNetworkImageProvider('${ASSETSBASEURL}Levels/${user!.karizma_level_icon}') , width: 50,),
                      const SizedBox(width: 10.0, height: 10,),
                      Image(image: CachedNetworkImageProvider('${ASSETSBASEURL}Levels/${user!.charging_level_icon}') , width: 50,),
                    ],
                  ),
                  SizedBox(height: 5.0,),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () async{
                      await Clipboard.setData(ClipboardData(text: user!.tag));
                      Fluttertoast.showToast(
                          msg: 'profile_msg_copied'.tr,
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.black26,
                          textColor: Colors.orange,
                          fontSize: 16.0
                      );
                    },
                    child: Row(
                      children: [
                        Text("ID:" + user!.tag , style: TextStyle(color: Colors.black , fontSize: 12.0),),
                        const SizedBox(width: 5.0,),
                        Icon(Icons.copy_outlined , color: Colors.black , size: 20.0,)
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
          actions: [
            IconButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (ctx) => const InnerProfileScreen(visitor_id: 0)));
            }, icon:Icon( Icons.arrow_forward_ios , color: Colors.black , size: 24.0,))
          ],
        ),
      ),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: MyColors.darkColor,
          padding: EdgeInsets.all(10.0),
          child: loading ? Loading() : RefreshIndicator(
            onRefresh: _refresh ,
            color: MyColors.primaryColor,
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              print('clicked');
                              Navigator.push(context, MaterialPageRoute(builder: (ctx) => const FollowersScreen()));
                              },
                            child: Column(
                              children: [
                                Text(user!.followers!.length.toString() ,
                                  style: TextStyle(color: MyColors.primaryColor , fontSize: 15.0 , fontWeight: FontWeight.bold),),
                                Text("followers_title".tr , style: TextStyle(color: Colors.black , fontSize: 13.0),)
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {Navigator.push(context, MaterialPageRoute(builder: (ctx) => const FollowingScreen()));},
                          child: Column(
                            children: [
                              Text(user!.followings!.length.toString() ,
                                style: TextStyle(color: MyColors.primaryColor , fontSize: 15.0 , fontWeight: FontWeight.bold),),
                              Text("following_title".tr , style: TextStyle(color:Colors.black , fontSize: 13.0),)
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {Navigator.push(context, MaterialPageRoute(builder: (ctx) => const FriendsScreen()));},
                          child: Column(
                            children: [
                              Text(user!.friends!.length.toString() ,
                                style: TextStyle(color: MyColors.primaryColor , fontSize: 15.0 , fontWeight: FontWeight.bold),),
                              Text("friends_title".tr , style: TextStyle(color: Colors.black , fontSize: 13.0),)
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {Navigator.push(context, MaterialPageRoute(builder: (ctx) => const VisitorsScreen()));},
                          child: Column(
                            children: [
                              Text(user!.visitors!.length.toString() ,
                                style: TextStyle(color: MyColors.primaryColor , fontSize: 15.0 , fontWeight: FontWeight.bold),),
                              Text("profile_visitors".tr , style: TextStyle(color: Colors.black , fontSize: 13.0),)
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.0,),
                  operatins.length == 0 ? GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const WalletScreen(),));
                    },
                    child: Container(
                      height: 80.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        image: DecorationImage(image: AssetImage('assets/images/first_charge_banar.png'), fit: BoxFit.cover
                      ),
                    ),
                    ),
                  ) : Container(),
                  SizedBox(height: 10.0,),
        
                  Column(
                    children: [
                      GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (ctx) => const VipScreen()));
                        },
                        child: Stack(
                          alignment: Alignment.centerRight,
                          children: [
                            Shimmer(
                              color:Colors.white ,
                              child: Container(
                                height: 60.0,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
                                  image: DecorationImage(image: AssetImage('assets/images/vip-bar.png'), fit: BoxFit.cover
                                  ),
                                ),
                              ),
                            ),
        
        
        
                           Container(
                                padding: EdgeInsets.symmetric(horizontal: 15.0 , vertical: 8.0),
                                margin: EdgeInsets.symmetric(horizontal: 10.0),
                                decoration: BoxDecoration(
                                  color: MyColors.primaryColor,
                                  borderRadius: BorderRadius.circular(20.0)
                                ),
                                child: Text('mall_purchase'.tr , style: TextStyle(color: Colors.white , fontSize: 13.0),),
                              ),
        
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.0,),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15.0),
                                image: DecorationImage(image: AssetImage('assets/images/Gold-bag.png'), fit: BoxFit.cover
                                ),
                              ),
                              child: GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (ctx) => const WalletScreen()));
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("profile_gold".tr , style: TextStyle(color: MyColors.primaryColor , fontSize: 18.0 , fontWeight: FontWeight.bold),),
                                    SizedBox(height: 10.0,),
                                    Row(
                                      children: [
                                        Image(image: AssetImage('assets/images/gold.png') , width: 30.0, height: 30.0,),
                                        SizedBox(width: 5.0,),
                                        Text(double.parse(user!.gold).floor().toString()  , style: TextStyle(color: MyColors.primaryColor , fontSize: 18.0 , fontWeight: FontWeight.bold),),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 10.0,),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15.0),
                                image: DecorationImage(image: AssetImage('assets/images/diamond-bag.png'), fit: BoxFit.cover
                                ),
                              ),
                              child: GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (ctx) => const WalletScreen()));
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("profile_diamond".tr , style: TextStyle(color: MyColors.blueColor.withOpacity(.9) , fontSize: 18.0 , fontWeight: FontWeight.bold),),
                                    SizedBox(height: 10.0,),
                                    Row(
                                      children: [
                                        Image(image: AssetImage('assets/images/diamond.png') , width: 27.0, height: 27.0,),
                                        SizedBox(width: 5.0,),
                                        Text(double.parse(user!.diamond).floor().toString(), style: TextStyle(color: MyColors.blueColor.withOpacity(.9) , fontSize: 18.0 , fontWeight: FontWeight.bold),),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
        
                  SizedBox(height: 10.0,),
                  Container(
                    height: 70.0,
                    decoration: BoxDecoration(color:Colors.white,
                    borderRadius: BorderRadius.circular(15.0)),
                    width: double.infinity,
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: (){
                              openMyRoom();
                            },
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image(image: AssetImage('assets/images/Room.png') , width: 45.0,),
        
                                Text("profile_room".tr , style: TextStyle(color: MyColors.whiteColor , fontSize: 12.0 ),)
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (ctx) => const MallScreen()));
                            },
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image(image: AssetImage('assets/images/mall.png') , width: 45.0,),
                                Text("mall_title".tr , style: TextStyle(color: MyColors.whiteColor , fontSize: 12.0 ),)
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (ctx) => const MyGiftsScreen()));
                            },
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image(image: AssetImage('assets/images/gIFT.png') , width: 45.0,),
                                Text("profile_gifts".tr , style: TextStyle(color: MyColors.whiteColor , fontSize: 12.0 ),)
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (ctx) => const MyLevelScreen()));
                            },
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image(image: AssetImage('assets/images/LV.png') , width: 45.0,),
                                Text("profile_level".tr , style: TextStyle(color: MyColors.whiteColor , fontSize: 12.0 ),)
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10.0,),
                  Container(
                    decoration: BoxDecoration(color: Colors.white,
                    borderRadius: BorderRadius.circular(15.0)),
                    width: double.infinity,
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (ctx) => const MyPostsScreen()));
                          },
                          child: Row(
                            children: [
                               Image(image: AssetImage('assets/images/POST.png') , width: 40.0, height: 40.5,),
                               SizedBox(width: 10.0,),
                               Text("profile_my_posts".tr , style: TextStyle(color: MyColors.whiteColor , fontSize: 16.0),),
                               Expanded(
                                 child: Column(
                                   crossAxisAlignment: CrossAxisAlignment.end,
                                   children: [
                                     Icon(Icons.arrow_forward_ios , size: 22.0, color: MyColors.whiteColor,)
                                   ],
                                 ),
                               )
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsetsDirectional.only(start: 50.0 , end: 10.0),
                          width: double.infinity,
                          height: 1.0,
                          color: MyColors.darkColor.withAlpha(120),
                        ),
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (ctx) => const AddStatusScreen()));
                          },
                          child: Row(
                            children: [
                              Image(image: AssetImage('assets/images/Status.png') , width: 40.0, height: 40.5,),
                              SizedBox(width: 10.0,),
                              Text("profile_my_status".tr , style: TextStyle(color: MyColors.whiteColor , fontSize: 16.0),),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Icon(Icons.arrow_forward_ios , size: 22.0, color: MyColors.whiteColor,)
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsetsDirectional.only(start: 50.0 , end: 10.0),
                          width: double.infinity,
                          height: 1.0,
                          color: MyColors.darkColor.withAlpha(120),
                        ),
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (ctx) => const InviteScreen()));
                          },
                          child: Row(
                            children: [
                              Image(image: AssetImage('assets/images/INVIT.png') , width: 40.0, height: 40.5,),
                              SizedBox(width: 10.0,),
                              Text("profile_invite_friends".tr , style: TextStyle(color: MyColors.whiteColor , fontSize: 16.0),),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Icon(Icons.arrow_forward_ios , size: 22.0, color: MyColors.whiteColor,)
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsetsDirectional.only(start: 50.0 , end: 10.0),
                          width: double.infinity,
                          height: 1.0,
                          color: MyColors.darkColor.withAlpha(120),
                        ),
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: (){
                            Navigator.push(context,MaterialPageRoute(builder: (context)=> MedalsScreen(),),);
                          },
                          child: Row(
                            children: [
                              Image(image: AssetImage('assets/images/badge.png') , width: 40.0, height: 40.5,),
                              SizedBox(width: 10.0,),
                              Text("profile_medals".tr , style: TextStyle(color: MyColors.whiteColor , fontSize: 16.0),),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Icon(Icons.arrow_forward_ios , size: 22.0, color: MyColors.whiteColor,)
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10.0,),
                  Container(
                    decoration: BoxDecoration(color: Colors.white,
                        borderRadius: BorderRadius.circular(15.0)),
                    width: double.infinity,
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: (){
                            Navigator.push(context,MaterialPageRoute(builder: (context)=> ContactUsScreen(),),);
                          },
                          child: Row(
                            children: [
                              Image(image: AssetImage('assets/images/contact.png') , width: 40.0, height: 40.5,),
                              SizedBox(width: 10.0,),
                              Text("profile_contact_us".tr , style: TextStyle(color: MyColors.whiteColor , fontSize: 16.0),),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Icon(Icons.arrow_forward_ios , size: 22.0, color: MyColors.whiteColor,)
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsetsDirectional.only(start: 50.0 , end: 10.0),
                          width: double.infinity,
                          height: 1.0,
                          color:MyColors.darkColor.withAlpha(120),
                        ),
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const Agreement_Screen(),));
                          },
                          child: Row(
                            children: [
                              Image(image: AssetImage('assets/images/Policy.png') , width: 40.0, height: 40.5,),
                              SizedBox(width: 10.0,),
                              Text("profile_terms_of_use".tr , style: TextStyle(color: MyColors.whiteColor , fontSize: 16.0),),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Icon(Icons.arrow_forward_ios , size: 22.0, color: MyColors.whiteColor,)
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsetsDirectional.only(start: 50.0 , end: 10.0),
                          width: double.infinity,
                          height: 1.0,
                          color: MyColors.darkColor.withAlpha(120),
                        ),
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const Privacy_Policy_Screen(),));
                          },
                          child: Row(
                            children: [
                              Image(image: AssetImage('assets/images/Userpolicy.png') , width: 40.0, height: 40.5,),
                              SizedBox(width: 10.0,),
                              Text("privacy_policy_title".tr , style: TextStyle(color: MyColors.whiteColor , fontSize: 16.0),),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Icon(Icons.arrow_forward_ios , size: 22.0, color: MyColors.whiteColor,)
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10.0,),
                  Container(
                    decoration: BoxDecoration(color:Colors.white,
                        borderRadius: BorderRadius.circular(15.0)),
                    width: double.infinity,
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (ctx) => const SettingScreen()));
                          },
                          child: Row(
                            children: [
                              Image(image: AssetImage('assets/images/SETTING.png') , width: 40.0, height: 40.5,),
                              SizedBox(width: 10.0,),
                              Text("profile_account_settings".tr , style: TextStyle(color: MyColors.whiteColor , fontSize: 16.0),),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Icon(Icons.arrow_forward_ios , size: 22.0, color: MyColors.whiteColor,)
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
              ),
            ),
          ),
        ),
      ),
    );
  }
}
