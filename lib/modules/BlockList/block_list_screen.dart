import 'package:LikLok/models/AppUser.dart';
import 'package:LikLok/models/Block.dart';
import 'package:LikLok/shared/network/remote/AppUserServices.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../../models/Follower.dart';
import '../../shared/components/Constants.dart';
import '../../shared/styles/colors.dart';
import '../Loading/loadig_screen.dart';

class BlockListScreen extends StatefulWidget {
  const BlockListScreen({super.key});

  @override
  State<BlockListScreen> createState() => _BlockListScreenState();
}

class _BlockListScreenState extends State<BlockListScreen> {
  List<Block>? blocks = [];
  AppUser? user ;
  bool loading = false ;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      user = AppUserServices().userGetter();
      blocks = user!.blocks ;
      print(blocks);
    });
  }

  loadData() async {
    setState(() {
      loading = true ;
    });
    AppUser? res = await AppUserServices().getUser(user!.id);
    setState(() {
      user = res;
      blocks = user!.blocks ;
      AppUserServices().userSetter(user!);
    });
    setState(() {
      loading = false ;
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
        title: Text("setting_blocked_list".tr , style: TextStyle(color: Colors.black),),
      ),
        body: SafeArea(
          child: Container(
            color: MyColors.darkColor,
            width: double.infinity,
            height: double.infinity,
            padding: EdgeInsets.all(10.0),
            child: loading ? Loading() :  Column(
              children: [
                blocks!.length == 0 ? Center(child: Column(
                  children: [
                    Image(image: AssetImage('assets/images/sad.png') , width: 100.0 , height: 100.0,),
                    SizedBox(height: 30.0,),
                    Text('no_data'.tr , style: TextStyle(color: Colors.red , fontSize: 18.0 ) ,)
          
          
                  ],), ) : SizedBox(),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: _refresh,
                    child: ListView.separated(itemBuilder: (ctx , index) =>itemListBuilder(index) ,
                        separatorBuilder: (ctx , index) =>itemSperatorBuilder(), itemCount: blocks!.length),
                  ),
                ),
          
              ],
            ),
          ),
        )
    );
  }
  Widget itemListBuilder(index) => Column(
    children: [
      Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              children: [
                CircleAvatar(
                  backgroundColor: MyColors.unSelectedColor ,
                  radius: 30,
                 child:  Text(blocks![index].blocked_name.toString().toUpperCase().substring(0 , 1) +
                      (blocks![index].blocked_name.toString().contains(" ") ? blocks![index].blocked_name.toString().substring(blocks![index].blocked_name.indexOf(" ")).toUpperCase().substring(1 , 2) : ""),
                    style: const TextStyle(color: Colors.black , fontSize: 24.0 , fontWeight: FontWeight.bold),) ,
                )
              ],
            ),
            const SizedBox(width: 10.0,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(blocks![index].blocked_name , style: TextStyle(color: MyColors.whiteColor , fontSize: 18.0),),


                Text("ID:${blocks![index].blocked_tag}" , style: TextStyle(color: MyColors.unSelectedColor , fontSize: 13.0),),


              ],

            ),
            Expanded(child:
             Column(
               crossAxisAlignment: CrossAxisAlignment.end,
               children: [
                 Container(
                   decoration: BoxDecoration(color: MyColors.whiteColor , borderRadius: BorderRadius.circular(15.0)),
                   child: MaterialButton(onPressed: (){
                     unblockUser(index);
                   } , child: Text('unblock'.tr , style: TextStyle(fontSize: 16.0 , color: Colors.red),)),
                 )
               ],
             )
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
  );

  Widget itemSperatorBuilder() => SizedBox(height: 5.0,);

  unblockUser(index) async{
    AppUser? currentUser = AppUserServices().userGetter();

    AppUser? res = await AppUserServices().unblockUser(currentUser!.id, blocks![index].blocke_user);

   setState(() {
     user = res ;
     blocks = user!.blocks ;
     AppUserServices().userSetter(user!);
   });
    Fluttertoast.showToast(
        msg: 'block_msg_unblocked'.tr,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black26,
        textColor: Colors.orange,
        fontSize: 16.0
    );
  }
}
