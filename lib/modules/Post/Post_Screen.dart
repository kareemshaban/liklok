import 'package:LikLok/models/Comment.dart';
import 'package:LikLok/models/Post.dart';
import 'package:LikLok/modules/Moments/Moments_Screen.dart';
import 'package:LikLok/shared/components/Constants.dart';
import 'package:LikLok/shared/network/remote/PostServices.dart';
import 'package:LikLok/shared/styles/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PostScreen extends StatefulWidget {
  final Post post;
  const PostScreen({super.key, required this.post});


  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  int user_id = 0;
  var contentTxt = TextEditingController()  ;

  getInitdata() async {
    setState(() {

    });
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int id = await prefs.getInt('userId') ?? 0;

    setState(() {
      user_id = id;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getInitdata();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(
              color: MyColors.whiteColor, //change your color here
            ),
            backgroundColor: MyColors.solidDarkColor,
            title:  Text(
              "post_title".tr,
              style: TextStyle(color: Colors.black),
            ),
            centerTitle: true,
          ),
          body: SafeArea(
            child: Container(
              color: MyColors.darkColor,
              width: double.infinity,
              padding: EdgeInsets.only(top: 10.0),
              child: SingleChildScrollView(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: (MediaQuery.of(context).size.height * 0.9 ) - 10.0,
                  child: Column(
                    children: [
                      Expanded(
                        flex: 9,
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10.0 , vertical: 10.0),
                              color: Colors.white,
                              margin: const EdgeInsets.symmetric( horizontal: 20.0),
                              child: Row(
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        backgroundColor: widget.post.gender == 0 ? MyColors.blueColor : MyColors.pinkColor ,
                                        backgroundImage: widget.post.user_img != "" ?  CachedNetworkImageProvider('${ASSETSBASEURL}AppUsers/${widget.post.user_img}') : null,
                                        radius: 25,
                                        child: widget.post.user_img == "" ?
                                        Text(widget.post.user_name.toUpperCase().substring(0 , 1) +
                                            (widget.post.user_name.contains(" ") ? widget.post.user_name.substring(widget.post.user_name.indexOf(" ")).toUpperCase().substring(1 , 2) : ""),
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
                                            Text(widget.post.user_name , style: TextStyle(color: MyColors.whiteColor , fontSize: 15.0),),
                                            const SizedBox(width: 5.0,),
                                            CircleAvatar(
                                              backgroundColor: widget.post.gender == 0 ? MyColors.blueColor : MyColors.pinkColor ,
                                              radius: 10.0,
                                              child: widget.post.gender == 0 ?  const Icon(Icons.male , color: Colors.white, size: 15.0,) :  const Icon(Icons.female , color: Colors.white, size: 15.0,),
                                            )
                                          ],
                                        ),
                                        Row(
            
                                          children: [
                                            Image(image: CachedNetworkImageProvider('${ASSETSBASEURL}Levels/${widget.post.share_level_img}') , width: 35,),
                                            const SizedBox(width: 10.0,),
                                            Image(image: CachedNetworkImageProvider('${ASSETSBASEURL}Levels/${widget.post.karizma_level_img}') , width: 35,),
                                            const SizedBox(width: 10.0,),
                                            Image(image: CachedNetworkImageProvider('${ASSETSBASEURL}Levels/${widget.post.charging_level_img}') , width: 35,),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: (){},
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10.0 , vertical: 5.0),
                                      decoration: BoxDecoration(border: Border.all(color: MyColors.primaryColor , width: 1.0 ) , borderRadius: BorderRadius.circular(15.0) , color: Colors.transparent),
                                      child:  Text("moments_follow".tr , style: TextStyle(color: MyColors.primaryColor),),
                                    ),
                                  ),
                                  PopupMenuButton<int>(
                                    onSelected: (item) => {
                                      reportPost(widget.post.id , item)
                                    },
                                    iconColor: Colors.black,
                                    iconSize: 25.0,
                                    itemBuilder: (context) => [
                                       PopupMenuItem<int>(value: 0, child: Text('moments_not_interested'.tr)),
                                       PopupMenuItem<int>(value: 1, child: Text('moments_report'.tr)),
                                    ],
                                  )
            
                                ],
            
                              ),
                            ),
                            Container(
                                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                color: Colors.white,
                                margin: const EdgeInsets.symmetric( horizontal: 20.0),
                                width: double.infinity,
                                child: Column(
                                  children: [
                                    widget.post.content != "" ? Text(widget.post.content , style: const TextStyle(color: Colors.white) , textAlign: TextAlign.center,) : SizedBox(width: 100.0,) ,
                                    const SizedBox(height: 10.0,),
                                    widget.post.img != "" ? Image(image: CachedNetworkImageProvider('${ASSETSBASEURL}Posts/${widget.post.img}') , width: 100.0 ,) : const SizedBox(height: 1,),
                                    const SizedBox(height: 5.0,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(widget.post.created_at , style: TextStyle(color: MyColors.unSelectedColor , fontSize: 11.0),) ,
                                        SizedBox(width: 10.0,),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 10.0 , vertical: 3.0),
                                          decoration: BoxDecoration(border: Border.all(color: Colors.transparent , width: 1.0 , style: BorderStyle.solid) , borderRadius: BorderRadius.circular(25.0) ,
                                              color:  MyColors.successColor),
                                          child:  Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              Text('#${widget.post.tag}' , style: TextStyle(color: MyColors.whiteColor , fontSize: 15.0),)
                                            ],),
                                        )
                                      ],
                                    ),
                                    SizedBox(height: 10.0,),
                                    TabBar(
                                      dividerColor: Colors.transparent,
                                      tabAlignment: TabAlignment.center,
                                      isScrollable: true ,
                                      indicatorColor: MyColors.primaryColor,
                                      labelColor: MyColors.primaryColor,
                                      unselectedLabelColor: MyColors.unSelectedColor,
                                      labelStyle: const TextStyle(fontSize: 17.0 , fontWeight: FontWeight.w900),
                                      tabs: [
                                        Row(
                                          children: [
                                            IconButton(icon: Icon(FontAwesomeIcons.comment , color:  MyColors.unSelectedColor ,  size:25.0), onPressed: () {  } ,  ),
                                            SizedBox(width: 5.0,),
                                            Text(widget.post.comments_count.toString() , style: TextStyle(color: MyColors.unSelectedColor , fontSize: 14.0),)
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            IconButton( icon:Icon(FontAwesomeIcons.heart , color: ( widget.post.likes!.where((element) => element.user_id == user_id).isEmpty  ? MyColors.unSelectedColor : MyColors.primaryColor),  size:25.0) , onPressed: () {  },),
                                            SizedBox(width: 5.0,),
                                            Text(widget.post.likes_count.toString() , style: TextStyle(color: MyColors.unSelectedColor , fontSize: 14.0),)
                                          ],
                                        ),
                                        //
                                      ],
                                    ),
                                    SizedBox(height: 15.0,),
                                  ],
                                )
                            ),
            
                            Expanded(
            
                              child: Container(
                                child: TabBarView(
                                  children: [
                                    widget.post.comments!.length > 0 ?
                                    ListView.separated( itemBuilder: (ctx , index) => commentListItem(index), separatorBuilder: (ctx , index) => separatorBuilder(), itemCount: widget.post.comments!.length)
                                    : const Center(
                                      child: Image(image: AssetImage('assets/images/empty.png'), width: 200.0, ),
                                    ),
            
                                    widget.post.likes!.length > 0 ?
                                    ListView.separated( itemBuilder: (ctx , index) => likesListItem(index), separatorBuilder: (ctx , index) => separatorBuilder(), itemCount: widget.post.likes!.length)
                                        : const Center(
                                          child: Image(image: AssetImage('assets/images/empty.png'), width: 200.0, ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
            
            
                          ],
                        ),
            
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          width: double.infinity,
                          color: MyColors.solidDarkColor,
                          padding:
                              EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                          child: Row(
                            children: [
                              Column(
                                children: [
                                  IconButton(
                                      onPressed: () {AddPost();},
                                      icon: Icon(
                                        FontAwesomeIcons.share,
                                        color: MyColors.unSelectedColor,
                                        size: 30.0,
                                      )),
                                ],
                              ),
                              const SizedBox(
                                width: 15.0,
                              ),
                              Expanded(
                                  child: Container(
                                      height: 50.0,
                                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                      decoration: BoxDecoration(
                                          color: MyColors.lightUnSelectedColor,
                                          borderRadius: BorderRadius.circular(15.0)),
                                      child: TextField(
                                        controller: contentTxt,
                                        cursorColor: MyColors.whiteColor ,
                                        style: const TextStyle(color: Colors.white),
                                        decoration: InputDecoration(
                                          focusedBorder: const OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  width: 3,
                                                  color: Colors
                                                      .transparent)
                                          ),
                                          labelText: "post_label".tr,
                                          labelStyle: TextStyle(color: MyColors.whiteColor),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                width: 3,
                                                color: Colors
                                                    .transparent), //<-- SEE HERE
                                            borderRadius: BorderRadius.circular(50.0),
                                          ),
                                        ),
                                      ))),
                              const SizedBox(
                                width: 15.0,
                              ),
                              Column(
                                children: [
                                  IconButton(
                                      onPressed: () {},
                                      icon: Icon(
                                        widget.post.likes!
                                                .where((element) =>
                                                    element.user_id == user_id)
                                                .isEmpty
                                            ? FontAwesomeIcons.heart
                                            : FontAwesomeIcons.solidHeart,
                                        color: (widget.post.likes!
                                                .where((element) =>
                                                    element.user_id == user_id)
                                                .isEmpty
                                            ? MyColors.unSelectedColor
                                            : MyColors.primaryColor),
                                        size: 30.0,
                                      )),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }

  reportPost(post_id, type) async {
    List<Post> res = await PostServices().reportPost(post_id, user_id, type);
    Navigator.push(
        context, MaterialPageRoute(builder: (ctx) => const MomentsScreen()));
  }

  Widget likesListItem(index) => Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: widget.post.likes?[index].gender == 0
                      ? MyColors.blueColor
                      : MyColors.pinkColor,
                  backgroundImage: widget.post.likes?[index].user_img != ""
                      ? CachedNetworkImageProvider(
                          '${ASSETSBASEURL}AppUsers/${widget.post.likes?[index].user_img}')
                      : null,
                  radius: 25,
                  child: widget.post.likes?[index].user_img == ""
                      ? Text(
                          widget.post.likes![index].user_name
                                  .toUpperCase()
                                  .substring(0, 1) +
                              (widget.post.likes![index].user_name.contains(" ")
                                  ? widget.post.likes![index].user_name
                                      .substring(widget
                                          .post.likes![index].user_name
                                          .indexOf(" "))
                                      .toUpperCase()
                                      .substring(1, 2)
                                  : ""),
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold),
                        )
                      : null,
                ),
                SizedBox(
                  width: 10.0,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          widget.post.likes![index].user_name,
                          style: TextStyle(
                              color: MyColors.whiteColor, fontSize: 15.0),
                        ),
                        const SizedBox(
                          width: 5.0,
                        ),
                        CircleAvatar(
                          backgroundColor: widget.post.likes?[index].gender == 0
                              ? MyColors.blueColor
                              : MyColors.pinkColor,
                          radius: 10.0,
                          child: widget.post.likes?[index].gender == 0
                              ? const Icon(
                                  Icons.male,
                                  color: Colors.white,
                                  size: 15.0,
                                )
                              : const Icon(
                                  Icons.female,
                                  color: Colors.white,
                                  size: 15.0,
                                ),
                        )
                      ],
                    ),
                    Text(
                      'ID:${widget.post.likes![index].user_tag}',
                      style: TextStyle(
                          color: MyColors.unSelectedColor, fontSize: 13.0),
                    )
                  ],
                ),
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 5.0),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: MyColors.primaryColor, width: 1.0),
                            borderRadius: BorderRadius.circular(15.0),
                            color: Colors.transparent),
                        child: Text(
                          "moments_follow".tr,
                          style: TextStyle(color: MyColors.primaryColor),
                        ),
                      ),
                    ),
                  ],
                ))
              ],
            ),
            const SizedBox(
              height: 10.0,
            ),
            Container(
              width: double.infinity,
              height: 1.0,
              color: MyColors.lightUnSelectedColor,
              child: const Text(""),
              margin: EdgeInsets.symmetric(horizontal: 10.0),
            )
          ],
        ),
      );

  Widget commentListItem(index) => Container(
    padding: EdgeInsets.all(20.0),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: widget.post.comments?[index].gender == 0
                  ? MyColors.blueColor
                  : MyColors.pinkColor,
              backgroundImage: widget.post.comments?[index].user_img != ""
                  ? CachedNetworkImageProvider(
                  '${ASSETSBASEURL}AppUsers/${widget.post.comments?[index].user_img}')
                  : null,
              radius: 25,
              child: widget.post.comments?[index].user_img == ""
                  ? Text(
                widget.post.comments![index].user_name
                    .toUpperCase()
                    .substring(0, 1) +
                    (widget.post.comments![index].user_name.contains(" ")
                        ? widget.post.comments![index].user_name
                        .substring(widget
                        .post.comments![index].user_name
                        .indexOf(" "))
                        .toUpperCase()
                        .substring(1, 2)
                        : ""),
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold),
              )
                  : null,
            ),
            SizedBox(
              width: 10.0,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      widget.post.comments![index].user_name,
                      style: TextStyle(
                          color: MyColors.whiteColor, fontSize: 15.0),
                    ),
                    const SizedBox(
                      width: 5.0,
                    ),
                    CircleAvatar(
                      backgroundColor: widget.post.comments?[index].gender == 0
                          ? MyColors.blueColor
                          : MyColors.pinkColor,
                      radius: 10.0,
                      child: widget.post.comments?[index].gender == 0
                          ? const Icon(
                        Icons.male,
                        color: Colors.white,
                        size: 15.0,
                      )
                          : const Icon(
                        Icons.female,
                        color: Colors.white,
                        size: 15.0,
                      ),
                    )
                  ],
                ),
                Text(
                  'ID:${widget.post.comments![index].user_tag}',
                  style: TextStyle(
                      color: MyColors.unSelectedColor, fontSize: 13.0),
                )
              ],
            ),
            Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 5.0),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: MyColors.primaryColor, width: 1.0),
                            borderRadius: BorderRadius.circular(15.0),
                            color: Colors.transparent),
                        child: Text(
                          "moments_follow".tr,
                          style: TextStyle(color: MyColors.primaryColor),
                        ),
                      ),
                    ),
                  ],
                ))
          ],
        ),
        const SizedBox(
          height: 10.0,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 60.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(widget.post.comments![index].content , style: TextStyle(color: MyColors.whiteColor , fontSize: 13.0),),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0 , vertical: 5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon(FontAwesomeIcons.clock , color: MyColors.unSelectedColor , size: 13.0,),
              SizedBox(width: 5.0,),
              Text(widget.post.comments![index].created_at , style: TextStyle(color: MyColors.unSelectedColor , fontSize: 11.0),),

            ],
          ),
        ),
        Container(
          width: double.infinity,
          height: 1.0,
          color: MyColors.lightUnSelectedColor,
          child: const Text(""),
          margin: EdgeInsets.symmetric(horizontal: 10.0),
        )
      ],
    ),
  );

  Widget separatorBuilder() => SizedBox(
        height: 10.0,
      );

  AddPost() async{
    List <Comment> res = await PostServices().addComment(widget.post.id, user_id, contentTxt.text);
    print(res);
    FocusScope.of(context).unfocus();
    contentTxt.text = "" ;
    Fluttertoast.showToast(
        msg: "post_msg".tr,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black26,
        textColor: Colors.orange,
        fontSize: 16.0
    );
    setState(() {

    });
  }
}
