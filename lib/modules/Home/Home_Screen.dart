import 'dart:io';
import 'package:LikLok/models/Mall.dart';
import 'package:LikLok/modules/BlockedScreen/blocked_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:LikLok/helpers/ExitRoomHelper.dart';
import 'package:LikLok/helpers/MicHelper.dart';
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
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
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

class HomeScreenState extends State<HomeScreen>   with WidgetsBindingObserver , SingleTickerProviderStateMixin{
  //vars
  AppLifecycleState? _lastLifecycleState;

  List<BannerData> banners = [];
  List<Country> countries = [];
  List<ChatRoom> rooms = [];
  List<ChatRoom> rooms_mine = [] ;

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
  AppUser? user;
  List<File> imageFile  = [] ;

  TabController? _tabController;

  HomeScreenState() {}

  getBanners() async {

    if(BannerServices().bannerGetter().length > 0 ){
      if(mounted) {
        setState(() {
          loading = false;
        });
      }
      rooms = ChatRoomService().roomsGetter();
      rooms.sort((b, a) => a.isTrend.compareTo(b.isTrend));
      banners = BannerServices().bannerGetter() ;
      countries = CountryService().countryGetter();
      rooms_mine = ChatRoomService().userRoomGetter();
      festivalBanners = FestivalBannerService().festivalBannersGetter();
    }
    else {
      List<BannerData> res = await BannerServices().getAllBanners();
      BannerServices().bannerSetter(BannerServices.banners);
      if (mounted) {
        setState(() {
          banners = res;
        });
      }
      List<Country> res2 = await CountryService().getAllCountries();
      if (mounted) {
        setState(() {
          countries = res2;
          CountryService().countrySetter(countries);
        });
      }
      List<ChatRoom> res3 = await ChatRoomService().getAllChatRooms();
      List<ChatRoom> res5 = await ChatRoomService().getAdminChatRooms(user!.id);
      ChatRoomService().roomsSetter(res3);
      ChatRoomService().userRoomSetter(res5);
      if (mounted) {
        setState(() {
          rooms = res3;
          rooms_mine = res5;
          rooms.sort((b, a) => a.isTrend.compareTo(b.isTrend));

          loaded = true;
        });
      }

      List<FestivalBanner> res4 = await FestivalBannerService().getAllBanners();
      FestivalBannerService().festivalBannersSetter(res4);
      if (mounted) {
        setState(() {
          festivalBanners = res4;
        });
        setState(() {
          loading = false;
        });
      }
    }
  }

  //var


  Future<void> _refresh() async {
    await getBanners();
   // await getAppCup();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _tabController = new TabController(vsync: this, length: 3);
    if(mounted) {
      setState(() {
        user = AppUserServices().userGetter();
      });
    }
    Wakelock.enable();
    getAppPermission();
    getBanners();
   // getAppCup();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  checkDeviceBanOrAccountDisable(token) async{

    bool res = await AppUserServices().checkDeviceBan(token);
    AppUser? resUser = await AppUserServices().getUser(user!.id);
    if(mounted) {
      setState(() {
        user = resUser!;
      });
    }
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
    if(state == AppLifecycleState.resumed){
      checkDeviceBanOrAccountDisable(user!.token);
    }
  }



  getAppCup() async {
    AppTrend? res = await AppTrendService().getAppTrend();
    if(mounted) {
      setState(() {
        trend = res;
      });
    }
  }

  getAppPermission() async {
    await [Permission.microphone , Permission.notification].request();
  }
  // getNotificationsPermissions() async{
  //   await Permission.notification.isDenied.then((value) {
  //     if (value) {
  //       Permission.notification.request();
  //     }
  //   });
  // }

  connectToWs() {}
  @override
  Widget build(BuildContext context) {
    return   DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: MyColors.solidDarkColor,
          title: TabBar(
            controller: _tabController ,
            dividerColor: Colors.transparent,
            tabAlignment: TabAlignment.start,
            isScrollable: true,
            indicatorColor: MyColors.primaryColor,
            labelColor: MyColors.primaryColor,
            unselectedLabelColor: MyColors.lightUnSelectedColor,
            labelStyle:
                const TextStyle(fontSize: 17.0, fontWeight: FontWeight.w900),
            tabs: [
              new Tab(text: "home_party".tr ,) ,
              new Tab(
                text: "home_discover".tr,
              ),
              new Tab(
                text: "home_my_room".tr,
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
             //     openMyRoom();
                  showMyRoomOnly();
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
                controller: _tabController,
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
                    //mine
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
                              children: rooms_mine
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
                  ],
                ),
        ),
      ),
    ) ;
  }


  Widget countryListItem(index) => countries.isNotEmpty
      ? GestureDetector(
          onTap: () {
            if(mounted) {
              setState(() {
                selectedCountry = countries[index].id;
              });
            }
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

  Widget chatRoomEmptyListItem() => GestureDetector(
    onTap: () {
      openMyRoom();
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
                        image: CachedNetworkImageProvider('${ASSETSBASEURL}Defaults/room_default.png'),
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
                        Text("create_room".tr,
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
                            Text("---",
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
                                  "0",
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
              ],
            ),
          )
        ],
      ),
    ),
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
                        Expanded(
                          child: Column(
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
                          ),
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
              if(mounted) {
                setState(() {
                  selectedChatRoomCategory = chatRoomCats[index];
                });
              }
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
  void showMyRoomOnly()  {
    _tabController!.animateTo(2);
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
    if (banner.room_id > 0) {
      openRoom(banner.room_id);
    }
  }
}
