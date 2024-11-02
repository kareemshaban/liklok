import 'package:LikLok/models/ChargingAgency.dart';
import 'package:LikLok/modules/AgencyChargeOperations/agency_charge_operations_screen.dart';
import 'package:LikLok/shared/network/remote/AppUserServices.dart';
import 'package:LikLok/shared/network/remote/ChargingAgencyServices.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../models/AppUser.dart';
import '../../shared/components/Constants.dart';
import '../../shared/styles/colors.dart';

class AgencyCharge extends StatefulWidget {
  const AgencyCharge({super.key});

  @override
  State<AgencyCharge> createState() => _AgencyChargeState();
}

class _AgencyChargeState extends State<AgencyCharge> {

   bool ShowUser = false;
   AppUser? agent ;
   AppUser? user ;
   ChargingAgency? agency ;
   final TextEditingController userTagController = TextEditingController();
   final TextEditingController chargingValueController = TextEditingController();

    @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(mounted){
      setState(() {
        agent = AppUserServices().userGetter();
      });
    }


    getAgency();

  }
  getAgency() async{
    ChargingAgency? res = await ChargingAgencyServices().getAgency(agent!.id);
    if(mounted){
      setState(() {
        agency = res ;
      });
    }

  }
  getTargetUser() async{
      AppUser? res = await AppUserServices().getUserByTag(userTagController.text);
      if(mounted){
        setState(() {
          user = res ;
          ShowUser = true ;
        });
      }

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: MyColors.whiteColor, //change your color here
        ),
        centerTitle: true,
        backgroundColor: MyColors.solidDarkColor,
        title: Text(
          "agency_charge_title".tr,
          style: TextStyle(color: MyColors.whiteColor, fontSize: 20.0),
        ),
        actions: [
          IconButton(icon: Icon(FontAwesomeIcons.circleInfo , color: Colors.black,) , onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (ctx) => AgencyChargeOperations()));
          },
          )
        ],
      ),
      body: Container(
        color: MyColors.darkColor,
        width: double.infinity,
        height: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Row(
                children: [
                  Text('ID',style: TextStyle(fontSize: 25.0 , color: Colors.black),),
                  SizedBox(width: 10.0,),
                  Container(
                    width: 220.0,
                    height: 45.0,
                    child: TextFormField(
                      controller: userTagController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),

                  SizedBox(width: 10.0,),
                  Container(
                    height: 45.0,
                    width: 80,
                    decoration: BoxDecoration(
                      color: MyColors.primaryColor,
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: MaterialButton(onPressed: ()
                    {
                      getTargetUser();
                    } ,
                      child: Text("agency_charge_search".tr , style: TextStyle(color: Colors.black , fontSize: 14.0),),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.0,),
              user != null ? Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('agency_charge_user_data'.tr,style: TextStyle(color: Colors.black , fontSize: 22.0)),
                    ],
                  ),
                  SizedBox(height: 20.0,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          CircleAvatar(
                            backgroundColor: user!.gender == 0 ? MyColors.blueColor : MyColors.pinkColor ,
                            backgroundImage: user?.img != "" ? (user!.img.startsWith('https') ? CachedNetworkImageProvider(user!.img)  :  CachedNetworkImageProvider('${ASSETSBASEURL}AppUsers/${user?.img}'))  :    null,
                            radius: 30,
                            child: user?.img== "" ?
                            Text(user!.name.toUpperCase().substring(0 , 1) +
                                (user!.name.contains(" ") ? user!.name.substring(user!.name.indexOf(" ")).toUpperCase().substring(1 , 2) : ""),
                              style: const TextStyle(color: Colors.white , fontSize: 22.0 , fontWeight: FontWeight.bold),) : null,
                          ),
                        ],
                      ),
                      SizedBox(width: 15.0,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text( user!.name ,style: TextStyle(color: Colors.black , fontSize: 18.0)),
                          Text( 'ID:' + user!.tag ,style: TextStyle(color: Colors.grey , fontSize: 18.0)),
                        ],
                      )
                    ],
                  ),
                  SizedBox(height: 20.0,),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      children: [
                        Text('profile_gold'.tr,style: TextStyle(fontSize: 25.0 , color: Colors.black),),
                        SizedBox(width: 20.0,),
                        Container(
                          width: 100.0,
                          height: 40.0,
                          child: TextFormField(
                            controller: chargingValueController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 30.0,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 60.0,
                        width: 90.0,
                        decoration: BoxDecoration(
                          color: MyColors.primaryColor,
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: MaterialButton(onPressed: (){
                          chargeAction();
                        } ,
                          child: Text("agency_charge_charge".tr , style: TextStyle(color: Colors.black , fontSize: 18.0),),
                        ),
                      )
                    ],
                  ),
                ],
              ) : Container()


            ],
          ),
        ),
      ),
    );
  }
  chargeAction() async {
      await ChargingAgencyServices().addBalanceToUser(agency!.id, user!.id, chargingValueController.text);
  }
}
