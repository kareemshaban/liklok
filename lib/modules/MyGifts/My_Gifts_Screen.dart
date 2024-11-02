import 'package:LikLok/helpers/DesigGiftHelper.dart';
import 'package:LikLok/models/AppUser.dart';
import 'package:LikLok/models/Design.dart';
import 'package:LikLok/shared/components/Constants.dart';
import 'package:LikLok/shared/network/remote/AppUserServices.dart';
import 'package:LikLok/shared/styles/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Loading/loadig_screen.dart';

class MyGiftsScreen extends StatefulWidget {
  const MyGiftsScreen({super.key});

  @override
  State<MyGiftsScreen> createState() => _MyGiftsScreenState();
}

class _MyGiftsScreenState extends State<MyGiftsScreen> {

  AppUser? user ;
  List<Design> gifts = [] ;
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
    DesignGiftHelper helper = await AppUserServices().getMyDesigns(user!.id);

    List<Design> _gifts = [] ;
    Design? design ;
     for(var i = 0 ; i< helper.gifts!.length ; i++){
       if(_gifts.where((element) => element.id ==helper.gifts![i].id ).toList().length == 0){
         design = helper.gifts![i] ;
         design.send_count = 1 ;
         _gifts.add(design);

       } else {
         design =  _gifts.where((element) => element.id ==helper.gifts![i].id ).toList()[0];
         _gifts.remove(design);
         design.send_count = design.send_count! + 1  ;
         _gifts.add(design);

       }
     }
    setState(() {
      gifts =_gifts;
      loading = false ;
    });

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                backgroundImage: user?.img != "" ?  CachedNetworkImageProvider(getUserImage()!) : null,
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
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: MyColors.darkColor,
        padding: EdgeInsets.all(10.0),
        child: loading ? Loading():   Column(
          children: [
            gifts.length == 0  ? Center(child: Column(
              children: [
                Image(image: AssetImage('assets/images/sad.png') , width: 100.0 , height: 100.0,),
                SizedBox(height: 30.0,),
                Text('no_data'.tr , style: TextStyle(color: Colors.red , fontSize: 18.0 ) ,)


              ],), ):    Expanded(
              child: GridView.count(
                scrollDirection: Axis.vertical,
                childAspectRatio: .7,

                crossAxisCount: 3,
                children: gifts.map((gift ) => giftItemBuilder(gift)).toList() ,
              ),
            )

          ],
        ),
      ),
    );
  }


  Widget giftItemBuilder(gift) =>  GestureDetector(
    onTap: (){} ,
    child: Container(
      width: MediaQuery.of(context).size.width / 3 ,
      margin: const EdgeInsets.all(5.0),
      child: Container(
        width: MediaQuery.of(context).size.width / 3 ,

          decoration: BoxDecoration(borderRadius: BorderRadius.circular(25.5), color: Colors.white),
          child: Column(
            children: [
              Image(image: CachedNetworkImageProvider(ASSETSBASEURL + 'Designs/' + gift.icon) , width: 100.0, height: 100.0,),
              Text(gift.name , style: TextStyle(color: MyColors.secondaryColor , fontSize: 15.0),),
              Text("X" + gift.send_count.toString() , style: TextStyle(color: MyColors.primaryColor , fontSize: 15.0),)
            ],
          )
       ),
    ),
  );

  Widget seperatorItem() => SizedBox(width: 10.0,);


  String? getUserImage(){
    if(user!.img.startsWith('https')){
      return user!.img.toString() ;
    } else {
      return '${ASSETSBASEURL}AppUsers/${user?.img}' ;
    }
  }
}
