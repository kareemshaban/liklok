import 'package:LikLok/shared/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.zero,
        child: AppBar(
          backgroundColor: MyColors.blueDarkColor,
          elevation: 0,
        ),
      ),
      body: Container(
        color: MyColors.blueDarkColor,
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 150.0,
                width: 150.0,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(15.0)),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: Image(
              image: AssetImage('assets/images/logo_blue_big.png'),
              width: 100,
              height: 100,
            )),
            SizedBox(height: 20.0),
            Text(
              "splash_party".tr,
              style: TextStyle(color: MyColors.primaryColor, fontSize: 20.0),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}
