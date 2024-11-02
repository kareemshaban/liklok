import 'package:LikLok/models/AgencyMemberWithStitics.dart';
import 'package:LikLok/models/AppUser.dart';
import 'package:LikLok/shared/components/Constants.dart';
import 'package:LikLok/shared/network/remote/AppUserServices.dart';
import 'package:LikLok/shared/network/remote/HostAgencyService.dart';
import 'package:LikLok/shared/styles/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AgencyStatics extends StatefulWidget {
  const AgencyStatics({super.key});

  @override
  State<AgencyStatics> createState() => _AgencyStaticsState();
}

class _AgencyStaticsState extends State<AgencyStatics> {
  AppUser? user ;
  List<AgencyMemberWithStatics> members = [] ;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      user = AppUserServices().userGetter();
    });
    loadData();
  }

  loadData() async {
    List<AgencyMemberWithStatics> res = await HostAgencyService().getAgencyStatics(user!.id);

      setState(() {
        members = res ;
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
        title: Text(
          "agency_statics_title".tr,
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
              members.length == 0 ? Center(child: Column(
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
    )
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
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Column(
                        children: [
                          CircleAvatar(
                            backgroundColor:  MyColors.blueColor  ,

                            backgroundImage: members[index].member_img != "" ?
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





                        ],

                      ),
                      const SizedBox(width: 10.0,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Text('day_count'.tr , style: TextStyle(color: MyColors.whiteColor , fontSize: 15.0),),
                              const SizedBox(width: 5.0,),
                            ],
                          ),
                          Row(
                            children: [
                              Text(members[index].days.toStringAsFixed(1) , style: TextStyle(color: Colors.blue , fontSize: 15.0),),
                              const SizedBox(width: 5.0,),
                            ],
                          ),

                        ],

                      ),
                      const SizedBox(width: 10.0,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Text('point_count'.tr , style: TextStyle(color: MyColors.whiteColor , fontSize: 15.0),),
                              const SizedBox(width: 5.0,),
                            ],
                          ),
                          Row(
                            children: [
                              Text(members[index].points.toString() , style: TextStyle(color: Colors.orange , fontSize: 15.0),),
                              const SizedBox(width: 5.0,),
                            ],
                          ),

                        ],

                      ),

                      const SizedBox(width: 10.0,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Text('host_agent'.tr , style: TextStyle(color: MyColors.whiteColor , fontSize: 15.0),),
                              const SizedBox(width: 5.0,),
                            ],
                          ),
                          Row(
                            children: [
                              Text(members[index].hostSalary , style: TextStyle(color: Colors.green , fontSize: 15.0),),
                              const SizedBox(width: 5.0,),
                            ],
                          ),


                        ],

                      ),

                    ],
                  ),
                ),
              ),





            ]),
        SizedBox(height: 15.0,),

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
    if(members[index].member_img.startsWith('https')){
      return members[index].member_img.toString() ;
    } else {
      return '${ASSETSBASEURL}AppUsers/${members[index].member_img}' ;
    }
  }



}
