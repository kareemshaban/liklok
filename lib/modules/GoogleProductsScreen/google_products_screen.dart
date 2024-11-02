import 'package:LikLok/models/AppUser.dart';
import 'package:LikLok/shared/network/remote/AppUserServices.dart';
import 'package:LikLok/shared/network/remote/WalletServices.dart';
import 'package:LikLok/shared/styles/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pay/pay.dart';
import 'package:LikLok/default_google_pay_config.dart';


class GoogleProductsScreen extends StatefulWidget {
  const GoogleProductsScreen({super.key});

  @override
  State<GoogleProductsScreen> createState() => _GoogleProductsScreenState();
}

class _GoogleProductsScreenState extends State<GoogleProductsScreen> {

  late final Pay _payClient;
  AppUser? user ;



  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setState(() {
      user = AppUserServices().userGetter();
      _payClient = Pay({
        PayProvider.google_pay: PaymentConfiguration.fromJsonString(defaultGooglePay),
        PayProvider.apple_pay: PaymentConfiguration.fromJsonString(defaultApplePay),
      });
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
        title: Text("Google Pay" , style: TextStyle(color: Colors.black),),
      ),
      body: Container(
        color: MyColors.darkColor,
        width: double.infinity,
        height: double.infinity,
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                purchaseItem(PaymentItem(amount:'1.0' , label: 'Total' , status: PaymentItemStatus.final_price ) , '8000');
              },
              child: Row(
                children: [
                  Image(image: AssetImage('assets/images/G1.png'), width: 65.0, height: 65.0,) ,
              
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('8000' , style: TextStyle(color: MyColors.whiteColor , fontSize: 20.0 , fontWeight: FontWeight.bold),) ,
                      Text('get_8000_coins'.tr , style: TextStyle(color: MyColors.unSelectedColor , fontSize: 9.0),)
                    ],
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          margin: EdgeInsets.symmetric(horizontal: 5.0),
              
                          decoration: BoxDecoration(color: MyColors.primaryColor.withOpacity(.7) , borderRadius: BorderRadius.circular(15.0) ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image(image: AssetImage('assets/images/google-pay.png'), width: 35.0, height: 35.0,) ,
                              SizedBox(width: 5.0,),
                              Text("1 \$" , style: TextStyle(color: Colors.white , fontSize: 15.0),)
              
                            ],
                          ),
              
                        ),
                      ],
                    ),
                  )
              
                ],
              ),
            ),
            GestureDetector(
              onTap: (){
                purchaseItem(PaymentItem(amount:'5.0' , label: 'Total' , status: PaymentItemStatus.final_price) , '40000');
              },
              child: Row(
                children: [
                  Image(image: AssetImage('assets/images/G5.png'), width: 65.0, height: 65.0,) ,

                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('40000' , style: TextStyle(color: MyColors.whiteColor , fontSize: 20.0 , fontWeight: FontWeight.bold),) ,
                      Text('get_40000_coins'.tr , style: TextStyle(color: MyColors.unSelectedColor , fontSize: 9.0),)
                    ],
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          margin: EdgeInsets.symmetric(horizontal: 5.0),

                          decoration: BoxDecoration(color: MyColors.primaryColor.withOpacity(.7) , borderRadius: BorderRadius.circular(15.0) ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image(image: AssetImage('assets/images/google-pay.png'), width: 35.0, height: 35.0,) ,
                              SizedBox(width: 5.0,),
                              Text("5 \$" , style: TextStyle(color: Colors.white , fontSize: 15.0),)

                            ],
                          ),

                        ),
                      ],
                    ),
                  )

                ],
              ),
            ),
            GestureDetector(
              onTap: (){
                purchaseItem(PaymentItem(amount:'20.0' , label: 'Total' , status: PaymentItemStatus.final_price) , '160000');
              },
              child: Row(
                children: [
                  Image(image: AssetImage('assets/images/G20.png'), width: 65.0, height: 65.0,) ,

                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('160000' , style: TextStyle(color: MyColors.whiteColor , fontSize: 20.0 , fontWeight: FontWeight.bold),) ,
                      Text('get_160000_coins'.tr , style: TextStyle(color: MyColors.unSelectedColor , fontSize: 9.0),)
                    ],
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          margin: EdgeInsets.symmetric(horizontal: 5.0),

                          decoration: BoxDecoration(color: MyColors.primaryColor.withOpacity(.7) , borderRadius: BorderRadius.circular(15.0) ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image(image: AssetImage('assets/images/google-pay.png'), width: 35.0, height: 35.0,) ,
                              SizedBox(width: 5.0,),
                              Text("20 \$" , style: TextStyle(color: Colors.white , fontSize: 15.0),)

                            ],
                          ),

                        ),
                      ],
                    ),
                  )

                ],
              ),
            ),
            GestureDetector(
              onTap: (){
                purchaseItem(PaymentItem(amount:'50.0' , label: 'Total' , status: PaymentItemStatus.final_price) , '400000');
              },
              child: Row(
                children: [
                  Image(image: AssetImage('assets/images/G50.png'), width: 65.0, height: 65.0,) ,

                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('400000' , style: TextStyle(color: MyColors.whiteColor , fontSize: 20.0 , fontWeight: FontWeight.bold),) ,
                      Text('get_400000_coins'.tr , style: TextStyle(color: MyColors.unSelectedColor , fontSize: 9.0),)
                    ],
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          margin: EdgeInsets.symmetric(horizontal: 5.0),

                          decoration: BoxDecoration(color: MyColors.primaryColor.withOpacity(.7) , borderRadius: BorderRadius.circular(15.0) ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image(image: AssetImage('assets/images/google-pay.png'), width: 35.0, height: 35.0,) ,
                              SizedBox(width: 5.0,),
                              Text("50 \$" , style: TextStyle(color: Colors.white , fontSize: 15.0),)

                            ],
                          ),

                        ),
                      ],
                    ),
                  )

                ],
              ),
            ),
            GestureDetector(
              onTap: (){
                purchaseItem(PaymentItem(amount:'100.0' , label: 'Total' , status: PaymentItemStatus.final_price) , '800000');
              },
              child: Row(
                children: [
                  Image(image: AssetImage('assets/images/G100.png'), width: 65.0, height: 65.0,) ,

                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('800000' , style: TextStyle(color: MyColors.whiteColor , fontSize: 20.0 , fontWeight: FontWeight.bold),) ,
                      Text('get_800000_coins'.tr , style: TextStyle(color: MyColors.unSelectedColor , fontSize: 9.0),)
                    ],
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          margin: EdgeInsets.symmetric(horizontal: 5.0),

                          decoration: BoxDecoration(color: MyColors.primaryColor.withOpacity(.7) , borderRadius: BorderRadius.circular(15.0) ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image(image: AssetImage('assets/images/google-pay.png'), width: 35.0, height: 35.0,) ,
                              SizedBox(width: 5.0,),
                              Text("100 \$" , style: TextStyle(color: Colors.white , fontSize: 15.0),)

                            ],
                          ),

                        ),
                      ],
                    ),
                  )

                ],
              ),
            ),

          ],
        ),
      ),
    );
  }

  purchaseItem( PaymentItem item , String gold ) async{
    final _paymentItems = [
      item
    ];

    final result = await _payClient.showPaymentSelector(
      PayProvider.google_pay,
      _paymentItems,
    );
    print('result');
    print(result);
     try{
       if(result['paymentMethodData']['tokenizationData']['token'] != null){
       await WalletServices().chargeWallet(user!.id , gold , 'TOKEN: ${result['paymentMethodData']['tokenizationData']['token']}');

       }
     } catch(err){

     }





  }

  void onGooglePayResult(paymentResult) {
    // Send the resulting Google Pay token to your server / PSP

  }



}
