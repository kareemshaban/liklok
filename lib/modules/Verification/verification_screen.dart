import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/AppUser.dart';
import '../../shared/components/Constants.dart';
import '../../shared/network/remote/AppUserServices.dart';
import '../../shared/styles/colors.dart';

class Verification extends StatefulWidget {
  const Verification({super.key});

  @override
  State<Verification> createState() => _VerificationState();
}

class _VerificationState extends State<Verification> {
  AppUser? user;
  File? _image;
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: MyColors.whiteColor, //change your color here
        ),
        centerTitle: true,
        backgroundColor: MyColors.solidDarkColor,
        title: Text("verification_title".tr , style: TextStyle(color: MyColors.whiteColor,fontSize: 20.0) ,),
      ),
      body: Container(
        color: MyColors.darkColor,
        width: double.infinity,
        height: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 10.0 , vertical: 10.0),
        child: Column(
          children: [
            Text('verification_id_card'.tr,style: TextStyle(color: MyColors.whiteColor,fontSize: 15.0 ),textAlign:TextAlign.center,),
            SizedBox(height: 20.0,),
            Row(
              children: [
                Column(
                  children: [
                    GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          showPickImageOptions('PHOTO');
                        },
                        child: Image(image: AssetImage('assets/images/id-card.png') , width: 80.0, height: 80.0,)
                    ),
                    Container(
                        width: (MediaQuery.sizeOf(context).width / 2 ) - 20.0,
                        child: Text('verification_id_face'.tr,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: MyColors.whiteColor,fontSize: 12.0 ) )),
                  ],
                ),
                SizedBox(width: 15.0,),
                Column(
                  children: [
                    GestureDetector(
                        onTap: () {
                          showPickImageOptions('PHOTO');
                        },
                        child: Image(image: AssetImage('assets/images/id.png') , width: 80.0, height: 80.0,)
                    ),
                    Container(
                        width: (MediaQuery.sizeOf(context).width / 2 ) - 20.0,
                        child: Text('verification_id_back'.tr,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: MyColors.whiteColor,fontSize: 12.0 ) )),],
                )
              ],
            ),
            SizedBox(height: 35.0,),
            Container(
              padding: EdgeInsetsDirectional.symmetric(horizontal: 30.0 , vertical: 5.0),
              decoration: BoxDecoration(color: MyColors.primaryColor , borderRadius: BorderRadius.circular(20.0)),
              child: MaterialButton(onPressed: (){();} ,
                child: Text("verification_verify".tr , style: TextStyle(color: Colors.black , fontSize: 18.0),),
              ),
            ),
          ],
        ),
      ),
    );

  }

  Future getImageFromGalleryOrCamera(ImageSource _source , which) async {
    final pickedFile = await ImagePicker().pickImage(source: _source);

    setState(() {
      if (pickedFile != null) {
        if(which == "PHOTO"){
          _image = File(pickedFile.path);
          uploadProfileImg();
        }
      }
    });
  }


  uploadProfileImg() async {
    await AppUserServices().updateProfileImg(user!.id, _image);
    AppUser? res = await AppUserServices().getUser(user!.id);
    AppUserServices().userSetter(res!);
    setState(() {
      user = res;
    });
    Fluttertoast.showToast(
        msg: 'edit_profile_photo_msg'.tr,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black26,
        textColor: Colors.orange,
        fontSize: 16.0);
  }


  Future showPickImageOptions(which) async {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            child: Text('add_photo_gallery'.tr),
            onPressed: () {
              // close the options modal
              Navigator.of(context).pop();
              // get image from gallery
              getImageFromGalleryOrCamera(ImageSource.gallery , which);
            },
          ),
          CupertinoActionSheetAction(
            child: Text('add_camera'.tr),
            onPressed: () {
              // close the options modal
              Navigator.of(context).pop();
              // get image from camera
              getImageFromGalleryOrCamera(ImageSource.camera , which);
            },
          ),
        ],
      ),
    );
  }


  String? getUserImage(){
    if(user!.img.startsWith('https')){
      return user?.img.toString() ;
    } else {
      return '${ASSETSBASEURL}AppUsers/${user?.img}' ;
    }
  }

}
