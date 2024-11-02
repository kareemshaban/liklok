import 'package:LikLok/helpers/DesigGiftHelper.dart';
import 'package:LikLok/helpers/ExitRoomHelper.dart';
import 'package:LikLok/helpers/MicHelper.dart';
import 'package:LikLok/models/AppUser.dart';
import 'package:LikLok/models/ChatRoom.dart';
import 'package:LikLok/models/Design.dart';
import 'package:LikLok/models/Medal.dart';
import 'package:LikLok/modules/EditProfile/Edit_Profile_Screen.dart';
import 'package:LikLok/modules/MyGifts/My_Gifts_Screen.dart';
import 'package:LikLok/modules/Room/Room_Screen.dart';
import 'package:LikLok/modules/chat/chat.dart';
import 'package:LikLok/shared/components/Constants.dart';
import 'package:LikLok/shared/network/remote/AppUserServices.dart';
import 'package:LikLok/shared/network/remote/ChatRoomService.dart';
import 'package:LikLok/shared/styles/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:svgaplayer_flutter/player.dart';

import '../Loading/loadig_screen.dart';

class InnerProfileScreen extends StatefulWidget {
  final int visitor_id ;
  const InnerProfileScreen({super.key , required this.visitor_id });

  @override
  State<InnerProfileScreen> createState() => _InnerProfileScreenState();
}

class _InnerProfileScreenState extends State<InnerProfileScreen> {
  AppUser? user ;
  AppUser? visitor ;
  bool isVisitor  = false;
  List<Design> designs = [] ;
  List<Design> gifts = [] ;
  String frame = "" ;
  Widget followBtn = Container();
  var passwordController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setState(() {
      isVisitor = widget.visitor_id != 0 ;
    });
    getProfileUser();

  }
  getProfileUser() async {
    if(isVisitor ){
      print(visitor)   ;
      AppUser? res = await AppUserServices().getUser(widget.visitor_id);
      print(res)   ;
      setState(() {
        user = res;
      });
      getDesigns();
    } else {
      AppUser? res = AppUserServices().userGetter();
      setState(() {
        user = res;
      });
      getDesigns();
    }

  }
  getDesigns () async {
    DesignGiftHelper helper = await AppUserServices().getMyDesigns(user!.id);
    List<Design> _gifts = [] ;
    Design? design ;
    for(var i = 0 ; i< helper.gifts!.length ; i++){
      if(_gifts.where((element) => element.id ==helper.gifts![i].id ).toList().length == 0){
        design = helper.gifts![i] ;
        design.send_count = 1 ;
        _gifts.add(design);

      } else {
        design =  _gifts.where((element) => element.id ==helper.gifts![i].id ).toList()[0];
        _gifts.remove(design);
        design.send_count = design.send_count! + 1  ;
        _gifts.add(design);

      }
    }
    setState(() {
      designs = helper.designs! ;
      gifts = _gifts ;

    });
    if(designs.where((element) => (element.category_id == 4 && element.isDefault == 1)).toList().length > 0){
      String icon = designs.where((element) => (element.category_id == 4 && element.isDefault == 1)).toList()[0].motion_icon ;

      setState(() {
        frame = ASSETSBASEURL + 'Designs/Motion/' + icon +'?raw=true' ;
        print(frame);
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return user != null ?  Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0),
        child: AppBar(
          iconTheme: IconThemeData(
            color: MyColors.whiteColor, //change your color here
          ),
          toolbarHeight: 70.0,
          backgroundColor: MyColors.solidDarkColor,
          title: Row(
            children: [
              CircleAvatar(
                backgroundColor: user!.gender == 0 ? MyColors.blueColor : MyColors.pinkColor ,
                backgroundImage: user?.img != "" ?  CachedNetworkImageProvider(getUserImage()!) : null,
                radius: 20,
                child: user?.img== "" ?
                Text(user!.name.toUpperCase().substring(0 , 1) +
                    (user!.name.contains(" ") ? user!.name.substring(user!.name.indexOf(" ")).toUpperCase().substring(1 , 2) : ""),
                  style: const TextStyle(color: Colors.white , fontSize: 18.0 , fontWeight: FontWeight.bold),) : null,
              ),
              SizedBox(width: 25.0,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Row(
                    children: [
                      Text(user!.name , style: TextStyle(color: Colors.black , fontSize: 15.0 , fontWeight: FontWeight.bold),),
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

                      Image(image: CachedNetworkImageProvider('${ASSETSBASEURL}Levels/${user!.share_level_icon}') , width: 30,),
                      const SizedBox(width: 5.0,),
                      Image(image: CachedNetworkImageProvider('${ASSETSBASEURL}Levels/${user!.karizma_level_icon}') , width: 30,),
                      const SizedBox(width: 5.0, ),
                      Image(image: CachedNetworkImageProvider('${ASSETSBASEURL}Levels/${user!.charging_level_icon}') , width: 30,),
                    ],
                  ),



                ],
              ),
            ],
          ),
          actions: [

            isVisitor! ?  PopupMenuButton<int>(
              color: MyColors.darkColor,
              onSelected: (item) => {
               if(item == 0){
                 reportUser()
               } else {
                 blockUser()
               }
              },
              iconColor: Colors.white,
              iconSize: 25.0,
              itemBuilder: (context) => [
                 PopupMenuItem<int>(value: 0, child: Row(
                   children: [
                     Icon(Icons.block , color: MyColors.whiteColor , size: 18.0,),
                     SizedBox(width: 5.0,),
                     Text("inner_report".tr , style: TextStyle(color: MyColors.whiteColor , fontSize: 15.0),)
                   ],
                 )),
                PopupMenuItem<int>(value: 1, child: Row(
                  children: [
                    Icon(Icons.report , color: MyColors.whiteColor , size: 18.0,),
                    SizedBox(width: 5.0,),
                    Text("inner_block".tr , style: TextStyle(color: MyColors.whiteColor , fontSize: 15.0),)
                  ],
                )),
              ],
            ) :
                IconButton(onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (ctx) => const EditProfileScreen()));
                }, icon: Icon(Icons.edit , color: Colors.black,))
          ],
        ),
      ),
      body: Container(
        color: MyColors.darkColor,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 150.0,
                      decoration: BoxDecoration(
                          image:  user!.cover != "" ?
                          DecorationImage( image: CachedNetworkImageProvider(ASSETSBASEURL + 'AppUsers/Covers/' + user!.cover), fit: BoxFit.cover) :
                          DecorationImage( image: AssetImage('assets/images/cover.png'), fit: BoxFit.cover ,
                            )

                      ),
                    ),
                    Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        Container(
                          width: double.infinity,
                          color: MyColors.darkColor,
                          padding: EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              SizedBox(height: 40.0,),
                              Text(user!.name , style: TextStyle(color: Colors.black , fontSize: 18.0),),
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
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("ID:" + user!.tag , style: TextStyle(color: MyColors.unSelectedColor , fontSize: 12.0),),
                                    const SizedBox(width: 5.0,),
                                    Icon(Icons.copy_outlined , color: MyColors.unSelectedColor , size: 20.0,)
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  user!.vips!.length > 0 ?  Image(image: CachedNetworkImageProvider('${ASSETSBASEURL}VIP/${user!.vips![0].icon}') , width: 40,) : Container(),
                                  user!.vips!.length > 0 ?  const SizedBox(width: 5.0,):  Container(),

                                  
                     
                                  Image(image: CachedNetworkImageProvider('${ASSETSBASEURL}Levels/${user!.share_level_icon}') , width: 40,),
                                  const SizedBox(width: 5.0,),
                                  Image(image: CachedNetworkImageProvider('${ASSETSBASEURL}Levels/${user!.karizma_level_icon}') , width: 40,),
                                  const SizedBox(width: 5.0),
                                  Image(image: CachedNetworkImageProvider('${ASSETSBASEURL}Levels/${user!.charging_level_icon}') , width: 40,),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  user!.vips!.length > 0  && designs.where((element) => element.category_id == 10).toList().length > 0  ?  Container(width: 50.0 , height: 50.0, child: SVGASimpleImage( resUrl: ASSETSBASEURL + 'Designs/Motion/' + designs.where((element) => element.category_id == 10).toList()[0].motion_icon +'?raw=true')) : Container(),
                                  Row(

                                    children:  user!.medals!.map((medal) =>  getMedalItem(medal)).toList()

                                  ),
                                ],
                              ),
                              Text(user!.status !="" ? user!.status  : (isVisitor ? "inner_nothing".tr : "inner_nothing_update".tr)  , style: TextStyle(color: MyColors.unSelectedColor , fontSize: 16.0),),
                            ],
                          ),
                        ),
                        Transform.translate(
                          offset: Offset(0, -40.0),
                          child: Stack(
                            alignment: Alignment.center,

                            children: [
                              CircleAvatar(
                                backgroundColor: user!.gender == 0 ? MyColors.blueColor : MyColors.pinkColor ,
                                backgroundImage: user?.img != "" ?  CachedNetworkImageProvider(getUserImage()!) : null,
                                radius: 35,
                                child: user?.img== "" ?
                                Text(user!.name.toUpperCase().substring(0 , 1) +
                                    (user!.name.contains(" ") ? user!.name.substring(user!.name.indexOf(" ")).toUpperCase().substring(1 , 2) : ""),
                                  style: const TextStyle(color: Colors.white , fontSize: 22.0 , fontWeight: FontWeight.bold),) : null,
                              ),
                              Container(height: 100.0, width: 100.0, child: frame != "" ? SVGASimpleImage(   resUrl: frame) : null),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: double.infinity,
                      height: 6.0,
                      color: MyColors.solidDarkColor,
                      margin: EdgeInsetsDirectional.only(top: 20.0),
                    ),
                    Container(
                      padding: EdgeInsets.all(15.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 8.0,
                                height: 30.0,
                                decoration: BoxDecoration(color: MyColors.secondaryColor , borderRadius: BorderRadius.circular(3.0)),
                              ),
                              SizedBox(width: 10.0,),
                              Text("inner_basic_information".tr , style: TextStyle(color: Colors.black , fontSize: 16.0 , fontWeight: FontWeight.bold),)
                            ],
                          ),
                          SizedBox(height: 5.0,),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Row(
                              children: [
                                Text("ID" , style: TextStyle(fontSize: 14.0 , color: MyColors.unSelectedColor , fontWeight: FontWeight.bold),),
                                Expanded(child:
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(user!.tag , style: TextStyle(fontSize: 14.0 , color: MyColors.whiteColor),),
                                        SizedBox(width: 5.0,),
                                        IconButton(onPressed: (){}, icon: Icon(FontAwesomeIcons.idBadge , color: Colors.black , size: 20.0,) ,)
                                      ],
                                    )                          ],
                                )

                                )
                              ],
                            ),
                          ),
                          SizedBox(height: 5.0,),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Row(
                              children: [
                                Text("edit_profile_user_name".tr , style: TextStyle(fontSize: 14.0 , color: MyColors.unSelectedColor , fontWeight: FontWeight.bold),),
                                Expanded(child:
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(user!.name , style: TextStyle(fontSize: 14.0 , color: Colors.black),),
                                        SizedBox(width: 5.0,),
                                        IconButton(onPressed: (){}, icon: Icon(FontAwesomeIcons.faceGrinWide , color: Colors.black , size: 20.0))
                                      ],
                                    )

                                  ],
                                )

                                )
                              ],
                            ),
                          ),
                          SizedBox(height: 5.0,),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Row(
                              children: [
                                Text("edit_profile_gender".tr , style: TextStyle(fontSize: 14.0 , color: MyColors.unSelectedColor , fontWeight: FontWeight.bold),),
                                Expanded(child:
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(user!.gender == 0 ? "edit_profile_male".tr : "edit_profile_female".tr , style: TextStyle(fontSize: 14.0 , color: Colors.black),),
                                        SizedBox(width: 5.0,),
                                        IconButton(onPressed: (){}, icon: Icon(user!.gender == 0 ?  FontAwesomeIcons.male : FontAwesomeIcons.female , color: Colors.black , size: 20.0))
                                      ],
                                    )

                                  ],
                                )

                                )
                              ],
                            ),
                          ),
                          SizedBox(height: 5.0,),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Row(
                              children: [
                                Text("edit_profile_date_of_birth".tr , style: TextStyle(fontSize: 14.0 , color: MyColors.unSelectedColor , fontWeight: FontWeight.bold),),
                                Expanded(child:
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(formattedDate(user!.birth_date ).toString(), style: TextStyle(fontSize: 14.0 , color: Colors.black),),
                                        SizedBox(width: 5.0,),
                                        IconButton(onPressed: (){}, icon: Icon(FontAwesomeIcons.birthdayCake  , color: Colors.black , size: 20.0))
                                      ],
                                    )

                                  ],
                                )

                                )
                              ],
                            ),
                          ),
                          SizedBox(height: 5.0,),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Row(
                              children: [
                                Text("edit_profile_country".tr , style: TextStyle(fontSize: 14.0 , color: MyColors.unSelectedColor , fontWeight: FontWeight.bold),),
                                Expanded(child:
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Image(image: CachedNetworkImageProvider(ASSETSBASEURL + 'Countries/' + user!.country_flag) , width: 30.0,),
                                        SizedBox(width: 5.0,),
                                        IconButton(onPressed: (){}, icon: Icon(FontAwesomeIcons.flag  , color: Colors.black , size: 20.0))

                                      ],
                                    )

                                  ],
                                )

                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: 6.0,
                      color: MyColors.solidDarkColor,
                      margin: EdgeInsetsDirectional.only(top: 20.0),
                    ),
                   Container(
                      padding: EdgeInsets.all(15.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 8.0,
                                height: 30.0,
                                decoration: BoxDecoration(color: MyColors.secondaryColor , borderRadius: BorderRadius.circular(3.0)),
                              ),
                              SizedBox(width: 10.0,),
                              Text("edit_profile_my_tags".tr , style: TextStyle(color: Colors.black , fontSize: 16.0 , fontWeight: FontWeight.bold),)
                            ],
                          ),
                          SizedBox(height:10.0,),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Row(
                              mainAxisAlignment: user!.hoppies!.length == 0 ? MainAxisAlignment.center : MainAxisAlignment.start,
                              children: [
                                user!.hoppies!.length == 0 ?
                                Text('inner_nothing'.tr , style: TextStyle(color: MyColors.unSelectedColor , fontSize: 15.0),)
                                : SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: user!.hoppies!.map((e) => hoppyListItem(e)).toList(),
                                  ),
                                ),
                              ],
                            ),
                          ),

                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: 6.0,
                      color: MyColors.solidDarkColor,
                      margin: EdgeInsetsDirectional.only(top: 20.0),
                    ),
                    Container(
                      padding: EdgeInsets.all(15.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 8.0,
                                height: 30.0,
                                decoration: BoxDecoration(color: MyColors.secondaryColor , borderRadius: BorderRadius.circular(3.0)),
                              ),
                              SizedBox(width: 10.0,),
                              Text("inner_room_gifts".tr , style: TextStyle(color: Colors.black , fontSize: 16.0 , fontWeight: FontWeight.bold),)
                            ],
                          ),
                          SizedBox(height: 5.0,),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Container(
                              height: 100.0,
                              child:  gifts.length == 0 ?
                              Text('inner_nothing'.tr , style: TextStyle(color: MyColors.unSelectedColor , fontSize: 15.0),)
                                  : Row(
                                children: [
                                   Expanded(child: ListView.separated(itemBuilder: (ctx , index) => giftItemBuilder(index), separatorBuilder:(ctx , index) =>  seperatorItem(), itemCount: gifts.length > 3 ? 4 : gifts.length + 1 , scrollDirection: Axis.horizontal, ))
                                ],
                              ),
                            ),
                          ),

                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: 6.0,
                      color: MyColors.solidDarkColor,
                      margin: EdgeInsetsDirectional.only(top: 20.0),
                    ),
                    Container(
                      padding: EdgeInsets.all(15.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 8.0,
                                height: 30.0,
                                decoration: BoxDecoration(color: MyColors.secondaryColor , borderRadius: BorderRadius.circular(3.0)),
                              ),
                              SizedBox(width: 10.0,),
                              Text("inner_my_frames".tr , style: TextStyle(color: Colors.black , fontSize: 16.0 , fontWeight: FontWeight.bold),)
                            ],
                          ),
                          SizedBox(height: 15.0,),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Container(
                              height: 100.0,
                              child:  designs.where((element) => element.category_id == 4).toList().length == 0 ?
                              Text('inner_nothing'.tr , style: TextStyle(color: MyColors.unSelectedColor , fontSize: 15.0),)
                                  : Row(
                                children: [
                                  Expanded(child: ListView.separated(itemBuilder: (ctx , index) => designItemBuilder(index , 4), separatorBuilder:(ctx , index) =>  seperatorItem(), itemCount: designs.where((element) => element.category_id == 4).toList().length   , scrollDirection: Axis.horizontal, ))
                                ],
                              ),
                            ),
                          ),

                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: 6.0,
                      color: MyColors.solidDarkColor,
                      margin: EdgeInsetsDirectional.only(top: 20.0),
                    ),
                    Container(
                      padding: EdgeInsets.all(15.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 8.0,
                                height: 30.0,
                                decoration: BoxDecoration(color: MyColors.secondaryColor , borderRadius: BorderRadius.circular(3.0)),
                              ),
                              SizedBox(width: 10.0,),
                              Text("inner_cars_(Entries)".tr , style: TextStyle(color: Colors.black , fontSize: 16.0 , fontWeight: FontWeight.bold),)
                            ],
                          ),
                          SizedBox(height: 15.0,),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Container(
                              height: 100.0,
                              child:  designs.where((element) => element.category_id == 5).toList().length == 0 ?
                              Text('inner_nothing'.tr , style: TextStyle(color: MyColors.unSelectedColor , fontSize: 15.0),)
                                  :Row(
                                children: [
                                  Expanded(child: ListView.separated(itemBuilder: (ctx , index) => designItemBuilder(index , 5), separatorBuilder:(ctx , index) =>  seperatorItem(), itemCount: designs.where((element) => element.category_id == 5).toList().length   , scrollDirection: Axis.horizontal, ))
                                ],
                              ),
                            ),
                          ),

                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
           isVisitor! ? Container(
              color: MyColors.solidDarkColor.withAlpha(150),
              width: double.infinity,
              height: 80.0,
              padding: EdgeInsets.all(5.0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        getFollowBtn()
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: (){openChat();},
                            child: Image(image: AssetImage('assets/images/message.png') , width: 80.0)),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: (){openUserRoom();}, child: Image(image: AssetImage('assets/images/home.png') , width: 80.0)),
                      ],
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                     behavior: HitTestBehavior.opaque,
                     onTap: (){trackUser();},
                      child: Column(
                        children: [
                          Image(image: AssetImage('assets/images/tracking.png') , width: 80.0),
                        ],
                      ),
                    ),
                  ),

                ],
              ),
            ) : SizedBox(height: 5.0,)
          ],
        ),
      ),
    ) : Loading();
  }



  String formattedDate(dateTime) {
    const DATE_FORMAT = 'dd/MM/yyyy';
    print('dateTime ($dateTime)');
    return DateFormat(DATE_FORMAT).format(DateTime.parse(dateTime) );

  }

  Widget hoppyListItem(tag) => Container(
    margin: EdgeInsets.symmetric(horizontal: 10.0),
    child: DottedBorder (
      borderType: BorderType.RRect,
      color: MyColors.primaryColor,
      strokeWidth: 1,
      dashPattern: [8, 4],
      strokeCap: StrokeCap.round,
      radius: Radius.circular(100.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15.0 , vertical: 8.0),
        decoration: BoxDecoration(border: Border.all(color: Colors.transparent , width: 1.0 , style: BorderStyle.solid) , borderRadius: BorderRadius.circular(25.0) ,
            color: MyColors.blueColor.withAlpha(100) ),
        child:  Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text('#${tag.name}' , style: TextStyle(color: MyColors.whiteColor , fontSize: 15.0),)
          ],),
      ),

    ),
  );

  Widget giftItemBuilder(i) => i < gifts.length ? Column(
    children: [
      Container(
        width: 80.0,
        height: 55.0,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(25.5), color: Colors.black12),
        child: Image(image: CachedNetworkImageProvider(ASSETSBASEURL + 'Designs/' + gifts[i].icon) , width: 50,)
      ),
      SizedBox(height: 5.0,),
      Text(gifts[i].name , style: TextStyle(fontSize: 13.0 , color: MyColors.unSelectedColor),),
      Text('X' +  gifts[i].count.toString() , style: TextStyle(fontSize: 12.0 , color: MyColors.unSelectedColor , fontWeight: FontWeight.bold),),
    ],
  ) :  Column(
    children: [
     !isVisitor ? GestureDetector(
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (ctx) => const MyGiftsScreen()));
        },
        child: Container(
            width: 80.0,
            height: 55.0,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(25.5), color: Colors.black12),
            child: Icon(Icons.arrow_forward_ios_outlined , color: MyColors.unSelectedColor , size: 20.0,)
        ),
      ) : Container(),
    ],
  );

  Widget seperatorItem() => SizedBox(width: 10.0,);

  Widget designItemBuilder(i , cat) => Container(
     width: 80.0,
     height: 80.0,
     decoration: BoxDecoration(borderRadius: BorderRadius.circular(15.0) , color: Colors.black12),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image(image: CachedNetworkImageProvider(ASSETSBASEURL + 'Designs/' +
            designs.where((element) => element.category_id == cat).toList()[i].icon) , width: 70, height: 70,)
      ],
    ),
  );

  String? getUserImage(){
    if(user!.img.startsWith('https')){
      return user!.img.toString() ;
    } else {
      return '${ASSETSBASEURL}AppUsers/${user?.img}' ;
    }
  }
  reportUser() async{
     AppUser? currentUser = AppUserServices().userGetter();
     await AppUserServices().reportUser(currentUser!.id, user!.id);
     Navigator.pop(context);
  }
  blockUser() async{
    AppUser? currentUser = AppUserServices().userGetter();
    await AppUserServices().blockUser(currentUser!.id, user!.id);
    currentUser = await AppUserServices().getUser(currentUser!.id);
    AppUserServices().userSetter(currentUser!);
    Navigator.pop(context);
  }
  followUser() async{
    AppUser? currentUser = AppUserServices().userGetter();
    AppUser? res = await AppUserServices().followUser(currentUser!.id, user!.id);

    AppUserServices().userSetter(res!);
    Fluttertoast.showToast(
        msg: 'inner_msg_followed'.tr,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black26,
        textColor: Colors.orange,
        fontSize: 16.0
    );
    Navigator.pop(context);
  }
  unFollowUser() async{
    AppUser? currentUser = AppUserServices().userGetter();
    AppUser? res = await AppUserServices().unfollowkUser(currentUser!.id, user!.id);
    AppUserServices().userSetter(res!);
    Fluttertoast.showToast(
        msg: 'inner_msg_unfollowed'.tr,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black26,
        textColor: Colors.orange,
        fontSize: 16.0
    );
    Navigator.pop(context);
  }
  openChat(){
    print('visitor');
    print(user);

    Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen(receiverUserEmail: user!.email, receiverUserID: user!.id , receiver: user!,),));
  }
  openUserRoom() async{

    ChatRoom? res = await ChatRoomService().openRoomByAdminId(user!.id);
    if(res != null){
      await checkForSavedRoom(res);
      if(res.password.isEmpty ){
        ChatRoomService().roomSetter(res!);
        Navigator.push(context, MaterialPageRoute(builder: (context) => RoomScreen(),));
      } else {
        //show password
        _displayTextInputDialog(context , res);
      }

    } else {
      print('clicked');
      Fluttertoast.showToast(
          msg: 'inner_msg_no_room'.tr,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black26,
          textColor: Colors.orange,
          fontSize: 16.0
      );
    }


  }
  trackUser() async {
    ChatRoom? res = await ChatRoomService().trackUser(user!.id);
    if(res != null){
      await checkForSavedRoom(res);
      if(res.password.isEmpty){
        ChatRoomService().roomSetter(res);
        Navigator.push(context, MaterialPageRoute(builder: (context) => RoomScreen(),));
      } else {
         //showpassword
        _displayTextInputDialog(context , res);
      }

    } else {
      print('clicked');
      Fluttertoast.showToast(
          msg: 'inner_msg_not_any_room'.tr,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black26,
          textColor: Colors.orange,
          fontSize: 16.0
      );
    }
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


  Future<void> _displayTextInputDialog(BuildContext context , ChatRoom room) async {
    return showDialog(
      context: context,
      builder: (context) {
        return Container(
          child: AlertDialog(
            backgroundColor: MyColors.darkColor,
            title: Text(
              'room_password_label'.tr,
              style: TextStyle(color: Colors.white, fontSize: 20.0),
              textAlign: TextAlign.center,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                Container(
                  height: 70.0,
                  child: TextField(
                    controller: passwordController,
                    style: TextStyle(color: Colors.white),
                    cursorColor: MyColors.primaryColor,
                    maxLength: 20,
                    keyboardType: TextInputType.visiblePassword,
                    decoration: InputDecoration(
                        hintText: "XXXXXXX",
                        hintStyle: TextStyle(color: Colors.white),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(color: MyColors.whiteColor)),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0))),
                  ),
                ),
              ],
            ),
            actions: <Widget>[
              Container(
                decoration: BoxDecoration(
                    color: MyColors.solidDarkColor,
                    borderRadius: BorderRadius.circular(15.0)),
                child: MaterialButton(
                  child: Text(
                    'edit_profile_cancel'.tr,
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    Navigator.pop(context);
                  },
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    color: MyColors.primaryColor,
                    borderRadius: BorderRadius.circular(15.0)),
                child: MaterialButton(
                  child: Text(
                    'OK',
                    style: TextStyle(color: MyColors.darkColor),
                  ),
                  onPressed: () async {
                    if(passwordController.text == room.password){
                      ChatRoomService().roomSetter(room);
                      Navigator.push(context, MaterialPageRoute(builder: (context) => RoomScreen(),));
                    } else {
                      Fluttertoast.showToast(
                          msg: "room_password_wrong".tr,
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.black26,
                          textColor: Colors.orange,
                          fontSize: 16.0
                      );
                    }

                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget getFollowBtn(){
    AppUser? currentUser = AppUserServices().userGetter();
    if(currentUser!.followings!.where((element) => element.follower_id == user!.id).length == 0){
      return  GestureDetector(onTap: () {followUser();},  child: Image(image: AssetImage('assets/images/add-user.png') , width: 80.0,));
    } else {
      return  GestureDetector(onTap: () {unFollowUser();},  child: Image(image: AssetImage('assets/images/remove-user.png') , width: 80.0,));
    }
  }

  Widget getMedalItem(Medal medal){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.0 , vertical: 5.0),
      child: Column(
        children:[
          Image(image: CachedNetworkImageProvider('${ASSETSBASEURL}Badges/${medal.icon}') , width: 40,),

        ]

      ),
    );
  }
}
