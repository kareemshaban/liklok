import 'package:LikLok/helpers/ExitRoomHelper.dart';
import 'package:LikLok/helpers/MicHelper.dart';
import 'package:LikLok/models/AppUser.dart';
import 'package:LikLok/models/ChatRoom.dart';
import 'package:LikLok/modules/InnerProfile/Inner_Profile_Screen.dart';
import 'package:LikLok/modules/Room/Room_Screen.dart';
import 'package:LikLok/shared/components/Constants.dart';
import 'package:LikLok/shared/network/remote/AppUserServices.dart';
import 'package:LikLok/shared/network/remote/ChatRoomService.dart';
import 'package:LikLok/shared/styles/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => SearchScreenState();
}

class SearchScreenState extends State<SearchScreen> {
  List<AppUser> users = [] ;
  List<ChatRoom> rooms = [] ;
  var userTxt = TextEditingController()  ;
  var roomTxt = TextEditingController();
  var passwordController = TextEditingController();
  bool isLoading = false ;
  AppUser? user ;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      user = AppUserServices().userGetter();
    });
  }
  @override
  Widget build(BuildContext context) {
    return
      DefaultTabController(
        length: 2,
        child: Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: MyColors.whiteColor, //change your color here
        ),
        centerTitle: true,
        backgroundColor: MyColors.solidDarkColor,
        title: TabBar(
          dividerColor: Colors.transparent,
          tabAlignment: TabAlignment.center,
          isScrollable: true ,
          indicatorColor: MyColors.primaryColor,
          labelColor: MyColors.primaryColor,
          unselectedLabelColor: MyColors.lightUnSelectedColor,
          labelStyle: const TextStyle(fontSize: 17.0 , fontWeight: FontWeight.w900),

          tabs:  [
            Tab(text: "search_user".tr ),
            Tab(text: "profile_room".tr,),
          ],
        ) ,
      ),
      body: Container(
        color: MyColors.darkColor,
        width: double.infinity,
        child: TabBarView(
            children:[
              Container(
                padding: const EdgeInsets.all(20.0),

                child:  Column(
                  children: [
                    Container(
                      height: 45.0 ,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(25.0) , color: MyColors.lightUnSelectedColor.withAlpha(100),),
                      child: TextField( controller: userTxt, decoration: InputDecoration(labelText: "search_label_search".tr , suffixIcon: IconButton(icon: const Icon(Icons.search , color: Colors.white, size: 25.0,),
                        onPressed: (){searchUsers();},) , fillColor: MyColors.primaryColor, focusColor: MyColors.primaryColor, focusedBorder: OutlineInputBorder( borderRadius: BorderRadius.circular(25.0) ,
                          borderSide: BorderSide(color: Colors.white) ) ,  border: OutlineInputBorder( borderRadius: BorderRadius.circular(25.0) ) , labelStyle: const TextStyle(color: Colors.black , fontSize: 13.0) ,  ),
                        style: const TextStyle(color: Colors.black , fontSize: 15.0), cursorColor: MyColors.primaryColor,),
                    ),
                    const SizedBox(height: 20.0,),

                    CircularProgressIndicator(
                        value: isLoading ? null : 0 ,
                      color: Colors.red,
                    ),
                    Expanded(child: ListView.separated(itemBuilder:(ctx , index) => usersListItem(index), separatorBuilder:(ctx , index) => listSeperator(), itemCount: users.length))
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(20.0),
                child:  Column(
                  children: [
                    Container(
                      height: 45.0 ,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(25.0) , color: MyColors.lightUnSelectedColor.withAlpha(100),),
                      child: TextField( controller: roomTxt, decoration: InputDecoration(  labelText: "search_label_search".tr , suffixIcon: IconButton(icon: const Icon(Icons.search , color: Colors.white, size: 25.0,),
                        onPressed: (){searchRooms();},) , fillColor: MyColors.primaryColor, focusColor: MyColors.primaryColor, focusedBorder: OutlineInputBorder( borderRadius: BorderRadius.circular(25.0) ,
                          borderSide: BorderSide(color: Colors.white) ) ,  border: OutlineInputBorder( borderRadius: BorderRadius.circular(25.0) ) , labelStyle: const TextStyle(color: Colors.black , fontSize: 13.0) ,  ),
                        style: const TextStyle(color: Colors.black , fontSize: 15.0), cursorColor: MyColors.primaryColor,),
                    ),
                    const SizedBox(height: 20.0,),
                    CircularProgressIndicator(
                      value: isLoading ? null : 0 ,
                      color: Colors.red,
                    ),
                    Expanded(
                        child: ListView.separated(itemBuilder:(ctx , index) => roomListItem(index), separatorBuilder:(ctx , index) => listSeperator(), itemCount: rooms.length)
                    )
                  ],
                ),
              )
            ],
        )
      ),
    ),);
  }
  void searchUsers() async{

      setState(() {
        isLoading = true ;
      });
     List<AppUser> res = await AppUserServices().searchUser(userTxt.text);
     print(res);
     setState(() {
       users = res ;
       isLoading = false ;
     });
  }
  void searchRooms() async{
    setState(() {

      isLoading = true ;
    });
    List<ChatRoom> res = await ChatRoomService().searchRoom(roomTxt.text);
    setState(() {
      rooms = res ;
      isLoading = false ;

    });
  }

  Widget usersListItem(index) => Column(
    children: [
      GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (ctx) =>  InnerProfileScreen(visitor_id: users[index].id )));
        },
        child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
             Column(
                 children: [
                   CircleAvatar(
                     backgroundColor: users[index].gender == 0 ? MyColors.blueColor : MyColors.pinkColor ,
                     backgroundImage:CachedNetworkImageProvider('${ASSETSBASEURL}AppUsers/${users[index].img}'),
                     radius: 30,
                     child: users[index].img == "" ?
                     Text(users[index].name.toUpperCase().substring(0 , 1) +
                         (users[index].name.contains(" ") ? users[index].name.substring(users[index].name.indexOf(" ")).toUpperCase().substring(1 , 2) : ""),
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
                      Text(users[index].name , style: TextStyle(color: MyColors.whiteColor , fontSize: 18.0),),
                      const SizedBox(width: 5.0,),
                      CircleAvatar(
                        backgroundColor: users[index].gender == 0 ? MyColors.blueColor : MyColors.pinkColor ,
                        radius: 10.0,
                        child: users[index].gender == 0 ?  const Icon(Icons.male , color: Colors.white, size: 15.0,) :  const Icon(Icons.female , color: Colors.white, size: 15.0,),
                      )
                    ],
                  ),
                  Row(

                    children: [
                      Image(image: CachedNetworkImageProvider(ASSETSBASEURL + 'Levels/' + users[index].share_level_icon) , width: 40,),
                      const SizedBox(width: 10.0,),
                      Image(image: CachedNetworkImageProvider(ASSETSBASEURL + 'Levels/' + users[index].karizma_level_icon) , width: 40,),
                      const SizedBox(width: 10.0,),
                      Image(image: CachedNetworkImageProvider(ASSETSBASEURL + 'Levels/' + users[index].charging_level_icon) , width: 30,),

                    ],
                  ),

                  Text("ID:${users[index].tag}" , style: TextStyle(color: MyColors.unSelectedColor , fontSize: 13.0),),


                ],

              ),

        ]),
      ),
      Container(
        width: double.infinity,
        height: 1.0,
        color: MyColors.lightUnSelectedColor,
        child: const Text(""),
      )
    ],
  );

  Widget listSeperator() => const SizedBox(height: 10.0,);

  Widget roomListItem(index) => Column(
    children: [
      GestureDetector(
        onTap: (){
          openRoom(rooms[index].id);

        },
        child: Row(
          children: [
            Column(
              children: [
                Container(
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.0)),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: rooms[index].img != "" ? Image(image: CachedNetworkImageProvider('${ASSETSBASEURL}Rooms/${rooms[index].img}') , width: 80.0 , height: 80.0,  fit: BoxFit.cover) :
                    Image(image: CachedNetworkImageProvider('${ASSETSBASEURL}Defaults/room_default.png') , width: 80.0 , height: 80.0,  fit: BoxFit.cover)
                )
              ],
            ),
            const SizedBox(width: 20.0,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(rooms[index].name , style: const TextStyle(color: Colors.black , fontSize: 16.0 , fontWeight: FontWeight.bold),),
                const SizedBox(height: 10.0,),
                Row(
                  children: [
                    Image(image: CachedNetworkImageProvider('${ASSETSBASEURL}Countries/${rooms[index].flag}' ) , width: 30.0,),
                     const SizedBox(width: 10.0,),
                    Container(
                        decoration: BoxDecoration(color: getMyColor(rooms[index].subject) , borderRadius: BorderRadius.circular(20.0)),
                         padding: const EdgeInsets.symmetric(horizontal: 5.0 , vertical: 1.0),
                        child: Text('#${rooms[index].subject.toLowerCase()}' , style: const TextStyle(color: Colors.white),)
                    )
                  ],
                ),
                const SizedBox(height: 10.0,),
                Text('ID:${rooms[index].tag}' , style: TextStyle(color: MyColors.unSelectedColor , fontSize: 13.0),)

              ],
            ),
          ],
        ),
      ),
      Container(
        width: double.infinity,
        height: 1.0,
        color: MyColors.lightUnSelectedColor,
        child: const Text(""),
      )
    ],
  );

  Color getMyColor(String subject){
    if(subject == "CHAT"){
      return MyColors.primaryColor.withOpacity(.8) ;
    } else if(subject == "FRIENDS"){
      return MyColors.successColor.withOpacity(.8) ;
    }else if(subject == "GAMES"){
      return MyColors.blueColor.withOpacity(.8) ;
    }
    else {
      return MyColors.primaryColor.withOpacity(.8) ;
    }

  }

  void openRoom(id) async{

    ChatRoom? res = await ChatRoomService().openRoomById(id);
    if(res != null){
      await checkForSavedRoom(res);
      if(res.password.isEmpty  || res.userId == user!.id){
        ChatRoomService().roomSetter(res);
        Navigator.push(context, MaterialPageRoute(builder: (context) => RoomScreen(),));
      } else {
        _displayTextInputDialog(context , res);
      }


    }
  }

  checkForSavedRoom(ChatRoom room) async {
    ChatRoom? savedRoom = ChatRoomService().savedRoomGetter();
    if(savedRoom != null){
      if(savedRoom.id == room.id){

      } else {
        // close the savedroom
        ChatRoomService().savedRoomSetter(null);
        await ChatRoomService.engine!.leaveChannel();
        await ChatRoomService.engine!.release();
        MicHelper( user_id:  user!.id , room_id:  savedRoom!.id , mic: 0).leaveMic();
        ExitRoomHelper(user!.id , savedRoom.id);

      }
    }

  }

  Future<void> _displayTextInputDialog(BuildContext context , ChatRoom room) async {
    return showDialog(
      context: context,
      builder: (context) {
        return Container(
          child: AlertDialog(
            backgroundColor: MyColors.darkColor,
            title: Text(
              'room_password_label'.tr,
              style: TextStyle(color: Colors.white, fontSize: 20.0),
              textAlign: TextAlign.center,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                Container(
                  height: 70.0,
                  child: TextField(
                    controller: passwordController,
                    style: TextStyle(color: Colors.white),
                    cursorColor: MyColors.primaryColor,
                    maxLength: 20,
                    keyboardType: TextInputType.visiblePassword,
                    decoration: InputDecoration(
                        hintText: "XXXXXXX",
                        hintStyle: TextStyle(color: Colors.white),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(color: MyColors.whiteColor)),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0))),
                  ),
                ),
              ],
            ),
            actions: <Widget>[
              Container(
                decoration: BoxDecoration(
                    color: MyColors.solidDarkColor,
                    borderRadius: BorderRadius.circular(15.0)),
                child: MaterialButton(
                  child: Text(
                    'edit_profile_cancel'.tr,
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    Navigator.pop(context);
                  },
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    color: MyColors.primaryColor,
                    borderRadius: BorderRadius.circular(15.0)),
                child: MaterialButton(
                  child: Text(
                    'OK',
                    style: TextStyle(color: MyColors.darkColor),
                  ),
                  onPressed: () async {
                    if(passwordController.text == room.password){
                      ChatRoomService().roomSetter(room);
                      Navigator.push(context, MaterialPageRoute(builder: (context) => RoomScreen(),));
                    } else {
                      Fluttertoast.showToast(
                          msg: "room_password_wrong".tr,
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.black26,
                          textColor: Colors.orange,
                          fontSize: 16.0
                      );
                    }

                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

}
