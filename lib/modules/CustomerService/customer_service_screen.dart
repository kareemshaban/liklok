import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../shared/styles/colors.dart';

class CustomerService extends StatefulWidget {
  const CustomerService({super.key});

  @override
  State<CustomerService> createState() => _CustomerServiceState();
}

final TextEditingController _messageController = TextEditingController();

class _CustomerServiceState extends State<CustomerService> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: MyColors.whiteColor, //change your color here
        ),
        centerTitle: true,
        backgroundColor: MyColors.solidDarkColor,
        title:Row(
          children: [
            Image(image: AssetImage('assets/images/customer-service.png') , width: 25.0, height: 25.0,),
            SizedBox(width: 10.0,),
            Text("customer_service_title".tr , style: TextStyle(color: MyColors.whiteColor,fontSize: 17.0) ,),
          ],
        )
      ),

      body: SafeArea(
        child: Container(
          color: MyColors.darkColor,
          width: double.infinity,
          height: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 10.0 , vertical: 10.0) ,
          child: Column(
            children: [
            Center(child: Column(
                children: [
                  Image(image: AssetImage('assets/images/sad.png') , width: 100.0 , height: 100.0,),
                  SizedBox(height: 30.0,),
                  Text('no_data'.tr , style: TextStyle(color: Colors.red , fontSize: 18.0 ) ,)


                ],), )
              // Expanded(
              //     child: ListView()
              //
              // ),
              // Container(
              //   height: 50.0,
              //
              //   child: Row(
              //     children: [
              //       Expanded(
              //           child: Container(
              //             decoration: BoxDecoration(
              //                 color: Colors.grey[600],
              //                 borderRadius: BorderRadius.circular(13.0)
              //             ),
              //             height: 45.0,
              //             child: TextFormField(
              //                 controller: _messageController,
              //                 cursorColor: Colors.grey,
              //                 style: TextStyle(color: Colors.white),
              //                 decoration: InputDecoration(
              //                     hintText: 'chat_hint_text_form'.tr,
              //                     hintStyle: TextStyle(
              //                         color: Colors.white, fontSize: 14),
              //                     border: OutlineInputBorder(
              //                       borderRadius: BorderRadius.circular(13.0),
              //                       borderSide: BorderSide(
              //                           color: Colors.grey),
              //                     ),
              //                     focusedBorder: OutlineInputBorder(
              //                       borderSide: BorderSide(
              //                         color: Colors.grey,),
              //                       borderRadius: BorderRadius.circular(13.0),
              //                     ),
              //
              //                 )
              //             ),
              //           )
              //       ),
              //       SizedBox(width: 15.0,),
              //       Container(
              //         height: 40.0,
              //         width: 80,
              //         decoration: BoxDecoration(
              //           color: MyColors.primaryColor,
              //           borderRadius: BorderRadius.circular(10.0),
              //         ),
              //         child: MaterialButton(
              //           onPressed: () {
              //
              //           }, //sendMessage
              //           child: Text('gift_send'.tr, style: TextStyle(
              //               color: MyColors.darkColor,
              //               fontSize: 15.0,
              //               fontWeight: FontWeight.bold),),
              //         ),
              //       ),
              //
              //     ],
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
