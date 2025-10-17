import 'package:LikLok/models/AppUser.dart';
import 'package:LikLok/models/Medal.dart';
import 'package:LikLok/shared/network/remote/AppUserServices.dart';
import 'package:LikLok/shared/network/remote/DesignServices.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/Design.dart';
import '../../shared/components/Constants.dart';
import '../../shared/styles/colors.dart';

class MedalsScreen extends StatefulWidget {
  const MedalsScreen({super.key});

  @override
  State<MedalsScreen> createState() => _MedalsScreenState();
}


class _MedalsScreenState extends State<MedalsScreen> {
  @override

  List<Medal> medals = [] ;
  AppUser? user ;
  bool loading = false ;

 @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      user = AppUserServices().userGetter();
      medals = user!.medals! ;
    });
  }

  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: MyColors.whiteColor, //change your color here
        ),
        centerTitle: true,
        backgroundColor: MyColors.solidDarkColor,
        title: Text("Medals".tr , style: TextStyle(color: MyColors.whiteColor,fontSize: 20.0) ,),
      ),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: MyColors.darkColor,
          padding: EdgeInsets.all(10.0),
          child: medals.length == 0 ? Center(child: Column(
            children: [
              Image(image: AssetImage('assets/images/sad.png') , width: 100.0 , height: 100.0,),
              SizedBox(height: 30.0,),
              Text('no_data'.tr , style: TextStyle(color: Colors.red , fontSize: 18.0 ) ,)
        
        
            ],), )
          : Column(
            children: [
              Expanded(
                child: GridView.count(
                  scrollDirection: Axis.vertical,
                  childAspectRatio: 1,
                  crossAxisCount: 2,
                  children: medals.map((gift ) => giftItemBuilder(gift)).toList() ,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget giftItemBuilder(gift) =>  GestureDetector(
    onTap: (){} ,
    child: Container(
      width: MediaQuery.of(context).size.width / 2 ,
      margin: const EdgeInsets.all(5.0),
      child: Container(
          width: MediaQuery.of(context).size.width / 2 ,

          decoration: BoxDecoration(borderRadius: BorderRadius.circular(25.5), color: Colors.black12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(image: CachedNetworkImageProvider(ASSETSBASEURL + 'Badges/' + gift.icon) , width: 100.0, height: 100.0,),
              Text(gift.name , style: TextStyle(color: MyColors.whiteColor , fontSize: 15.0),),
            ],
          )
      ),
    ),
  );

}
