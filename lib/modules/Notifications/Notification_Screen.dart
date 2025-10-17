import 'package:LikLok/helpers/NotificationHelper.dart';
import 'package:LikLok/models/Announcement.dart';
import 'package:LikLok/shared/components/Constants.dart';
import 'package:LikLok/shared/network/remote/NotificationServices.dart';
import 'package:LikLok/shared/styles/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:LikLok/models/Notification.dart';

import '../Loading/loadig_screen.dart';

class NotificationScreen extends StatefulWidget {

  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => NotificationScreenState();
}

class NotificationScreenState extends State<NotificationScreen> {
  List<UserNotification> notifications = [] ;
  List<Announcement> announcements = [] ;
  bool loading = false ;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllNotifications();
  }
  getAllNotifications() async {
    setState(() {
      loading = true ;
    });
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int id = await prefs.getInt('userId') ?? 0;
    NotificationHelper  res = await NotificationServices().getAllNotifications(id);
   setState(() {
     notifications = res.notifications! ;
     announcements = res.announcements! ;
   });
setState(() {
  loading = false ;
});
  }
  @override
  Widget build(BuildContext context) {
    return  DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: MyColors.whiteColor, //change your color here
          ),
          backgroundColor: MyColors.solidDarkColor,
          title: TabBar(
          dividerColor: Colors.transparent,
          tabAlignment: TabAlignment.start,
          isScrollable: true ,
          indicatorColor: MyColors.primaryColor,
          labelColor: MyColors.primaryColor,
          unselectedLabelColor: MyColors.unSelectedColor,
          labelStyle: const TextStyle(fontSize: 17.0 , fontWeight: FontWeight.w900),

          tabs:  [
            Tab(child: Text("notification_moments".tr , style: TextStyle(fontSize: 15.0),), ),
            Tab(child: Text("notification_profile".tr , style: TextStyle(fontSize: 15.0),), ),
            Tab(child: Text("notification_charging".tr , style: TextStyle(fontSize: 15.0),), ),
            Tab(child: Text("notification_system".tr , style: TextStyle(fontSize: 15.0),), ),
            Tab(child: Text("notification_announcement".tr , style: TextStyle(fontSize: 15.0),), ),
          ],
        ) ,
        ),
        body: SafeArea(
          child: Container(
            color: MyColors.darkColor,
            width: double.infinity,
            padding: const EdgeInsets.all(20.0),
           child: loading ? Loading() : TabBarView(
               children:[
                 Column(
                   children: [
                     notifications.where((element) => element.type == "MOMENTS").toList().length == 0 ? Center(child: Column(
                       children: [
                         Image(image: AssetImage('assets/images/sad.png') , width: 100.0 , height: 100.0,),
                         SizedBox(height: 30.0,),
                         Text('no_data'.tr , style: TextStyle(color: Colors.red , fontSize: 18.0 ) ,)
          
          
                       ],), ) :
                     Expanded(child: ListView.separated(itemBuilder:(ctx , index) => notificationsListItem(index , notifications.where((element) => element.type == "MOMENTS").toList() , 'MOMENTS'), separatorBuilder:(ctx , index) => listSeperator(), itemCount: notifications.where((element) => element.type == "MOMENTS").toList().length)),
          
                   ],
                 ),
                 Column(
                   children: [
                     notifications.where((element) => element.type == "PROFILE").toList().length == 0 ? Center(child: Column(
                       children: [
                         Image(image: AssetImage('assets/images/sad.png') , width: 100.0 , height: 100.0,),
                         SizedBox(height: 30.0,),
                         Text('no_data'.tr , style: TextStyle(color: Colors.red , fontSize: 18.0 ) ,)
          
          
                       ],), ):
                     Expanded(child: ListView.separated(itemBuilder:(ctx , index) => notificationsListItem(index , notifications.where((element) => element.type == "PROFILE").toList() , 'PROFILE'), separatorBuilder:(ctx , index) => listSeperator(), itemCount: notifications.where((element) => element.type == "PROFILE").toList().length)),
          
                   ],
                 ),
                 Column(
                   children: [
                     notifications.where((element) => element.type == "CHARGING").toList().length == 0 ? Center(child: Column(
                       children: [
                         Image(image: AssetImage('assets/images/sad.png') , width: 100.0 , height: 100.0,),
                         SizedBox(height: 30.0,),
                         Text('no_data'.tr , style: TextStyle(color: Colors.red , fontSize: 18.0 ) ,)
          
          
                       ],), ):
                     Expanded(child: ListView.separated(itemBuilder:(ctx , index) => notificationsListItem(index , notifications.where((element) => element.type == "CHARGING").toList() , 'CHARGING'), separatorBuilder:(ctx , index) => listSeperator(), itemCount: notifications.where((element) => element.type == "CHARGING").toList().length)),
          
                   ],
                 ),
                 Column(
                   children: [
                     notifications.where((element) => element.type == "SYSTEM").toList().length == 0 ? Center(child: Column(
                       children: [
                         Image(image: AssetImage('assets/images/sad.png') , width: 100.0 , height: 100.0,),
                         SizedBox(height: 30.0,),
                         Text('no_data'.tr , style: TextStyle(color: Colors.red , fontSize: 18.0 ) ,)
          
          
                       ],), ):
                     Expanded(child: ListView.separated(itemBuilder:(ctx , index) => notificationsListItem(index , notifications.where((element) => element.type == "SYSTEM").toList() , 'SYSTEM'), separatorBuilder:(ctx , index) => listSeperator(), itemCount: notifications.where((element) => element.type == "SYSTEM").toList().length)),
          
                   ],
                 ),
                 Column(
                   children: [
                     announcements.length == 0 ? Center(child: Column(
                       children: [
                         Image(image: AssetImage('assets/images/sad.png') , width: 100.0 , height: 100.0,),
                         SizedBox(height: 30.0,),
                         Text('no_data'.tr , style: TextStyle(color: Colors.red , fontSize: 18.0 ) ,)
          
          
                       ],), ):
                     Expanded(child: ListView.separated(itemBuilder:(ctx , index) => announcementListItem(index ), separatorBuilder:(ctx , index) => listSeperator(), itemCount: announcements.length)),
                   ],
                 )
          
               ]
           )
          ),
        ),
      ),
    );
  }
  Widget notificationsListItem (index , list , key) => Container(
    padding: EdgeInsets.all(8.0),
    decoration: BoxDecoration(color: list[index].isRead == 0 ? Colors.black38  : Colors.transparent,  borderRadius: BorderRadius.circular(10.0)),
    child:Row(
      children: [
        Column(
          children: [
            CircleAvatar(
              backgroundColor: list[index].action_user_gender == 0 ? MyColors.blueColor : MyColors.pinkColor ,
              backgroundImage: list[index].action_user_img != ""  ? CachedNetworkImageProvider('${ASSETSBASEURL}AppUsers/${list[index].action_user_img}') : null,
              radius: 22,
              child: list[index].action_user_img == "" ?
              Text(list[index].action_user_name.toUpperCase().substring(0 , 1) +
                  (list[index].action_user_name.contains(" ") ? list[index].action_user_name.substring(list[index].action_user_name.indexOf(" ")).toUpperCase().substring(1 , 2) : ""),
                style: const TextStyle(color: Colors.white , fontSize: 22.0 , fontWeight: FontWeight.bold),) : null,
            )
          ],
        ),
        SizedBox(width: 10.0,),
        Expanded(
          child: Column(
            children: [
              Row(
                children: [
                  Text(list[index].title  , style: TextStyle(color: Colors.white, fontSize: 15.0 , fontWeight: FontWeight.bold),),
                ],
              ),

              SizedBox(height: 5.0,),
              Row(
                children: [
                  Text(list[index].content , style: TextStyle(color: Colors.grey , fontSize: 13.0 ),),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(list[index].created_at , style: TextStyle(color: Colors.grey , fontSize: 13.0 ),),
                ],
              ),
            ],
          ),
        )
      ],
    )
    ,);

  Widget announcementListItem(index) =>   Container(
    padding: EdgeInsets.all(8.0),
    decoration: BoxDecoration(color:  Colors.black38  ,  borderRadius: BorderRadius.circular(10.0)),
    child:Row(
      children: [
        Column(
          children: [
            CircleAvatar(
              backgroundImage:  AssetImage('assets/images/logo.jpg') ,
              radius: 22,
            )
          ],
        ),
        SizedBox(width: 10.0,),
        Expanded(
          child: Column(
            children: [
              Row(
                children: [
                  Text(announcements[index].title  , style: TextStyle(color: Colors.white, fontSize: 15.0 , fontWeight: FontWeight.bold),),
                ],
              ),

              SizedBox(height: 5.0,),
              Row(
                children: [
                  Text(announcements[index].message , style: TextStyle(color: Colors.grey , fontSize: 13.0 ),),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(DateTime.parse(announcements[index].created_at ).toString() , style: TextStyle(color: Colors.grey , fontSize: 13.0 ),),
                ],
              ),
            ],
          ),
        )
      ],
    )
    ,);
  Widget listSeperator() => SizedBox(height: 5.0,);
}
