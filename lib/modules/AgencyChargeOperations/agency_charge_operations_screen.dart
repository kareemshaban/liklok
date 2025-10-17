import 'package:LikLok/models/AgencyOperations.dart';
import 'package:LikLok/models/AppUser.dart';
import 'package:LikLok/models/ChargingAgency.dart';
import 'package:LikLok/shared/network/remote/AppUserServices.dart';
import 'package:LikLok/shared/network/remote/ChargingAgencyServices.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/ChargingOperation.dart';
import '../../shared/styles/colors.dart';
import '../Loading/loadig_screen.dart';

class AgencyChargeOperations extends StatefulWidget {
  const AgencyChargeOperations({super.key});

  @override
  State<AgencyChargeOperations> createState() => _AgencyChargeOperationsState();
}

class _AgencyChargeOperationsState extends State<AgencyChargeOperations> {

  List<AgencyOperations> operatins = [] ;
  AppUser? agent ;
  ChargingAgency? agency ;
  bool loading = true ;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      agent = AppUserServices().userGetter();
    });
    getAgency();
  }
  getAgency() async{
    ChargingAgency res = await ChargingAgencyServices().getAgency(agent!.id);
    setState(() {
      agency = res ;
    });
   List<AgencyOperations>  res2 = await ChargingAgencyServices().getAgencyChargingOperations(agency!.id);
   setState(() {
     operatins = res2 ;
     loading = false ;
   });

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
          "agency_charge_operation_title".tr,
          style: TextStyle(color: MyColors.whiteColor, fontSize: 20.0),
        ),
      ),
      body: SafeArea(
        child: Container(
          color: MyColors.darkColor,
          width: double.infinity,
          height: double.infinity,
          padding: EdgeInsets.all(15.0),
          child: loading ? Loading() : Column(
            children: [
              Row(
                children: [
                  Text('Current Balance: '  , style: TextStyle(color: MyColors.whiteColor , fontSize: 20.0),),
                  Text( agency!.wallet!.balance.toString() , style: TextStyle(color: MyColors.primaryColor , fontSize: 20.0),),
        
                ],
              ),
              SizedBox(height: 15.0,),
              Expanded(child: ListView.separated(itemBuilder: (context, index) => itemBuilder(index),  separatorBuilder: (context, index) => seperatorBuilder() , itemCount: operatins.length)),
            ],
          ),
        ),
      ),
    );
  }
  Widget itemBuilder  (index) => Container(
    decoration: BoxDecoration(color: Colors.white , borderRadius: BorderRadius.circular(15.0)),
    padding: EdgeInsets.all(10.0),
    child: Row(
      children: [
        Image(image: AssetImage('assets/images/gold_charge.png') , width: 40.0,),
        SizedBox(width:15.0),

        Expanded(
          child: Column(

            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image(image: AssetImage('assets/images/gold.png') , width: 25.0,),
                  Text(operatins[index].gold.toString() , style: TextStyle(color: MyColors.primaryColor , fontSize: 20.0 , fontWeight: FontWeight.bold),)
                ],
              ),
              SizedBox(height: 15.0,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(operatins[index].type , style: TextStyle(color: operatins[index].type == "IN" ? Colors.green : Colors.red , fontSize: 20.0),),
                  SizedBox(width: 15.0,),
                  Text(operatins[index].source , style: TextStyle(color: MyColors.whiteColor , fontSize: 15.0),),
                ],
              ),
              SizedBox(height: 15.0,),
              Text(operatins[index].charging_date , style: TextStyle(color: MyColors.whiteColor , fontSize: 15.0),)

            ],
          ),
        )
      ],
    ),
  );
  Widget seperatorBuilder  () => SizedBox(height: 10.0,);
}
