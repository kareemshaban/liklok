import 'package:LikLok/models/AppUser.dart';
import 'package:LikLok/models/ChargingOperation.dart';
import 'package:LikLok/shared/network/remote/AppUserServices.dart';
import 'package:LikLok/shared/network/remote/WalletServices.dart';
import 'package:LikLok/shared/styles/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Loading/loadig_screen.dart';

class ChargingOperationScreen extends StatefulWidget {
  const ChargingOperationScreen({super.key});

  @override
  State<ChargingOperationScreen> createState() => _ChargingOperationScreenState();
}

class _ChargingOperationScreenState extends State<ChargingOperationScreen> {
  List<ChargingOperation> operatins = [] ;
  AppUser? user ;
  bool loading = false ;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      user = AppUserServices().userGetter();
    });
    getMyOperations();
  }
  getMyOperations() async{
    setState(() {
      loading = true ;
    });
    List<ChargingOperation> res = await WalletServices().getUserChargingOperations(user!.id);
    setState(() {
      operatins = res ;
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
        centerTitle: true,
        backgroundColor: MyColors.solidDarkColor,
        title: Text('charging_details'.tr , style: TextStyle(color: MyColors.whiteColor , fontSize: 18.0),),
      ),
      body: Container(
        color: MyColors.darkColor,
        width: double.infinity,
        height: double.infinity,
        padding: EdgeInsets.all(15.0),
        child: loading ? Loading() : ListView.separated(itemBuilder: (context, index) => itemBuilder(index),  separatorBuilder: (context, index) => seperatorBuilder() , itemCount: operatins.length),
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
                  Image(image: AssetImage('assets/images/gold.png') , width: 30.0,),
                  SizedBox(width: 5.0,),
                  Text(operatins[index].gold.toString() , style: TextStyle(color: MyColors.primaryColor , fontSize: 20.0 , fontWeight: FontWeight.bold),)
                ],
              ),
              SizedBox(height: 15.0,),
              Text(operatins[index].source , style: TextStyle(color: MyColors.secondaryColor , fontSize: 15.0),),
              SizedBox(height: 15.0,),
              Text(operatins[index].charging_date , style: TextStyle(color: MyColors.unSelectedColor , fontSize: 15.0),)
          
            ],
          ),
        )
      ],
    ),
  );
  Widget seperatorBuilder  () => SizedBox(height: 10.0,);
}
