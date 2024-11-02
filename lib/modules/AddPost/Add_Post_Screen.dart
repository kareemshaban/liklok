import 'dart:io';

import 'package:LikLok/layout/tabs_screen.dart';
import 'package:LikLok/models/AppUser.dart';
import 'package:LikLok/models/Tag.dart';
import 'package:LikLok/modules/Moments/Moments_Screen.dart';
import 'package:LikLok/shared/components/Constants.dart';
import 'package:LikLok/shared/network/remote/AppUserServices.dart';
import 'package:LikLok/shared/network/remote/PostServices.dart';
import 'package:LikLok/shared/styles/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../Loading/loadig_screen.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => AddPostScreenState();
}

class AddPostScreenState extends State<AddPostScreen> {
  AppUser? user ;
  List<Tag> tags = [];
  int selectedTag = 0 ;
  File? _image;
  final picker = ImagePicker();
  var contentController = TextEditingController()  ;
  bool _isLoading = false ;
  bool loading = false ;

  @override
  void initState()  {
    // TODO: implement initState
    super.initState();
    getUser();
    getTags();
  }
  void getUser() async{
    if(mounted){
    setState(() {

        loading = true ;
        user =  AppUserServices().userGetter();
    });
    }
  }
  getTags() async {
    List<Tag> res = await PostServices().getAllTags();
    if(mounted) {
      setState(() {
        tags = res;
        selectedTag = tags[0].id;
        loading = false;
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
           elevation: 0.0,
           backgroundColor: MyColors.solidDarkColor,
           title: user != null ? Row(
             children: [
               CircleAvatar(
                 backgroundColor: user?.gender == 0 ? MyColors.blueColor : MyColors.pinkColor ,
                 backgroundImage: user?.img != "" ?  CachedNetworkImageProvider(getUserImage()!) : null,
                 radius: 18,
                 child: user?.img == "" ?
                 Text(user!.name.toUpperCase().substring(0 , 1) +
                     (user!.name.contains(" ") ? user!.name.substring(user!.name.indexOf(" ")).toUpperCase().substring(1 , 2) : ""),
                   style: const TextStyle(color: Colors.white , fontSize: 18.0 , fontWeight: FontWeight.bold),) : null,
               ),
               SizedBox(width: 5.0,),
               Text(user!.name.length > 11 ?  user!.name.substring(0, 11)+'...' : user!.name , style: TextStyle(color: MyColors.whiteColor , fontSize: 15.0 , fontWeight: FontWeight.bold) ,)
             ],
           ) : SizedBox(width: 1,),
           actions: [

             ElevatedButton.icon(
               onPressed: (){
                 post();
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
               label:  Text('add_post'.tr , style: TextStyle(color: MyColors.darkColor , fontSize: 13.0), ),
             ),

             SizedBox(width: 20.0,),

           ],
         ),
      body: Container(
        color: MyColors.darkColor,
        height: double.infinity ,
        child: loading ? Loading(): SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: TextField(
                  controller: contentController,
                  keyboardType: TextInputType.multiline,
                  maxLines: 5,
                  cursorColor: MyColors.primaryColor,
                  decoration: InputDecoration(border: InputBorder.none , labelText: "add_post_label".tr , labelStyle: TextStyle(color: Colors.grey , fontSize: 18.0)),
                  style: TextStyle(color: MyColors.whiteColor ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: GestureDetector(child: _image == null ? Image(image: AssetImage('assets/images/select_img.png') , width: 90.0, ) : Image.file(_image! , width: 100,) ,  onTap: (){showPickImageOptions(); }),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  width: double.infinity,
                  height: 1.0,
                  color: Colors.grey,
                
                ),
              ),
              Container(
                  height: 40.0,
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child:
               ListView.separated(itemBuilder:(ctx , index) => tagItemBuilder(index), separatorBuilder: (ctx , index) => seperatedItem(), itemCount: tags.length , scrollDirection: Axis.horizontal,)
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget tagItemBuilder(index) => TextButton(onPressed: () { setState(() {
    selectedTag = tags[index].id ;
  }); },
  child: Text('#' + tags[index].name , style: TextStyle(color: selectedTag ==  tags[index].id ? MyColors.primaryColor : MyColors.whiteColor , fontSize: 18.0)) ,);
  Widget seperatedItem() => SizedBox(width: 15.0,);


  Future getImageFromGalleryOrCamera(ImageSource _source) async {
    final pickedFile = await ImagePicker().pickImage(source: _source);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  Future showPickImageOptions() async {
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
              getImageFromGalleryOrCamera(ImageSource.gallery);
            },
          ),
          CupertinoActionSheetAction(
            child: Text('add_camera'.tr),
            onPressed: () {
              // close the options modal
              Navigator.of(context).pop();
              // get image from camera
              getImageFromGalleryOrCamera(ImageSource.camera);
            },
          ),
        ],
      ),
    );
  }
  post() async {
   setState(() {
     _isLoading = true ;
   });
   await PostServices().AddPost(_image , contentController.text , user!.id , selectedTag);
   setState(() {
     _isLoading = false ;
   });
    Fluttertoast.showToast(
        msg: 'add_post_msg'.tr,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black26,
        textColor: Colors.orange,
        fontSize: 16.0
    );
    Navigator.pop(context);

  }

  String? getUserImage(){
    if(user!.img.startsWith('https')){
      return user?.img.toString() ;
    } else {
      return '${ASSETSBASEURL}AppUsers/${user?.img}' ;
    }
  }

}
