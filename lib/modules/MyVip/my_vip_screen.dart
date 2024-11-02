import 'package:LikLok/models/AppUser.dart';
import 'package:LikLok/models/Vip.dart';
import 'package:LikLok/modules/Loading/loadig_screen.dart';
import 'package:LikLok/shared/components/Constants.dart';
import 'package:LikLok/shared/network/remote/AppUserServices.dart';
import 'package:LikLok/shared/network/remote/VipServices.dart';
import 'package:LikLok/shared/styles/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyVipScreen extends StatefulWidget {
  const MyVipScreen({super.key});

  @override
  State<MyVipScreen> createState() => _MyVipScreenState();
}

class _MyVipScreenState extends State<MyVipScreen> {
  AppUser? user ;
  List<Vip> vips = [];
  bool loading = false ;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      user = AppUserServices().userGetter();
    });
    getUserVips();
  }
  getUserVips() async {
    setState(() {
      loading = true ;
    });
    List<Vip> res = await VipServices().getUserVips(user!.id);
    setState(() {
      vips = res ;
      loading = false ;
    });
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: MyColors.whiteColor, //change your color here
        ),
        backgroundColor: MyColors.solidDarkColor,
        centerTitle: true,
        title: Text('vip'.tr , style: TextStyle(color: MyColors.whiteColor , fontSize: 18.0),),

      ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          color: MyColors.darkColor,
          child: loading ? Loading():   Column(
            children: [
              vips.length == 0 ? Center(child: Column(
                children: [
                  Image(image: AssetImage('assets/images/sad.png') , width: 100.0 , height: 100.0,),
                  SizedBox(height: 30.0,),
                  Text('no_data'.tr , style: TextStyle(color: Colors.red , fontSize: 18.0 ) ,)


                ],), )
                  :
              Expanded(
                child: GridView.count(
                  scrollDirection: Axis.vertical,
                  childAspectRatio: .7,

                  crossAxisCount: 3,
                  children: vips.map((gift ) => giftItemBuilder(gift)).toList() ,
                ),
              )

            ],
          ),


        )
    );
  }

  Widget giftItemBuilder(gift) =>  GestureDetector(
    onTap: (){} ,
    child: Container(
      width: MediaQuery.of(context).size.width / 3 ,
      margin: const EdgeInsets.all(5.0),
      child: Container(
          width: MediaQuery.of(context).size.width / 3 ,

          decoration: BoxDecoration(borderRadius: BorderRadius.circular(25.5), color: Colors.black12),
          child: Stack(
            alignment: Alignment.topLeft,
            children: [
              Column(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Image(image: CachedNetworkImageProvider(ASSETSBASEURL + 'VIP/' + gift.icon) , width: 100.0, height: 100.0,),
                        Text(gift.name , style: TextStyle(color: Colors.black , fontSize: 15.0),),


                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(  borderRadius: BorderRadius.circular(15.0)),
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: (){
                            useVip(gift!.id);
                          },
                          child: gift.isDefault == 0 ? Container(
                              padding: EdgeInsets.symmetric(horizontal: 15.0 , vertical: 3.0),
                              decoration: BoxDecoration(color: MyColors.primaryColor , borderRadius: BorderRadius.circular(20.0)),
                              child:
                              Text("my_designs_use".tr , style: TextStyle(color:  Colors.white , fontSize: 16.0),)

                          ): Container(),
                        )
                      ],
                    ),
                  ),
                ],
              ),

              Container(
                padding: EdgeInsets.all(5.0),
                decoration: BoxDecoration(color: Colors.black45 , borderRadius: BorderRadius.circular(15.0)),
                child: Text("my_designs_days".tr + getRemainDays(gift) , style: TextStyle(color: MyColors.primaryColor , fontSize: 13.0),),
              )
            ],
          )
      ),
    ),
  );

  Widget seperatorItem() => SizedBox(width: 10.0,);

  String getRemainDays(design){

    final DateTime dateOne = DateTime.parse(design.available_untill);
    final DateTime dateTwo = DateTime.now() ;

    final Duration duration = dateOne.difference(dateTwo);

    return (duration.inDays + 1).toString() ;
  }

  useVip(vip_id) async {
  List<Vip> res =   await VipServices().useDesign(user!.id, vip_id);
  setState(() {
    vips = res ;
  });
  }
}
