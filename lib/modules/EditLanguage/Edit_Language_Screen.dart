import 'package:LikLok/shared/styles/colors.dart';
import 'package:LikLok/utils/ar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditLanguageScreen extends StatefulWidget {
  const EditLanguageScreen({super.key});

  @override
  State<EditLanguageScreen> createState() => _EditLanguageScreenState();
}

class _EditLanguageScreenState extends State<EditLanguageScreen> {
  dynamic groupValue ;
  dynamic englishRadioVal ;
  dynamic arabicRadioVal ;
  String _SelectedLang ='';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getLang();
  // Translation();
  }
  getLang() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? l = await prefs.getString('local_lang') ;
    print('lang') ;
    print(l);
    if(l == null){l = ('en') ;};
    if(l == ""){l = ('en') ;};
    setState(() {
      _SelectedLang = l!;
      groupValue = l;
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
        title: Text("edit_language".tr , style: TextStyle(color: Colors.black,fontSize: 18.0) ,),
      ),
      body: Container(
        color: MyColors.darkColor,
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children: [
            Container(
              color: Colors.white,
              margin: EdgeInsets.only(right: 15.0 , left: 15.0 , top: 15.0),
              padding: EdgeInsets.all(15.0) ,
              child: Row(
                children: [
                  Text("English" ,style:TextStyle(color: Colors.black,fontSize: 15.0) ,),
                  Expanded(child:
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Transform.scale(
                            scale:1.3 ,
                            child: Radio(activeColor: MyColors.primaryColor,value:'en' , groupValue:groupValue , onChanged: ( val){
                              setState(() {
                                _SelectedLang= val.toString();
                                showAlertDialog(context );
                              });
                            }))
                      ],
                    )
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              height: 1.0,
              color: Colors.black45,
              margin: EdgeInsetsDirectional.only(start: 15.0),
            ),
            Container(
              color: Colors.white,
              margin: EdgeInsets.only(right: 15.0 , left: 15.0),
              padding: EdgeInsets.all(15.0) ,
              child: Row(
                children: [
                  Text("edit_arabic".tr ,style:TextStyle(color: Colors.black,fontSize: 15.0) ,),
                  Expanded(child:
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Transform.scale(
                          scale: 1.3,
                          child:
                          Radio( activeColor: MyColors.primaryColor,value: 'ar', groupValue:groupValue , onChanged: (val){
                            setState(() {
                              _SelectedLang= val.toString();
                              print(_SelectedLang);
                              showAlertDialog(context );
                            });
                          }))
                    ],
                  )
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              height: 1.0,
              color: Colors.black45,
              margin: EdgeInsetsDirectional.only(start: 15.0),
            ),
            Container(
              color: Colors.white,
              margin: EdgeInsets.only(right: 15.0 , left: 15.0),
              padding: EdgeInsets.all(15.0) ,
              child: Row(
                children: [
                  Text("chineese_lang".tr ,style:TextStyle(color: Colors.black,fontSize: 15.0) ,),
                  Expanded(child:
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Transform.scale(
                          scale: 1.3,
                          child:
                          Radio( activeColor: MyColors.primaryColor,value: 'zh', groupValue:groupValue , onChanged: (val){
                            setState(() {
                              _SelectedLang= val.toString();
                              print(_SelectedLang);
                              showAlertDialog(context );
                            });
                          }))
                    ],
                  )
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              height: 1.0,
              color: Colors.black45,
              margin: EdgeInsetsDirectional.only(start: 15.0),
            ),
            Container(
              color: Colors.white,
              margin: EdgeInsets.only(right: 15.0 , left: 15.0),
              padding: EdgeInsets.all(15.0) ,
              child: Row(
                children: [
                  Text("indian_lang".tr ,style:TextStyle(color: Colors.black,fontSize: 15.0) ,),
                  Expanded(child:
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Transform.scale(
                          scale: 1.3,
                          child:
                          Radio( activeColor: MyColors.primaryColor,value: 'hi', groupValue:groupValue , onChanged: (val){
                            setState(() {
                              _SelectedLang= val.toString();
                              print(_SelectedLang);
                              showAlertDialog(context );
                            });
                          }))
                    ],
                  )
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              height: 1.0,
              color: Colors.black45,
              margin: EdgeInsetsDirectional.only(start: 15.0),
            ),
            Container(
              color: Colors.white,
              margin: EdgeInsets.only(right: 15.0 , left: 15.0),
              padding: EdgeInsets.all(15.0) ,
              child: Row(
                children: [
                  Text("phlpini_lang".tr ,style:TextStyle(color: Colors.black,fontSize: 15.0) ,),
                  Expanded(child:
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Transform.scale(
                          scale: 1.3,
                          child:
                          Radio( activeColor: MyColors.primaryColor,value: 'ph', groupValue:groupValue , onChanged: (val){
                            setState(() {
                              _SelectedLang= val.toString();
                              print(_SelectedLang);
                              showAlertDialog(context );
                            });
                          }))
                    ],
                  )
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              height: 1.0,
              color: Colors.black45,
              margin: EdgeInsetsDirectional.only(start: 15.0),
            ),
            Container(
              color: Colors.white,
              margin: EdgeInsets.only(right: 15.0 , left: 15.0),
              padding: EdgeInsets.all(15.0) ,
              child: Row(
                children: [
                  Text("pangladish_lang".tr ,style:TextStyle(color: Colors.black,fontSize: 15.0) ,),
                  Expanded(child:
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Transform.scale(
                          scale: 1.3,
                          child:
                          Radio( activeColor: MyColors.primaryColor,value: 'bn', groupValue:groupValue , onChanged: (val){
                            setState(() {
                              _SelectedLang= val.toString();
                              print(_SelectedLang);
                              showAlertDialog(context );
                            });
                          }))
                    ],
                  )
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              height: 1.0,
              color: Colors.black45,
              margin: EdgeInsetsDirectional.only(start: 15.0),
            ),
            Container(
              color: Colors.white,
              margin: EdgeInsets.only(right: 15.0 , left: 15.0),
              padding: EdgeInsets.all(15.0) ,
              child: Row(
                children: [
                  Text("barazil_lang".tr ,style:TextStyle(color: Colors.black,fontSize: 15.0) ,),
                  Expanded(child:
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Transform.scale(
                          scale: 1.3,
                          child:
                          Radio( activeColor: MyColors.primaryColor,value: 'br', groupValue:groupValue , onChanged: (val){
                            setState(() {
                              _SelectedLang= val.toString();
                              print(_SelectedLang);
                              showAlertDialog(context );
                            });
                          }))
                    ],
                  )
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              height: 1.0,
              color: Colors.black45,
              margin: EdgeInsetsDirectional.only(start: 15.0),
            ),
            Container(
              color: Colors.white,
              margin: EdgeInsets.only(right: 15.0 , left: 15.0),
              padding: EdgeInsets.all(15.0) ,
              child: Row(
                children: [
                  Text("france_lang".tr ,style:TextStyle(color: Colors.black,fontSize: 15.0) ,),
                  Expanded(child:
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Transform.scale(
                          scale: 1.3,
                          child:
                          Radio( activeColor: MyColors.primaryColor,value: 'fr', groupValue:groupValue , onChanged: (val){
                            setState(() {
                              _SelectedLang= val.toString();
                              print(_SelectedLang);
                              showAlertDialog(context );
                            });
                          }))
                    ],
                  )
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              height: 1.0,
              color: Colors.black45,
              margin: EdgeInsetsDirectional.only(start: 15.0),
            ),
            Container(
              color: Colors.white,
              margin: EdgeInsets.only(right: 15.0 , left: 15.0),
              padding: EdgeInsets.all(15.0) ,
              child: Row(
                children: [
                  Text("indonisian_lang".tr ,style:TextStyle(color: Colors.black,fontSize: 15.0) ,),
                  Expanded(child:
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Transform.scale(
                          scale: 1.3,
                          child:
                          Radio( activeColor: MyColors.primaryColor,value: 'id', groupValue:groupValue , onChanged: (val){
                            setState(() {
                              _SelectedLang= val.toString();
                              print(_SelectedLang);
                              showAlertDialog(context );
                            });
                          }))
                    ],
                  )
                  ),
                ],
              ),
            ),
          ],
          )
        ),
      );
  }
void Translation() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('local_lang', _SelectedLang);
  Get.updateLocale(Locale(_SelectedLang));
  print('SharedPreferences');
  print(_SelectedLang);
  Navigator.pop(context);
  setState(() {
    groupValue = _SelectedLang ;
  });

}


  showAlertDialog(BuildContext context) {

    // set up the button
    Widget okButton = TextButton(
      child: Text("edit_ok".tr , style: TextStyle(color: MyColors.primaryColor),),
      onPressed: () {
        Translation();

      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      backgroundColor: MyColors.darkColor,
      title: Text("change_local".tr , style: TextStyle(color: MyColors.primaryColor),),
      content: Text("change_local_msg".tr , style: TextStyle(color: MyColors.whiteColor),),
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
