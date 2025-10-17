import 'package:LikLok/shared/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ErrorScreen extends StatefulWidget {
  const ErrorScreen({super.key});

  @override
  State<ErrorScreen> createState() => _ErrorScreenState();
}

class _ErrorScreenState extends State<ErrorScreen> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: AppBar(
          title:  Text(  "عطل فني", style: TextStyle(color: Colors.red),),
          iconTheme: IconThemeData(
            color: MyColors.whiteColor, //change your color here
          ),
          centerTitle: true,
          backgroundColor: MyColors.solidDarkColor,
        ),
        body: SafeArea(
          child: Container(
            color: MyColors.darkColor,
            width: double.infinity,
            height: double.infinity,
            padding: EdgeInsets.all(20.0),
            child: Column(
              children: [
                Image(image: AssetImage('assets/images/logo_round.png') , width: 200.0,),
                Text(  "تعرض التطبيق لعطل فني وجاري العمل علي إصلاحه في اقرب وقت نشكر نفهمكم" , style: TextStyle(color: Colors.black , fontSize: 25.0), textAlign: TextAlign.center,),
                SizedBox(height: 20.0,),
                GestureDetector(
                  onTap: () async{
                    final SharedPreferences prefs = await SharedPreferences.getInstance();
                    await prefs.setInt('userId', 0);
          
                    SystemNavigator.pop();
                  },
                  child: Container(
                    width: 150.0,
                    child: Center(child: Text("أتفهم ذلك" , style: TextStyle(color: Colors.white , fontSize: 20.0),)),
                    padding: EdgeInsets.all(10.0), decoration: BoxDecoration(color: MyColors.primaryColor, borderRadius: BorderRadius.all(Radius.circular(15.0))),  ),
                )
              ],
            ),
          ),
        )
    );
  }
}
