import 'package:LikLok/models/AppUser.dart';
import 'package:LikLok/models/Design.dart';
import 'package:LikLok/models/Mall.dart';
import 'package:LikLok/models/Vip.dart';
import 'package:LikLok/modules/Loading/loadig_screen.dart';
import 'package:LikLok/modules/MyVip/my_vip_screen.dart';
import 'package:LikLok/shared/components/Constants.dart';
import 'package:LikLok/shared/network/remote/AppUserServices.dart';
import 'package:LikLok/shared/network/remote/DesignServices.dart';
import 'package:LikLok/shared/network/remote/VipServices.dart';
import 'package:LikLok/shared/styles/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:svgaplayer_flutter/player.dart';

class VipScreen extends StatefulWidget {
  const VipScreen({super.key});

  @override
  State<VipScreen> createState() => _VipScreenState();
}

class _VipScreenState extends State<VipScreen> {
  List<Mall> designs = [] ;
  List<Vip> vips = [] ;
  bool loading = false ;
  AppUser? user ;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      user = AppUserServices().userGetter();
    });
    getVipData();
  }
  getVipData() async{

    setState(() {
      loading = true ;
    });

    List<Vip> res0 = await VipServices().getAllVipTags();
    setState(() {
      vips = res0 ;
    });
    List<Mall> res = await VipServices().getAllVip();
    setState(() {
      designs = res ;
    });

    setState(() {
      loading = false ;
    });

   }
  @override
  Widget build(BuildContext context) {
    return  DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: MyColors.whiteColor, //change your color here
          ),
          backgroundColor: MyColors.solidDarkColor,
          centerTitle: true,
          title: Text('vip'.tr , style: TextStyle(color: MyColors.whiteColor , fontSize: 18.0),),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (ctx) => const MyVipScreen()));
                },
                icon: const Icon(
                  Icons.store,
                  color: Colors.black,
                  size: 30.0,
                ))
          ],

        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          color: MyColors.darkColor,
          child:  designs.length > 0 ? loading ? Loading() : Column(

            children: [
              TabBar(
                dividerColor: Colors.transparent,
                tabAlignment: TabAlignment.center,
                isScrollable: true ,
                indicatorColor: MyColors.primaryColor,
                labelColor: MyColors.primaryColor,
                unselectedLabelColor: MyColors.unSelectedColor,
                labelStyle: const TextStyle(fontSize: 17.0 , fontWeight: FontWeight.w900),
                tabs:  vips.map((e) => Tab(child: Text(e.tag),)).toList()
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    Column(
                      children: [
                        getVipCard(0),
                        Expanded(child:   Transform.translate(
                          offset: Offset(0, -40.0),
                          child: Container(
                            decoration: BoxDecoration(
                                color: MyColors.darkColor,
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(15.0) , topRight: Radius.circular(15.0))),

                            width: double.infinity,
                            child: Column(
                              children: [
                                SizedBox(height: 15.0,),
                                 Text('vip_privileges'.tr , style: TextStyle(color: MyColors.primaryColor , fontSize: 20.0),),
                                SizedBox(height: 15.0,),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(border: Border.all(color: MyColors.primaryColor) , borderRadius: BorderRadius.circular(30.0)),
                                            child: CircleAvatar(
                                              radius: 25.0,
                                              backgroundColor: Colors.transparent,

                                              child: Image(image:AssetImage('assets/images/1.png') , width: 35.0 ,) ,
                                             // child: Image(image: AssetImage('assets/images/logo_blue.png'),),
                                            ),
                                          ),
                                          SizedBox(height: 5.0,),
                                          Text('Vip_package'.tr , style: TextStyle(color: MyColors.primaryColor , fontSize: 11.0),)
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(border: Border.all(color: MyColors.primaryColor) , borderRadius: BorderRadius.circular(30.0)),
                                            child: CircleAvatar(
                                              radius: 25.0,
                                              backgroundColor: Colors.transparent,

                                              child: Image(image:AssetImage('assets/images/2.png') , width: 35.0 ,) ,
                                              // child: Image(image: AssetImage('assets/images/logo_blue.png'),),
                                            ),
                                          ),
                                          SizedBox(height: 5.0,),
                                          Text('car'.tr , style: TextStyle(color: MyColors.primaryColor , fontSize: 11.0),)
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(border: Border.all(color: MyColors.primaryColor) , borderRadius: BorderRadius.circular(30.0)),
                                            child: CircleAvatar(
                                              radius: 25.0,
                                              backgroundColor: Colors.transparent,

                                              child: Image(image:AssetImage('assets/images/3.png') , width: 35.0 ,) ,
                                              // child: Image(image: AssetImage('assets/images/logo_blue.png'),),
                                            ),
                                          ),
                                          SizedBox(height: 5.0,),
                                          Text('medal'.tr , style: TextStyle(color: MyColors.primaryColor , fontSize: 11.0),)
                                        ],
                                      ),
                                    ),

                                  ],
                                ),
                                SizedBox(height: 15.0,),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(border: Border.all(color: MyColors.primaryColor) , borderRadius: BorderRadius.circular(30.0)),
                                            child: CircleAvatar(
                                              radius: 25.0,
                                              backgroundColor: Colors.transparent,

                                              child: Image(image:AssetImage('assets/images/4.png') , width: 35.0 ,) ,
                                              // child: Image(image: AssetImage('assets/images/logo_blue.png'),),
                                            ),

                                          ),
                                          SizedBox(height: 5.0,),
                                          Text('special_msg'.tr , style: TextStyle(color: MyColors.primaryColor , fontSize: 11.0),)
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(border: Border.all(color: MyColors.unSelectedColor) , borderRadius: BorderRadius.circular(30.0)),
                                            child: CircleAvatar(
                                              radius: 25.0,
                                              backgroundColor: Colors.transparent,

                                              child: Image(image:AssetImage('assets/images/6_off.png') , width: 35.0 ,) ,
                                              // child: Image(image: AssetImage('assets/images/logo_blue.png'),),
                                            ),
                                          ),
                                          SizedBox(height: 5.0,),
                                          Text('entering_effect'.tr , style: TextStyle(color: MyColors.unSelectedColor , fontSize: 11.0),)
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(border: Border.all(color: MyColors.unSelectedColor) , borderRadius: BorderRadius.circular(30.0)),
                                            child: CircleAvatar(
                                              radius: 25.0,
                                              backgroundColor: Colors.transparent,

                                              child: Image(image:AssetImage('assets/images/7_off.png') , width: 35.0 ,) ,
                                              // child: Image(image: AssetImage('assets/images/logo_blue.png'),),
                                            ),
                                          ),
                                          SizedBox(height: 5.0,),
                                          Text('login_time'.tr , style: TextStyle(color: MyColors.unSelectedColor , fontSize: 11.0),)

                                        ],
                                      ),
                                    ),

                                  ],
                                ),
                                SizedBox(height: 15.0,),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(border: Border.all(color: MyColors.unSelectedColor) , borderRadius: BorderRadius.circular(30.0)),
                                            child: CircleAvatar(
                                              radius: 25.0,
                                              backgroundColor: Colors.transparent,

                                              child: Image(image:AssetImage('assets/images/8_off.png') , width: 35.0 ,) ,
                                              // child: Image(image: AssetImage('assets/images/logo_blue.png'),),
                                            ),

                                          ),
                                          SizedBox(height: 5.0,),
                                          Text('stop_track'.tr , style: TextStyle(color: MyColors.unSelectedColor , fontSize: 11.0),)
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(border: Border.all(color: MyColors.unSelectedColor) , borderRadius: BorderRadius.circular(30.0)),
                                            child: CircleAvatar(
                                              radius: 25.0,
                                              backgroundColor: Colors.transparent,

                                              child: Image(image:AssetImage('assets/images/9_off.png') , width: 35.0 ,) ,
                                              // child: Image(image: AssetImage('assets/images/logo_blue.png'),),
                                            ),
                                          ),
                                          SizedBox(height: 5.0,),
                                          Text('no_kick'.tr , style: TextStyle(color: MyColors.unSelectedColor , fontSize: 11.0),)
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        children: [


                                        ],
                                      ),
                                    ),

                                  ],
                                ),
                              ],
                            ),
                          ),
                        )),
                        getVipFooter(0),
                      ],
                    ),
                    Column(
                      children: [
                        getVipCard(1),
                        Expanded(child:   Transform.translate(
                          offset: Offset(0, -40.0),
                          child: Container(
                            decoration: BoxDecoration(
                                color: MyColors.darkColor,
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(15.0) , topRight: Radius.circular(15.0))),

                            width: double.infinity,
                            child: Column(
                              children: [
                                SizedBox(height: 15.0,),
                                Text('vip_privileges'.tr , style: TextStyle(color: MyColors.primaryColor , fontSize: 20.0),),
                                SizedBox(height: 15.0,),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(border: Border.all(color: MyColors.primaryColor) , borderRadius: BorderRadius.circular(30.0)),
                                            child: CircleAvatar(
                                              radius: 25.0,
                                              backgroundColor: Colors.transparent,

                                              child: Image(image:AssetImage('assets/images/1.png') , width: 35.0 ,) ,
                                              // child: Image(image: AssetImage('assets/images/logo_blue.png'),),
                                            ),
                                          ),
                                          SizedBox(height: 5.0,),
                                          Text('Vip_package'.tr , style: TextStyle(color: MyColors.primaryColor , fontSize: 11.0),)
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(border: Border.all(color: MyColors.primaryColor) , borderRadius: BorderRadius.circular(30.0)),
                                            child: CircleAvatar(
                                              radius: 25.0,
                                              backgroundColor: Colors.transparent,

                                              child: Image(image:AssetImage('assets/images/2.png') , width: 35.0 ,) ,
                                              // child: Image(image: AssetImage('assets/images/logo_blue.png'),),
                                            ),
                                          ),
                                          SizedBox(height: 5.0,),
                                          Text('car'.tr , style: TextStyle(color: MyColors.primaryColor , fontSize: 11.0),)
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(border: Border.all(color: MyColors.primaryColor) , borderRadius: BorderRadius.circular(30.0)),
                                            child: CircleAvatar(
                                              radius: 25.0,
                                              backgroundColor: Colors.transparent,

                                              child: Image(image:AssetImage('assets/images/3.png') , width: 35.0 ,) ,
                                              // child: Image(image: AssetImage('assets/images/logo_blue.png'),),
                                            ),
                                          ),
                                          SizedBox(height: 5.0,),
                                          Text('medal'.tr , style: TextStyle(color: MyColors.primaryColor , fontSize: 11.0),)
                                        ],
                                      ),
                                    ),

                                  ],
                                ),
                                SizedBox(height: 15.0,),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(border: Border.all(color: MyColors.primaryColor) , borderRadius: BorderRadius.circular(30.0)),
                                            child: CircleAvatar(
                                              radius: 25.0,
                                              backgroundColor: Colors.transparent,

                                              child: Image(image:AssetImage('assets/images/4.png') , width: 35.0 ,) ,
                                              // child: Image(image: AssetImage('assets/images/logo_blue.png'),),
                                            ),

                                          ),
                                          SizedBox(height: 5.0,),
                                          Text('special_msg'.tr , style: TextStyle(color: MyColors.primaryColor , fontSize: 11.0),)
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(border: Border.all(color: MyColors.primaryColor) , borderRadius: BorderRadius.circular(30.0)),
                                            child: CircleAvatar(
                                              radius: 25.0,
                                              backgroundColor: Colors.transparent,

                                              child: Image(image:AssetImage('assets/images/6.png') , width: 35.0 ,) ,
                                              // child: Image(image: AssetImage('assets/images/logo_blue.png'),),
                                            ),
                                          ),
                                          SizedBox(height: 5.0,),
                                          Text('entering_effect'.tr , style: TextStyle(color: MyColors.primaryColor , fontSize: 11.0),)
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(border: Border.all(color: MyColors.unSelectedColor) , borderRadius: BorderRadius.circular(30.0)),
                                            child: CircleAvatar(
                                              radius: 25.0,
                                              backgroundColor: Colors.transparent,

                                              child: Image(image:AssetImage('assets/images/7_off.png') , width: 35.0 ,) ,
                                              // child: Image(image: AssetImage('assets/images/logo_blue.png'),),
                                            ),
                                          ),
                                          SizedBox(height: 5.0,),
                                          Text('login_time'.tr , style: TextStyle(color: MyColors.unSelectedColor , fontSize: 11.0),)

                                        ],
                                      ),
                                    ),

                                  ],
                                ),
                                SizedBox(height: 15.0,),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(border: Border.all(color: MyColors.unSelectedColor) , borderRadius: BorderRadius.circular(30.0)),
                                            child: CircleAvatar(
                                              radius: 25.0,
                                              backgroundColor: Colors.transparent,

                                              child: Image(image:AssetImage('assets/images/8_off.png') , width: 35.0 ,) ,
                                              // child: Image(image: AssetImage('assets/images/logo_blue.png'),),
                                            ),

                                          ),
                                          SizedBox(height: 5.0,),
                                          Text('stop_track'.tr , style: TextStyle(color: MyColors.unSelectedColor , fontSize: 11.0),)
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(border: Border.all(color: MyColors.unSelectedColor) , borderRadius: BorderRadius.circular(30.0)),
                                            child: CircleAvatar(
                                              radius: 25.0,
                                              backgroundColor: Colors.transparent,

                                              child: Image(image:AssetImage('assets/images/9_off.png') , width: 35.0 ,) ,
                                              // child: Image(image: AssetImage('assets/images/logo_blue.png'),),
                                            ),
                                          ),
                                          SizedBox(height: 5.0,),
                                          Text('no_kick'.tr , style: TextStyle(color: MyColors.unSelectedColor , fontSize: 11.0),)
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        children: [


                                        ],
                                      ),
                                    ),

                                  ],
                                ),
                              ],
                            ),
                          ),
                        )),
                        getVipFooter(1),
                      ],
                    ),
                    Column(
                      children: [
                        getVipCard(2),
                        Expanded(child:   Transform.translate(
                          offset: Offset(0, -40.0),
                          child: Container(
                            decoration: BoxDecoration(
                                color: MyColors.darkColor,
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(15.0) , topRight: Radius.circular(15.0))),

                            width: double.infinity,
                            child: Column(
                              children: [
                                SizedBox(height: 15.0,),
                                Text('vip_privileges'.tr , style: TextStyle(color: MyColors.primaryColor , fontSize: 20.0),),
                                SizedBox(height: 15.0,),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(border: Border.all(color: MyColors.primaryColor) , borderRadius: BorderRadius.circular(30.0)),
                                            child: CircleAvatar(
                                              radius: 25.0,
                                              backgroundColor: Colors.transparent,

                                              child: Image(image:AssetImage('assets/images/1.png') , width: 35.0 ,) ,
                                              // child: Image(image: AssetImage('assets/images/logo_blue.png'),),
                                            ),
                                          ),
                                          SizedBox(height: 5.0,),
                                          Text('Vip_package'.tr , style: TextStyle(color: MyColors.primaryColor , fontSize: 11.0),)
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(border: Border.all(color: MyColors.primaryColor) , borderRadius: BorderRadius.circular(30.0)),
                                            child: CircleAvatar(
                                              radius: 25.0,
                                              backgroundColor: Colors.transparent,

                                              child: Image(image:AssetImage('assets/images/2.png') , width: 35.0 ,) ,
                                              // child: Image(image: AssetImage('assets/images/logo_blue.png'),),
                                            ),
                                          ),
                                          SizedBox(height: 5.0,),
                                          Text('car'.tr , style: TextStyle(color: MyColors.primaryColor , fontSize: 11.0),)
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(border: Border.all(color: MyColors.primaryColor) , borderRadius: BorderRadius.circular(30.0)),
                                            child: CircleAvatar(
                                              radius: 25.0,
                                              backgroundColor: Colors.transparent,

                                              child: Image(image:AssetImage('assets/images/3.png') , width: 35.0 ,) ,
                                              // child: Image(image: AssetImage('assets/images/logo_blue.png'),),
                                            ),
                                          ),
                                          SizedBox(height: 5.0,),
                                          Text('medal'.tr , style: TextStyle(color: MyColors.primaryColor , fontSize: 11.0),)
                                        ],
                                      ),
                                    ),

                                  ],
                                ),
                                SizedBox(height: 15.0,),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(border: Border.all(color: MyColors.primaryColor) , borderRadius: BorderRadius.circular(30.0)),
                                            child: CircleAvatar(
                                              radius: 25.0,
                                              backgroundColor: Colors.transparent,

                                              child: Image(image:AssetImage('assets/images/4.png') , width: 35.0 ,) ,
                                              // child: Image(image: AssetImage('assets/images/logo_blue.png'),),
                                            ),

                                          ),
                                          SizedBox(height: 5.0,),
                                          Text('special_msg'.tr , style: TextStyle(color: MyColors.primaryColor , fontSize: 11.0),)
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(border: Border.all(color: MyColors.primaryColor) , borderRadius: BorderRadius.circular(30.0)),
                                            child: CircleAvatar(
                                              radius: 25.0,
                                              backgroundColor: Colors.transparent,

                                              child: Image(image:AssetImage('assets/images/6.png') , width: 35.0 ,) ,
                                              // child: Image(image: AssetImage('assets/images/logo_blue.png'),),
                                            ),
                                          ),
                                          SizedBox(height: 5.0,),
                                          Text('entering_effect'.tr , style: TextStyle(color: MyColors.primaryColor , fontSize: 11.0),)
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(border: Border.all(color: MyColors.primaryColor) , borderRadius: BorderRadius.circular(30.0)),
                                            child: CircleAvatar(
                                              radius: 25.0,
                                              backgroundColor: Colors.transparent,

                                              child: Image(image:AssetImage('assets/images/7.png') , width: 35.0 ,) ,
                                              // child: Image(image: AssetImage('assets/images/logo_blue.png'),),
                                            ),
                                          ),
                                          SizedBox(height: 5.0,),
                                          Text('login_time'.tr , style: TextStyle(color: MyColors.primaryColor , fontSize: 11.0),)

                                        ],
                                      ),
                                    ),

                                  ],
                                ),
                                SizedBox(height: 15.0,),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(border: Border.all(color: MyColors.unSelectedColor) , borderRadius: BorderRadius.circular(30.0)),
                                            child: CircleAvatar(
                                              radius: 25.0,
                                              backgroundColor: Colors.transparent,

                                              child: Image(image:AssetImage('assets/images/8_off.png') , width: 35.0 ,) ,
                                              // child: Image(image: AssetImage('assets/images/logo_blue.png'),),
                                            ),

                                          ),
                                          SizedBox(height: 5.0,),
                                          Text('stop_track'.tr , style: TextStyle(color: MyColors.unSelectedColor , fontSize: 11.0),)
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(border: Border.all(color: MyColors.unSelectedColor) , borderRadius: BorderRadius.circular(30.0)),
                                            child: CircleAvatar(
                                              radius: 25.0,
                                              backgroundColor: Colors.transparent,

                                              child: Image(image:AssetImage('assets/images/9_off.png') , width: 35.0 ,) ,
                                              // child: Image(image: AssetImage('assets/images/logo_blue.png'),),
                                            ),
                                          ),
                                          SizedBox(height: 5.0,),
                                          Text('no_kick'.tr , style: TextStyle(color: MyColors.unSelectedColor , fontSize: 11.0),)
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        children: [


                                        ],
                                      ),
                                    ),

                                  ],
                                ),
                              ],
                            ),
                          ),
                        )),
                        getVipFooter(2),
                      ],
                    ),
                    Column(
                      children: [
                        getVipCard(3),
                        Expanded(child:   Transform.translate(
                          offset: Offset(0, -40.0),
                          child: Container(
                            decoration: BoxDecoration(
                                color: MyColors.darkColor,
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(15.0) , topRight: Radius.circular(15.0))),

                            width: double.infinity,
                            child: Column(
                              children: [
                                SizedBox(height: 15.0,),
                                Text('vip_privileges'.tr , style: TextStyle(color: MyColors.primaryColor , fontSize: 20.0),),
                                SizedBox(height: 15.0,),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(border: Border.all(color: MyColors.primaryColor) , borderRadius: BorderRadius.circular(30.0)),
                                            child: CircleAvatar(
                                              radius: 25.0,
                                              backgroundColor: Colors.transparent,

                                              child: Image(image:AssetImage('assets/images/1.png') , width: 35.0 ,) ,
                                              // child: Image(image: AssetImage('assets/images/logo_blue.png'),),
                                            ),
                                          ),
                                          SizedBox(height: 5.0,),
                                          Text('Vip_package'.tr , style: TextStyle(color: MyColors.primaryColor , fontSize: 11.0),)
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(border: Border.all(color: MyColors.primaryColor) , borderRadius: BorderRadius.circular(30.0)),
                                            child: CircleAvatar(
                                              radius: 25.0,
                                              backgroundColor: Colors.transparent,

                                              child: Image(image:AssetImage('assets/images/2.png') , width: 35.0 ,) ,
                                              // child: Image(image: AssetImage('assets/images/logo_blue.png'),),
                                            ),
                                          ),
                                          SizedBox(height: 5.0,),
                                          Text('car'.tr , style: TextStyle(color: MyColors.primaryColor , fontSize: 11.0),)
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(border: Border.all(color: MyColors.primaryColor) , borderRadius: BorderRadius.circular(30.0)),
                                            child: CircleAvatar(
                                              radius: 25.0,
                                              backgroundColor: Colors.transparent,

                                              child: Image(image:AssetImage('assets/images/3.png') , width: 35.0 ,) ,
                                              // child: Image(image: AssetImage('assets/images/logo_blue.png'),),
                                            ),
                                          ),
                                          SizedBox(height: 5.0,),
                                          Text('medal'.tr , style: TextStyle(color: MyColors.primaryColor , fontSize: 11.0),)
                                        ],
                                      ),
                                    ),

                                  ],
                                ),
                                SizedBox(height: 15.0,),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(border: Border.all(color: MyColors.primaryColor) , borderRadius: BorderRadius.circular(30.0)),
                                            child: CircleAvatar(
                                              radius: 25.0,
                                              backgroundColor: Colors.transparent,

                                              child: Image(image:AssetImage('assets/images/4.png') , width: 35.0 ,) ,
                                              // child: Image(image: AssetImage('assets/images/logo_blue.png'),),
                                            ),

                                          ),
                                          SizedBox(height: 5.0,),
                                          Text('special_msg'.tr , style: TextStyle(color: MyColors.primaryColor , fontSize: 11.0),)
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(border: Border.all(color: MyColors.primaryColor) , borderRadius: BorderRadius.circular(30.0)),
                                            child: CircleAvatar(
                                              radius: 25.0,
                                              backgroundColor: Colors.transparent,

                                              child: Image(image:AssetImage('assets/images/6.png') , width: 35.0 ,) ,
                                              // child: Image(image: AssetImage('assets/images/logo_blue.png'),),
                                            ),
                                          ),
                                          SizedBox(height: 5.0,),
                                          Text('entering_effect'.tr , style: TextStyle(color: MyColors.primaryColor , fontSize: 11.0),)
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(border: Border.all(color: MyColors.primaryColor) , borderRadius: BorderRadius.circular(30.0)),
                                            child: CircleAvatar(
                                              radius: 25.0,
                                              backgroundColor: Colors.transparent,

                                              child: Image(image:AssetImage('assets/images/7.png') , width: 35.0 ,) ,
                                              // child: Image(image: AssetImage('assets/images/logo_blue.png'),),
                                            ),
                                          ),
                                          SizedBox(height: 5.0,),
                                          Text('login_time'.tr , style: TextStyle(color: MyColors.primaryColor , fontSize: 11.0),)

                                        ],
                                      ),
                                    ),

                                  ],
                                ),
                                SizedBox(height: 15.0,),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(border: Border.all(color: MyColors.primaryColor) , borderRadius: BorderRadius.circular(30.0)),
                                            child: CircleAvatar(
                                              radius: 25.0,
                                              backgroundColor: Colors.transparent,

                                              child: Image(image:AssetImage('assets/images/8.png') , width: 35.0 ,) ,
                                              // child: Image(image: AssetImage('assets/images/logo_blue.png'),),
                                            ),

                                          ),
                                          SizedBox(height: 5.0,),
                                          Text('stop_track'.tr , style: TextStyle(color: MyColors.primaryColor , fontSize: 11.0),)
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(border: Border.all(color: MyColors.unSelectedColor) , borderRadius: BorderRadius.circular(30.0)),
                                            child: CircleAvatar(
                                              radius: 25.0,
                                              backgroundColor: Colors.transparent,

                                              child: Image(image:AssetImage('assets/images/9_off.png') , width: 35.0 ,) ,
                                              // child: Image(image: AssetImage('assets/images/logo_blue.png'),),
                                            ),
                                          ),
                                          SizedBox(height: 5.0,),
                                          Text('no_kick'.tr , style: TextStyle(color: MyColors.unSelectedColor , fontSize: 11.0),)
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        children: [


                                        ],
                                      ),
                                    ),

                                  ],
                                ),
                              ],
                            ),
                          ),
                        )),
                        getVipFooter(3),
                      ],
                    ),
                    Column(
                      children: [
                        getVipCard(4),
                        Expanded(child:   Transform.translate(
                          offset: Offset(0, -40.0),
                          child: Container(
                            decoration: BoxDecoration(
                                color: MyColors.darkColor,
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(15.0) , topRight: Radius.circular(15.0))),

                            width: double.infinity,
                            child: Column(
                              children: [
                                SizedBox(height: 15.0,),
                                Text('vip_privileges'.tr , style: TextStyle(color: MyColors.primaryColor , fontSize: 20.0),),
                                SizedBox(height: 15.0,),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(border: Border.all(color: MyColors.primaryColor) , borderRadius: BorderRadius.circular(30.0)),
                                            child: CircleAvatar(
                                              radius: 25.0,
                                              backgroundColor: Colors.transparent,

                                              child: Image(image:AssetImage('assets/images/1.png') , width: 35.0 ,) ,
                                              // child: Image(image: AssetImage('assets/images/logo_blue.png'),),
                                            ),
                                          ),
                                          SizedBox(height: 5.0,),
                                          Text('Vip_package'.tr , style: TextStyle(color: MyColors.primaryColor , fontSize: 11.0),)
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(border: Border.all(color: MyColors.primaryColor) , borderRadius: BorderRadius.circular(30.0)),
                                            child: CircleAvatar(
                                              radius: 25.0,
                                              backgroundColor: Colors.transparent,

                                              child: Image(image:AssetImage('assets/images/2.png') , width: 35.0 ,) ,
                                              // child: Image(image: AssetImage('assets/images/logo_blue.png'),),
                                            ),
                                          ),
                                          SizedBox(height: 5.0,),
                                          Text('car'.tr , style: TextStyle(color: MyColors.primaryColor , fontSize: 11.0),)
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(border: Border.all(color: MyColors.primaryColor) , borderRadius: BorderRadius.circular(30.0)),
                                            child: CircleAvatar(
                                              radius: 25.0,
                                              backgroundColor: Colors.transparent,

                                              child: Image(image:AssetImage('assets/images/3.png') , width: 35.0 ,) ,
                                              // child: Image(image: AssetImage('assets/images/logo_blue.png'),),
                                            ),
                                          ),
                                          SizedBox(height: 5.0,),
                                          Text('medal'.tr , style: TextStyle(color: MyColors.primaryColor , fontSize: 11.0),)
                                        ],
                                      ),
                                    ),

                                  ],
                                ),
                                SizedBox(height: 15.0,),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(border: Border.all(color: MyColors.primaryColor) , borderRadius: BorderRadius.circular(30.0)),
                                            child: CircleAvatar(
                                              radius: 25.0,
                                              backgroundColor: Colors.transparent,

                                              child: Image(image:AssetImage('assets/images/4.png') , width: 35.0 ,) ,
                                              // child: Image(image: AssetImage('assets/images/logo_blue.png'),),
                                            ),

                                          ),
                                          SizedBox(height: 5.0,),
                                          Text('special_msg'.tr , style: TextStyle(color: MyColors.primaryColor , fontSize: 11.0),)
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(border: Border.all(color: MyColors.primaryColor) , borderRadius: BorderRadius.circular(30.0)),
                                            child: CircleAvatar(
                                              radius: 25.0,
                                              backgroundColor: Colors.transparent,

                                              child: Image(image:AssetImage('assets/images/6.png') , width: 35.0 ,) ,
                                              // child: Image(image: AssetImage('assets/images/logo_blue.png'),),
                                            ),
                                          ),
                                          SizedBox(height: 5.0,),
                                          Text('entering_effect'.tr , style: TextStyle(color: MyColors.primaryColor , fontSize: 11.0),)
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(border: Border.all(color: MyColors.primaryColor) , borderRadius: BorderRadius.circular(30.0)),
                                            child: CircleAvatar(
                                              radius: 25.0,
                                              backgroundColor: Colors.transparent,

                                              child: Image(image:AssetImage('assets/images/7.png') , width: 35.0 ,) ,
                                              // child: Image(image: AssetImage('assets/images/logo_blue.png'),),
                                            ),
                                          ),
                                          SizedBox(height: 5.0,),
                                          Text('login_time'.tr , style: TextStyle(color: MyColors.primaryColor , fontSize: 11.0),)

                                        ],
                                      ),
                                    ),

                                  ],
                                ),
                                SizedBox(height: 15.0,),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(border: Border.all(color: MyColors.primaryColor) , borderRadius: BorderRadius.circular(30.0)),
                                            child: CircleAvatar(
                                              radius: 25.0,
                                              backgroundColor: Colors.transparent,

                                              child: Image(image:AssetImage('assets/images/8.png') , width: 35.0 ,) ,
                                              // child: Image(image: AssetImage('assets/images/logo_blue.png'),),
                                            ),

                                          ),
                                          SizedBox(height: 5.0,),
                                          Text('stop_track'.tr , style: TextStyle(color: MyColors.primaryColor , fontSize: 11.0),)
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(border: Border.all(color: MyColors.primaryColor) , borderRadius: BorderRadius.circular(30.0)),
                                            child: CircleAvatar(
                                              radius: 25.0,
                                              backgroundColor: Colors.transparent,

                                              child: Image(image:AssetImage('assets/images/9.png') , width: 35.0 ,) ,
                                              // child: Image(image: AssetImage('assets/images/logo_blue.png'),),
                                            ),
                                          ),
                                          SizedBox(height: 5.0,),
                                          Text('no_kick'.tr , style: TextStyle(color: MyColors.primaryColor , fontSize: 11.0),)
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        children: [


                                        ],
                                      ),
                                    ),

                                  ],
                                ),
                              ],
                            ),
                          ),
                        )),
                        getVipFooter(4),
                      ],
                    ),

                  ],
                ),
              )
            ],
          ) : Loading(),
        ),
      ),
    );
  }

  Widget getVipCard(index) {
     List<Mall> vipDesigns = designs.where((element) => element.vip_id == vips[index].id).toList();
     final bg = vipDesigns.where((element) => element.category_id == 9).toList()[0].icon;
     final profile_frame =  vipDesigns.where((element) => element.category_id == 8).toList()[0].icon;
     final vip_ch =  vipDesigns.where((element) => element.category_id == 10).toList()[0].motion_icon;

    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Transform.translate(
          offset: Offset(0 , 45),
          child: Container(
            height: MediaQuery.sizeOf(context).height * .25,
            decoration: BoxDecoration(
                image: DecorationImage(image: CachedNetworkImageProvider(ASSETSBASEURL + 'Designs/' + bg) , fit: BoxFit.cover)
            ),

          ),
        ),
        Column(
          children: [
            Transform.translate(
              offset: Offset(0 , 80),
              child: Column(
                children: [
                  // CircleAvatar(
                  //   backgroundColor: user!.gender == 0 ? MyColors.blueColor : MyColors.pinkColor ,
                  //   backgroundImage: user?.img != "" ? (user!.img.startsWith('https') ? CachedNetworkImageProvider(user!.img)  :  CachedNetworkImageProvider('${ASSETSBASEURL}AppUsers/${user?.img}'))  :    null,
                  //   radius: 25,
                  //   child: user?.img== "" ?
                  //   Text(user!.name.toUpperCase().substring(0 , 1) +
                  //       (user!.name.contains(" ") ? user!.name.substring(user!.name.indexOf(" ")).toUpperCase().substring(1 , 2) : ""),
                  //     style: const TextStyle(color: Colors.white , fontSize: 22.0 , fontWeight: FontWeight.bold),) : null,
                  // ),
                  Container( height: 100.0 , width: 100.0, child: SVGASimpleImage(  resUrl: ASSETSBASEURL + 'Designs/Motion/' + vip_ch +'?raw=true'   ))

                ],
              ),
            ),

            Transform.translate(
                offset: Offset(0 , -110),
                child: Image(image: CachedNetworkImageProvider(ASSETSBASEURL + 'Designs/' + profile_frame)))
          ],
        )
      ],
    );
  }
  Widget getVipFooter(index) => Container(
    height: 50.0,
    color: MyColors.solidDarkColor,
    padding: EdgeInsets.symmetric(horizontal: 15.0 , vertical: 5.0),
    child: Column(

      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(vips[index].price , style: TextStyle(color: MyColors.primaryColor , fontSize: 18.0 , fontWeight: FontWeight.bold),),
            SizedBox(width: 5.0,),
            Image(image: AssetImage('assets/images/gold.png') , width: 25.0,),
            SizedBox(width: 15.0,),
            Text('/ Month' , style: TextStyle(color: MyColors.whiteColor , fontSize: 16.0 , fontWeight: FontWeight.bold),),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap:(){
                      purchaseVip(vips[index].id);
                   },
                    child: Container(
                      width: 80.0,
                      height: 40.0,
                      decoration: BoxDecoration(color: MyColors.primaryColor , borderRadius: BorderRadius.circular(15.0)),
                      child: Center(child: Text('mall_purchase'.tr)),

                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ],
    ),

  );

  purchaseVip(vip) async{
    await DesignServices().purchaseVip(user!.id , vip);
  }


}
