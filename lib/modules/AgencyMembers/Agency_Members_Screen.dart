import 'package:LikLok/models/AgencyMember.dart';
import 'package:LikLok/models/AppUser.dart';
import 'package:LikLok/models/HostAgency.dart';
import 'package:LikLok/shared/components/Constants.dart';
import 'package:LikLok/shared/network/remote/AppUserServices.dart';
import 'package:LikLok/shared/network/remote/HostAgencyService.dart';
import 'package:LikLok/shared/styles/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../AgencyIncome/agency_income_screen.dart';

class AgencyMembsersScreen extends StatefulWidget {
  const AgencyMembsersScreen({super.key});

  @override
  State<AgencyMembsersScreen> createState() => _AgencyMembsersScreenState();
}

class _AgencyMembsersScreenState extends State<AgencyMembsersScreen> {

  List<AgencyMember> members = [] ;
  AppUser? user ;
   @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      user = AppUserServices().userGetter();
    });
    loadData();
  }
   Future<void> _refresh()async{
     await loadData() ;
   }

   loadData() async {
     HostAgency? agency = await HostAgencyService().getAgencyMembers(user!.id);
     if(agency != null){
        setState(() {
          members = agency.members! ;
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
          "agency_members_title".tr,
          style: TextStyle(color: MyColors.whiteColor, fontSize: 20.0),
        ),
      ),
      body: Container(
        color: MyColors.darkColor,
        width: double.infinity,
        height: double.infinity,
        padding: EdgeInsets.all(10.0),
          child: Column(
            children: [
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _refresh,
                  color: MyColors.primaryColor,
                  child:
                  members!.length == 0 ? Center(child: Column(
                    children: [
                      Image(image: AssetImage('assets/images/sad.png') , width: 100.0 , height: 100.0,),
                      SizedBox(height: 30.0,),
                      Text('no_data'.tr , style: TextStyle(color: Colors.red , fontSize: 18.0 ) ,)


                    ],), ) :
                  ListView.separated(itemBuilder: (ctx , index) =>itemListBuilder(index) ,
                      separatorBuilder: (ctx , index) =>itemSperatorBuilder(), itemCount: members!.length),
                ),
              ),
            ],
          ),
      ),
    );

  }

  Widget itemListBuilder(index) => GestureDetector(
    onTap: (){
    },
    child: Column(
      children: [
        Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Column(
                      children: [
                        CircleAvatar(
                          backgroundColor:  MyColors.blueColor  ,
                
                          backgroundImage: members![index].member_img != "" ?
                          CachedNetworkImageProvider(getUserImage(index)!) : null,
                          radius: 25,
                          child: members[index].member_img == "" ?
                          Text(members[index].member_name.toUpperCase().substring(0 , 1) +
                              (members[index].member_name.contains(" ") ? members[index].member_name.substring(members![index].member_name.indexOf(" ")).toUpperCase().substring(1 , 2) : ""),
                            style: const TextStyle(color: Colors.white , fontSize: 22.0 , fontWeight: FontWeight.bold),) : null,
                        )
                      ],
                    ),
                    const SizedBox(width: 10.0,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(members[index].member_name , style: TextStyle(color: MyColors.whiteColor , fontSize: 15.0),),
                            const SizedBox(width: 5.0,),
                          ],
                        ),
                
                        Text("ID:${members[index].member_tag}" , style: TextStyle(color: MyColors.unSelectedColor , fontSize: 12.0),),
                        Text("Joining Date:${members[index].joining_date}" , style: TextStyle(color: MyColors.unSelectedColor , fontSize: 11.0),),
                
                
                
                
                      ],
                
                    ),
                  ],
                ),
              ),



              Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 5.0),
                    decoration: BoxDecoration(color: Colors.white , borderRadius: BorderRadius.circular(10.0)),

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                      members[index].state == 0 ?  MaterialButton( onPressed: () {
                        showAlertDialog(context , 'accept_member_title'.tr , 'accept_member_msg'.tr , index);
                      },
                        child: Text('new_joiner'.tr , style: TextStyle(fontSize: 15.0 ,
                              fontWeight: FontWeight.bold , color: MyColors.primaryColor),),
                      ): SizedBox(),

                        members[index].state == 1 ?  MaterialButton( onPressed: (){
                          showAlertDialog(context , 'kik_member_title'.tr , 'kik_member_msg'.tr , index);
                        },
                          child: Text('kik_member'.tr , style: TextStyle(fontSize: 15.0 ,
                              fontWeight: FontWeight.bold , color: MyColors.primaryColor),),
                        ): SizedBox(),

                        members[index].state == 2 ?  MaterialButton( onPressed: (){},
                          child: Text('out_member'.tr , style: TextStyle(fontSize: 15.0 ,
                              fontWeight: FontWeight.bold , color: MyColors.primaryColor),),
                        ): SizedBox(),
                      ],
                    ),
                  )
                ],
              ),


            ]),
        SizedBox(height: 15.0,),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 5.0),
          decoration: BoxDecoration(color: Colors.white , borderRadius: BorderRadius.circular(10.0)),

          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MaterialButton(onPressed:  () => {

              Navigator.push(context, MaterialPageRoute(builder: (ctx) =>  AgencyIncome(user_id: members[index].user_id,)))
              } , child:  Text('Show Balance' , style: TextStyle(color: MyColors.primaryColor , fontSize: 18.0),), )
            ],
          ),
        ),
        Container(
          width: double.infinity,
          height: 1.0,
          color: MyColors.lightUnSelectedColor,
          margin: EdgeInsetsDirectional.only(start: 50.0),
          child: const Text(""),
        ),
        
      ],
    ),
  );

  Widget itemSperatorBuilder() => SizedBox(height: 5.0,);

  String? getUserImage(index){
    if(members[index]!.member_img.startsWith('https')){
      return members[index]!.member_img.toString() ;
    } else {
      return '${ASSETSBASEURL}AppUsers/${members![index].member_img}' ;
    }
  }


  showAlertDialog(BuildContext context , String title , String msg , int index) {

    // set up the button
    Widget okButton = TextButton(
      child: Text("edit_ok".tr , style: TextStyle(color: MyColors.primaryColor),),
      onPressed: () async{
        if(members[index].state == 0){
          //approve
         HostAgency? agnecy = await HostAgencyService().approveMember(members[index].user_id, user!.id)  ;
         if(agnecy != null){
           setState(() {
             members = agnecy.members!;
           });
           Navigator.pop(context);
           Fluttertoast.showToast(
               msg: 'Member has been joined successfully',
               toastLength: Toast.LENGTH_SHORT,
               gravity: ToastGravity.CENTER,
               timeInSecForIosWeb: 1,
               backgroundColor: Colors.black26,
               textColor: Colors.orange,
               fontSize: 16.0
           );

         }
        } else if(members[index].state == 1){
          //kik
          HostAgency? agnecy = await HostAgencyService().kikMember(members[index].user_id, user!.id)  ;
          if(agnecy != null){
            setState(() {
              members = agnecy.members!;
            });
            Navigator.pop(context);
            Fluttertoast.showToast(
                msg: 'Member has been kicked out successfully',
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.black26,
                textColor: Colors.orange,
                fontSize: 16.0
            );

          }
        }

      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      backgroundColor: MyColors.darkColor,
      title: Text(title , style: TextStyle(color: MyColors.primaryColor),),
      content: Text(msg , style: TextStyle(color: MyColors.whiteColor),),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
