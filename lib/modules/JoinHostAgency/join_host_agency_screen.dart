import 'package:LikLok/models/AppUser.dart';
import 'package:LikLok/models/HostAgency.dart';
import 'package:LikLok/shared/network/remote/AppUserServices.dart';
import 'package:LikLok/shared/network/remote/HostAgencyService.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../shared/styles/colors.dart';

class JoinHostAgency extends StatefulWidget {
  const JoinHostAgency({super.key});

  @override
  State<JoinHostAgency> createState() => _JoinHostAgencyState();
}

class _JoinHostAgencyState extends State<JoinHostAgency> {
  AppUser? user ;
  HostAgency? agency ;
  bool showAgency = false ;
  final TextEditingController agencyTagController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      user = AppUserServices().userGetter();
    });
  }
  getAgency() async {
    HostAgency? res = await HostAgencyService().getAgencyByTag(agencyTagController.text);
    agencyTagController.clear();
    if(res != null){
      setState(() {
        agency = res ;
        if(agency!.id > 0){
          setState(() {
            showAgency = true ;
          });
        }
      });
    }
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
        title: Text(
          'join_host_title'.tr,
          style: TextStyle(color: MyColors.whiteColor, fontSize: 20.0),
        ),
      ),
      body: Container(
        color: MyColors.darkColor,
        width: double.infinity,
        height: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 45.0,
                child: TextField(controller: agencyTagController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: "host_agency_search".tr ,
                    suffixIcon: IconButton(icon: const Icon(Icons.search , color: Colors.black, size: 25.0,),
                  onPressed: (){getAgency();},) , fillColor: MyColors.primaryColor, focusColor: MyColors.primaryColor, focusedBorder: OutlineInputBorder( borderRadius: BorderRadius.circular(25.0) ,
                    borderSide: BorderSide(color: MyColors.whiteColor) ) ,  border: OutlineInputBorder( borderRadius: BorderRadius.circular(25.0) ) , labelStyle: const TextStyle(color: Colors.black , fontSize: 13.0) ),
                  style: const TextStyle(color: Colors.black), cursorColor: MyColors.primaryColor,)

              ),

              SizedBox(width: 10.0,),
              SizedBox(height: 20.0,),
           showAgency ?   Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('join_host_data'.tr,style: TextStyle(color: Colors.black , fontSize: 22.0)),
                    ],
                  ),
                  SizedBox(height: 20.0,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          CircleAvatar(
                            backgroundColor:MyColors.blueColor,
                            radius: 28,
                           child:
                            Text(agency!.name.toUpperCase().substring(0 , 1) +
                                (agency!.name.contains(" ") ? agency!.name.substring(agency!.name.indexOf(" ")).toUpperCase().substring(1 , 2) : ""),
                              style: const TextStyle(color: Colors.black , fontSize: 22.0 , fontWeight: FontWeight.bold),) ,
                          ),
                        ],
                      ),
                      SizedBox(width: 15.0,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(agency!.name,style: TextStyle(color: Colors.black , fontSize: 18.0)),
                          Text(agency!.tag ,style: TextStyle(color: Colors.black , fontSize: 18.0)),
                        ],
                      )
                    ],
                  ),
                  SizedBox(height: 30.0,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 60.0,
                        width: 190.0,
                        decoration: BoxDecoration(
                          color: MyColors.primaryColor,
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: MaterialButton(onPressed: (){
                          JoinAgencyRequest();
                        } ,
                          child: Text("join_host_request".tr , style: TextStyle(color: Colors.white , fontSize: 18.0),),
                        ),
                      )
                    ],
                  ),
                ],
              ) : Container(),


            ],
          ),
        ),
      ),
    );
  }

  JoinAgencyRequest() async{
    if(agency != null){
      await HostAgencyService().JoinAgencyRequest(agency!.id , user!.id);
      await AppUserServices().getUser(user!.id);
      Navigator.pop(context);
    }
  }
}
