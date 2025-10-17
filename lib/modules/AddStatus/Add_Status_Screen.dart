import 'package:LikLok/models/AppUser.dart';
import 'package:LikLok/shared/components/Constants.dart';
import 'package:LikLok/shared/network/remote/AppUserServices.dart';
import 'package:LikLok/shared/styles/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class AddStatusScreen extends StatefulWidget {
  const AddStatusScreen({super.key});

  @override
  State<AddStatusScreen> createState() => _AddStatusScreenState();
}

class _AddStatusScreenState extends State<AddStatusScreen> {
  AppUser? user ;
  bool _isLoading = false ;
  var statusController = TextEditingController()  ;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(mounted) {
      setState(() {
        user = AppUserServices().userGetter();
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
        title: Text("add_status_my_status".tr , style: TextStyle(color: MyColors.whiteColor),),
        actions: [
          IconButton(icon: Icon(FontAwesomeIcons.circleQuestion , color: MyColors.whiteColor,) , onPressed: (){},)
        ],
      ),
      body: SafeArea(
        child: Container(
          color: MyColors.darkColor,
          width: double.infinity,
          height: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(top: 10.0) ,
                  child: CircleAvatar(
                    backgroundColor: user!.gender == 0 ? MyColors.blueColor : MyColors.pinkColor ,
                    backgroundImage:(user!.img != "" ?  CachedNetworkImageProvider(getUserImage()!) : null),
                    radius: 50,
                    child: user?.img== ""  ?
                    Text(user!.name.toUpperCase().substring(0 , 1) +
                        (user!.name.contains(" ") ? user!.name.substring(user!.name.indexOf(" ")).toUpperCase().substring(1 , 2) : ""),
                      style: const TextStyle(color: Colors.white , fontSize: 28.0 , fontWeight: FontWeight.bold),) : null,
                  ),
            
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image(image: CachedNetworkImageProvider('${ASSETSBASEURL}Levels/${user!.share_level_icon}') , width: 50,),
                      const SizedBox(width: 10.0,),
                      Image(image: CachedNetworkImageProvider('${ASSETSBASEURL}Levels/${user!.karizma_level_icon}') , width: 50,),
                      const SizedBox(width: 10.0, height: 10,),
                      Image(image: CachedNetworkImageProvider('${ASSETSBASEURL}Levels/${user!.charging_level_icon}') , width: 30,),
                      
                    ],
                  ),
                ),
                SizedBox(height: 5.0,),
                Text(user!.status , style: TextStyle(color: MyColors.whiteColor , fontSize: 13.0),),
        
                Container(
                  width: double.infinity,
                  height: 6.0,
                  color: MyColors.solidDarkColor,
                  margin: EdgeInsetsDirectional.only(top: 20.0),
                ),
            
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(color: Colors.white ),
                  child: TextField(
                    controller: statusController,
                    keyboardType: TextInputType.multiline,
                    maxLines: 5,
                    maxLength: 30,
                    cursorColor: MyColors.primaryColor,
                    decoration: InputDecoration(border: InputBorder.none , labelText: "add_status_label_text".tr , labelStyle: TextStyle(color: Colors.grey , fontSize: 18.0)),
                    style: TextStyle(color: MyColors.whiteColor),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric( horizontal: 20.0),
                  margin: EdgeInsets.all(10.0),
                  // decoration: BoxDecoration(  color: MyColors.primaryColor, borderRadius: BorderRadius.circular(15.0)),
                  child: ElevatedButton.icon(
                    onPressed: (){
                      AddStatus();
                    },
                    style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 10.0 , vertical: 5.0) , backgroundColor: MyColors.primaryColor ,
                    ),
                    icon: _isLoading
                        ? Container(
                         width: 20,
                         height: 20,
                        padding: const EdgeInsets.all(2.0),
                          child: const CircularProgressIndicator(
                         color: Colors.white,
                         strokeWidth: 3,
                         ),
                       )
                        :  Icon(Icons.publish , color: MyColors.darkColor , size: 20.0,),
                    label:  Text('add_status_share'.tr , style: TextStyle(color: MyColors.darkColor , fontSize: 18.0), ),
                  ),
        
        
                  //MaterialButton(onPressed: (){ AddStatus();} , child: Text('add_status_share'.tr , style: TextStyle(color:MyColors.darkColor , fontSize: 18.0),),),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  String calculateAge(DateTime birth) {
    DateTime now = DateTime.now();
    Duration age = now.difference(birth);
    int years = age.inDays ~/ 365;
    int months = (age.inDays % 365) ~/ 30;
    int days = ((age.inDays % 365) % 30);
    return years.toString() ;
  }

  AddStatus() async{
    setState(() {
      _isLoading = true ;
    });
    AppUser? res = await AppUserServices().updateStatus(user!.id, statusController.text);
    AppUserServices().userSetter(res!);
    setState(() {
      user = res;
      _isLoading = false ;
      statusController.text = "" ;
    });
    Fluttertoast.showToast(
        msg: "add_status_msg".tr,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black26,
        textColor: Colors.orange,
        fontSize: 16.0
    );
  //  Navigator.pop(context , true);
  }

  String? getUserImage(){
    if(user!.img.startsWith('https')){
      return user?.img.toString() ;
    } else {
      return '${ASSETSBASEURL}AppUsers/${user?.img}' ;
    }
  }
}
