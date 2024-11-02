import 'package:LikLok/models/Announcement.dart';
import 'package:LikLok/shared/components/Constants.dart';
import 'package:LikLok/shared/network/remote/NotificationServices.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../shared/styles/colors.dart';

class EventMessage extends StatefulWidget {
  const EventMessage({super.key});

  @override
  State<EventMessage> createState() => _EventMessageState();
}

class _EventMessageState extends State<EventMessage> {
  List<Announcement> announcements = [] ;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  getData() async{
    List<Announcement>  res = await NotificationServices().getAppNotifications();
    setState(() {
      announcements = res  ;
    });

  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: MyColors.whiteColor, //change your color here
        ),
        centerTitle: true,
        backgroundColor: MyColors.solidDarkColor,
        title: Text("event_message_title".tr , style: TextStyle(color: MyColors.whiteColor,fontSize: 20.0) ,),
      ),
      body: Container(
        color: MyColors.darkColor,
        width: double.infinity,
        height: double.infinity,
        child:  Column(
          children: [
            announcements.length == 0 ? Center(child: Column(
              children: [
                Image(image: AssetImage('assets/images/sad.png') , width: 100.0 , height: 100.0,),
                SizedBox(height: 30.0,),
                Text('no_data'.tr , style: TextStyle(color: Colors.red , fontSize: 18.0 ) ,)


              ],), ):
            Expanded(child: ListView.separated(itemBuilder:(ctx , index) => announcementListItem(index ), separatorBuilder:(ctx , index) => listSeperator(), itemCount: announcements.length)),
          ],
        ),


           )
    );
  }

  Widget announcementListItem(index) =>   Container(
    padding: EdgeInsets.all(8.0),
    decoration: BoxDecoration(color:  Colors.white  ,  borderRadius: BorderRadius.circular(10.0)),
    child:Row(
      children: [
        Column(
          children: [
            CircleAvatar(
              backgroundImage:  AssetImage('assets/images/logo_round.png') ,
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
                  Text(announcements[index].title  , style: TextStyle(color: Colors.black, fontSize: 15.0 , fontWeight: FontWeight.bold),),
                ],
              ),

              SizedBox(height: 5.0,),
              Container(
                child:
                  Text(announcements[index].message , style: TextStyle(color: Colors.black , fontSize: 13.0  ,) , textAlign: TextAlign.end,),

              ),

              announcements[index].img != "" ?
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 5.0,),
                  Image(image: CachedNetworkImageProvider(ASSETSBASEURL + 'Notifications/' + announcements[index].img) , height: 100.0 , )
                ],
              ) : SizedBox(),
              announcements[index].link != "" ?
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 5.0,),
                  TextButton(onPressed: (){}, child: Text('read_more'.tr , style: TextStyle(color: MyColors.primaryColor , fontSize: 16.0 , decoration: TextDecoration.underline),) , )
                ],
              ) : SizedBox(),
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
