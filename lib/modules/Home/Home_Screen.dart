import 'dart:convert';
import 'dart:io';
import 'package:LikLok/helpers/RoomBasicDataHelper.dart';
import 'package:LikLok/models/Mall.dart';
import 'package:LikLok/modules/BlockedScreen/blocked_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:LikLok/helpers/ExitRoomHelper.dart';
import 'package:LikLok/helpers/MicHelper.dart';
import 'package:LikLok/layout/tabs_screen.dart';
import 'package:LikLok/models/AppTrend.dart';
import 'package:LikLok/models/AppUser.dart';
import 'package:LikLok/models/Banner.dart';
import 'package:LikLok/models/ChatRoom.dart';
import 'package:LikLok/models/Country.dart';
import 'package:LikLok/models/FestivalBanner.dart';
import 'package:LikLok/modules/AppCup/app_cup_screen.dart';
import 'package:LikLok/modules/BannerDetails/banner_details_screen.dart';
import 'package:LikLok/modules/InnerProfile/Inner_Profile_Screen.dart';
import 'package:LikLok/modules/Loading/loadig_screen.dart';
import 'package:LikLok/modules/Room/Room_Screen.dart';
import 'package:LikLok/modules/Search_Screen/SearchScreen.dart';
import 'package:LikLok/shared/components/Constants.dart';
import 'package:LikLok/shared/network/remote/AppTrendServices.dart';
import 'package:LikLok/shared/network/remote/AppUserServices.dart';
import 'package:LikLok/shared/network/remote/BannerServices.dart';
import 'package:LikLok/shared/network/remote/ChatRoomService.dart';
import 'package:LikLok/shared/network/remote/CountryService.dart';
import 'package:LikLok/shared/network/remote/FestivalBannerServices.dart';
import 'package:LikLok/shared/styles/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:path_provider/path_provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wakelock/wakelock.dart';

import '../../helpers/MallHelper.dart';
import '../../shared/network/remote/DesignServices.dart';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen>   with WidgetsBindingObserver {
  //vars
  AppLifecycleState? _lastLifecycleState;

  List<BannerData> banners = [];
  List<Country> countries = [];
  List<ChatRoom> rooms = [];
  List<FestivalBanner> festivalBanners = [];
  List<String> chatRoomCats = [
    'CHAT',
    'FRIENDS',
    'QURAN',
    'GAMES',
    'ENTERTAINMENT'
  ];
  int selectedCountry = 0;
  String selectedChatRoomCategory = 'CHAT';
  bool loaded = false;
  bool loading = false;
  var passwordController = TextEditingController();
  AppTrend? trend;
  MallHelper? helper;

  List<Mall>? designs = [];
  int? selectedCategory;

  int tabsCount = 0;

  List<File> imageFile  = [] ;

  TabController? _tabController;

  HomeScreenState() {}

  getBanners() async {
    setState(() {
      loading = true;
    });
    List<BannerData> res = await BannerServices().getAllBanners();
    setState(() {
      banners = res;
    });
    List<Country> res2 = await CountryService().getAllCountries();
    setState(() {
      countries = res2;
      CountryService().countrySetter(countries);
    });
    List<ChatRoom> res3 = await ChatRoomService().getAllChatRooms();
    setState(() {
      rooms = res3;
      rooms.sort((b, a) => a.isTrend.compareTo(b.isTrend));

      loaded = true;
    });
    List<FestivalBanner> res4 = await FestivalBannerService().getAllBanners();
    setState(() {
      festivalBanners = res4;
      print('FestivalBanner');
    });
    setState(() {
      loading = false;
    });
  }

  //var
  AppUser? user;

  Future<void> _refresh() async {
    await getBanners();
    await getAppCup();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    setState(() {
      user = AppUserServices().userGetter();
    });
    Wakelock.enable();
    getMicPermission();
    getNotificationsPermissions();
    getBanners();
    getAppCup();
   // cashData();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  checkDeviceBanOrAccountDisable(token) async{

    bool res = await AppUserServices().checkDeviceBan(token);
    AppUser? resUser = await AppUserServices().getUser(user!.id);
    setState(() {
      user = resUser! ;
    });
    if(!res ){
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => BlockedScreen(block_type:1),
          ) ,   (route) => false
      );

    } else if(user!.enable == 0){
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => BlockedScreen(block_type:0),
          ) ,   (route) => false
      );
    }


  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print('app state');
    print(state);
    if(state == AppLifecycleState.resumed){
      checkDeviceBanOrAccountDisable(user!.token);
    }

    // setState(() {
    //   _lastLifecycleState = state;
    //
    // });
    // print('lastState');
    // print(_lastLifecycleState);
    // if(_lastLifecycleState == AppLifecycleState.paused){
    //   Future.delayed(Duration(seconds: 120)).then((value) async {
    //     if(_lastLifecycleState == AppLifecycleState.paused){
    //       //still in active =>  remove from rooms
    //       RoomBasicDataHelper? res = await ChatRoomService().getRoomBasicData() ;
    //       print(res);
    //       // if(res){
    //       //   await FirebaseFirestore.instance.collection("exitRoom").add({
    //       //     'room_id': 0,
    //       //     'user_id': user!.id,
    //       //   });
    //       //   SystemNavigator.pop();
    //       // }
    //     } else {
    //       print('AppStateToKeep');
    //       print(_lastLifecycleState);
    //     }
    //
    //   }
    //
    //   );
    // }

  }





  cashData() async {
    helper = await DesignServices().getAllCatsAndDesigns();
    setState(() {
      designs = helper!.designs;
    });
    loadImage();
  }
  Future<void> loadImage() async {
    for(var i =0 ; i < helper!.designs!.length ; i++){
      final directory = await getApplicationDocumentsDirectory();
      final filePath = path.join(directory.path, helper!.designs![i].motion_icon);
      final file = File(filePath);

      if (await file.exists()){
        List<File> temp = [];
        temp = imageFile ;
        temp.add(file);
        setState((){
          imageFile = temp ;
        });
        updateImage(file,helper!);
      } else {
        await downloadImage(file , helper!);
        setState(() {
          imageFile.add(file);
        });
      }
    }
  }
  Future<void> downloadImage(File file , MallHelper helper) async {
    for(var i = 0 ; i < helper.designs!.length  ; i++){
      final response = await http.get(Uri.parse('${ASSETSBASEURL + 'Designs/' + helper.designs![i].motion_icon}'));
      if (response.statusCode == 200) {
        await file.writeAsBytes(response.bodyBytes);
        List<File> temp = [];
        temp = imageFile ;
        temp.add(file);
        setState((){
          imageFile = temp ;
        });
      }
    }
    print('Download imageFile');
    print(imageFile);
  }
  Future<void> updateImage(File file , MallHelper helper) async {
    for(var i = 0 ; i < helper.designs!.length  ; i++){
      final response = await http.get(Uri.parse('${ASSETSBASEURL + 'Designs/' + helper.designs![i].motion_icon}'));
      if (response.statusCode == 200) {
        await file.writeAsBytes(response.bodyBytes);
        List<File> temp = [];
        temp = imageFile ;
        temp.add(file);
        setState((){
          imageFile = temp ;
        });
      }
    }
    print('Update Image');
    print(imageFile);
  }


  getAppCup() async {
    AppTrend? res = await AppTrendService().getAppTrend();
    setState(() {
      trend = res;
    });
  }

  getMicPermission() async {
    await [Permission.microphone].request();
  }
  getNotificationsPermissions() async{
    await Permission.notification.isDenied.then((value) {
      if (value) {
        Permission.notification.request();
      }
    });
  }

  connectToWs() {}
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: MyColors.solidDarkColor,
          title: TabBar(
            dividerColor: Colors.transparent,
            tabAlignment: TabAlignment.start,
            isScrollable: true,
            indicatorColor: MyColors.primaryColor,
            labelColor: MyColors.primaryColor,
            unselectedLabelColor: MyColors.lightUnSelectedColor,
            labelStyle:
                const TextStyle(fontSize: 17.0, fontWeight: FontWeight.w900),
            tabs: [
              Tab(text: "home_party".tr),
              Tab(
                text: "home_discover".tr,
              ),
            ],
          ),
          actions: [
            GestureDetector(
                behavior: HitTestBehavior.opaque,
                child: const Image(
                  image: AssetImage('assets/images/chatroom_rank_ic.png'),
                  width: 30.0,
                  height: 30.0,
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AppCupScreen(),
                      ));
                }),
            const SizedBox(
              width: 20.0,
            ),
            GestureDetector(
                behavior: HitTestBehavior.opaque,
                child: const Image(
                  image: AssetImage('assets/images/voice-message.png'),
                  width: 30.0,
                  height: 30.0,
                ),
                onTap: () {
                  openMyRoom();
                }),
            const SizedBox(
              width: 20.0,
            ),
            GestureDetector(
                behavior: HitTestBehavior.opaque,
                child: const Image(
                  image: AssetImage('assets/images/search.png'),
                  width: 30.0,
                  height: 30.0,
                ),
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (ctx) => const SearchScreen()))),
            const SizedBox(
              width: 10.0,
            ),
          ],
        ),
        body: Container(
          color: MyColors.darkColor,
          width: double.infinity,
          child: loading
              ? Loading()
              : TabBarView(
                  children: [
                    // home
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 121.0,
                          width: MediaQuery.sizeOf(context).width * .95,
                          child: CarouselSlider(
                              items: banners
                                  .map((banner) => GestureDetector(
                                        onTap: () {
                                          bannerAction(banner);
                                        },
                                        child: Container(
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 5.0, vertical: 10.0),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                              image: DecorationImage(
                                                  image: CachedNetworkImageProvider(
                                                      '${ASSETSBASEURL}Banners/${banner.img}'),
                                                  fit: BoxFit.cover)),
                                          clipBehavior:
                                              Clip.antiAliasWithSaveLayer,
                                        ),
                                      ))
                                  .toList(),
                              options: CarouselOptions(
                                  aspectRatio: 3,
                                  autoPlay: true,
                                  viewportFraction: 1.0)),
                        ),

                        SizedBox(height: 10.0,),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          height: 40.0,
                          child: ListView.separated(
                            itemBuilder: (ctx, index) => countryListItem(index),
                            separatorBuilder: (ctx, index) =>
                                countryListSpacer(),
                            itemCount: countries.length,
                            scrollDirection: Axis.horizontal,
                          ),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Expanded(
                          child: RefreshIndicator(
                            color: MyColors.primaryColor,
                            onRefresh: _refresh,
                            child: GridView.count(
                              crossAxisCount: 2,
                                childAspectRatio: .85 ,
                              children: rooms
                                  .where((element) =>
                                      element.country_id == selectedCountry ||
                                      selectedCountry == 0)
                                  .map((room) => chatRoomListItem(room))
                                  .toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    //discover.

                    Column(
                      children: [
                        festivalBanners.length > 0
                            ? Container(
                                height: 110.0,
                                width: MediaQuery.sizeOf(context).width * .95,
                                child: CarouselSlider(
                                    items: festivalBanners
                                        .map((banner) => GestureDetector(
                                              onTap: () {
                                                bannerFestivalAction(banner);
                                              },
                                              child: Container(
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 5.0,
                                                        vertical: 10.0),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                    image: DecorationImage(
                                                        image: CachedNetworkImageProvider(
                                                            '${ASSETSBASEURL}FestivalBanner/${banner.img}'),
                                                        fit: BoxFit.cover)),
                                                clipBehavior:
                                                    Clip.antiAliasWithSaveLayer,
                                              ),
                                            ))
                                        .toList(),
                                    options: CarouselOptions(
                                        aspectRatio: 3,
                                        autoPlay: true,
                                        viewportFraction: 1.0)),
                              )
                            : Container(),
                        Container(
                          margin: EdgeInsetsDirectional.only(top: 10.0),
                          padding: const EdgeInsets.symmetric(horizontal: 15.0 ),
                          height: 40.0,
                          child: ListView.separated(
                            itemBuilder: (ctx, index) =>
                                chatRoomCategoryListItem(index),
                            separatorBuilder: (ctx, index) =>
                                countryListSpacer(),
                            itemCount: chatRoomCats.length,
                            scrollDirection: Axis.horizontal,
                          ),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Expanded(
                          child: RefreshIndicator(
                            color: MyColors.primaryColor,
                            onRefresh: _refresh,
                            child: rooms.length == 0 ?
                            Center(child: Column(
                              children: [
                                SizedBox(height: 20.0,),
                                Image(image: AssetImage('assets/images/sad.png') , width: 100.0 , height: 100.0,),
                                SizedBox(height: 30.0,),
                                Text('no_data'.tr , style: TextStyle(color: Colors.red , fontSize: 18.0 ) ,)


                              ],), )
                            : GridView.count(
                              crossAxisCount: 2,
                              childAspectRatio: .85 ,
                              children: rooms
                                  .where((element) =>
                                      element.subject ==
                                      selectedChatRoomCategory)
                                  .map((room) => chatRoomListItem(room))
                                  .toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget countryListItem(index) => countries.isNotEmpty
      ? GestureDetector(
          onTap: () {
            setState(() {
              selectedCountry = countries[index].id;
            });
          },
          child: Container(
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
                border: Border.all(
                    color: MyColors.lightUnSelectedColor.withOpacity(.2),
                    width: 1.0,
                    style: BorderStyle.solid),
                borderRadius: BorderRadius.circular(25.0),
                color: countries[index].id == selectedCountry
                    ? MyColors.primaryColor
                    : MyColors.lightUnSelectedColor.withOpacity(.2)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                countries[index].id > 0
                    ? Image(
                        image: CachedNetworkImageProvider(
                            '${ASSETSBASEURL}Countries/${countries[index].icon}'),
                        width: 30.0,
                      )
                    : Image(
                        image: AssetImage(countries[index].icon),
                        width: 30.0,
                      ),
                const SizedBox(
                  width: 5.0,
                ),
                Text(
                  countries[index].name,
                  style: TextStyle(color: countries[index].id == selectedCountry ? Colors.white : Colors.black, fontSize: 13.0),
                )
              ],
            ),
          ),
        )
      : Container();
  Widget countryListSpacer() => const SizedBox(
        width: 5.0,
      );

  Widget chatRoomListItem(room) => GestureDetector(
        onTap: () {
          openRoom(room.id);
        },
        child: Container(
          width: MediaQuery.of(context).size.width / 2,
          margin: const EdgeInsets.all(5.0),

          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width / 2,
                    height: (MediaQuery.of(context).size.width / 2) * 1.15 ,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        image: DecorationImage(
                            image: getRoomImage(room),
                            fit: BoxFit.cover,
                            colorFilter: ColorFilter.mode(
                                Colors.grey.withOpacity(.7),
                                BlendMode.darken))),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.only(
                        start: 15.0, bottom: 20.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(room.name,
                                textAlign: TextAlign.end,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold,
                                )),
                            Row(
                              children: [
                                Icon(Icons.location_pin , color: Colors.white, size: 18,),
                                Text(room.country_name,
                                    textAlign: TextAlign.end,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 11.0,
                                      fontWeight: FontWeight.bold,
                                    )),


                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      width: ((MediaQuery.of(context).size.width / 2) - 50),
                      child: Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                color: MyColors.lightgrey.withOpacity(.7),
                                borderRadius: BorderRadiusDirectional.only(
                                    topStart: Radius.circular(15.0))),
                            width: MediaQuery.sizeOf(context).width / 4,
                            height: 32.0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                    flex: 7,
                                    child: Image(image: AssetImage('assets/images/rank.webp') , height: 20,)),
                                Expanded(
                                  flex: 3,
                                  child: Padding(
                                    padding: const EdgeInsetsDirectional.only(start: 5.0),
                                    child: Text(
                                      room.memberCount.toString(),
                                      style: TextStyle(
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Container(
                    //     margin: EdgeInsets.all(5.0),
                    //     child: Image(
                    //       image: CachedNetworkImageProvider(
                    //           ASSETSBASEURL + 'Countries/' + room.flag),
                    //       width: 30.0,
                    //     )),
                  ],
                ),
              )
            ],
          ),
        ),
      );

  Widget chatRoomCategoryListItem(index) => chatRoomCats.isNotEmpty
      ? GestureDetector(
          onTap: () {
            setState(() {
              selectedChatRoomCategory = chatRoomCats[index];
            });
          },
          child: Container(
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
                border: Border.all(
                    color: Colors.transparent,
                    width: 1.0,
                    style: BorderStyle.solid),
                borderRadius: BorderRadius.circular(25.0),
                color: chatRoomCats[index] == selectedChatRoomCategory
                    ? MyColors.primaryColor
                    : MyColors.lightUnSelectedColor),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  '#${chatRoomCats[index].toLowerCase()}',
                  style: TextStyle(
                      color: chatRoomCats[index] == selectedChatRoomCategory
                          ? MyColors.darkColor
                          : MyColors.whiteColor,
                      fontSize: 15.0),
                )
              ],
            ),
          ),
        )
      : Container();

  void openChatRoom(room) {}
  void takeBannerAction(index) {}
  Color getMyColor(String subject) {
    if (subject == "CHAT") {
      return MyColors.primaryColor.withOpacity(.8);
    } else if (subject == "FRIENDS") {
      return MyColors.successColor.withOpacity(.8);
    } else if (subject == "GAMES") {
      return MyColors.blueColor.withOpacity(.8);
    } else {
      return MyColors.primaryColor.withOpacity(.8);
    }
  }

  void openTrendPage() {}
  void openMyRoom() async {
    ChatRoom? room = await ChatRoomService().openMyRoom(user!.id);
    await checkForSavedRoom(room!);
    ChatRoomService().roomSetter(room);
    Navigator.push(
        context, MaterialPageRoute(builder: (ctx) => const RoomScreen()));
  }

  void openSearch() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const SearchScreen()));
  }

  void openRoom(id) async {
    ChatRoom? res = await ChatRoomService().openRoomById(id);
    if (res != null) {
      await checkForSavedRoom(res);
      if (res.password.isEmpty || res.userId == user!.id) {
        ChatRoomService().roomSetter(res);
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RoomScreen(),
            ));
      } else {
        //showPassword popup
        _displayTextInputDialog(context, res);
      }
    }
  }

  Future<void> _displayTextInputDialog(
      BuildContext context, ChatRoom room) async {
    return showDialog(
      context: context,
      builder: (context) {
        return Container(
          child: AlertDialog(
            backgroundColor: MyColors.darkColor,
            title: Text(
              'room_password_label'.tr,
              style: TextStyle(color: Colors.black, fontSize: 20.0),
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
                        hintStyle: TextStyle(color: Colors.black),
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
                    color: MyColors.whiteColor,
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
                    if (passwordController.text == room.password) {
                      ChatRoomService().roomSetter(room);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RoomScreen(),
                          ));
                    } else {
                      Fluttertoast.showToast(
                          msg: "room_password_wrong".tr,
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.black26,
                          textColor: Colors.orange,
                          fontSize: 16.0);
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

  ImageProvider getRoomImage(room) {
    String room_img = '';

    if (room!.img == room!.admin_img) {
      if (room!.admin_img != "") {
        room_img = '${ASSETSBASEURL}AppUsers/${room?.admin_img}';
      } else {
        room_img = '${ASSETSBASEURL}Defaults/room_default.png';
      }
    } else {
      if (room?.img != "") {
        room_img = '${ASSETSBASEURL}Rooms/${room?.img}';
      } else {
        room_img = '${ASSETSBASEURL}Defaults/room_default.png';
      }
    }
    return CachedNetworkImageProvider(room_img);
  }

  checkForSavedRoom(ChatRoom room) async {
    ChatRoom? savedRoom = ChatRoomService().savedRoomGetter();
    if (savedRoom != null) {
      if (savedRoom.id == room.id) {
      } else {
        // close the savedroom
        ChatRoomService().savedRoomSetter(null);
        await ChatRoomService.engine!.leaveChannel();
        await ChatRoomService.engine!.release();
        MicHelper(user_id: user!.id, room_id: savedRoom!.id, mic: 0).leaveMic();
        ExitRoomHelper(user!.id, savedRoom.id);
      }
    }
  }

  bannerAction(banner) {
    if (banner.action == 0) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BannerDetailsScreen(url: banner.url),
          ));
    } else if (banner.action == 1) {
      //open Room
      if (banner.room_id > 0) {
        openRoom(banner.room_id);
      }
    } else if (banner.action == 2) {
      //open User Profile
      if (banner.user_id > 0) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (ctx) =>
                    InnerProfileScreen(visitor_id: banner.user_id)));
      }
    }
  }

  bannerFestivalAction(banner) {
    print(banner.room_id);
    if (banner.room_id > 0) {
      openRoom(banner.room_id);
    }
  }
}
