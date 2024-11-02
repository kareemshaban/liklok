import 'dart:convert';

import 'package:LikLok/models/AppUser.dart';
import 'package:LikLok/models/Post.dart';
import 'package:LikLok/models/PostLike.dart';
import 'package:LikLok/modules/AddPost/Add_Post_Screen.dart';
import 'package:LikLok/modules/Notifications/Notification_Screen.dart';
import 'package:LikLok/modules/Post/Post_Screen.dart';
import 'package:LikLok/modules/SmallProfile/Small_Profile_Screen.dart';
import 'package:LikLok/shared/components/Constants.dart';
import 'package:LikLok/shared/network/remote/AppUserServices.dart';
import 'package:LikLok/shared/network/remote/PostServices.dart';
import 'package:LikLok/shared/styles/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Loading/loadig_screen.dart';

class MomentsScreen extends StatefulWidget {
  const MomentsScreen({super.key});

  @override
  State<MomentsScreen> createState() => MomentsScreenState();
}

class MomentsScreenState extends State<MomentsScreen> {
  List<Post> posts = [] ;
  List<Post> followingPosts = [] ;
  List<Post> myPosts = [] ;
   int user_id = 0 ;
  bool loading = false ;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllPosts();
  }

  getAllPosts() async{
    setState(() {
      loading = true ;
    });
    List<Post> res = await PostServices().getAllPosts() ;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int id = await prefs.getInt('userId') ?? 0;

    setState(() {
      user_id = id ;
      posts = res ;
      followingPosts = [] ;
      myPosts = res.where((ele) =>  ele.user_id == id).toList();

    });
    setState(() {
      loading = false ;
    });
  }
  Future<void> _refresh ()async{

    await getAllPosts() ;

  }

  @override
  Widget build(BuildContext context) {
    return  DefaultTabController(length: 3,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: MyColors.solidDarkColor,
            title: TabBar(
              dividerColor: Colors.transparent,
              tabAlignment: TabAlignment.start,
              isScrollable: true ,
              indicatorColor: MyColors.primaryColor,
              labelColor: MyColors.primaryColor,
              unselectedLabelColor: MyColors.lightUnSelectedColor,
              labelStyle: const TextStyle(fontSize: 17.0 , fontWeight: FontWeight.w900),

              tabs:  [
                Tab(child: Text("moments_recommend".tr , style: TextStyle(fontSize: 15.0),), ),
                Tab(child: Text("following_title".tr , style: TextStyle(fontSize: 15.0),), ),
                Tab(child: Text("moments_mine".tr , style: TextStyle(fontSize: 15.0),), ),
              ],
            ) ,
            actions: [
              IconButton(onPressed: (){
                 Navigator.push(context, MaterialPageRoute(builder: (ctx) => const NotificationScreen()));
              }, icon: const Icon(Icons.notifications_outlined , color: Colors.black , size: 30.0,))
            ],
          ),

         body: Container(
           color: MyColors.darkColor,
           width: double.infinity,
           padding: const EdgeInsets.all(20.0),
           child: loading ? Loading() : Stack(
             alignment: AlignmentDirectional.bottomEnd,
             children: [
              posts.length > 0 ? TabBarView(
                 children: [
                   Column(
                     crossAxisAlignment: CrossAxisAlignment.end,
                     children: [
                       posts.isNotEmpty ?
                           Expanded(child: RefreshIndicator( color:MyColors.primaryColor ,onRefresh:_refresh ,child: ListView.separated(  itemBuilder:(ctx , index) => postListItem(index , posts), separatorBuilder:(ctx , index) => listSeperatorItem(), itemCount: posts.length)))
                           :  RefreshIndicator(
                         color: MyColors.primaryColor,
                         onRefresh: _refresh,
                         child: ListView.builder(
                           itemBuilder: (context,index)=>Show_image(),
                           itemCount: 1,
                         ),
                       ) ,
                     ],
                   ),
                   Column(
                     crossAxisAlignment: CrossAxisAlignment.end,
                     children: [
                       Expanded(
                           child: followingPosts.isNotEmpty ?
                           RefreshIndicator(color:MyColors.primaryColor ,onRefresh:_refresh ,child: ListView.separated( shrinkWrap: true,itemBuilder:(ctx , index) => postListItem(index , posts), separatorBuilder:(ctx , index) => listSeperatorItem(), itemCount: followingPosts.length))
                               : RefreshIndicator(
                                 color: MyColors.primaryColor,
                                 onRefresh: _refresh,
                                 child: ListView.builder(
                                     itemBuilder: (context,index)=>Show_image(),
                                     itemCount: 1,
                                 ),
                               ) ,

                     ),
                     ],
                   ),
                   Column(
                     crossAxisAlignment: CrossAxisAlignment.end,
                     children: [
                       Expanded(
                           child: myPosts.isNotEmpty ?
                           RefreshIndicator(color:MyColors.primaryColor,onRefresh:_refresh,child: ListView.separated(shrinkWrap: true ,itemBuilder:(ctx , index) => postListItem(index , posts), separatorBuilder:(ctx , index) => listSeperatorItem(), itemCount: myPosts.length))
                               : RefreshIndicator(
                               color: MyColors.primaryColor,
                               onRefresh: _refresh,
                               child: ListView.builder(
                                 itemBuilder: (context,index)=>Show_image(),
                                 itemCount: 1,
                               ),
                             ) ,
                       ),
                     ],
                   ),

                 ],
               ) : Container(),
                FloatingActionButton(onPressed: (){openAddPostPage();} , backgroundColor: MyColors.primaryColor, mini: true, child: const Icon(FontAwesomeIcons.pen , color: Colors.white),)

             ],
           ),
         ),
        )
    );
  }

  Widget getFollowBtn(fuser){
    AppUser? currentUser = AppUserServices().userGetter();
    if(currentUser!.followings!.where((element) => element.follower_id == fuser).length == 0 && currentUser.id != fuser){
      return  GestureDetector(
        onTap: (){
          followUser(fuser);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10.0 , vertical: 5.0),
          decoration: BoxDecoration(border: Border.all(color: MyColors.primaryColor , width: 1.0 ) , borderRadius: BorderRadius.circular(15.0) , color: Colors.transparent),
          child:  Text("moments_follow".tr , style: TextStyle(color: MyColors.primaryColor),),
        ),
      );
    } else {
      return  Container();
    }
  }
  followUser(fuser) async{
    AppUser? currentUser = AppUserServices().userGetter();
    AppUser? res = await AppUserServices().followUser(currentUser!.id, fuser);

    AppUserServices().userSetter(res!);
    await getAllPosts() ;
    Fluttertoast.showToast(
        msg: 'inner_msg_followed'.tr,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black26,
        textColor: Colors.orange,
        fontSize: 16.0
    );
  }
  Widget postListItem(index ,List<Post> _posts) => Visibility(
    visible:_posts[index].reports != null ? _posts[index].reports!.isEmpty : true,
    child: Column(children: [
       Row(
         children: [
           Row(
             children: [
               GestureDetector(
                 onTap: () async{
                   AppUser? res =  await AppUserServices().getUser(_posts[index].user_id);
                   showModalBottomSheet(

                       context: context,
                       builder: (ctx) => ProfileBottomSheet(res));
                 },
                 child: CircleAvatar(
                   backgroundColor: _posts[index].gender == 0 ? MyColors.blueColor : MyColors.pinkColor ,
                   backgroundImage: _posts[index].user_img != "" ?  CachedNetworkImageProvider('${ASSETSBASEURL}AppUsers/${_posts[index].user_img}') : null,
                   radius: 25,
                   child: _posts[index].user_img == "" ?
                   Text(_posts[index].user_name.toUpperCase().substring(0 , 1) +
                       (_posts[index].user_name.contains(" ") ? _posts[index].user_name.substring(_posts[index].user_name.indexOf(" ")).toUpperCase().substring(1 , 2) : ""),
                     style: const TextStyle(color: Colors.white , fontSize: 24.0 , fontWeight: FontWeight.bold),) : null,
                 ),
               ),
    
             ],
           ),
    
           const SizedBox(width: 10.0,),
           Expanded(
             child: Column(
               children: [
                 Row(
                   children: [
                     Text(_posts[index].user_name , style: TextStyle(color: MyColors.whiteColor , fontSize: 15.0),),
                     const SizedBox(width: 5.0,),
                     CircleAvatar(
                       backgroundColor: _posts[index].gender == 0 ? MyColors.blueColor : MyColors.pinkColor ,
                       radius: 10.0,
                       child: _posts[index].gender == 0 ?  const Icon(Icons.male , color: Colors.white, size: 15.0,) :  const Icon(Icons.female , color: Colors.white, size: 15.0,),
                     )
                   ],
                 ),
                 Row(
    
                   children: [
                     Image(image: CachedNetworkImageProvider('${ASSETSBASEURL}Levels/${_posts[index].share_level_img}') , width: 35,),
                     const SizedBox(width: 10.0,),
                     Image(image: CachedNetworkImageProvider('${ASSETSBASEURL}Levels/${_posts[index].karizma_level_img}') , width: 35,),
                     const SizedBox(width: 10.0,),
                     Image(image: CachedNetworkImageProvider('${ASSETSBASEURL}Levels/${_posts[index].charging_level_img}') , width: 35,),
                   ],
                 ),
               ],
             ),
           ),
           GestureDetector(
             onTap: (){},
             child: getFollowBtn(_posts[index].user_id)
           ),
           PopupMenuButton<int>(
             onSelected: (item) => {
             reportPost(_posts[index].id , item)
             },
             iconColor: Colors.grey,
             iconSize: 25.0,
             itemBuilder: (context) => [
                PopupMenuItem<int>(value: 0, child: Text('moments_not_interested'.tr)),
                PopupMenuItem<int>(value: 1, child: Text('moments_report'.tr)),
             ],
           )
    
         ],
    
       ),
       const SizedBox(height: 10.0,),
       Text(_posts[index].content , style: const TextStyle(color: Colors.black) , textAlign: TextAlign.start,) ,
      const SizedBox(height: 10.0,),
      _posts[index].img != "" ? Image(image: CachedNetworkImageProvider('${ASSETSBASEURL}Posts/${_posts[index].img}') , width: 200.0 ,) : const SizedBox(height: 1,),
       Container(),
      const SizedBox(height: 5.0,),
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(_posts[index].created_at , style: TextStyle(color: MyColors.unSelectedColor , fontSize: 11.0),) ,
          SizedBox(width: 10.0,),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10.0 , vertical: 3.0),
            decoration: BoxDecoration(border: Border.all(color: Colors.transparent , width: 1.0 , style: BorderStyle.solid) , borderRadius: BorderRadius.circular(25.0) ,
                color:  MyColors.successColor),
            child:  Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text('#${_posts[index].tag}' , style: TextStyle(color: MyColors.whiteColor , fontSize: 15.0),)
              ],),
          )
        ],
      ),
    
      Row(
        children: [
          Row(
            children: [
              IconButton(onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) =>  PostScreen(post: _posts[index])));
              }, icon: Icon(FontAwesomeIcons.comment , color: MyColors.unSelectedColor, size: 20.0,)),
              Text(_posts[index].comments_count.toString() , style: TextStyle(color: MyColors.unSelectedColor , fontSize: 14.0),)
            ],
          ),
          Row(
            children: [
              IconButton(onPressed: (){
                _posts[index].likes!.where((element) => element.user_id == user_id).isEmpty ? likePost(_posts[index].id) : unLikePost(_posts[index].id);
              }, icon: Icon(FontAwesomeIcons.heart ,
                color: ( _posts[index].likes!.where((element) => element.user_id == user_id).isEmpty  ? MyColors.unSelectedColor : MyColors.primaryColor), size:20.0,)),
              Text(_posts[index].likes_count.toString() , style: TextStyle(color: MyColors.unSelectedColor , fontSize: 14.0),)
            ],
          )
          //
        ],
      ),
      Container(
        width: double.infinity,
        height: 1.0,
        color: MyColors.lightUnSelectedColor,
        child: const Text(""),
      )
    
    
    ],),
  );
  Widget listSeperatorItem() => const SizedBox(height: 10.0);

  openAddPostPage(){
    Navigator.push(context, MaterialPageRoute(builder: (ctx) => const AddPostScreen()));
  }
  likePost(post_id ) async{
     List<Post> res = await PostServices().likePost(post_id, user_id);
     setState(() {
       posts = res ;
       print(posts[0].likes);
       print(posts[1].likes);
       print(posts[2].likes);
       followingPosts = [] ;
       myPosts = res.where((ele) =>  ele.user_id == user_id).toList();

     });

     }
  unLikePost(post_id) async{
    List<Post> res = await PostServices().unlike(post_id, user_id);
    setState(() {
      posts = res ;
      print(posts);
      followingPosts = [] ;
      myPosts = res.where((ele) =>  ele.user_id == user_id).toList();

    });

  }
  reportPost(post_id , type) async{
    List<Post> res = await PostServices().reportPost(post_id, user_id , type);
    setState(() {
      posts = res ;
      print(posts);
      followingPosts = [] ;
      myPosts = res.where((ele) =>  ele.user_id == user_id).toList();

    });
  }

}

Widget Show_image() => Column(
  children: [
    Center(child: Column(
      children: [
        Image(image: AssetImage('assets/images/sad.png') , width: 100.0 , height: 100.0,),
        SizedBox(height: 30.0,),
        Text('no_data'.tr , style: TextStyle(color: Colors.red , fontSize: 18.0 ) ,)


      ],), )
  ],
) ;

Widget ProfileBottomSheet( user ) => SmallProfileModal(visitor: user);


