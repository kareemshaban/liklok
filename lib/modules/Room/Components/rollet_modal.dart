import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:LikLok/models/AppUser.dart';
import 'package:LikLok/models/ChatRoom.dart';
import 'package:LikLok/models/Rollet.dart';
import 'package:LikLok/models/RolletMember.dart';
import 'package:LikLok/shared/components/Constants.dart';
import 'package:LikLok/shared/network/remote/AppUserServices.dart';
import 'package:LikLok/shared/network/remote/ChatRoomService.dart';
import 'package:LikLok/shared/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:roulette/roulette.dart';

class RolletModal extends StatefulWidget {
  final Rollet rollet ;
  const RolletModal({super.key , required this.rollet});

  @override
  State<RolletModal> createState() => _RolletModalState();
}

class _RolletModalState extends State<RolletModal> with TickerProviderStateMixin {

  late RouletteController rouletteController ;
  List<RolletMember> roulletMembers = [];
  AppUser? user ;
  ChatRoom? room ;
  Rollet? mrollet ;
  late RouletteGroup group ;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    user =  AppUserServices().userGetter() ;
    room = ChatRoomService().roomGetter() ;
    setState(() {
      mrollet = widget.rollet ;
      roulletMembers = mrollet!.members! ;
      group = RouletteGroup.uniformImages(roulletMembers.length , imageBuilder: (index) => RoulletItemBuilder(index),
        textBuilder:(index) =>  roulletMembers[index].user_name,
        styleBuilder: (index) => TextStyle(fontSize: 15.0 ) ,

      );

    });
 //   rouletteController = RouletteController(group: group , vsync: this);
    RolletChangeListner();
    RolletSpinListner();
    RolletJoinListner();
  }

  RolletChangeListner() async{
    CollectionReference reference = FirebaseFirestore.instance.collection('roulette-change');
    reference.snapshots().listen((querySnapshot) async {
      DocumentChange change =   querySnapshot.docChanges[0] ;
      if(change.newIndex > 0){
        Map<String , dynamic>? data = change.doc.data() as Map<String,dynamic>;
        int rollet_id = data['rollet_id'] ;
        if(rollet_id == mrollet!.id){
          Rollet? res0 = await ChatRoomService().getRollet(mrollet!.id);
          setState(() {
            mrollet = res0 ;
          });
          print('RolletChangeListner');
          spin();

        }
      }
    });
  }
  RolletJoinListner() async{
    CollectionReference reference = FirebaseFirestore.instance.collection('roulette-join');
    reference.snapshots().listen((querySnapshot) async {
      DocumentChange change =   querySnapshot.docChanges[0] ;
      if(change.newIndex > 0){
        Map<String , dynamic>? data = change.doc.data() as Map<String,dynamic>;
        int rollet_id = data['rollet_id'] ;
        if(rollet_id == mrollet!.id){
          Rollet? res0 = await ChatRoomService().getRollet(mrollet!.id);

          setState(() {
            mrollet = res0 ;
            roulletMembers = mrollet!.members! ;
         //   rouletteController =  RouletteController(group: RouletteGroup.uniform(0) , vsync: this);
         //    rouletteController = RouletteController(group: RouletteGroup.uniformImages(roulletMembers.length , imageBuilder: (index) => RoulletItemBuilder(index),
         //      textBuilder:(index) =>  roulletMembers[index].user_name,
         //      styleBuilder: (index) => TextStyle(fontSize: 15.0 ) ,
         //
         //    ), vsync: this);
          });


        }
      }
    });
  }


  RolletSpinListner() async{
    CollectionReference reference = FirebaseFirestore.instance.collection('roulette-spin');
    reference.snapshots().listen((querySnapshot) async {
      DocumentChange change =   querySnapshot.docChanges[0] ;
      if(change.newIndex > 0){
        Map<String , dynamic>? data = change.doc.data() as Map<String,dynamic>;
        int rollet_id = data['rollet_id'] ;
        int rand = data['rand'] ;
        print('roulette-spin');
        if(rollet_id == mrollet!.id){
          await rouletteController.rollTo(rand );
          Rollet? res0 = await ChatRoomService().getRollet(mrollet!.id);
          setState(() {
            mrollet = res0 ;
            roulletMembers = mrollet!.members! ;
        //    rouletteController =  RouletteController(group: RouletteGroup.uniform(0) , vsync: this);
        //     rouletteController = RouletteController(group: RouletteGroup.uniformImages(roulletMembers.length , imageBuilder: (index) => RoulletItemBuilder(index),
        //       textBuilder:(index) =>  roulletMembers[index].user_name,
        //       styleBuilder: (index) => TextStyle(fontSize: 15.0 ) ,
        //
        //     ), vsync: this);
          });
          print(roulletMembers);
          if(roulletMembers.length > 1){
            spin();
          } else {


          }
        }
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return  SafeArea(
      child: Container(
        height: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 50.0 , horizontal: 10.0),
        color: Colors.black.withAlpha(150),
        child: Center(
          child: Container(
            height: MediaQuery.sizeOf(context).height * .5,
            width: MediaQuery.sizeOf(context).width * .9,
            padding: EdgeInsets.all(5.0),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(15.0) , image: DecorationImage(image: AssetImage('assets/images/rollet_bg.png') , fit:BoxFit.cover)),
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(onPressed: (){
                      Navigator.pop(context);
                    }, icon: Icon(FontAwesomeIcons.minus , size: 25.0, color: Colors.white,) , color: Colors.white , ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.all(10.0),
                  height: MediaQuery.sizeOf(context).height * .35,
                  width: MediaQuery.sizeOf(context).height * .35,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.all(10.0),
                        // child: Roulette(
                        //   controller: rouletteController,
                        //   style: RouletteStyle(
                        //     // Customize appearance
                        //   ),
                        // ),
                      ),
                      Image(image: AssetImage('assets/images/rollet_frame.png')),

                     mrollet!.state == 0 ?
                      user!.id == room!.userId ? GestureDetector(
                        onTap: () => {
                          StartRollet()
                        },
                        child: Container(
                          width: 80,
                          height: 80,
                          child: Center(child: Text('rollet_start'.tr   , style: TextStyle(color: Colors.white , fontSize: 20.0),)),
                          decoration: BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/start_btn.png'))),
                        ),
                      ) :
                     mrollet!.members!.where((element) => element.User_id == user!.id).length == 0 ? GestureDetector(
                        onTap: () => {
                          joinRollet()
                        },
                        child: Container(
                          width: 80,
                          height: 80,
                          child: Center(child: Text(  'rollet_join'.tr   , style: TextStyle(color: Colors.white , fontSize: 20.0),)),
                          decoration: BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/start_btn.png'))),
                        ),
                      ) : SizedBox()

                         : SizedBox()

                    ],
                  ),
                ),
                Column(
                  children: [
                    Text('rollet_hint_text'.tr , style: TextStyle(color: MyColors.unSelectedColor , fontSize: 11.0 ) , textAlign: TextAlign.center ,),
                  ],
                )

              ],
            ),
          ),
        ) ,
      ),
    );
  }

  ImageProvider RoulletItemBuilder(i) => mrollet!.members![i].user_img != "" ? CachedNetworkImageProvider(ASSETSBASEURL + 'AppUsers/' +  mrollet!.members![i].user_img) : CachedNetworkImageProvider('');

  StartRollet() async{
    Rollet? res0 = await ChatRoomService().startRollet(mrollet!.id);
    await FirebaseFirestore.instance.collection("roulette-change").add({
      'room_id': room!.id,
      'rollet_id': mrollet!.id
    });



  }
  joinRollet() async {
   Rollet? res = await ChatRoomService().addUserToRollet(mrollet!.id , user!.id);
   await FirebaseFirestore.instance.collection("roulette-join").add({
     'room_id': room!.id,
     'rollet_id': mrollet!.id
   });



  }
  Widget roomRolletModal(Rollet rollet) => RolletModal(rollet: rollet,);

  spin() async {
    var rng = Random();
    int rand = rng.nextInt(mrollet!.members!.length);
    Rollet? res = await ChatRoomService().RolletLoser(mrollet!.id , mrollet!.members![rand].rollet_user_id);
    setState(() {
      mrollet = res ;
      roulletMembers = mrollet!.members! ;
    });
    print('spinspinspin');


    await FirebaseFirestore.instance.collection("roulette-spin").add({
      'room_id': room!.id,
      'rollet_id': mrollet!.id,
      'rand': rand
    });

   // await rouletteController.rollTo(rand );
  }
}
