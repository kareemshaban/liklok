import 'package:LikLok/models/AppUser.dart';
import 'package:LikLok/models/Friends.dart';
import 'package:LikLok/modules/InnerProfile/Inner_Profile_Screen.dart';
import 'package:LikLok/shared/components/Constants.dart';
import 'package:LikLok/shared/network/remote/AppUserServices.dart';
import 'package:LikLok/shared/styles/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FriendsScreen extends StatefulWidget {
  const FriendsScreen({super.key});

  @override
  State<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {
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
    return  Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: MyColors.whiteColor, //change your color here
        ),
        centerTitle: true,
        backgroundColor: MyColors.solidDarkColor,
        title: Text("friends_title".tr , style: TextStyle(color: Colors.black),),
      ),
      body: SafeArea(
        child: Container(
          color: MyColors.darkColor,
          width: double.infinity,
          height: double.infinity,
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: [
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _refresh,
                  color: MyColors.primaryColor,
                  child: friends!.length == 0 ? Center(child: Column(
                    children: [
                      Image(image: AssetImage('assets/images/sad.png') , width: 100.0 , height: 100.0,),
                      SizedBox(height: 30.0,),
                      Text('no_data'.tr , style: TextStyle(color: Colors.red , fontSize: 18.0 ) ,)
        
        
                    ],), ): ListView.separated(itemBuilder: (ctx , index) =>itemListBuilder(index) ,
                      separatorBuilder: (ctx , index) =>itemSperatorBuilder(), itemCount: friends!.length),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget itemListBuilder(index) => GestureDetector(
    onTap: (){
      Navigator.push(context, MaterialPageRoute(builder: (ctx) =>
          InnerProfileScreen(visitor_id: friends![index].friend_id == user!.id ?  friends![index].user_id :  friends![index].friend_id)));

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
}
