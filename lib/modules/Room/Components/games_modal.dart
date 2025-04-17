import 'package:LikLok/models/AppSettings.dart';
import 'package:LikLok/models/AppUser.dart';
import 'package:LikLok/modules/Room/Components/game_modal.dart';
import 'package:LikLok/shared/components/Constants.dart';
import 'package:LikLok/shared/network/remote/AppSettingsServices.dart';
import 'package:LikLok/shared/network/remote/AppUserServices.dart';
import 'package:LikLok/shared/styles/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class GamesModal extends StatefulWidget {
  const GamesModal({super.key});

  @override
  State<GamesModal> createState() => _GamesModalState();
}

class _GamesModalState extends State<GamesModal> {
  AppUser? user ;
  AppSettings? appSettings ;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setState(() {
      user = AppUserServices().userGetter();
      appSettings = AppSettingsServices().appSettingGetter();
    });
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      height: 300,
      decoration: BoxDecoration(color: Colors.white.withAlpha(180),
          borderRadius: BorderRadius.only(topRight: Radius.circular(20.0) , topLeft: Radius.circular(15.0)) ,
          border: Border(top: BorderSide(width: 4.0, color: MyColors.secondaryColor),) ),
      child:  SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 15.0,),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  appSettings!.game25 == 1 ? Expanded(
                   child: GestureDetector(
                      onTap: (){

                        Navigator.pop(context);
                        showModalBottomSheet(
                            isScrollControlled: true ,
                            context: context,
                            builder: (ctx) => openGame(25 , 1.0));
                      },
                      child: Column(
                        children: [
                          Image(image: AssetImage('assets/images/game25.png') , width: 100.0,),
        
                        ],
                      ),
                    ) ,
                  ) : Container(),
                  appSettings!.game10 == 1 ? Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: (){
                        Navigator.pop(context);
                        showModalBottomSheet(
                            isScrollControlled: true ,
                            context: context,
                            builder: (ctx) => openGame(10 , .7));
                      },
                      child: Column(
                        children: [
                          Image(image: AssetImage('assets/images/game10.png') , width: 100.0,),

                        ],
                      ),
                    ),
                  ) : Container(),
                  appSettings!.game1 == 1 ?  Expanded(
                    child: GestureDetector(
                      onTap: (){
                        Navigator.pop(context);
                        showModalBottomSheet(
                            isScrollControlled: true ,
                            context: context,
                            builder: (ctx) => openGame(1 , .7));
                      },
                      child: Column(
                        children: [
                          Image(image: AssetImage('assets/images/game1.png') , width: 100.0,),

                        ],
                      ),
                    ),
                  ) : Container(),
        
                ],
              ),
              SizedBox(height: 15.0,),
              Row(
                children: [

                  appSettings!.game26 == 1 ?  Expanded(
                    child: GestureDetector(
                      onTap: (){
                        Navigator.pop(context);
                        showModalBottomSheet(
                            isScrollControlled: true ,
                            context: context,
                            builder: (ctx) => openGame(26 , .7));
                      },
                      child: Column(
                        children: [
                          Image(image: AssetImage('assets/images/game26.png') , width: 100.0,),
        
                        ],
                      ),
                    ),
                  ) : Container(),
                  appSettings!.game7 == 1 ? Expanded(
                    child: GestureDetector(
                      onTap: (){
                        Navigator.pop(context);
                        showModalBottomSheet(
                            isScrollControlled: true ,
                            context: context,
                            builder: (ctx) => openGame(7 , .7));
                      },
                      child: Column(
                        children: [
                          Image(image: AssetImage('assets/images/game7.png') , width: 100.0,),

                        ],
                      ),
                    ),
                  ) : Container(),
                  appSettings!.game20 == 1 ? Expanded(
                    child: GestureDetector(
                      onTap: (){
                        Navigator.pop(context);
                        showModalBottomSheet(
                            isScrollControlled: true ,
                            context: context,
                            builder: (ctx) => openGame(20 , .7));
                      },
                      child: Column(
                        children: [
                          Image(image: AssetImage('assets/images/game20.png') , width: 100.0,),

                        ],
                      ),
                    ),
                  ) : Container(),
                ],
              ),
              SizedBox(height: 15.0,),
              Row(
                children: [

                  appSettings!.game15 == 1 ? Expanded(
                    child: GestureDetector(
                      onTap: (){
                        Navigator.pop(context);
                        showModalBottomSheet(
                            isScrollControlled: true ,
                            context: context,
                            builder: (ctx) => openGame(15 , .7));
                      },
                      child: Column(
                        children: [
                          Image(image: AssetImage('assets/images/game15.png') , width: 100.0,),

                        ],
                      ),
                    ),
                  ) : Container(),
                  appSettings!.game8 == 1 ? Expanded(
                    child: GestureDetector(
                      onTap: (){
                        Navigator.pop(context);
                        showModalBottomSheet(
                            isScrollControlled: true ,
                            context: context,
                            builder: (ctx) => openGame(8 , .7));
                      },
                      child: Column(
                        children: [
                          Image(image: AssetImage('assets/images/game8.png') , width: 100.0,),

                        ],
                      ),
                    ),
                  ) : Container(),
                  Expanded(child: Container())
                ],
              ),

            ]
        ),
      ),

    );
  }


  Widget openGame(id , ratio) =>  GameModal(id: id, height_ratio: ratio,);
}
