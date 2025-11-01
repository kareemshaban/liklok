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
import 'package:flutter_svga/flutter_svga.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import '../../helpers/MallHelper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  List<BannerData> banners = [];
  List<Country> countries = [];
  List<ChatRoom> rooms = [];
  List<ChatRoom> rooms_mine = [];

  List<FestivalBanner> festivalBanners = [];
  List<String> chatRoomCats = [
    'CHAT',
    'FRIENDS',
    'QURAN',
    'GAMES',
    'ENTERTAINMENT',
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
  List<File> imageFile = [];

  TabController? _tabController;

  HomeScreenState() {}

  getBanners() async {
    if (BannerServices().bannerGetter().length > 0) {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
      rooms = ChatRoomService().roomsGetter();
      rooms.sort((b, a) => a.isTrend.compareTo(b.isTrend));
      banners = BannerServices().bannerGetter();
      countries = CountryService().countryGetter();
      rooms_mine = ChatRoomService().userRoomGetter();
      festivalBanners = FestivalBannerService().festivalBannersGetter();
    } else {
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
    await getAppCup();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // Enable wakelock
    //Wakelock.enable();

    WidgetsBinding.instance.addObserver(this);
    _tabController = new TabController(vsync: this, length: 3);
    if (mounted) {
      setState(() {
        user = AppUserServices().userGetter();
      });
    }
    //Wakelock.enable();
    WakelockPlus.enable(); // Keep screen on

    getAppPermission();
    getBanners();
    getAppCup();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  checkDeviceBanOrAccountDisable(token) async {
    bool res = await AppUserServices().checkDeviceBan(token);
    AppUser? resUser = await AppUserServices().getUser(user!.id);
    if (mounted) {
      setState(() {
        user = resUser!;
      });
    }
    if (!res) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => BlockedScreen(block_type: 1)),
        (route) => false,
      );
    } else if (user!.enable == 0) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => BlockedScreen(block_type: 0)),
        (route) => false,
      );
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      checkDeviceBanOrAccountDisable(user!.token);
    }
  }

  getAppCup() async {
    AppTrend? res = await AppTrendService().getAppTrend();
    if (mounted) {
      setState(() {
        trend = res;
      });
    }
  }

  getAppPermission() async {
    await [Permission.microphone, Permission.notification].request();
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
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: MyColors.solidDarkColor,
          title: TabBar(
            controller: _tabController,
            dividerColor: Colors.transparent,
            tabAlignment: TabAlignment.start,
            isScrollable: true,
            indicatorColor: MyColors.primaryColor,
            labelColor: MyColors.primaryColor,
            unselectedLabelColor: MyColors.lightUnSelectedColor,
            labelStyle: const TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w900,
            ),
            tabs: [
              new Tab(text: "home_party".tr),
              new Tab(text: "home_discover".tr),
              new Tab(text: "home_my_room".tr),
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
                  MaterialPageRoute(builder: (context) => const AppCupScreen()),
                );
              },
            ),
            const SizedBox(width: 20.0),
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
              },
            ),
            const SizedBox(width: 20.0),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              child: const Image(
                image: AssetImage('assets/images/search.png'),
                width: 30.0,
                height: 30.0,
              ),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (ctx) => const SearchScreen()),
              ),
            ),
            const SizedBox(width: 10.0),
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
                                .map(
                                  (banner) => GestureDetector(
                                    onTap: () {
                                      bannerAction(banner);
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 5.0,
                                        vertical: 10.0,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          10.0,
                                        ),
                                        image: DecorationImage(
                                          image: CachedNetworkImageProvider(
                                            '${ASSETSBASEURL}Banners/${banner.img}',
                                          ),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                    ),
                                  ),
                                )
                                .toList(),
                            options: CarouselOptions(
                              aspectRatio: 3,
                              autoPlay: true,
                              viewportFraction: 1.0,
                            ),
                          ),
                        ),
                        SizedBox(height: 10.0),
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
                        const SizedBox(height: 10.0),
                        Expanded(
                          child: RefreshIndicator(
                            color: MyColors.primaryColor,
                            onRefresh: _refresh,
                            child: ListView.builder(
                              padding: const EdgeInsets.all(8.0),
                              itemCount: rooms
                                  .where(
                                    (element) =>
                                        element.country_id == selectedCountry ||
                                        selectedCountry == 0,
                                  )
                                  .length,
                              itemBuilder: (context, index) {
                                final filteredRooms = rooms
                                    .where(
                                      (element) =>
                                          element.country_id ==
                                              selectedCountry ||
                                          selectedCountry == 0,
                                    )
                                    .toList();

                                final room = filteredRooms[index];
                                return chatRoomListItem(room, context, index);
                              },
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
                                      .map(
                                        (banner) => GestureDetector(
                                          onTap: () {
                                            bannerFestivalAction(banner);
                                          },
                                          child: Container(
                                            margin: const EdgeInsets.symmetric(
                                              horizontal: 5.0,
                                              vertical: 10.0,
                                            ),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                              image: DecorationImage(
                                                image: CachedNetworkImageProvider(
                                                  '${ASSETSBASEURL}FestivalBanner/${banner.img}',
                                                ),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            clipBehavior:
                                                Clip.antiAliasWithSaveLayer,
                                          ),
                                        ),
                                      )
                                      .toList(),
                                  options: CarouselOptions(
                                    aspectRatio: 3,
                                    autoPlay: true,
                                    viewportFraction: 1.0,
                                  ),
                                ),
                              )
                            : Container(),
                        Container(
                          margin: EdgeInsetsDirectional.only(top: 10.0),
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
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
                        const SizedBox(height: 10.0),
                        Expanded(
                          child: RefreshIndicator(
                            color: MyColors.primaryColor,
                            onRefresh: _refresh,
                            child: rooms.length == 0
                                ? Center(
                                    child: Column(
                                      children: [
                                        SizedBox(height: 20.0),
                                        Image(
                                          image: AssetImage(
                                            'assets/images/sad.png',
                                          ),
                                          width: 100.0,
                                          height: 100.0,
                                        ),
                                        SizedBox(height: 30.0),
                                        Text(
                                          'no_data'.tr,
                                          style: TextStyle(
                                            color: Colors.red,
                                            fontSize: 18.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : ListView.builder(
                                    padding: const EdgeInsets.all(8.0),
                                    itemCount: rooms
                                        .where(
                                          (element) =>
                                              element.subject ==
                                              selectedChatRoomCategory,
                                        )
                                        .length,
                                    itemBuilder: (context, index) {
                                      final filteredRooms = rooms
                                          .where(
                                            (element) =>
                                                element.subject ==
                                                selectedChatRoomCategory,
                                          )
                                          .toList();

                                      final room = filteredRooms[index];

                                      return chatRoomListItem(
                                        room,
                                        context,
                                        index,
                                      );
                                    },
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
                                .map(
                                  (banner) => GestureDetector(
                                    onTap: () {
                                      bannerAction(banner);
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 5.0,
                                        vertical: 10.0,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          10.0,
                                        ),
                                        image: DecorationImage(
                                          image: CachedNetworkImageProvider(
                                            '${ASSETSBASEURL}Banners/${banner.img}',
                                          ),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                    ),
                                  ),
                                )
                                .toList(),
                            options: CarouselOptions(
                              aspectRatio: 3,
                              autoPlay: true,
                              viewportFraction: 1.0,
                            ),
                          ),
                        ),
                        SizedBox(height: 10.0),
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
                        const SizedBox(height: 10.0),
                        Expanded(
                          child: RefreshIndicator(
                            color: MyColors.primaryColor,
                            onRefresh: _refresh,
                            child: ListView(
                              padding: const EdgeInsets.all(8.0),
                              children: rooms_mine
                                  .where(
                                    (element) =>
                                        element.country_id == selectedCountry ||
                                        selectedCountry == 0,
                                  )
                                  .map(
                                    (room) =>
                                        chatRoomListItem(room, context, 6),
                                  )
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
            if (mounted) {
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
                style: BorderStyle.solid,
              ),
              borderRadius: BorderRadius.circular(25.0),
              color: countries[index].id == selectedCountry
                  ? MyColors.primaryColor
                  : MyColors.lightUnSelectedColor.withOpacity(.2),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                countries[index].id > 0
                    ? Image(
                        image: CachedNetworkImageProvider(
                          '${ASSETSBASEURL}Countries/${countries[index].icon}',
                        ),
                        width: 30.0,
                      )
                    : Image(
                        image: AssetImage(countries[index].icon),
                        width: 30.0,
                      ),
                const SizedBox(width: 5.0),
                Text(
                  countries[index].name,
                  style: TextStyle(
                    color: countries[index].id == selectedCountry
                        ? Colors.white
                        : Colors.black,
                    fontSize: 13.0,
                  ),
                ),
              ],
            ),
          ),
        )
      : Container();

  Widget countryListSpacer() => const SizedBox(width: 5.0);

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
                height: (MediaQuery.of(context).size.width / 2) * 1.15,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(
                      '${ASSETSBASEURL}Defaults/room_default.png',
                    ),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      Colors.grey.withOpacity(.7),
                      BlendMode.darken,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.only(
                  start: 15.0,
                  bottom: 20.0,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "create_room".tr,
                          textAlign: TextAlign.end,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.location_pin,
                              color: Colors.white,
                              size: 18,
                            ),
                            Text(
                              "---",
                              textAlign: TextAlign.end,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
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
                            topStart: Radius.circular(15.0),
                          ),
                        ),
                        width: MediaQuery.sizeOf(context).width / 4,
                        height: 32.0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 7,
                              child: Image(
                                image: AssetImage('assets/images/rank.webp'),
                                height: 20,
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Padding(
                                padding: const EdgeInsetsDirectional.only(
                                  start: 5.0,
                                ),
                                child: Text(
                                  "0",
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );

  Widget chatRoomListItem(
    ChatRoom room,
    BuildContext context,
    int? index,
  ) => GestureDetector(
    onTap: () {
      print('isTrend');
      print(room.isTrend);
      openRoom(room.id);
    },
    child: Stack(
      children: [
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
            side: BorderSide(color: Colors.white, width: 1.0),
          ),
          elevation: 3.0,
          child: Container(
            height: MediaQuery.of(context).size.width / 3,
            child: Stack(
              alignment: AlignmentDirectional.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width / 3.2,
                        height: MediaQuery.of(context).size.width / 3.2,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12.0),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [getRoomImage(room)],
                          ),
                        ),
                      ),
                      SizedBox(width: 12.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 14.0),
                            Text(
                              room.name,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'ID:' + room.tag,
                              style: TextStyle(
                                color: MyColors.unSelectedColor,
                                fontSize: 13.0,
                              ),
                            ),
                            SizedBox(height: 10.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.location_pin,
                                  color: Colors.black,
                                  size: 20,
                                ),
                                SizedBox(width: 4.0),
                                Expanded(
                                  child: Text(
                                    room.country_name,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // 🟨 Positioned widget: لوضع الـ rank badge أسفل يمين الكارد
                Positioned(
                  bottom: 8,
                  right: 12,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 4.0,
                      horizontal: 10.0,
                    ),
                    decoration: BoxDecoration(
                      color: MyColors.lightgrey.withOpacity(.7),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image(
                          image: AssetImage('assets/images/rank.webp'),
                          height: 15,
                        ),
                        SizedBox(width: 6),
                        Text(
                          room.memberCount.toString(),
                          style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (index == 0)
          Positioned.fill(
            child: Container(
              height: MediaQuery.of(context).size.height / 2,
              width: MediaQuery.of(context).size.width,
              child: SVGAEasyPlayer(
                resUrl: '${ASSETSBASEURL}/Defaults/top1.svga',
                fit: BoxFit.cover,
              ),
            ),
          ),
        if (index == 1)
          Positioned.fill(
            child: Container(
              height: MediaQuery.of(context).size.height / 2,
              width: MediaQuery.of(context).size.width,
              child: SVGAEasyPlayer(
                resUrl: '${ASSETSBASEURL}/Defaults/top2.svga',
                fit: BoxFit.cover,
              ),
            ),
          ),
        if (index == 2)
          Positioned.fill(
            child: Container(
              height: MediaQuery.of(context).size.height / 2,
              width: MediaQuery.of(context).size.width,
              child: SVGAEasyPlayer(
                resUrl: '${ASSETSBASEURL}/Defaults/top3.svga',
                fit: BoxFit.cover,
              ),
            ),
          ),
      ],
    ),
  );

  Widget chatRoomListItem1(room) => GestureDetector(
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
                height: (MediaQuery.of(context).size.width / 2) * 1.15,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      getRoomImage(room),
                      // Add any overlay content here
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.only(
                  start: 15.0,
                  bottom: 20.0,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            room.name,
                            textAlign: TextAlign.end,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.location_pin,
                                color: Colors.white,
                                size: 18,
                              ),
                              Text(
                                room.country_name,
                                textAlign: TextAlign.end,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
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
                            topStart: Radius.circular(15.0),
                          ),
                        ),
                        width: MediaQuery.sizeOf(context).width / 4,
                        height: 32.0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 7,
                              child: Image(
                                image: AssetImage('assets/images/rank.webp'),
                                height: 20,
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Padding(
                                padding: const EdgeInsetsDirectional.only(
                                  start: 5.0,
                                ),
                                child: Text(
                                  room.memberCount.toString(),
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );

  Widget chatRoomCategoryListItem(index) => chatRoomCats.isNotEmpty
      ? GestureDetector(
          onTap: () {
            if (mounted) {
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
                style: BorderStyle.solid,
              ),
              borderRadius: BorderRadius.circular(25.0),
              color: chatRoomCats[index] == selectedChatRoomCategory
                  ? MyColors.primaryColor
                  : MyColors.lightUnSelectedColor,
            ),
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
                    fontSize: 15.0,
                  ),
                ),
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
      context,
      MaterialPageRoute(builder: (ctx) => const RoomScreen()),
    );
  }

  void showMyRoomOnly() {
    _tabController!.animateTo(2);
  }

  void openSearch() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SearchScreen()),
    );
  }

  void openRoom(id) async {
    ChatRoom? res = await ChatRoomService().openRoomById(id);
    if (res != null) {
      await checkForSavedRoom(res);
      if (res.password.isEmpty || res.userId == user!.id) {
        ChatRoomService().roomSetter(res);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => RoomScreen()),
        );
      } else {
        //showPassword popup
        _displayTextInputDialog(context, res);
      }
    }
  }

  Future<void> _displayTextInputDialog(
    BuildContext context,
    ChatRoom room,
  ) async {
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
                        borderSide: BorderSide(color: MyColors.whiteColor),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            actions: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: MyColors.whiteColor,
                  borderRadius: BorderRadius.circular(15.0),
                ),
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
                  borderRadius: BorderRadius.circular(15.0),
                ),
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
                        MaterialPageRoute(builder: (context) => RoomScreen()),
                      );
                    } else {
                      Fluttertoast.showToast(
                        msg: "room_password_wrong".tr,
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.black26,
                        textColor: Colors.orange,
                        fontSize: 16.0,
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

  CachedNetworkImage getRoomImage(room) {
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
    return CachedNetworkImage(
      imageUrl: room_img,
      fit: BoxFit.cover,
      errorWidget: (context, url, error) => CachedNetworkImage(
        imageUrl: '${ASSETSBASEURL}Defaults/room_default.png',
        fit: BoxFit.cover,
      ),
    );
  }

  Widget roomImage(String roomImg) {
    return CachedNetworkImage(
      imageUrl: roomImg,
      fit: BoxFit.cover,
      placeholder: (context, url) => Center(child: CircularProgressIndicator()),
      errorWidget: (context, url, error) => Image.asset(
        'assets/images/default_room.png', // صورة افتراضية لو حصل خطأ
        fit: BoxFit.cover,
      ),
    );
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
        MicHelper(
          user_id: user!.id,
          room_id: savedRoom.id,
          mic: 0,
          user!,
        ).leaveMic();
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
        ),
      );
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
            builder: (ctx) => InnerProfileScreen(visitor_id: banner.user_id),
          ),
        );
      }
    }
  }

  bannerFestivalAction(banner) {
    if (banner.room_id > 0) {
      openRoom(banner.room_id);
    }
  }
}
