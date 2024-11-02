import 'package:LikLok/models/AppUser.dart';
import 'package:LikLok/models/Settings.dart';
import 'package:LikLok/modules/ChargingOperation/Charging_Operation_Screen.dart';
import 'package:LikLok/modules/GoogleProductsScreen/google_products_screen.dart';
import 'package:LikLok/modules/Loading/loadig_screen.dart';
import 'package:LikLok/shared/constants/Contants.dart';
import 'package:LikLok/shared/network/remote/AppUserServices.dart';
import 'package:LikLok/shared/network/remote/WalletServices.dart';
import 'package:LikLok/utils/en.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_ip_address/get_ip_address.dart';
import 'package:pay/pay.dart';


import '../../shared/styles/colors.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  AppUser? user;
  AppSettings? setting ;
  var diamondTxt = TextEditingController()  ;
  bool isLoading = false ;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSettings();
    setState(() {
      user = AppUserServices().userGetter();
    });
  }

  getSettings() async {
    AppSettings? res = await WalletServices().getAppSettings();
    setState(() {
      setting = res  ;
    });
  }

  Future<void> _refresh()async{
    await loadData() ;
  }
  loadData()async {
     AppUser? res = await AppUserServices().getUser(user!.id);
     if(res != null){
       setState(() {
         user = res ;
       });
     }
  }
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: MyColors.whiteColor, //change your color here
          ),
          backgroundColor: MyColors.solidDarkColor,
          title: TabBar(
            dividerColor: Colors.transparent,
            tabAlignment: TabAlignment.start,
            isScrollable: true,
            indicatorColor: MyColors.primaryColor,
            labelColor: MyColors.primaryColor,
            unselectedLabelColor: MyColors.unSelectedColor,
            labelStyle:
                const TextStyle(fontSize: 17.0, fontWeight: FontWeight.w900),
            tabs: [
              Tab(text: "profile_gold".tr),
              Tab(
                text: "profile_diamond".tr,
              ),
            ],
          ),
          actions: [
            TextButton( onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => const ChargingOperationScreen(),));
            }, child: Text('details'.tr , style:
            TextStyle(color: MyColors.whiteColor, fontSize: 15.0)) ,
                ),
            SizedBox(
              width: 10.0,
            )
          ],
        ),
        body:  Container(
          color: MyColors.darkColor,
          width: double.infinity,
          child: setting != null  || isLoading ? TabBarView(
            children: [
              Column(
                children: [
                  Container(
                    height: 150.0,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/Gold-bag.png'),
                        colorFilter: new ColorFilter.mode(
                            Colors.black.withOpacity(0.6), BlendMode.dstATop),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Current Gold',
                          style: TextStyle(
                              color: MyColors.primaryColor,
                              fontSize: 22.0,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image(
                              image: AssetImage('assets/images/gold.png'),
                              width: 40.0,
                              height: 40.0,
                            ),
                            SizedBox(width: 10.0,),
                            Text(
                              double.parse(user!.gold).floor().toString(),
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 25.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: Transform.translate(
                        offset: Offset(0, -20.0), child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 15.0 , vertical: 20.0),
                        decoration: BoxDecoration(color: MyColors.darkColor , borderRadius: BorderRadius.circular(15.0)),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 8.0,
                                    height: 30.0,
                                    decoration: BoxDecoration(color: MyColors.primaryColor , borderRadius: BorderRadius.circular(3.0)),
                                  ),
                                  SizedBox(width: 10.0,),
                                  Text("recharge_gold".tr , style: TextStyle(color: Colors.black , fontSize: 18.0 , fontWeight: FontWeight.bold),)
                                ],
                              ),
                              SizedBox(height: 15.0,),
                              getChargeProvider()

                            ],
                          ),
                        ),


                    )),
                  )
                ],
              ),
              Column(
                children: [
                  Container(
                    height: 150.0,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/diamond-bag.png'),
                        colorFilter: new ColorFilter.mode(
                            Colors.black.withOpacity(0.6), BlendMode.dstATop),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Current Diamond',
                          style: TextStyle(
                              color: Colors.lightBlueAccent,
                              fontSize: 22.0,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image(
                              image: AssetImage('assets/images/diamond.png'),
                              width: 40.0,
                              height: 40.0,
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Text(
                              double.parse(user!.diamond).floor().toString(),
                              style: TextStyle(
                                  color: MyColors.whiteColor,
                                  fontSize: 25.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: Transform.translate(
                        offset: Offset(0, -20.0), child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 15.0 , vertical: 20.0),
                      decoration: BoxDecoration(color: MyColors.darkColor , borderRadius: BorderRadius.circular(15.0)),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 8.0,
                                  height: 30.0,
                                  decoration: BoxDecoration(color: MyColors.primaryColor , borderRadius: BorderRadius.circular(3.0)),
                                ),
                                SizedBox(width: 10.0,),
                                Text("diamond_exchange".tr , style: TextStyle(color: Colors.black , fontSize: 18.0 , fontWeight: FontWeight.bold),)
                              ],
                            ),
                            SizedBox(height: 8.0,),
                            Row(
                              children: [
                                SizedBox(width: 20.0,),
                                Text('diamond_exchange_note'.tr , style: TextStyle(color: MyColors.unSelectedColor , fontSize: 14.0),)
                              ],
                            ),
                            SizedBox(height: 15.0,),
                            Row(
                              children: [
                                Container(
                                  height: 45.0,
                                  width: MediaQuery.sizeOf(context).width - 40.0,
                                  child: TextField( controller: diamondTxt, decoration: InputDecoration(labelText: "diamond_exchange_inp_hint".tr ,
                                    suffixIcon: GestureDetector(
                                      onTap: (){
                                        setState(() {
                                          diamondTxt.text =double.parse(user!.diamond).floor().toString()  ;
                                        });
                                      },
                                      child: Container(width: 80.0, height: 45.0,
                                        decoration: BoxDecoration(color: MyColors.primaryColor , borderRadius: BorderRadiusDirectional.only(bottomEnd: Radius.circular(25.0) , topEnd: Radius.circular(25.0))),
                                        child: Center(child: Text('All' , style: TextStyle(color: MyColors.darkColor , fontSize: 18.0),)),
                                      ),
                                    ),
                                    fillColor: MyColors.primaryColor, focusColor: MyColors.primaryColor, focusedBorder: OutlineInputBorder( borderRadius: BorderRadius.circular(25.0) ,
                                      borderSide: BorderSide(color: MyColors.whiteColor) ) ,  border: OutlineInputBorder( borderRadius: BorderRadius.circular(25.0) ) , labelStyle: const TextStyle(color: Colors.black , fontSize: 13.0) ,  ),
                                    style: const TextStyle(color: Colors.black , fontSize: 18.0), textAlign: TextAlign.center, cursorColor: MyColors.primaryColor ,  keyboardType: TextInputType.number,),
                                ),
                              ],
                            ),
                            SizedBox(height: 25.0,),
                            Row(
                              children: [
                                Container(
                                  width: 8.0,
                                  height: 30.0,
                                  decoration: BoxDecoration(color: MyColors.primaryColor , borderRadius: BorderRadius.circular(3.0)),
                                ),
                                SizedBox(width: 10.0,),
                                Text("diamond_exchange_rules".tr , style: TextStyle(color: Colors.black , fontSize: 18.0 , fontWeight: FontWeight.bold),)
                              ],
                            ),
                            SizedBox(height: 15.0,),
                            Column(

                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(Icons.star , color: MyColors.primaryColor, size: 20.0,),
                                    SizedBox(width: 5.0,),
                                    Container(
                                        width: MediaQuery.sizeOf(context).width - 70,
                                        child: Text('wallet_diamond_rule1'.tr , style: TextStyle(color: MyColors.unSelectedColor , fontSize: 18.0),))
                                  ],
                                ),
                                SizedBox(height: 10.0,),
                                Row(
                                  children: [
                                    Icon(Icons.star , color: MyColors.primaryColor, size: 20.0,),
                                    SizedBox(width: 5.0,),
                                    Container(
                                        width: MediaQuery.sizeOf(context).width - 70,  child: Text('wallet_diamond_rule2'.tr + setting!.diamond_to_gold_ratio , style: TextStyle(color: MyColors.unSelectedColor , fontSize: 18.0),))
                                  ],
                                ),
                              ],
                            ),
                            Container(
                              color: MyColors.unSelectedColor,
                              height: 1.0,
                              width: double.infinity,
                              margin: EdgeInsets.symmetric(vertical: 20.0),
                            ),
                            Row(
                              children: [
                                Text('exchanged_gold'.tr , style: TextStyle(color: MyColors.secondaryColor , fontSize: 20.0 , fontWeight: FontWeight.bold),),
                                SizedBox(width: 15.0,),
                                Image(image: AssetImage('assets/images/gold.png') , width: 25.0 , height: 25.0,),
                                SizedBox(width: 15.0,),
                                Text(diamondTxt.text, style: TextStyle(color: Colors.red , fontSize: 25.0 , fontWeight: FontWeight.bold),),
                              ],
                            ),
                            SizedBox(height:20.0),
                            Container(
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(15.0) , color: MyColors.primaryColor ),
                              child: MaterialButton(onPressed: (){
                                convertDiamondToGold();
                              } , child: Text('exchange_btn'.tr , style: TextStyle(color: Colors.white),),),
                            )

                          ],
                        ),
                      ),


                    )),
                  )
                ],
              ),

            ],
          ) : Loading(),
        ) ,
      ),
    );
  }
  Widget googleProvider() => GestureDetector(
     onTap: (){
       //Navigator.push(context, MaterialPageRoute(builder: (context) => const GoogleProductsScreen(),));
     },
    child: Container(
      width: double.infinity,
      padding: EdgeInsets.all(15.0),
      decoration: BoxDecoration(color: Colors.white , borderRadius: BorderRadius.circular(15.0)),
      child: Column(
        children: [
          Row(
            children: [
              Text("Google Pay" , style: TextStyle(color: MyColors.primaryColor , fontSize: 18.0 , fontWeight: FontWeight.bold),),
            ],
          ),
          Container(
            color: MyColors.unSelectedColor,
            height: 1.0,
            width: double.infinity,
            margin: EdgeInsets.symmetric(vertical: 8.0),
          ),
          Row(
            children: [
              Image(image: AssetImage('assets/images/google-pay.png') , width: 80.0,),
              SizedBox(width: 20.0,),
              Text("Google Pay" , style: TextStyle(color: MyColors.primaryColor , fontSize: 18.0), ),
              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  IconButton(onPressed: (){}, icon: Icon(Icons.arrow_forward_ios , color: MyColors.primaryColor,))
                ],
              ))

            ],

          )
        ],
      ),
    ),
  );
  Widget appleProvider() => Container(
    width: double.infinity,
    padding: EdgeInsets.all(15.0),
    decoration: BoxDecoration(color: Colors.black26 , borderRadius: BorderRadius.circular(15.0)),
    child: Column(
      children: [
        Row(
          children: [
            Text("Apple Pay" , style: TextStyle(color: MyColors.unSelectedColor , fontSize: 18.0),),
          ],
        ),
        Container(
          color: MyColors.unSelectedColor,
          height: 1.0,
          width: double.infinity,
          margin: EdgeInsets.symmetric(vertical: 8.0),
        ),
        Row(
          children: [
            Image(image: AssetImage('assets/images/apple-pay.png') , width: 80.0,),
            SizedBox(width: 20.0,),
            Text("Apple Pay" , style: TextStyle(color: MyColors.whiteColor , fontSize: 18.0), ),
            Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                IconButton(onPressed: (){}, icon: Icon(Icons.arrow_forward_ios , color: Colors.white,))
              ],
            ))

          ],

        )
      ],
    ),
  );
  Widget huwaiProvider() => Container(
    width: double.infinity,
    padding: EdgeInsets.all(15.0),
    decoration: BoxDecoration(color: Colors.black26 , borderRadius: BorderRadius.circular(15.0)),
    child: Column(
      children: [
        Row(
          children: [
            Text("Huawei Pay" , style: TextStyle(color: MyColors.unSelectedColor , fontSize: 18.0),),
          ],
        ),
        Container(
          color: MyColors.unSelectedColor,
          height: 1.0,
          width: double.infinity,
          margin: EdgeInsets.symmetric(vertical: 8.0),
        ),
        Row(
          children: [
            Image(image: AssetImage('assets/images/huawei.png') , width: 80.0,),
            SizedBox(width: 20.0,),
            Text("Huawei Pay" , style: TextStyle(color: MyColors.whiteColor , fontSize: 18.0), ),
            Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                IconButton(onPressed: (){}, icon: Icon(Icons.arrow_forward_ios , color: Colors.white,))
              ],
            ))

          ],

        )
      ],
    ),
  );
  Widget getChargeProvider (){
    if(AppContants().AppType == 'GOOGLE'){
      return googleProvider();
    } else if(AppContants().AppType == 'IOS'){
      return appleProvider();
    }
    else if(AppContants().AppType == 'HUWAI'){
      return huwaiProvider();
    }
    else {
      return Container();
    }
  }
  convertDiamondToGold() async{
    print(double.parse(diamondTxt.text) >= 100);
    if(double.parse(diamondTxt.text) >= 100){
      if(double.parse(diamondTxt.text) <= double.parse(user!.diamond) ){
        setState(() {
          isLoading = true ;
        });
        await  WalletServices().exchangeDiamond(user!.id , diamondTxt.text);
        AppUser? res =  await AppUserServices().getUser(user!.id);

        setState(() {
          user = res ;
          isLoading = false ;
          diamondTxt.text = "" ;
        });
      } else {
        Fluttertoast.showToast(
            msg: 'exchange_failed2'.tr,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black26,
            textColor: Colors.orange,
            fontSize: 16.0
        );
      }


      } else {
      Fluttertoast.showToast(
          msg: 'exchange_failed'.tr,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black26,
          textColor: Colors.orange,
          fontSize: 16.0
      );
    }

  }
}
