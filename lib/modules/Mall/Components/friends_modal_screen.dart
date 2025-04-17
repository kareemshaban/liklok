import 'package:LikLok/models/AppUser.dart';
import 'package:LikLok/models/Friends.dart';
import 'package:LikLok/modules/chat_service/chat_service.dart';
import 'package:LikLok/shared/components/Constants.dart';
import 'package:LikLok/shared/network/remote/AppUserServices.dart';
import 'package:LikLok/shared/network/remote/ChatServic.dart';
import 'package:LikLok/shared/network/remote/Notification_service.dart';
import 'package:LikLok/shared/network/remote/RelationsServices.dart';
import 'package:LikLok/shared/styles/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class FriendsModalScreen extends StatefulWidget {
  final int relation_id ;
  final String relation_name ;
  const FriendsModalScreen({super.key , required this.relation_id , required this.relation_name});

  @override
  State<FriendsModalScreen> createState() => _FriendsModalScreenState();
}

class _FriendsModalScreenState extends State<FriendsModalScreen> {

  List<Friends>? friends = [];
  AppUser? user;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      user = AppUserServices().userGetter();
      friends = user!.friends ;
    });
  }
  loadData() async {
    AppUser? res = await AppUserServices().getUser(user!.id);
    setState(() {
      user = res;
      friends = user!.friends ;
      AppUserServices().userSetter(user!);
    });
  }

  Future<void> _refresh()async{
    await loadData() ;
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 50.0 , horizontal: 10.0),
      color: Colors.white.withAlpha(220),

      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(onPressed: (){
                Navigator.pop(context);
              }, icon: Icon(Icons.arrow_back_ios , color: Colors.black, size: 25.0,)),
              Expanded(child: Text('friends_title'.tr , style: TextStyle(color: Colors.black , fontSize: 20.0), textAlign: TextAlign.center,))
            ],
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refresh,
              color: MyColors.primaryColor,
              child: ListView.separated(itemBuilder: (ctx , index) =>itemListBuilder(index) ,
                  separatorBuilder: (ctx , index) =>itemSperatorBuilder(), itemCount: friends!.length),
            ),
          ),
        ],
      ),
    );
  }

  Widget itemListBuilder(index) => GestureDetector(
    onTap: (){


    },
    child: Column(
      children: [
        Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                children: [
                  CircleAvatar(
                    backgroundColor: friends![index].follower_gender == 0 ? MyColors.blueColor : MyColors.pinkColor ,

                    backgroundImage: friends![index].follower_img != "" ?
                    CachedNetworkImageProvider(getUserImage(index)!) : null,
                    radius: 30,
                    child: friends![index].follower_img == "" ?
                    Text(friends![index].follower_name.toUpperCase().substring(0 , 1) +
                        (friends![index].follower_name.contains(" ") ? friends![index].follower_name.substring(friends![index].follower_name.indexOf(" ")).toUpperCase().substring(1 , 2) : ""),
                      style: const TextStyle(color: Colors.white , fontSize: 24.0 , fontWeight: FontWeight.bold),) : null,
                  )
                ],
              ),
              const SizedBox(width: 10.0,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(friends![index].follower_name , style: TextStyle(color: MyColors.whiteColor , fontSize: 18.0),),
                      const SizedBox(width: 5.0,),
                      CircleAvatar(
                        backgroundColor: friends![index].follower_gender == 0 ? MyColors.blueColor : MyColors.pinkColor ,
                        radius: 10.0,
                        child: friends![index].follower_gender == 0 ?  const Icon(Icons.male , color: Colors.black, size: 15.0,) :  const Icon(Icons.female , color: Colors.black, size: 15.0,),
                      )
                    ],
                  ),
                  Row(

                    children: [
                      Image(image: CachedNetworkImageProvider(ASSETSBASEURL + 'Levels/' + friends![index].share_level_img) , width: 40,),
                      const SizedBox(width: 10.0,),
                      Image(image: CachedNetworkImageProvider(ASSETSBASEURL + 'Levels/' + friends![index].karizma_level_img) , width: 40,),
                      const SizedBox(width: 10.0,),
                      Image(image: CachedNetworkImageProvider(ASSETSBASEURL + 'Levels/' + friends![index].charging_level_img) , width: 30,),

                    ],
                  ),

                  Text("ID:${friends![index].follower_tag}" , style: TextStyle(color: MyColors.unSelectedColor , fontSize: 13.0),),


                ],

              ),
              Expanded(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: (){
                        sendRelation(friends![index].friend_id);
                      },
                      child: Container(
                        width: 80.0,
                        height:40.0,
                        decoration: BoxDecoration(color: MyColors.primaryColor ,
                            borderRadius:BorderRadiusDirectional.all(Radius.circular(20.0))),
                        child: Center(child: Text("gift_send".tr , style: TextStyle(color: MyColors.darkColor , fontSize: 15.0),)),
                      ),
                    ),

                  ],
                ),
              )

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

  String? getUserImage(index){
    if(friends![index].follower_img.startsWith('https')){
      return friends![index].follower_img.toString() ;
    } else {
      return '${ASSETSBASEURL}AppUsers/${friends![index].follower_img}' ;
    }
  }

  sendRelation(reciver_id) async {
    print('reciver_id');
    print(reciver_id);
    print('user!.id');
    print(user!.id);
    bool res =  await  RelationsServices().purchaseRelation(user!.id, widget.relation_id, reciver_id);
    if(res == true){
      String msg = '' ;
      msg = 'Your Friend ${user!.name} send you a relation Request (${widget.relation_name}) and waiting for your response YOU CAN DECLINE OR ACCEPT RELATION_ID ${widget.relation_id}';
      sendRelationRequest(reciver_id , msg);
    }

  }

  sendRelationRequest(reciver_id , msg) async {
    await ChatApiService().send_Message(user!.id, reciver_id, msg);
    await ChatService().sendMessage( reciver_id, msg , 1);
    AppUser? rec = await AppUserServices().getUser(reciver_id) ;
    if(rec != null){
      await NotificationService().send_notification(rec.token , msg , user!.name);

    }

    Fluttertoast.showToast(
        msg: 'RelationShip Sent To user Successfully and waiting for his response',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black26,
        textColor: Colors.orange,
        fontSize: 16.0
    );
    Navigator.pop(context);
  }
}
