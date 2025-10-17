import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:LikLok/models/AppUser.dart';
import 'package:LikLok/models/ChatRoom.dart';
import 'package:LikLok/models/Rollet.dart';
import 'package:LikLok/shared/network/remote/AppUserServices.dart';
import 'package:LikLok/shared/network/remote/ChatRoomService.dart';
import 'package:LikLok/shared/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateRolletModal extends StatefulWidget {
  const CreateRolletModal({super.key});

  @override
  State<CreateRolletModal> createState() => _CreateRolletModalState();
}

class _CreateRolletModalState extends State<CreateRolletModal> {
  final values = [300 , 500 , 1000 , 2000];
  final members = [3 , 5 , 7 ];
  int selectedValue = 300 ;
  int selectedCount = 3 ;
  ChatRoom? room ;
  AppUser? user ;
  late bool adminShare = false ;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      room = ChatRoomService().roomGetter();
      user = AppUserServices().userGetter();
    });
  }
  @override
  Widget build(BuildContext context) {
    return  SafeArea(
      child: Container(
        height: MediaQuery.sizeOf(context).height * .45,
        padding: EdgeInsets.all(7.0),
        decoration: BoxDecoration(color: Colors.transparent,
            image: DecorationImage(image: AssetImage('assets/images/rollet_bg.png') , fit: BoxFit.cover),
            borderRadius: BorderRadius.only(topRight: Radius.circular(20.0) , topLeft: Radius.circular(15.0)) ,
            border: Border(top: BorderSide(width: 3.0, color: Colors.grey),)
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: Container(
                      margin: EdgeInsets.all(5),
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(width: 2, color: Colors.white)),
                      child: Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 15.0,
                      ),
                    ),
                  ),
                  Expanded(child:
                   Image(
                     image: AssetImage('assets/images/rollet_title_ar.png'),
                     width: 70.0,
                   )
                  ),
                  GestureDetector(
                    onTap: (){
                      //Navigator.pop(context);
                    },
                    child: Container(
                      margin: EdgeInsets.all(5),
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(width: 2, color: Colors.white)),
                      child: Icon(
                        Icons.question_mark,
                        color: Colors.white,
                        size: 15.0,
                      ),
                    ),
                  ),
                ],
          
              ),
              SizedBox(height: 10.0,),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15.0 , vertical: 5.0),
                width: MediaQuery.sizeOf(context).width * .9,
                decoration: BoxDecoration(color: MyColors.rolletSelectColor , borderRadius: BorderRadius.circular(20.0)),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('rollet_value'.tr , style: TextStyle(color: Colors.white , fontSize: 18.0),),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          DropdownButtonHideUnderline(
                            child: DropdownButton(
                              items: getItems(),
                              onChanged: (value) async {
                                print(value);
                                setState(() {
                                  // selectedCountry = value;
                                  // updateUserCountry(value);
                                });
                              },
                              value: selectedValue,
                              dropdownColor: MyColors.rolletSelectColor,
                              menuMaxHeight: 200.0,
                            ),
                          ),
                        ],
                      ),
                    ),
          
                  ],
                ),
              ),
              SizedBox(height: 10.0,),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15.0 , vertical: 5.0),
                width: MediaQuery.sizeOf(context).width * .9,
                decoration: BoxDecoration(color: MyColors.rolletSelectColor , borderRadius: BorderRadius.circular(20.0)),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('rollet_max_members'.tr , style: TextStyle(color: MyColors.whiteColor , fontSize: 18.0),),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          DropdownButtonHideUnderline(
                            child: DropdownButton(
                              items: getItems2(),
                              onChanged: (value) async {
                                print(value);
                                setState(() {
                                  // selectedCountry = value;
                                  // updateUserCountry(value);
                                });
                              },
                              value: selectedCount,
                              dropdownColor: MyColors.rolletSelectColor,
                              menuMaxHeight: 100.0,
                            ),
                          ),
                        ],
                      ),
                    ),
          
                  ],
                ),
              ),
              Container(
                width: MediaQuery.sizeOf(context).width * .9,
                child: Column(
                  children: [
                    ListTile(
                      title: Text('rollet_admin_play'.tr , style: TextStyle(fontSize: 16.0 , color: Colors.white),),
                      leading: Radio(
                        activeColor: MyColors.primaryColor,
      
                        value: true,
                        groupValue: adminShare,
                        onChanged: (bool? value) {
                          setState(() {
                            adminShare = value!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: (){
      
                  if(user!.id == room!.userId){
                    createRollet();
                  } else {
                    getRollet();
                  }
      
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: MediaQuery.sizeOf(context).width * .8,
                      height: 60.0,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(25.0) , image: DecorationImage(image: AssetImage('assets/images/rollet_start_bg.png'))),
                    ),
                    Text('rollet_start'.tr , style: TextStyle(fontSize: 22.0 , color: MyColors.luckyunsTextColor , fontWeight: FontWeight.bold),)
                  ],
                ),
              )
          
            ],
          ),
        ),
      ),
    );
  }
   List<DropdownMenuItem> getItems() {
     return values.map<DropdownMenuItem<int>>((item) {
       return DropdownMenuItem<int>(
         value: item,
         child: Container(
           child: Row(
             children: [
               SizedBox(
                 width: 5.0,
               ),
               Image(
                 image:
                 AssetImage('assets/images/gold.png'),
                 width: 30.0,
               ),
               SizedBox(
                 width: 5.0,
               ),
               Text(
                 item.toString(),
                 style: TextStyle(color: Colors.white, fontSize: 16.0),
               )
             ],
           ),
         ),
       );
     }).toList();
   }
   List<DropdownMenuItem> getItems2() {
     return members.map<DropdownMenuItem<int>>((item) {
       return DropdownMenuItem<int>(
         value: item,
         child: Container(
           child: Row(
             children: [
               SizedBox(
                 width: 5.0,
               ),
               Text(
                 item.toString(),
                 style: TextStyle(color: Colors.white, fontSize: 18.0 , fontWeight: FontWeight.bold),
               )
             ],
           ),
         ),
       );
     }).toList();
   }

   createRollet() async{

     Rollet? rollet = await ChatRoomService().createRollet(room!.id, user!.id , selectedValue , adminShare , selectedCount);
     print('rolletID');
     print(rollet!.id);
     if(rollet.id > 0){
       Navigator.pop(context);
       await FirebaseFirestore.instance.collection("roulette").add({
         'room_id': room!.id,
         'user_id': user!.id,
         'rollet_id': rollet.id,
       });
     }
   }

  getRollet() async{
    Rollet? rollet = await ChatRoomService().getRoomActiveRollet(room!.id);
    if(rollet!.id > 0){
      await FirebaseFirestore.instance.collection("rollet").add({
        'room_id': room!.id,
        'user_id': user!.id,
        'rollet_id': rollet.id,
      });
    }
  }

}
