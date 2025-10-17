import 'package:LikLok/helpers/RoomCupHelper.dart';
import 'package:LikLok/models/ChatRoom.dart';
import 'package:LikLok/modules/Loading/loadig_screen.dart';
import 'package:LikLok/shared/components/Constants.dart';
import 'package:LikLok/shared/network/remote/ChatRoomService.dart';
import 'package:LikLok/shared/styles/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RoomCupModal extends StatefulWidget {
  const RoomCupModal({super.key});

  @override
  State<RoomCupModal> createState() => _RoomCupModalState();
}

class _RoomCupModalState extends State<RoomCupModal> {
  RoomCupHelper? helper ;
  ChatRoom? room ;
  bool loading = false ;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      room = ChatRoomService().roomGetter();
    });
    getRoomCup();
  }
  getRoomCup() async{
    RoomCupHelper res = await ChatRoomService().getRoomCup(room!.id);
    setState(() {
      helper = res ;
      loading = true ;
    });
    print('helper');
    print(helper);
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 3,
        child: Container(
          decoration: BoxDecoration(color: Colors.white.withAlpha(200),
              borderRadius: BorderRadius.only(topRight: Radius.circular(20.0) , topLeft: Radius.circular(15.0)) ,
              border: Border(top: BorderSide(width: 4.0, color: MyColors.secondaryColor),) ),
          width: double.infinity,
          height: MediaQuery.sizeOf(context).height * .6,
          padding: EdgeInsets.symmetric(vertical: 20.0 , horizontal: 15.0),
      
          child: loading ?  Column(
            children: [
              TabBar(
                dividerColor: Colors.transparent,
                tabAlignment: TabAlignment.center,
                isScrollable: true ,
                indicatorColor: MyColors.primaryColor,
                labelColor: MyColors.primaryColor,
                unselectedLabelColor: MyColors.whiteColor,
                labelStyle: const TextStyle(fontSize: 17.0 , fontWeight: FontWeight.w500),
      
                tabs:  [
                  Tab(text: "daily".tr ),
                  Tab(text: "weekly".tr,),
                  Tab(text: "monthly".tr,),
                ],
              ),
              SizedBox(height: 15.0,),
              Expanded(
                child: TabBarView(
                  children: [
                    Column(
                      children: [
                        Expanded(child: ListView.separated(itemBuilder:(context, index) => itemBuilder(index), separatorBuilder:(context, index) =>  separatorBuilder(), itemCount: helper!.daily.length)),
                      ],
                    ),
                    Column(
                      children: [
                        Expanded(child: ListView.separated(itemBuilder:(context, index) => itemBuilder2(index), separatorBuilder:(context, index) =>  separatorBuilder(), itemCount: helper!.weekly.length)),
                      ],
                    ),
                    Column(
                      children: [
                        Expanded(child: ListView.separated(itemBuilder:(context, index) => itemBuilder3(index), separatorBuilder:(context, index) =>  separatorBuilder(), itemCount: helper!.monthly.length)),
                      ],
                    )
                
                
                  ],
                ),
              )
            ],
          ) : Loading(),
        ),
      ),
    );
  }

  Widget itemBuilder(index) => Column(
    children: [
      Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Row(
                children: [
                  Column(
                    children: [
                      CircleAvatar(
                        backgroundColor: helper!.daily[index].user!.gender == 0 ? MyColors.blueColor : MyColors.pinkColor ,
              
                        backgroundImage: helper!.daily[index].user!.img != "" ?
                        CachedNetworkImageProvider('${ASSETSBASEURL}AppUsers/${helper!.daily[index].user!.img}') : null,
                        radius: 25,
                        child: helper!.daily[index].user!.img == "" ?
                        Text(helper!.daily[index].user!.name.toUpperCase().substring(0 , 1) +
                            (helper!.daily[index].user!.name.contains(" ") ? helper!.daily[index].user!.name.substring(helper!.daily[index].user!.name.indexOf(" ")).toUpperCase().substring(1 , 2) : ""),
                          style: const TextStyle(color: Colors.white , fontSize: 20.0 , fontWeight: FontWeight.bold),) : null,
                      )
                    ],
                  ),
                  const SizedBox(width: 10.0,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(helper!.daily[index].user!.name , style: TextStyle(color: MyColors.whiteColor , fontSize: 15.0),),
                          const SizedBox(width: 5.0,),
                          CircleAvatar(
                            backgroundColor: helper!.daily[index].user!.gender == 0 ? MyColors.blueColor : MyColors.pinkColor ,
                            radius: 8.0,
                            child: helper!.daily[index].user!.gender== 0 ?  const Icon(Icons.male , color: Colors.white, size: 13.0,) :  const Icon(Icons.female , color: Colors.white, size: 15.0,),
                          )
                        ],
                      ),
                      Row(
              
                        children: [
                          Image(image: CachedNetworkImageProvider(ASSETSBASEURL + 'Levels/' + helper!.daily[index].user!.share_level_icon) , width: 30,),
                          const SizedBox(width: 5.0,),
                          Image(image: CachedNetworkImageProvider(ASSETSBASEURL + 'Levels/' + helper!.daily[index].user!.karizma_level_icon) , width: 30,),
                          const SizedBox(width: 5.0,),
                          Image(image: CachedNetworkImageProvider(ASSETSBASEURL + 'Levels/' + helper!.daily[index].user!.charging_level_icon) , width: 30,),
              
                        ],
                      ),
              
                      Text("ID:${helper!.daily[index].user!.tag}" , style: TextStyle(color: MyColors.whiteColor , fontSize: 11.0),),
              
              
                    ],
              
                  ),
                ],
              ),
            ),


            Container(

              padding: EdgeInsetsDirectional.only(end: 10.0 , top: 3.0 , bottom: 3.0 , start: 10.0),
              decoration: BoxDecoration(color: Colors.white , borderRadius: BorderRadius.circular(20.0)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Image(image: AssetImage('assets/images/gold.png') , width: 25.0,),
                  SizedBox(width: 5.0,),
                  Text( double.parse(helper!.daily[index].sum).floor().toString() , style: TextStyle(color: MyColors.primaryColor , fontSize: 13.0),),
                ],
              ),
            ),

          ]),
      SizedBox(height: 5.0,),
      Container(
        width: double.infinity,
        height: 1.0,
        color: MyColors.lightUnSelectedColor,
        margin: EdgeInsetsDirectional.only(start: 40.0),
        child: const Text(""),
      )
    ],
  );
  Widget itemBuilder2(index) => Column(
    children: [
      Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Row(
                children: [
                  Column(
                    children: [
                      CircleAvatar(
                        backgroundColor: helper!.weekly[index].user!.gender == 0 ? MyColors.blueColor : MyColors.pinkColor ,

                        backgroundImage: helper!.weekly[index].user!.img != "" ?
                        CachedNetworkImageProvider('${ASSETSBASEURL}AppUsers/${helper!.weekly[index].user!.img}') : null,
                        radius: 25,
                        child: helper!.weekly[index].user!.img == "" ?
                        Text(helper!.weekly[index].user!.name.toUpperCase().substring(0 , 1) +
                            (helper!.weekly[index].user!.name.contains(" ") ? helper!.weekly[index].user!.name.substring(helper!.weekly[index].user!.name.indexOf(" ")).toUpperCase().substring(1 , 2) : ""),
                          style: const TextStyle(color: Colors.white , fontSize: 20.0 , fontWeight: FontWeight.bold),) : null,
                      )
                    ],
                  ),
                  const SizedBox(width: 10.0,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(helper!.weekly[index].user!.name , style: TextStyle(color: MyColors.whiteColor , fontSize: 15.0),),
                          const SizedBox(width: 5.0,),
                          CircleAvatar(
                            backgroundColor: helper!.weekly[index].user!.gender == 0 ? MyColors.blueColor : MyColors.pinkColor ,
                            radius: 8.0,
                            child: helper!.weekly[index].user!.gender== 0 ?  const Icon(Icons.male , color: Colors.white, size: 13.0,) :  const Icon(Icons.female , color: Colors.white, size: 15.0,),
                          )
                        ],
                      ),
                      Row(

                        children: [
                          Image(image: CachedNetworkImageProvider(ASSETSBASEURL + 'Levels/' + helper!.weekly[index].user!.share_level_icon) , width: 30,),
                          const SizedBox(width: 5.0,),
                          Image(image: CachedNetworkImageProvider(ASSETSBASEURL + 'Levels/' + helper!.weekly[index].user!.karizma_level_icon) , width: 30,),
                          const SizedBox(width: 5.0,),
                          Image(image: CachedNetworkImageProvider(ASSETSBASEURL + 'Levels/' + helper!.weekly[index].user!.charging_level_icon) , width: 30,),

                        ],
                      ),

                      Text("ID:${helper!.weekly[index].user!.tag}" , style: TextStyle(color: MyColors.whiteColor , fontSize: 11.0),),


                    ],

                  ),
                ],
              ),
            ),


            Container(

              padding: EdgeInsetsDirectional.only(end: 10.0 , top: 3.0 , bottom: 3.0 , start: 10.0),
              decoration: BoxDecoration(color: Colors.white , borderRadius: BorderRadius.circular(20.0)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Image(image: AssetImage('assets/images/gold.png') , width: 25.0,),
                  SizedBox(width: 5.0,),
                  Text( double.parse(helper!.weekly[index].sum).floor().toString() , style: TextStyle(color: MyColors.primaryColor , fontSize: 13.0),),
                ],
              ),
            ),

          ]),
      SizedBox(height: 5.0,),
      Container(
        width: double.infinity,
        height: 1.0,
        color: MyColors.lightUnSelectedColor,
        margin: EdgeInsetsDirectional.only(start: 40.0),
        child: const Text(""),
      )
    ],
  );
  Widget itemBuilder3(index) => Column(
    children: [
      Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Row(
                children: [
                  Column(
                    children: [
                      CircleAvatar(
                        backgroundColor: helper!.monthly[index].user!.gender == 0 ? MyColors.blueColor : MyColors.pinkColor ,

                        backgroundImage: helper!.monthly[index].user!.img != "" ?
                        CachedNetworkImageProvider('${ASSETSBASEURL}AppUsers/${helper!.monthly[index].user!.img}') : null,
                        radius: 25,
                        child: helper!.monthly[index].user!.img == "" ?
                        Text(helper!.monthly[index].user!.name.toUpperCase().substring(0 , 1) +
                            (helper!.monthly[index].user!.name.contains(" ") ? helper!.monthly[index].user!.name.substring(helper!.monthly[index].user!.name.indexOf(" ")).toUpperCase().substring(1 , 2) : ""),
                          style: const TextStyle(color: Colors.white , fontSize: 20.0 , fontWeight: FontWeight.bold),) : null,
                      )
                    ],
                  ),
                  const SizedBox(width: 10.0,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(helper!.monthly[index].user!.name , style: TextStyle(color: MyColors.whiteColor , fontSize: 15.0),),
                          const SizedBox(width: 5.0,),
                          CircleAvatar(
                            backgroundColor: helper!.monthly[index].user!.gender == 0 ? MyColors.blueColor : MyColors.pinkColor ,
                            radius: 8.0,
                            child: helper!.monthly[index].user!.gender== 0 ?  const Icon(Icons.male , color: Colors.white, size: 13.0,) :  const Icon(Icons.female , color: Colors.white, size: 15.0,),
                          )
                        ],
                      ),
                      Row(

                        children: [
                          Image(image: CachedNetworkImageProvider(ASSETSBASEURL + 'Levels/' + helper!.monthly[index].user!.share_level_icon) , width: 30,),
                          const SizedBox(width: 5.0,),
                          Image(image: CachedNetworkImageProvider(ASSETSBASEURL + 'Levels/' + helper!.monthly[index].user!.karizma_level_icon) , width: 30,),
                          const SizedBox(width: 5.0,),
                          Image(image: CachedNetworkImageProvider(ASSETSBASEURL + 'Levels/' + helper!.monthly[index].user!.charging_level_icon) , width: 30,),

                        ],
                      ),

                      Text("ID:${helper!.monthly[index].user!.tag}" , style: TextStyle(color: MyColors.whiteColor , fontSize: 11.0),),


                    ],

                  ),
                ],
              ),
            ),


            Container(

              padding: EdgeInsetsDirectional.only(end: 10.0 , top: 3.0 , bottom: 3.0 , start: 10.0),
              decoration: BoxDecoration(color: Colors.white , borderRadius: BorderRadius.circular(20.0)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Image(image: AssetImage('assets/images/gold.png') , width: 25.0,),
                  SizedBox(width: 5.0,),
                  Text( double.parse(helper!.monthly[index].sum).floor().toString() , style: TextStyle(color: MyColors.primaryColor , fontSize: 13.0),),
                ],
              ),
            ),

          ]),
      SizedBox(height: 5.0,),
      Container(
        width: double.infinity,
        height: 1.0,
        color: MyColors.lightUnSelectedColor,
        margin: EdgeInsetsDirectional.only(start: 40.0),
        child: const Text(""),
      )
    ],
  );
  Widget separatorBuilder() => SizedBox(height: 5.0,);
}
