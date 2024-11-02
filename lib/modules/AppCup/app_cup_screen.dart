import 'package:LikLok/models/AppTrend.dart';
import 'package:LikLok/models/TrendRoom.dart';
import 'package:LikLok/models/TrendUser.dart';
import 'package:LikLok/modules/Loading/loadig_screen.dart';
import 'package:LikLok/shared/components/Constants.dart';
import 'package:LikLok/shared/network/remote/AppTrendServices.dart';
import 'package:LikLok/shared/styles/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppCupScreen extends StatefulWidget {
  const AppCupScreen({super.key});

  @override
  State<AppCupScreen> createState() => _AppCupScreenState();
}

class _AppCupScreenState extends State<AppCupScreen> with TickerProviderStateMixin{
  late TabController _tabController;
  late TabController _tabController1;
  late TabController _tabController2;
  late TabController _tabController3;
  AppTrend? trend ;
  bool loading = false ;
  String local = '' ;
  @override
  void initState() {
    super.initState();
    getLocal();
    _tabController = new TabController(length: 3, vsync: this);
    _tabController1 = new TabController(length: 3, vsync: this);
    _tabController2 = new TabController(length: 3, vsync: this);
    _tabController3 = new TabController(length: 3, vsync: this);
    getAppTrend();
  }
  getLocal() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? l = await prefs.getString('local_lang') ;
    if(l == null) l = 'en' ;
    if(l == '') l = 'en' ;
     setState(() {
       local = l! ;
     });

  }
  getAppTrend()async {
    AppTrend? res =  await AppTrendService().getAppTrend();
    if(mounted){
      setState(() {
        trend = res ;
        loading = true ;
      });

      print(trend!.dailyShareFans.length);

    }


  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: MyColors.whiteColor, //change your color here
        ),
        backgroundColor: MyColors.solidDarkColor,
        centerTitle: true,
        title:  TabBar(
          controller: _tabController,
          dividerColor: Colors.transparent,
          tabAlignment: TabAlignment.center,
          isScrollable: true ,
          indicatorColor: MyColors.primaryColor,
          labelColor: MyColors.primaryColor,
          unselectedLabelColor: MyColors.whiteColor,
          labelStyle: const TextStyle(fontSize: 17.0 , fontWeight: FontWeight.w900),

          tabs:  [
            Tab(child: Text("my_level_wealth".tr , style: TextStyle(fontSize: 16.0),), ),
            Tab(child: Text("my_level_karizma".tr , style: TextStyle(fontSize: 16.0),), ),
            Tab(child: Text("profile_room".tr , style: TextStyle(fontSize: 16.0),), ),
          ],
        ) ,
        actions: [
          IconButton(icon: Icon(FontAwesomeIcons.sync , color: Colors.black,) , onPressed: (){

          },
          )
        ],
      ),
      body: Container(
        color: MyColors.darkColor,
        //decoration: BoxDecoration(color: MyColors.darkColor,  image: DecorationImage(image: AssetImage('assets/images/icon_profit_live_user.png') , fit: BoxFit.fill)),
        width: double.infinity,
        height: double.infinity,

        child:
        loading ?  TabBarView(
          controller: _tabController,
          children: [
            Column(
              children: [
                Expanded(
                  flex: 5,
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(color: MyColors.darkColor,  image: DecorationImage(image: AssetImage(local == 'en' ? 'assets/images/icon_profit_live_user.png' : 'assets/images/icon_profit_live_user_e.png') , fit: BoxFit.fill)),
                    child: Column(
                      children: [
                        SizedBox(height: 30.0,),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 40.0),
                          decoration: BoxDecoration(color: MyColors.lightUnSelectedColor.withOpacity(.4) , borderRadius: BorderRadius.circular(20.0)),
                          child: TabBar(
                            controller: _tabController1,
                            dividerColor: Colors.transparent,
                            tabAlignment: TabAlignment.center,
                            isScrollable: true ,
                            indicatorColor: MyColors.secondaryColor,
                            labelColor: MyColors.secondaryColor,
                            unselectedLabelColor: MyColors.unSelectedColor,
                            labelStyle: const TextStyle(fontSize: 17.0 , fontWeight: FontWeight.w900),

                            tabs:  [
                              Tab(child: Text("daily".tr , style: TextStyle(fontSize: 16.0),), ),
                              Tab(child: Text("weekly".tr , style: TextStyle(fontSize: 16.0),), ),
                              Tab(child: Text("monthly".tr , style: TextStyle(fontSize: 16.0),), ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: TabBarView(
                            controller: _tabController1,
                            children: [
                              Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 30.0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            children: [
                                              SizedBox(height: 40.0,),
                                              Stack(
                                                alignment: Alignment.center,
                                                children: [

                                                  trend!.dailyShareFans.length > 1 ?  CircleAvatar(
                                                    backgroundColor: trend!.dailyShareFans[1].gender == 0 ? MyColors.blueColor : MyColors.pinkColor ,
                                                    backgroundImage: trend!.dailyShareFans[1].img != "" ? (trend!.dailyShareFans[1].img.startsWith('https') ? CachedNetworkImageProvider(trend!.dailyShareFans[1].img)  :  CachedNetworkImageProvider('${ASSETSBASEURL}AppUsers/${trend!.dailyShareFans[1].img}'))  :    null,
                                                    radius: 30,
                                                    child: trend!.dailyShareFans[1].img== "" ?
                                                    Text(trend!.dailyShareFans[1].name.toUpperCase().substring(0 , 1) +
                                                        (trend!.dailyShareFans[1].name.contains(" ") ? trend!.dailyShareFans[1].name.substring(trend!.dailyShareFans[1].name.indexOf(" ")).toUpperCase().substring(1 , 2) : ""),
                                                      style: const TextStyle(color: Colors.white , fontSize: 22.0 , fontWeight: FontWeight.bold),) : null,
                                                  ): Container(),
                                                  Image(image: AssetImage('assets/images/ic_detail_top_two.png') , width: 90.0,),
                                                ],
                                              ),


                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            children: [
                                              Stack(
                                                alignment: Alignment.center,
                                                children: [
                                                  trend!.dailyShareFans.length > 0 ?  CircleAvatar(
                                                    backgroundColor: trend!.dailyShareFans[0].gender == 0 ? MyColors.blueColor : MyColors.pinkColor ,
                                                    backgroundImage: trend!.dailyShareFans[0].img != "" ? (trend!.dailyShareFans[0].img.startsWith('https') ? CachedNetworkImageProvider(trend!.dailyShareFans[0].img)  :  CachedNetworkImageProvider('${ASSETSBASEURL}AppUsers/${trend!.dailyShareFans[0].img}'))  :    null,
                                                    radius: 40,
                                                    child: trend!.dailyShareFans[0].img== "" ?
                                                    Text(trend!.dailyShareFans[0].name.toUpperCase().substring(0 , 1) +
                                                        (trend!.dailyShareFans[0].name.contains(" ") ? trend!.dailyShareFans[0].name.substring(trend!.dailyShareFans[0].name.indexOf(" ")).toUpperCase().substring(1 , 2) : ""),
                                                      style: const TextStyle(color: Colors.white , fontSize: 22.0 , fontWeight: FontWeight.bold),) : null,
                                                  ): Container(),
                                                  Image(image: AssetImage('assets/images/ic_detail_top_one_small(1).png')),
                                                ],
                                              ),
                                              SizedBox(height: 40.0,),

                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            children: [
                                              SizedBox(height: 40.0,),
                                              Stack(
                                                alignment: Alignment.center,
                                                children: [
                                                  trend!.dailyShareFans.length > 2 ?  CircleAvatar(
                                                    backgroundColor: trend!.dailyShareFans[2].gender == 0 ? MyColors.blueColor : MyColors.pinkColor ,
                                                    backgroundImage: trend!.dailyShareFans[2].img != "" ? (trend!.dailyShareFans[2].img.startsWith('https') ? CachedNetworkImageProvider(trend!.dailyShareFans[2].img)  :  CachedNetworkImageProvider('${ASSETSBASEURL}AppUsers/${trend!.dailyShareFans[2].img}'))  :    null,
                                                    radius: 30,
                                                    child: trend!.dailyShareFans[2].img== "" ?
                                                    Text(trend!.dailyShareFans[2].name.toUpperCase().substring(0 , 1) +
                                                        (trend!.dailyShareFans[2].name.contains(" ") ? trend!.dailyShareFans[2].name.substring(trend!.dailyShareFans[2].name.indexOf(" ")).toUpperCase().substring(1 , 2) : ""),
                                                      style: const TextStyle(color: Colors.white , fontSize: 22.0 , fontWeight: FontWeight.bold),) : null,
                                                  ): Container(),
                                                  Image(image: AssetImage('assets/images/ic_detail_top_three(1).png') , width: 90.0,),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 30.0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            children: [
                                              SizedBox(height: 40.0,),
                                              Stack(
                                                alignment: Alignment.center,
                                                children: [

                                                  trend!.weekShareFanss.length > 1 ?  CircleAvatar(
                                                    backgroundColor: trend!.weekShareFanss[1].gender == 0 ? MyColors.blueColor : MyColors.pinkColor ,
                                                    backgroundImage: trend!.weekShareFanss[1].img != "" ? (trend!.weekShareFanss[1].img.startsWith('https') ? CachedNetworkImageProvider(trend!.weekShareFanss[1].img)  :  CachedNetworkImageProvider('${ASSETSBASEURL}AppUsers/${trend!.weekShareFanss[1].img}'))  :    null,
                                                    radius: 30,
                                                    child: trend!.weekShareFanss[1].img== "" ?
                                                    Text(trend!.weekShareFanss[1].name.toUpperCase().substring(0 , 1) +
                                                        (trend!.weekShareFanss[1].name.contains(" ") ? trend!.weekShareFanss[1].name.substring(trend!.weekShareFanss[1].name.indexOf(" ")).toUpperCase().substring(1 , 2) : ""),
                                                      style: const TextStyle(color: Colors.white , fontSize: 22.0 , fontWeight: FontWeight.bold),) : null,
                                                  ): Container(),
                                                  Image(image: AssetImage('assets/images/ic_detail_top_two.png') , width: 90.0,),
                                                ],
                                              ),


                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            children: [
                                              Stack(
                                                alignment: Alignment.center,
                                                children: [
                                                  trend!.weekShareFanss.length > 0 ?  CircleAvatar(
                                                    backgroundColor: trend!.weekShareFanss[0].gender == 0 ? MyColors.blueColor : MyColors.pinkColor ,
                                                    backgroundImage: trend!.weekShareFanss[0].img != "" ? (trend!.weekShareFanss[0].img.startsWith('https') ? CachedNetworkImageProvider(trend!.weekShareFanss[0].img)  :  CachedNetworkImageProvider('${ASSETSBASEURL}AppUsers/${trend!.weekShareFanss[0].img}'))  :    null,
                                                    radius: 40,
                                                    child: trend!.weekShareFanss[0].img== "" ?
                                                    Text(trend!.weekShareFanss[0].name.toUpperCase().substring(0 , 1) +
                                                        (trend!.weekShareFanss[0].name.contains(" ") ? trend!.weekShareFanss[0].name.substring(trend!.weekShareFanss[0].name.indexOf(" ")).toUpperCase().substring(1 , 2) : ""),
                                                      style: const TextStyle(color: Colors.white , fontSize: 22.0 , fontWeight: FontWeight.bold),) : null,
                                                  ): Container(),
                                                  Image(image: AssetImage('assets/images/ic_detail_top_one_small(1).png')),
                                                ],
                                              ),
                                              SizedBox(height: 40.0,),

                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            children: [
                                              SizedBox(height: 40.0,),
                                              Stack(
                                                alignment: Alignment.center,
                                                children: [
                                                  trend!.weekShareFanss.length > 2 ?  CircleAvatar(
                                                    backgroundColor: trend!.weekShareFanss[2].gender == 0 ? MyColors.blueColor : MyColors.pinkColor ,
                                                    backgroundImage: trend!.weekShareFanss[2].img != "" ? (trend!.weekShareFanss[2].img.startsWith('https') ? CachedNetworkImageProvider(trend!.weekShareFanss[2].img)  :  CachedNetworkImageProvider('${ASSETSBASEURL}AppUsers/${trend!.weekShareFanss[2].img}'))  :    null,
                                                    radius: 30,
                                                    child: trend!.weekShareFanss[2].img== "" ?
                                                    Text(trend!.weekShareFanss[2].name.toUpperCase().substring(0 , 1) +
                                                        (trend!.weekShareFanss[2].name.contains(" ") ? trend!.weekShareFanss[2].name.substring(trend!.weekShareFanss[2].name.indexOf(" ")).toUpperCase().substring(1 , 2) : ""),
                                                      style: const TextStyle(color: Colors.white , fontSize: 22.0 , fontWeight: FontWeight.bold),) : null,
                                                  ): Container(),
                                                  Image(image: AssetImage('assets/images/ic_detail_top_three(1).png') , width: 90.0,),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 30.0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            children: [
                                              SizedBox(height: 40.0,),
                                              Stack(
                                                alignment: Alignment.center,
                                                children: [

                                                  trend!.monthShareFans.length > 1 ?  CircleAvatar(
                                                    backgroundColor: trend!.monthShareFans[1].gender == 0 ? MyColors.blueColor : MyColors.pinkColor ,
                                                    backgroundImage: trend!.monthShareFans[1].img != "" ? (trend!.monthShareFans[1].img.startsWith('https') ? CachedNetworkImageProvider(trend!.monthShareFans[1].img)  :  CachedNetworkImageProvider('${ASSETSBASEURL}AppUsers/${trend!.monthShareFans[1].img}'))  :    null,
                                                    radius: 30,
                                                    child: trend!.monthShareFans[1].img== "" ?
                                                    Text(trend!.monthShareFans[1].name.toUpperCase().substring(0 , 1) +
                                                        (trend!.monthShareFans[1].name.contains(" ") ? trend!.monthShareFans[1].name.substring(trend!.monthShareFans[1].name.indexOf(" ")).toUpperCase().substring(1 , 2) : ""),
                                                      style: const TextStyle(color: Colors.white , fontSize: 22.0 , fontWeight: FontWeight.bold),) : null,
                                                  ): Container(),
                                                  Image(image: AssetImage('assets/images/ic_detail_top_two.png') , width: 90.0,),
                                                ],
                                              ),


                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            children: [
                                              Stack(
                                                alignment: Alignment.center,
                                                children: [
                                                  trend!.monthShareFans.length > 0 ?  CircleAvatar(
                                                    backgroundColor: trend!.monthShareFans[0].gender == 0 ? MyColors.blueColor : MyColors.pinkColor ,
                                                    backgroundImage: trend!.monthShareFans[0].img != "" ? (trend!.monthShareFans[0].img.startsWith('https') ? CachedNetworkImageProvider(trend!.monthShareFans[0].img)  :  CachedNetworkImageProvider('${ASSETSBASEURL}AppUsers/${trend!.monthShareFans[0].img}'))  :    null,
                                                    radius: 40,
                                                    child: trend!.monthShareFans[0].img== "" ?
                                                    Text(trend!.monthShareFans[0].name.toUpperCase().substring(0 , 1) +
                                                        (trend!.monthShareFans[0].name.contains(" ") ? trend!.monthShareFans[0].name.substring(trend!.monthShareFans[0].name.indexOf(" ")).toUpperCase().substring(1 , 2) : ""),
                                                      style: const TextStyle(color: Colors.white , fontSize: 22.0 , fontWeight: FontWeight.bold),) : null,
                                                  ): Container(),
                                                  Image(image: AssetImage('assets/images/ic_detail_top_one_small(1).png')),
                                                ],
                                              ),
                                              SizedBox(height: 40.0,),

                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            children: [
                                              SizedBox(height: 40.0,),
                                              Stack(
                                                alignment: Alignment.center,
                                                children: [
                                                  trend!.monthShareFans.length > 2 ?  CircleAvatar(
                                                    backgroundColor: trend!.monthShareFans[2].gender == 0 ? MyColors.blueColor : MyColors.pinkColor ,
                                                    backgroundImage: trend!.monthShareFans[2].img != "" ? (trend!.monthShareFans[2].img.startsWith('https') ? CachedNetworkImageProvider(trend!.monthShareFans[2].img)  :  CachedNetworkImageProvider('${ASSETSBASEURL}AppUsers/${trend!.monthShareFans[2].img}'))  :    null,
                                                    radius: 30,
                                                    child: trend!.monthShareFans[2].img== "" ?
                                                    Text(trend!.monthShareFans[2].name.toUpperCase().substring(0 , 1) +
                                                        (trend!.monthShareFans[2].name.contains(" ") ? trend!.monthShareFans[2].name.substring(trend!.monthShareFans[2].name.indexOf(" ")).toUpperCase().substring(1 , 2) : ""),
                                                      style: const TextStyle(color: Colors.white , fontSize: 22.0 , fontWeight: FontWeight.bold),) : null,
                                                  ): Container(),
                                                  Image(image: AssetImage('assets/images/ic_detail_top_three(1).png') , width: 90.0,),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                    flex: 5,
                    child: TabBarView(
                      controller: _tabController1,
                      children: [
                        ListView.separated(itemBuilder: (ctx , index) =>itemListBuilder(trend!.dailyShareFans[index]) ,
                            separatorBuilder: (ctx , index) =>itemSperatorBuilder(), itemCount: trend!.dailyShareFans.length),
                        ListView.separated(itemBuilder: (ctx , index) =>itemListBuilder(trend!.weekShareFanss[index]) ,
                            separatorBuilder: (ctx , index) =>itemSperatorBuilder(), itemCount: trend!.weekShareFanss.length),
                        ListView.separated(itemBuilder: (ctx , index) =>itemListBuilder(trend!.monthShareFans[index]) ,
                            separatorBuilder: (ctx , index) =>itemSperatorBuilder(), itemCount: trend!.monthShareFans.length),
                      ],

                    )

                )
              ],
            ),
            Column(
              children: [
                Expanded(
                  flex: 5,
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(color: MyColors.darkColor,  image: DecorationImage(image: AssetImage(local == 'en' ? 'assets/images/icon_profit_voice_user.png' : 'assets/images/icon_profit_voice_user_en.png') , fit: BoxFit.fill)),
                    child: Column(
                      children: [
                        SizedBox(height: 30.0,),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 40.0),
                          decoration: BoxDecoration(color: MyColors.lightUnSelectedColor.withOpacity(.4) , borderRadius: BorderRadius.circular(20.0)),
                          child: TabBar(
                            controller: _tabController2,
                            dividerColor: Colors.transparent,
                            tabAlignment: TabAlignment.center,
                            isScrollable: true ,
                            indicatorColor: MyColors.secondaryColor,
                            labelColor: MyColors.secondaryColor,
                            unselectedLabelColor: MyColors.unSelectedColor,
                            labelStyle: const TextStyle(fontSize: 17.0 , fontWeight: FontWeight.w900),

                            tabs:  [
                              Tab(child: Text("daily".tr , style: TextStyle(fontSize: 16.0),), ),
                              Tab(child: Text("weekly".tr , style: TextStyle(fontSize: 16.0),), ),
                              Tab(child: Text("monthly".tr , style: TextStyle(fontSize: 16.0),), ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: TabBarView(
                            controller: _tabController2,
                            children: [
                              Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 30.0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            children: [
                                              SizedBox(height: 40.0,),
                                              Stack(
                                                alignment: Alignment.center,
                                                children: [

                                                  trend!.dailyKarizmaFans.length > 1 ?  CircleAvatar(
                                                    backgroundColor: trend!.dailyKarizmaFans[1].gender == 0 ? MyColors.blueColor : MyColors.pinkColor ,
                                                    backgroundImage: trend!.dailyKarizmaFans[1].img != "" ? (trend!.dailyKarizmaFans[1].img.startsWith('https') ? CachedNetworkImageProvider(trend!.dailyKarizmaFans[1].img)  :  CachedNetworkImageProvider('${ASSETSBASEURL}AppUsers/${trend!.dailyKarizmaFans[1].img}'))  :    null,
                                                    radius: 30,
                                                    child: trend!.dailyKarizmaFans[1].img== "" ?
                                                    Text(trend!.dailyKarizmaFans[1].name.toUpperCase().substring(0 , 1) +
                                                        (trend!.dailyKarizmaFans[1].name.contains(" ") ? trend!.dailyKarizmaFans[1].name.substring(trend!.dailyKarizmaFans[1].name.indexOf(" ")).toUpperCase().substring(1 , 2) : ""),
                                                      style: const TextStyle(color: Colors.white , fontSize: 22.0 , fontWeight: FontWeight.bold),) : null,
                                                  ): Container(),
                                                  Image(image: AssetImage('assets/images/ic_detail_top_two.png') , width: 90.0,),
                                                ],
                                              ),


                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            children: [
                                              Stack(
                                                alignment: Alignment.center,
                                                children: [
                                                  trend!.dailyKarizmaFans.length > 0 ?  CircleAvatar(
                                                    backgroundColor: trend!.dailyKarizmaFans[0].gender == 0 ? MyColors.blueColor : MyColors.pinkColor ,
                                                    backgroundImage: trend!.dailyKarizmaFans[0].img != "" ? (trend!.dailyKarizmaFans[0].img.startsWith('https') ? CachedNetworkImageProvider(trend!.dailyKarizmaFans[0].img)  :  CachedNetworkImageProvider('${ASSETSBASEURL}AppUsers/${trend!.dailyKarizmaFans[0].img}'))  :    null,
                                                    radius: 40,
                                                    child: trend!.dailyKarizmaFans[0].img== "" ?
                                                    Text(trend!.dailyKarizmaFans[0].name.toUpperCase().substring(0 , 1) +
                                                        (trend!.dailyKarizmaFans[0].name.contains(" ") ? trend!.dailyKarizmaFans[0].name.substring(trend!.dailyKarizmaFans[0].name.indexOf(" ")).toUpperCase().substring(1 , 2) : ""),
                                                      style: const TextStyle(color: Colors.white , fontSize: 22.0 , fontWeight: FontWeight.bold),) : null,
                                                  ): Container(),
                                                  Image(image: AssetImage('assets/images/ic_detail_top_one_small(1).png')),
                                                ],
                                              ),
                                              SizedBox(height: 40.0,),

                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            children: [
                                              SizedBox(height: 40.0,),
                                              Stack(
                                                alignment: Alignment.center,
                                                children: [
                                                  trend!.dailyKarizmaFans.length > 2 ?  CircleAvatar(
                                                    backgroundColor: trend!.dailyKarizmaFans[2].gender == 0 ? MyColors.blueColor : MyColors.pinkColor ,
                                                    backgroundImage: trend!.dailyKarizmaFans[2].img != "" ? (trend!.dailyKarizmaFans[2].img.startsWith('https') ? CachedNetworkImageProvider(trend!.dailyKarizmaFans[2].img)  :  CachedNetworkImageProvider('${ASSETSBASEURL}AppUsers/${trend!.dailyKarizmaFans[2].img}'))  :    null,
                                                    radius: 30,
                                                    child: trend!.dailyKarizmaFans[2].img== "" ?
                                                    Text(trend!.dailyKarizmaFans[2].name.toUpperCase().substring(0 , 1) +
                                                        (trend!.dailyKarizmaFans[2].name.contains(" ") ? trend!.dailyKarizmaFans[2].name.substring(trend!.dailyKarizmaFans[2].name.indexOf(" ")).toUpperCase().substring(1 , 2) : ""),
                                                      style: const TextStyle(color: Colors.white , fontSize: 22.0 , fontWeight: FontWeight.bold),) : null,
                                                  ): Container(),
                                                  Image(image: AssetImage('assets/images/ic_detail_top_three(1).png') , width: 90.0,),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 30.0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            children: [
                                              SizedBox(height: 40.0,),
                                              Stack(
                                                alignment: Alignment.center,
                                                children: [

                                                  trend!.weekKarizmaFans.length > 1 ?  CircleAvatar(
                                                    backgroundColor: trend!.weekKarizmaFans[1].gender == 0 ? MyColors.blueColor : MyColors.pinkColor ,
                                                    backgroundImage: trend!.weekKarizmaFans[1].img != "" ? (trend!.weekKarizmaFans[1].img.startsWith('https') ? CachedNetworkImageProvider(trend!.weekKarizmaFans[1].img)  :  CachedNetworkImageProvider('${ASSETSBASEURL}AppUsers/${trend!.weekKarizmaFans[1].img}'))  :    null,
                                                    radius: 30,
                                                    child: trend!.weekKarizmaFans[1].img== "" ?
                                                    Text(trend!.weekKarizmaFans[1].name.toUpperCase().substring(0 , 1) +
                                                        (trend!.weekKarizmaFans[1].name.contains(" ") ? trend!.weekKarizmaFans[1].name.substring(trend!.weekKarizmaFans[1].name.indexOf(" ")).toUpperCase().substring(1 , 2) : ""),
                                                      style: const TextStyle(color: Colors.white , fontSize: 22.0 , fontWeight: FontWeight.bold),) : null,
                                                  ): Container(),
                                                  Image(image: AssetImage('assets/images/ic_detail_top_two.png') , width: 90.0,),
                                                ],
                                              ),


                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            children: [
                                              Stack(
                                                alignment: Alignment.center,
                                                children: [
                                                  trend!.weekKarizmaFans.length > 0 ?  CircleAvatar(
                                                    backgroundColor: trend!.weekKarizmaFans[0].gender == 0 ? MyColors.blueColor : MyColors.pinkColor ,
                                                    backgroundImage: trend!.weekKarizmaFans[0].img != "" ? (trend!.weekKarizmaFans[0].img.startsWith('https') ? CachedNetworkImageProvider(trend!.weekKarizmaFans[0].img)  :  CachedNetworkImageProvider('${ASSETSBASEURL}AppUsers/${trend!.weekKarizmaFans[0].img}'))  :    null,
                                                    radius: 40,
                                                    child: trend!.weekKarizmaFans[0].img== "" ?
                                                    Text(trend!.weekKarizmaFans[0].name.toUpperCase().substring(0 , 1) +
                                                        (trend!.weekKarizmaFans[0].name.contains(" ") ? trend!.weekKarizmaFans[0].name.substring(trend!.weekKarizmaFans[0].name.indexOf(" ")).toUpperCase().substring(1 , 2) : ""),
                                                      style: const TextStyle(color: Colors.white , fontSize: 22.0 , fontWeight: FontWeight.bold),) : null,
                                                  ): Container(),
                                                  Image(image: AssetImage('assets/images/ic_detail_top_one_small(1).png')),
                                                ],
                                              ),
                                              SizedBox(height: 40.0,),

                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            children: [
                                              SizedBox(height: 40.0,),
                                              Stack(
                                                alignment: Alignment.center,
                                                children: [
                                                  trend!.weekKarizmaFans.length > 2 ?  CircleAvatar(
                                                    backgroundColor: trend!.weekKarizmaFans[2].gender == 0 ? MyColors.blueColor : MyColors.pinkColor ,
                                                    backgroundImage: trend!.weekKarizmaFans[2].img != "" ? (trend!.weekKarizmaFans[2].img.startsWith('https') ? CachedNetworkImageProvider(trend!.weekKarizmaFans[2].img)  :  CachedNetworkImageProvider('${ASSETSBASEURL}AppUsers/${trend!.weekKarizmaFans[2].img}'))  :    null,
                                                    radius: 30,
                                                    child: trend!.weekKarizmaFans[2].img== "" ?
                                                    Text(trend!.weekKarizmaFans[2].name.toUpperCase().substring(0 , 1) +
                                                        (trend!.weekKarizmaFans[2].name.contains(" ") ? trend!.weekKarizmaFans[2].name.substring(trend!.weekKarizmaFans[2].name.indexOf(" ")).toUpperCase().substring(1 , 2) : ""),
                                                      style: const TextStyle(color: Colors.white , fontSize: 22.0 , fontWeight: FontWeight.bold),) : null,
                                                  ): Container(),
                                                  Image(image: AssetImage('assets/images/ic_detail_top_three(1).png') , width: 90.0,),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 30.0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            children: [
                                              SizedBox(height: 40.0,),
                                              Stack(
                                                alignment: Alignment.center,
                                                children: [

                                                  trend!.monthKarizmaFans.length > 1 ?  CircleAvatar(
                                                    backgroundColor: trend!.monthKarizmaFans[1].gender == 0 ? MyColors.blueColor : MyColors.pinkColor ,
                                                    backgroundImage: trend!.monthKarizmaFans[1].img != "" ? (trend!.monthKarizmaFans[1].img.startsWith('https') ? CachedNetworkImageProvider(trend!.monthKarizmaFans[1].img)  :  CachedNetworkImageProvider('${ASSETSBASEURL}AppUsers/${trend!.monthKarizmaFans[1].img}'))  :    null,
                                                    radius: 30,
                                                    child: trend!.monthKarizmaFans[1].img== "" ?
                                                    Text(trend!.monthKarizmaFans[1].name.toUpperCase().substring(0 , 1) +
                                                        (trend!.monthKarizmaFans[1].name.contains(" ") ? trend!.monthKarizmaFans[1].name.substring(trend!.monthKarizmaFans[1].name.indexOf(" ")).toUpperCase().substring(1 , 2) : ""),
                                                      style: const TextStyle(color: Colors.white , fontSize: 22.0 , fontWeight: FontWeight.bold),) : null,
                                                  ): Container(),
                                                  Image(image: AssetImage('assets/images/ic_detail_top_two.png') , width: 90.0,),
                                                ],
                                              ),


                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            children: [
                                              Stack(
                                                alignment: Alignment.center,
                                                children: [
                                                  trend!.monthKarizmaFans.length > 0 ?  CircleAvatar(
                                                    backgroundColor: trend!.monthKarizmaFans[0].gender == 0 ? MyColors.blueColor : MyColors.pinkColor ,
                                                    backgroundImage: trend!.monthKarizmaFans[0].img != "" ? (trend!.monthKarizmaFans[0].img.startsWith('https') ? CachedNetworkImageProvider(trend!.monthKarizmaFans[0].img)  :  CachedNetworkImageProvider('${ASSETSBASEURL}AppUsers/${trend!.monthKarizmaFans[0].img}'))  :    null,
                                                    radius: 40,
                                                    child: trend!.monthKarizmaFans[0].img== "" ?
                                                    Text(trend!.monthKarizmaFans[0].name.toUpperCase().substring(0 , 1) +
                                                        (trend!.monthKarizmaFans[0].name.contains(" ") ? trend!.monthKarizmaFans[0].name.substring(trend!.monthKarizmaFans[0].name.indexOf(" ")).toUpperCase().substring(1 , 2) : ""),
                                                      style: const TextStyle(color: Colors.white , fontSize: 22.0 , fontWeight: FontWeight.bold),) : null,
                                                  ): Container(),
                                                  Image(image: AssetImage('assets/images/ic_detail_top_one_small(1).png')),
                                                ],
                                              ),
                                              SizedBox(height: 40.0,),

                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            children: [
                                              SizedBox(height: 40.0,),
                                              Stack(
                                                alignment: Alignment.center,
                                                children: [
                                                  trend!.monthKarizmaFans.length > 2 ?  CircleAvatar(
                                                    backgroundColor: trend!.monthKarizmaFans[2].gender == 0 ? MyColors.blueColor : MyColors.pinkColor ,
                                                    backgroundImage: trend!.monthKarizmaFans[2].img != "" ? (trend!.monthKarizmaFans[2].img.startsWith('https') ? CachedNetworkImageProvider(trend!.monthKarizmaFans[2].img)  :  CachedNetworkImageProvider('${ASSETSBASEURL}AppUsers/${trend!.monthKarizmaFans[2].img}'))  :    null,
                                                    radius: 30,
                                                    child: trend!.monthKarizmaFans[2].img== "" ?
                                                    Text(trend!.monthKarizmaFans[2].name.toUpperCase().substring(0 , 1) +
                                                        (trend!.monthKarizmaFans[2].name.contains(" ") ? trend!.monthKarizmaFans[2].name.substring(trend!.monthKarizmaFans[2].name.indexOf(" ")).toUpperCase().substring(1 , 2) : ""),
                                                      style: const TextStyle(color: Colors.white , fontSize: 22.0 , fontWeight: FontWeight.bold),) : null,
                                                  ): Container(),
                                                  Image(image: AssetImage('assets/images/ic_detail_top_three(1).png') , width: 90.0,),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                    flex: 5,
                    child: TabBarView(
                      controller: _tabController2,
                      children: [
                        ListView.separated(itemBuilder: (ctx , index) =>itemListBuilder(trend!.dailyKarizmaFans[index]) ,
                            separatorBuilder: (ctx , index) =>itemSperatorBuilder(), itemCount: trend!.dailyKarizmaFans.length),
                        ListView.separated(itemBuilder: (ctx , index) =>itemListBuilder(trend!.weekKarizmaFans[index]) ,
                            separatorBuilder: (ctx , index) =>itemSperatorBuilder(), itemCount: trend!.weekKarizmaFans.length),
                        ListView.separated(itemBuilder: (ctx , index) =>itemListBuilder(trend!.monthKarizmaFans[index]) ,
                            separatorBuilder: (ctx , index) =>itemSperatorBuilder(), itemCount: trend!.monthKarizmaFans.length),
                      ],

                    )

                )
              ],
            ),
            Column(
              children: [
                Expanded(
                  flex: 5,
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(color: MyColors.darkColor,  image: DecorationImage(image: AssetImage(local =='en' ?  'assets/images/icon_profit_voice_anchor.png' : 'assets/images/icon_profit_voice_anchor_e.png') , fit: BoxFit.fill)),
                    child: Column(
                      children: [
                        SizedBox(height: 30.0,),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 40.0),
                          decoration: BoxDecoration(color: MyColors.lightUnSelectedColor.withOpacity(.4) , borderRadius: BorderRadius.circular(20.0)),
                          child: TabBar(
                            controller: _tabController3,
                            dividerColor: Colors.transparent,
                            tabAlignment: TabAlignment.center,
                            isScrollable: true ,
                            indicatorColor: MyColors.secondaryColor,
                            labelColor: MyColors.secondaryColor,
                            unselectedLabelColor: MyColors.unSelectedColor,
                            labelStyle: const TextStyle(fontSize: 17.0 , fontWeight: FontWeight.w900),

                            tabs:  [
                              Tab(child: Text("daily".tr , style: TextStyle(fontSize: 16.0),), ),
                              Tab(child: Text("weekly".tr , style: TextStyle(fontSize: 16.0),), ),
                              Tab(child: Text("monthly".tr , style: TextStyle(fontSize: 16.0),), ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: TabBarView(
                            controller: _tabController3,
                            children: [
                              Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 30.0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            children: [
                                              SizedBox(height: 40.0,),
                                              Stack(
                                                alignment: Alignment.center,
                                                children: [

                                                  trend!.dailyRoomFans.length > 1 ?  CircleAvatar(
                                                      backgroundColor: MyColors.primaryColor ,
                                                      backgroundImage: getRoomImage(trend!.dailyRoomFans[1])  ,
                                                      radius: 30
                                                  ): Container(),
                                                  Image(image: AssetImage('assets/images/ic_detail_top_two.png') , width: 90.0,),
                                                ],
                                              ),
                                              SizedBox(height:10.0),
                                              Text(   trend!.dailyRoomFans.length > 1 ? trend!.dailyRoomFans[1].name : "" , style: TextStyle(color: Colors.white , fontSize: 15.0),)


                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            children: [
                                              Stack(
                                                alignment: Alignment.center,
                                                children: [
                                                  trend!.dailyRoomFans.length > 0 ?  CircleAvatar(
                                                      backgroundColor: MyColors.primaryColor ,
                                                      backgroundImage: getRoomImage(trend!.dailyRoomFans[0])  ,
                                                      radius: 30
                                                  ): Container(),
                                                  Image(image: AssetImage('assets/images/ic_detail_top_one_small(1).png')),
                                                ],
                                              ),
                                              SizedBox(height:10.0),
                                              Text(trend!.dailyRoomFans.length > 0 ? trend!.dailyRoomFans[0].name : "" , style: TextStyle(color: Colors.white , fontSize: 15.0),),
                                              SizedBox(height: 40.0,),


                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            children: [
                                              SizedBox(height: 40.0,),
                                              Stack(
                                                alignment: Alignment.center,
                                                children: [
                                                  trend!.dailyRoomFans.length > 2 ?  CircleAvatar(
                                                      backgroundColor: MyColors.primaryColor ,
                                                      backgroundImage: getRoomImage(trend!.dailyRoomFans[2])  ,
                                                      radius: 30
                                                  ): Container(),
                                                  Image(image: AssetImage('assets/images/ic_detail_top_three(1).png') , width: 90.0,),
                                                ],
                                              ),
                                              Text(trend!.dailyRoomFans.length > 2 ? trend!.dailyRoomFans[2].name : "", style: TextStyle(color: Colors.white , fontSize: 15.0),),
                                              SizedBox(height: 40.0,),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 30.0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            children: [
                                              SizedBox(height: 40.0,),
                                              Stack(
                                                alignment: Alignment.center,
                                                children: [

                                                  trend!.weekRoomFans.length > 1 ?  CircleAvatar(
                                                      backgroundColor: MyColors.primaryColor ,
                                                      backgroundImage: getRoomImage(trend!.weekRoomFans[1])  ,
                                                      radius: 30
                                                  ): Container(),
                                                  Image(image: AssetImage('assets/images/ic_detail_top_two.png') , width: 90.0,),
                                                ],
                                              ),
                                              SizedBox(height:10.0),
                                              Text(   trend!.weekRoomFans.length > 1 ? trend!.weekRoomFans[1].name : "" , style: TextStyle(color: Colors.white , fontSize: 15.0),)


                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            children: [
                                              Stack(
                                                alignment: Alignment.center,
                                                children: [
                                                  trend!.weekRoomFans.length > 0 ?  CircleAvatar(
                                                      backgroundColor: MyColors.primaryColor ,
                                                      backgroundImage: getRoomImage(trend!.weekRoomFans[0])  ,
                                                      radius: 30
                                                  ): Container(),
                                                  Image(image: AssetImage('assets/images/ic_detail_top_one_small(1).png')),
                                                ],
                                              ),
                                              SizedBox(height:10.0),
                                              Text(trend!.weekRoomFans.length > 0 ? trend!.weekRoomFans[0].name : "" , style: TextStyle(color: Colors.white , fontSize: 15.0),),
                                              SizedBox(height: 40.0,),


                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            children: [
                                              SizedBox(height: 40.0,),
                                              Stack(
                                                alignment: Alignment.center,
                                                children: [
                                                  trend!.weekRoomFans.length > 2 ?  CircleAvatar(
                                                      backgroundColor: MyColors.primaryColor ,
                                                      backgroundImage: getRoomImage(trend!.weekRoomFans[2])  ,
                                                      radius: 30
                                                  ): Container(),
                                                  Image(image: AssetImage('assets/images/ic_detail_top_three(1).png') , width: 90.0,),
                                                ],
                                              ),
                                              Text(trend!.weekRoomFans.length > 2 ? trend!.weekRoomFans[2].name : "", style: TextStyle(color: Colors.white , fontSize: 15.0),),
                                              SizedBox(height: 40.0,),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 30.0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            children: [
                                              SizedBox(height: 40.0,),
                                              Stack(
                                                alignment: Alignment.center,
                                                children: [

                                                  trend!.monthRoomFans.length > 1 ?  CircleAvatar(
                                                      backgroundColor: MyColors.primaryColor ,
                                                      backgroundImage: getRoomImage(trend!.monthRoomFans[1])  ,
                                                      radius: 30
                                                  ): Container(),
                                                  Image(image: AssetImage('assets/images/ic_detail_top_two.png') , width: 90.0,),
                                                ],
                                              ),
                                              SizedBox(height:10.0),
                                              Text(   trend!.monthRoomFans.length > 1 ? trend!.monthRoomFans[1].name : "" , style: TextStyle(color: Colors.white , fontSize: 15.0),)


                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            children: [
                                              Stack(
                                                alignment: Alignment.center,
                                                children: [
                                                  trend!.monthRoomFans.length > 0 ?  CircleAvatar(
                                                      backgroundColor: MyColors.primaryColor ,
                                                      backgroundImage: getRoomImage(trend!.monthRoomFans[0])  ,
                                                      radius: 30
                                                  ): Container(),
                                                  Image(image: AssetImage('assets/images/ic_detail_top_one_small(1).png')),
                                                ],
                                              ),
                                              SizedBox(height:10.0),
                                              Text(trend!.monthRoomFans.length > 0 ? trend!.monthRoomFans[0].name : "" , style: TextStyle(color: Colors.white , fontSize: 15.0),),
                                              SizedBox(height: 40.0,),


                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            children: [
                                              SizedBox(height: 40.0,),
                                              Stack(
                                                alignment: Alignment.center,
                                                children: [
                                                  trend!.monthRoomFans.length > 2 ?  CircleAvatar(
                                                      backgroundColor: MyColors.primaryColor ,
                                                      backgroundImage: getRoomImage(trend!.monthRoomFans[2])  ,
                                                      radius: 30
                                                  ): Container(),
                                                  Image(image: AssetImage('assets/images/ic_detail_top_three(1).png') , width: 90.0,),
                                                ],
                                              ),
                                              Text(trend!.monthRoomFans.length > 2 ? trend!.monthRoomFans[2].name : "", style: TextStyle(color: Colors.white , fontSize: 15.0),),
                                              SizedBox(height: 40.0,),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                    flex: 5,
                    child: TabBarView(
                      controller: _tabController3,
                      children: [
                        ListView.separated(itemBuilder: (ctx , index) =>itemListBuilder2(trend!.dailyRoomFans[index]) ,
                            separatorBuilder: (ctx , index) =>itemSperatorBuilder(), itemCount: trend!.dailyRoomFans.length),
                        ListView.separated(itemBuilder: (ctx , index) =>itemListBuilder2(trend!.weekRoomFans[index]) ,
                            separatorBuilder: (ctx , index) =>itemSperatorBuilder(), itemCount: trend!.weekRoomFans.length),
                        ListView.separated(itemBuilder: (ctx , index) =>itemListBuilder2(trend!.monthRoomFans[index]) ,
                            separatorBuilder: (ctx , index) =>itemSperatorBuilder(), itemCount: trend!.monthRoomFans.length),
                      ],

                    )

                )
              ],
            ),
          ],
        ): Loading(),
      ),
    );
  }

  ImageProvider getRoomImage(room){
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

  Widget itemListBuilder( TrendUser user) => Container(
    margin: EdgeInsets.symmetric(horizontal: 10.0 ),
    child: Column(
      children: [
        Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                children: [
                  CircleAvatar(
                    backgroundColor: user.gender == 0 ? MyColors.blueColor : MyColors.pinkColor ,

                    backgroundImage: user.img != "" ?
                    CachedNetworkImageProvider(getUserImage(user)!) : null,
                    radius: 22,
                    child: user.img == "" ?
                    Text(user.name.toUpperCase().substring(0 , 1) +
                        (user.name.contains(" ") ? user.name.substring(user.name.indexOf(" ")).toUpperCase().substring(1 , 2) : ""),
                      style: const TextStyle(color: Colors.white , fontSize: 18.0 , fontWeight: FontWeight.bold),) : null,
                  )
                ],
              ),
              const SizedBox(width: 10.0,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(user.name , style: TextStyle(color: MyColors.whiteColor , fontSize: 18.0),),
                      const SizedBox(width: 5.0,),
                      CircleAvatar(
                        backgroundColor: user.gender == 0 ? MyColors.blueColor : MyColors.pinkColor ,
                        radius: 10.0,
                        child: user.gender == 0 ?  const Icon(Icons.male , color: Colors.white, size: 15.0,) :  const Icon(Icons.female , color: Colors.white, size: 15.0,),
                      )
                    ],
                  ),
                  Row(

                    children: [
                      Image(image: CachedNetworkImageProvider(ASSETSBASEURL + 'Levels/' + user.share_level_icon) , width: 40,),
                      const SizedBox(width: 10.0,),
                      Image(image: CachedNetworkImageProvider(ASSETSBASEURL + 'Levels/' + user.karizma_level_icon) , width: 40,),
                      const SizedBox(width: 10.0,),
                      Image(image: CachedNetworkImageProvider(ASSETSBASEURL + 'Levels/' + user.charging_level_icon) , width: 30,),

                    ],
                  ),

                  Text("ID:${user.tag}" , style: TextStyle(color: MyColors.unSelectedColor , fontSize: 13.0),),


                ],

              ),

            ]),
        Container(
          width: double.infinity,
          height: 1.0,
          color: MyColors.lightUnSelectedColor,
          margin: EdgeInsetsDirectional.only(start: 50.0),
          child: const Text(""),
        )
      ],
    ),
  );

  Widget itemListBuilder2( TrendRoom room) => Container(
    margin: EdgeInsets.symmetric(horizontal: 10.0 , vertical: 10.0),
    child: Column(
      children: [
        Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                children: [
                  CircleAvatar(
                      backgroundColor: MyColors.primaryColor ,
                      backgroundImage: getRoomImage(room)  ,
                      radius: 20
                  )
                ],
              ),
              const SizedBox(width: 10.0,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(room.name , style: TextStyle(color: MyColors.whiteColor , fontSize: 18.0),),
                      const SizedBox(width: 5.0,),
                      Container(
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0) ,
                            color: getTagColor(room)),
                        padding: EdgeInsets.all(3.0),
                        child: Text('#' + room!.subject , style: TextStyle(fontSize: 9.0 , color: Colors.white),),
                      )
                    ],
                  ),


                  Text("ID:${room.tag}" , style: TextStyle(color: MyColors.unSelectedColor , fontSize: 13.0),),


                ],

              ),

            ]),
        Container(
          width: double.infinity,
          height: 1.0,
          color: MyColors.lightUnSelectedColor,
          margin: EdgeInsetsDirectional.only(start: 50.0),
          child: const Text(""),
        )
      ],
    ),
  );

  Widget itemSperatorBuilder() => SizedBox(height: 5.0,);

  String? getUserImage(TrendUser user){
    if(user.img.startsWith('https')){
      return user.img.toString() ;
    } else {
      return '${ASSETSBASEURL}AppUsers/${user.img}' ;
    }
  }

  Color getTagColor(room){
    if(room!.subject == "CHAT"){
      return MyColors.primaryColor.withOpacity(.8) ;
    } else if(room!.subject == "FRIENDS"){
      return MyColors.successColor.withOpacity(.8) ;
    }else if(room!.subject == "GAMES"){
      return MyColors.blueColor.withOpacity(.8) ;
    }
    else {
      return MyColors.primaryColor.withOpacity(.8) ;
    }

  }

}