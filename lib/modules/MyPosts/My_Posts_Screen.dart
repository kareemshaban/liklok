import 'package:LikLok/models/AppUser.dart';
import 'package:LikLok/models/Post.dart';
import 'package:LikLok/modules/Post/Post_Screen.dart';
import 'package:LikLok/shared/components/Constants.dart';
import 'package:LikLok/shared/network/remote/AppUserServices.dart';
import 'package:LikLok/shared/network/remote/PostServices.dart';
import 'package:LikLok/shared/styles/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../Loading/loadig_screen.dart';

class MyPostsScreen extends StatefulWidget {
  const MyPostsScreen({super.key});

  @override
  State<MyPostsScreen> createState() => _MyPostsScreenState();
}

class _MyPostsScreenState extends State<MyPostsScreen> {
  AppUser? user ;
  List<Post> posts = [] ;
  bool loading = false ;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }
  getData() async{
    setState(() {
      loading = true ;
    });
    setState(() {
      user = AppUserServices().userGetter();
    });
    List<Post> res = await PostServices().getMyPosts(user!.id);
    setState(() {
      posts = res ;
      loading = false ;
    });

  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0),
        child: AppBar(
          iconTheme: IconThemeData(
            color: MyColors.whiteColor, //change your color here
          ),
          toolbarHeight: 70.0,
          backgroundColor: MyColors.solidDarkColor,
          title: Row(
            children: [
              CircleAvatar(
                backgroundColor: user!.gender == 0 ? MyColors.blueColor : MyColors.pinkColor ,
                backgroundImage: user?.img != "" ?  CachedNetworkImageProvider('${ASSETSBASEURL}AppUsers/${user?.img}') : null,
                radius: 20,
                child: user?.img== "" ?
                Text(user!.name.toUpperCase().substring(0 , 1) +
                    (user!.name.contains(" ") ? user!.name.substring(user!.name.indexOf(" ")).toUpperCase().substring(1 , 2) : ""),
                  style: const TextStyle(color: Colors.white , fontSize: 18.0 , fontWeight: FontWeight.bold),) : null,
              ),
              SizedBox(width: 25.0,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Row(
                    children: [
                      Text(user!.name , style: TextStyle(color: Colors.black , fontSize: 15.0 , fontWeight: FontWeight.bold),),
                      const SizedBox(width: 10.0,),
                      CircleAvatar(
                        backgroundColor: user!.gender == 0 ? MyColors.blueColor : MyColors.pinkColor ,
                        radius: 12.0,
                        child: user!.gender == 0 ?  const Icon(Icons.male , color: Colors.white, size: 15.0,) :  const Icon(Icons.female , color: Colors.white, size: 15.0,),
                      )
                    ],
                  ),
                  SizedBox(height: 3.0,),
                  Row(
                    children: [
                      Image(image: CachedNetworkImageProvider('${ASSETSBASEURL}Levels/${user!.share_level_icon}') , width: 30,),
                      const SizedBox(width: 10.0,),
                      Image(image: CachedNetworkImageProvider('${ASSETSBASEURL}Levels/${user!.karizma_level_icon}') , width: 30,),
                      const SizedBox(width: 10.0, height: 10,),
                      Image(image: CachedNetworkImageProvider('${ASSETSBASEURL}Levels/${user!.charging_level_icon}') , width: 30,),
                    ],
                  ),


                ],
              ),
            ],
          ),

        ),
      ),
      body: SafeArea(
        child: Container(
          color: MyColors.darkColor,
          height: double.infinity ,
          width: double.infinity,
          padding: EdgeInsets.all(10.0),
          child: loading ? Loading() : Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                  child: posts.isNotEmpty ?
                  ListView.separated( shrinkWrap: true,itemBuilder:(ctx , index) => postListItem(index , posts),
                      separatorBuilder:(ctx , index) => listSeperatorItem(), itemCount: posts.length)
                      : const Center(
                    child: Image(image: AssetImage('assets/images/empty.png'), width: 200.0, ),
                  )
        
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget postListItem(index ,List<Post> _posts) => Visibility(
    visible:_posts[index].reports != null ? _posts[index].reports!.isEmpty : true,
    child: Column(children: [
      Row(
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: _posts[index].gender == 0 ? MyColors.blueColor : MyColors.pinkColor ,
                backgroundImage: _posts[index].user_img != "" ?  CachedNetworkImageProvider(getUserImage()!) : null,
                radius: 25,
                child: _posts[index].user_img == "" ?
                Text(_posts[index].user_name.toUpperCase().substring(0 , 1) +
                    (_posts[index].user_name.contains(" ") ? _posts[index].user_name.substring(_posts[index].user_name.indexOf(" ")).toUpperCase().substring(1 , 2) : ""),
                  style: const TextStyle(color: Colors.white , fontSize: 24.0 , fontWeight: FontWeight.bold),) : null,
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
                _posts[index].likes!.where((element) => element.user_id == user!.id).isEmpty ? likePost(_posts[index].id) : unLikePost(_posts[index].id);
              }, icon: Icon(FontAwesomeIcons.heart ,
                color: ( _posts[index].likes!.where((element) => element.user_id == user!.id).isEmpty  ? MyColors.unSelectedColor : MyColors.primaryColor), size:20.0,)),
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

  likePost(post_id ) async{
    List<Post> res = await PostServices().likePost(post_id, user!.id);
    setState(() {
      posts = res.where((ele) =>  ele.user_id == user!.id).toList();

    });

  }
  unLikePost(post_id) async{
    List<Post> res = await PostServices().unlike(post_id, user!.id);
    setState(() {

      posts = res.where((ele) =>  ele.user_id == user!.id).toList();

    });

  }

  String? getUserImage(){
    if(user!.img.startsWith('https')){
      return user!.img.toString() ;
    } else {
      return '${ASSETSBASEURL}AppUsers/${user?.img}' ;
    }
  }
}
