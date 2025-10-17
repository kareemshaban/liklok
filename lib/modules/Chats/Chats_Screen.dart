

import 'package:LikLok/modules/FriendsScreen/Friends_Screen.dart';
import 'package:LikLok/modules/InnerProfile/Inner_Profile_Screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:LikLok/models/AppUser.dart';
import 'package:LikLok/models/Chat.dart';
import 'package:LikLok/modules/CustomerService/customer_service_screen.dart';
import 'package:LikLok/modules/EventMessage/event_message_screen.dart';
import 'package:LikLok/modules/Followers/Followers_Screen.dart';
import 'package:LikLok/modules/SystemMessage/system_message_screen.dart';
import 'package:LikLok/modules/chat/chat.dart';
import 'package:LikLok/modules/chat_service/chat_service.dart';
import 'package:LikLok/shared/network/remote/AppUserServices.dart';
import 'package:LikLok/shared/network/remote/ChatServic.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../models/Friends.dart';
import '../../shared/components/Constants.dart';
import '../../shared/styles/colors.dart';
import '../Loading/loadig_screen.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({super.key});

  @override
  State<ChatsScreen> createState() => ChatsScreenState();
}

class ChatsScreenState extends State<ChatsScreen> {
  bool isloading = false ;
  var userTxt = TextEditingController()  ;
  List<Friends>? friends = [];
  List<Chat> chats = [] ;
  AppUser? user;
  AppUser? reciver ;
  final FirebaseAuth _auth = FirebaseAuth.instance ;
   @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      user = AppUserServices().userGetter();
      friends = user!.friends ;
    });
    print(friends);
    getUserChats();
  }
  Future<void> _refresh()async{
    await loadData2() ;
  }

  loadData2() async {
    AppUser? res = await AppUserServices().getUser(user!.id);
    setState(() {
      user = res;
      friends = user!.friends ;
      AppUserServices().userSetter(user!);
    });
  }

  getUserChats() async {
     chats = [] ;
     setState(() {
       isloading = true ;
     });
     List<Chat> res = await ChatApiService().getuserChats(user!.id);
     print(res);
     setState(() {
       chats = res ;
     });
     setState(() {
       isloading = false ;
     });
  }

  Future<void> refresh()async{
    await loadData() ;
  }
  loadData() async {
    AppUser? res = await AppUserServices().getUser(user!.id);
    await getUserChats();
    setState(() {
      user = res;
      friends = user!.friends ;
      AppUserServices().userSetter(user!);
    });
    print(friends);
  }
  Widget build(BuildContext context) {
    return  DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
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
              Tab(text: "chats_massage".tr ),
              Tab(text: "chats_friends".tr,),
            ],
          ) ,
          actions: [
            IconButton(
                onPressed: () async{
              showDialog(
                context: context,
                builder: (BuildContext context){
                  context = context;
                  return const Loading();
                },
              );
              await Future.delayed(Duration(milliseconds: 3000));
              Navigator.pop(context);

              Fluttertoast.showToast(
                  msg: 'chats_update_data_msg'.tr,
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.white,
                  textColor: MyColors.primaryColor,
                  fontSize: 16.0
              );

            }, icon: const Icon(Icons.cleaning_services_rounded , color: Colors.grey , size: 30.0,))
          ],
          ),
        body: SafeArea(
          child: Container(
            color: MyColors.darkColor,
            width: double.infinity,
            child: TabBarView(
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0 , vertical: 10.0),
                      child: Row(
                        children: [
                          //SizedBox(width: 8.0,),
                          Expanded(child: Column(
                            children: [
                              Container(
                                height: 70,
                                decoration: BoxDecoration(
                                  color: Color(0xFF6A1B9A) ,
                                  borderRadius: BorderRadius.circular(12.0)
                                ),
                                child: Row(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                           GestureDetector(
                                             behavior: HitTestBehavior.opaque,
                                             onTap: (){
                                               Navigator.push(context, MaterialPageRoute(builder: (ctx) => const EventMessage(),),);
                                             },
                                             child: Container(
                                               padding: EdgeInsets.symmetric(horizontal: 8.0)  ,
                                               width: (MediaQuery.of(context).size.width / 3 - 50 ),
                                               child: Text('chats_event_message'.tr , style: TextStyle(color: Colors.white ,
                                                   fontSize: 13.0 , fontWeight: FontWeight.bold),),
                                             ),
                                           ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Image(image: AssetImage('assets/images/notification-bell.png') , width: 30.0, height: 30.0,),
                                        ],
                                      )
                                    ],
                                )
                              )
                            ],
                          )),
                          SizedBox(width: 5.0,),
                          Expanded(child: Column(
                            children: [
                              Container(
                                  height: 70,
                                  decoration: BoxDecoration(
                                      color: Color(0xFFF50057) ,
                                      borderRadius: BorderRadius.circular(12.0)
                                  ),
                                  child: Row(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          GestureDetector(
                                            onTap: (){
                                              Navigator.push(context, MaterialPageRoute(builder: (ctx) => const FollowersScreen(),),);
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(horizontal: 8.0)  ,
                                              width: (MediaQuery.of(context).size.width / 3 - 50 ),
                                              child: Text('notification_setting_new_followers'.tr , style: TextStyle(color: Colors.white ,
                                                  fontSize: 12.0 , fontWeight: FontWeight.bold),),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Image(image: AssetImage('assets/images/users.png') , width: 30.0, height: 30.0,),
                                        ],
                                      )
                                    ],
                                  )
                              )
                            ],
                          )),
                          SizedBox(width: 5.0,),
                          Expanded(child: Column(
                            children: [
                              Container(
                                  height: 70,
                                  decoration: BoxDecoration(
                                      color: Color(0xFF64FFDA) ,
                                      borderRadius: BorderRadius.circular(12.0)
                                  ),
                                  child: Row(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          GestureDetector(
                                            onTap: (){
                                              Navigator.push(context, MaterialPageRoute(builder: (ctx) => const CustomerService(),),);
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(horizontal: 8.0)  ,
                                              width: (MediaQuery.of(context).size.width / 3 - 50 ),
                                              child: Text('chats_club_chat_service'.tr , style: TextStyle(color: Colors.white ,
                                                  fontSize: 12.0 , fontWeight: FontWeight.bold),),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Image(image: AssetImage('assets/images/customer-service.png') , width: 30.0, height: 30.0,),
                                        ],
                                      ),
                                    ],
                                  )
                              )
                            ],
                          )),
                        ],
                      ),
                    ),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> SystemMessage())) ;
                      },
                      child: Container(
                        color: Colors.white,
                        padding: EdgeInsets.all(15.0) ,
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 28.0,backgroundColor: MyColors.primaryColor,
                              child: Image(image: AssetImage('assets/images/control-system.png') , width: 35.0, height: 35.0,),
                            ),
                            SizedBox(width: 14.0,),
                            Text("chats_system_massage".tr,style: TextStyle(fontSize: 17.0,color: Colors.black),)
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10.0),
                    isloading ? Loading(

                    ) : Container() ,
                    Expanded(
                      child: RefreshIndicator(
                        color: MyColors.primaryColor,
                        onRefresh: refresh,
                        child: ListView.separated(
                            itemBuilder: (context,index) =>build_list_chats(chats[index]),
                            separatorBuilder: (context,index) =>Padding(
                              padding: const EdgeInsetsDirectional.only(start: 10.0),
                              child: Container(
                                color: Colors.grey,
                                height: 1,
                                width: double.infinity,
                              ),
                            ),
                            itemCount: chats.length
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Container(
                      color: MyColors.darkColor,
                      width: double.infinity,
                      height: MediaQuery.sizeOf(context).height - 200,
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          Expanded(

                            child: friends!.length == 0 ? Center(child: Column(
                              children: [
                                Image(image: AssetImage('assets/images/sad.png') , width: 100.0 , height: 100.0,),
                                SizedBox(height: 30.0,),
                                Text('no_data'.tr , style: TextStyle(color: Colors.red , fontSize: 18.0 ) ,)


                              ],), ): ListView.separated( itemBuilder: (ctx , index) =>itemListBuilder(index) ,
                                separatorBuilder: (ctx , index) =>itemSperatorBuilder(), itemCount: friends!.length),
                          ),
                        ],
                      ),
                    ),
                  ],
                )

              ],

            ),
          ),
        ),
        ),
      );
  }
  // build a list of users except for the current logged in user
  Widget _buildUserList(){
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('chat_rooms').snapshots(),
      builder: (context,snapshot){
        if(snapshot.hasError){
          return Text('chat_error'.tr) ;
        }
        if(snapshot.connectionState == ConnectionState.waiting){
          return Text('chat_loading'.tr) ;
        }
        return Expanded(
          child: ListView(
              children:
              snapshot.data!.docs
                  .map<Widget>((doc) => _buildUserListItem(doc),
              ).toList()
          ),
        );
      },
    );
  }
//build individual user list items
  Widget _buildUserListItem(DocumentSnapshot document){
    Map<String , dynamic> data = document.data()! as Map<String,dynamic>;
    //display all users except current user
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 7.0 , horizontal: 5.0),
        child: Container(
          height: 80,
          decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(10.0)
          ),
          child: Center(
            child: ListTile(
              title: Text(document.id, style: TextStyle(color: Colors.white),),
              onTap: (){
                // pass the clicked user's UID to the chat page
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //       builder: (context) => ChatScreen(
                //         receiverUserEmail: data['email'],
                //         receiverUserID: data['uid'],
                //         receiver: user!,
                //       ),
                //     )
                // );
              },
            ),
          ),
        ),
      );

  }

  Widget build_list_chats(Chat article) =>  GestureDetector(
    behavior: HitTestBehavior.opaque,
    onTap: () async{
      int id = 0 ;
      if(user!.id == article.sender_id) id = article.reciver_id ;
      else id = article.sender_id ;
      AppUser? rec = await AppUserServices().getUser(id);
      print(rec!.id);
      print(user!.id);
      Navigator.push(context, MaterialPageRoute(builder: (ctx) =>  ChatScreen(
        receiverUserEmail:  rec!.email ,
        receiverUserID: rec.id,
        receiver: rec,

      )
      )
      );
    },
    child: Container(
      color: Colors.white,
      padding: EdgeInsets.all(15.0) ,
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor:  MyColors.primaryColor,
            backgroundImage: getChatItemImg(article),
            radius: 30,
            child: getUserIntial(article),
          ),
          SizedBox(width: 14.0,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(getUserName(article),style: TextStyle(fontSize: 17.0,color: Colors.black),),
              SizedBox(height: 5.0,),
              Container( width: 90.0, child: Text((article.last_message),style: TextStyle(fontSize: 15.0,color: Colors.black), overflow: TextOverflow.ellipsis,)),
            ],
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(formattedDate(article.last_action_date) ,style: TextStyle(color: Colors.black),),
                    SizedBox(width: 5.0,),
                    Text(formattedTime(article.last_action_date) ,style: TextStyle(color: Colors.black),),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    ),
  );

  ImageProvider getChatItemImg(chat){
     if(chat.sender_id == user!.id){
       return CachedNetworkImageProvider('${ASSETSBASEURL}AppUsers/${chat.receiver_img}') ;
     } else {
       return CachedNetworkImageProvider('${ASSETSBASEURL}AppUsers/${chat.sender_img}') ;
     }

  }
  Widget getUserIntial(chat){
    String user_img = chat.sender_id == user!.id ? chat.receiver_img : chat.sender_img ;
    String user_name = chat.sender_id == user!.id ? chat.receiver_name : chat.sender_name ;

    return user_img== "" ?
    Text(user_name.toUpperCase().substring(0 , 1) +
        (user_name.contains(" ") ? user_name.substring(user_name.indexOf(" ")).toUpperCase().substring(1 , 2) : ""),
      style: const TextStyle(color: Colors.white , fontSize: 22.0 , fontWeight: FontWeight.bold),) : Container();
  }
  String getUserName(chat){
    String user_name = chat.sender_id == user!.id ? chat.receiver_name : chat.sender_name ;
     return user_name ;
  }

  String formattedDate(dateTime) {
    const DATE_FORMAT = 'dd/MM/yyyy';
    print('dateTime ($dateTime)');
    return DateFormat(DATE_FORMAT).format(DateTime.parse(dateTime) );
  }

  String formattedTime(dateTime) {
    const DATE_FORMAT = 'hh:mm';
    print('dateTime ($dateTime)');
    return DateFormat(DATE_FORMAT).format(DateTime.parse(dateTime) );
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
                        child: friends![index].follower_gender == 0 ?  const Icon(Icons.male , color: Colors.white, size: 15.0,) :  const Icon(Icons.female , color: Colors.white, size: 15.0,),
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
    if(user!.img.startsWith('https')){
      return friends![index].follower_img.toString() ;
    } else {
      return '${ASSETSBASEURL}AppUsers/${friends![index].follower_img}' ;
    }
  }
}


