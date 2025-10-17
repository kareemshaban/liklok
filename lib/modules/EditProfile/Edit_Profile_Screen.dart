import 'dart:io';
import 'dart:math';

import 'package:LikLok/modules/Help/help_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:LikLok/models/AppUser.dart';
import 'package:LikLok/models/Country.dart';
import 'package:LikLok/models/Tag.dart';
import 'package:LikLok/models/UserHoppy.dart';
import 'package:LikLok/shared/components/Constants.dart';
import 'package:LikLok/shared/network/remote/AppUserServices.dart';
import 'package:LikLok/shared/network/remote/CountryService.dart';
import 'package:LikLok/shared/styles/colors.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  AppUser? user;
  List<Country> countries = [];
  List<Tag> tags = [];
  List<UserHoppy>? hoppies = [];
  String selectedCountry = "1";
  String selectedGender = "0";
  String selectedDate = "2000-01-01 00:00:00";
  var userNameController = TextEditingController();
  File? _image;
  File? _cover;
  final picker = ImagePicker();
  bool _isLoading = false ;

  void ChangeProfilePhoto(img , userid){
    FirebaseFirestore.instance.collection('users')
        .where("id" , isEqualTo: userid).get()
        .then((value) => {
          value.docs.map((doc) => doc.reference.update({'img': img}))
    });
  }
  void ChangeUserName(name , userid){
    FirebaseFirestore.instance.collection('users')
        .where("id" , isEqualTo: userid).get()
        .then((value) => {
      value.docs.map((doc) => doc.reference.update({'img': name}))
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      user = AppUserServices().userGetter();
      selectedGender = user!.gender.toString() ;
      countries = CountryService().countryGetter();
      selectedCountry = user!.country != 0
          ? user!.country.toString()
          : countries[1].id.toString();
      hoppies = user!.hoppies;
      selectedDate = user!.birth_date;
      userNameController.text = user!.name;
    });
    getHoppies();
  }

  getHoppies() async {
    List<Tag> res = await AppUserServices().getAllHoppies();
    setState(() {
      this.tags = res;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: MyColors.whiteColor, //change your color here
        ),
        centerTitle: true,
        backgroundColor: MyColors.solidDarkColor,
        title: Text(
          "edit_profile_title".tr,
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
            icon: Icon(
              FontAwesomeIcons.circleQuestion,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const HelpScreen(),));
            },
          )
        ],
      ),
      body: SafeArea(
        child: Container(
          color: MyColors.darkColor,
          width: double.infinity,
          height: double.infinity,
          padding: EdgeInsets.only(bottom: 30.0),
          child: SingleChildScrollView(
            child: (Column(
              children: [
                Container(
                  padding: EdgeInsets.only(top: 10.0),
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      showPickImageOptions('PHOTO');
                    },
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        CircleAvatar(
                          backgroundColor: user!.gender == 0
                              ? MyColors.blueColor
                              : MyColors.pinkColor,
                          backgroundImage: _image == null
                              ? (user!.img != ""
                                  ? CachedNetworkImageProvider(getUserImage()!)
                                  : null)
                              : Image.file(
                                  _image!,
                                  width: 100,
                                ).image,
                          radius: 50,
                          child: user?.img == "" && _image == null
                              ? Text(
                                  user!.name.toUpperCase().substring(0, 1) +
                                      (user!.name.contains(" ")
                                          ? user!.name
                                              .substring(user!.name.indexOf(" "))
                                              .toUpperCase()
                                              .substring(1, 2)
                                          : ""),
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 28.0,
                                      fontWeight: FontWeight.bold),
                                )
                              : null,
                        ),
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            showPickImageOptions('PHOTO');
                          },
                          child: Transform.translate(
                            offset: Offset(0, 10.0),
                            child: CircleAvatar(
                              radius: 20.0,
                              backgroundColor: Colors.black54,
                              child: Icon(
                                Icons.camera_alt_outlined,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 6.0,
                  color: MyColors.solidDarkColor,
                  margin: EdgeInsetsDirectional.only(top: 20.0),
                ),
                Container(
                  padding: EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 8.0,
                            height: 30.0,
                            decoration: BoxDecoration(
                                color: MyColors.primaryColor,
                                borderRadius: BorderRadius.circular(3.0)),
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          Text(
                            "edit_profile_Cover_photo".tr,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                showPickImageOptions('COVER');
                              },
                              child:  Image(image: _cover == null ? AssetImage('assets/images/select_img.png') :
                              Image.file(
                                _cover!,
                                width: 100,
                              ).image
                                , width: 100,),
                            ),
                            Expanded(
                                child: Column(
                              children: [
                                ElevatedButton.icon(
                                  onPressed: (){
                                    uploadCoverPhoto();
                                  },
                                  style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(16.0) , backgroundColor: MyColors.primaryColor ,
                                  ),
                                  icon: _isLoading
                                      ? Container(
                                    width: 24,
                                    height: 24,
                                    padding: const EdgeInsets.all(2.0),
                                    child: const CircularProgressIndicator(
                                      color: Colors.black,
                                      strokeWidth: 3,
                                    ),
                                  )
                                      :  Icon(Icons.upload , color: MyColors.darkColor),
                                  label:  Text('edit_profile_upload'.tr , style: TextStyle(color: MyColors.darkColor , fontSize: 15.0), ),
                                )
                              ],
                            ))
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 6.0,
                  color: MyColors.solidDarkColor,
                  margin: EdgeInsetsDirectional.only(top: 20.0),
                ),
                Container(
                  padding: EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 8.0,
                            height: 30.0,
                            decoration: BoxDecoration(
                                color: MyColors.primaryColor,
                                borderRadius: BorderRadius.circular(3.0)),
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          Text(
                            "edit_profile_basic_information".tr,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Row(
                          children: [
                            Text(
                              "ID",
                              style: TextStyle(
                                  fontSize: 16.0,
                                  color: MyColors.unSelectedColor,
                                  fontWeight: FontWeight.bold),
                            ),
                            Expanded(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      user!.tag,
                                      style: TextStyle(
                                          fontSize: 16.0, color: Colors.black),
                                    ),
                                    SizedBox(
                                      width: 5.0,
                                    ),
                                    IconButton(
                                      onPressed: () {},
                                      icon: Icon(
                                        Icons.arrow_forward_ios_outlined,
                                        color: Colors.black,
                                        size: 20.0,
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ))
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Row(
                          children: [
                            Text(
                              "edit_profile_user_name".tr,
                              style: TextStyle(
                                  fontSize: 16.0,
                                  color: MyColors.unSelectedColor,
                                  fontWeight: FontWeight.bold),
                            ),
                            Expanded(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () async {
                                    await _displayTextInputDialog(context);
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        user!.name,
                                        style: TextStyle(
                                            fontSize: 16.0, color: Colors.black),
                                      ),
                                      SizedBox(
                                        width: 5.0,
                                      ),
                                      IconButton(
                                          onPressed: () {},
                                          icon: Icon(FontAwesomeIcons.pen,
                                              color: Colors.black, size: 20.0))
                                    ],
                                  ),
                                )
                              ],
                            ))
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Row(
                          children: [
                            Text(
                              "edit_profile_gender".tr,
                              style: TextStyle(
                                  fontSize: 16.0,
                                  color: MyColors.unSelectedColor,
                                  fontWeight: FontWeight.bold),
                            ),
                            Expanded(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    DropdownButtonHideUnderline(
                                      child: DropdownButton(
                                        items: getGenders(),
                                        onChanged: (value) async {
                                          print(value);
                                          setState(() {
                                            selectedGender = value;
                                          //  updateUserCountry(value);
                                            updateUserGender(value);
                                          });
                                        },
                                        value: selectedGender,
                                        dropdownColor: Colors.white,
                                        menuMaxHeight: 200.0,
                                      ),
                                    ),
        
                                  ],
                                )
                              ],
                            ))
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Row(
                          children: [
                            Text(
                              "edit_profile_date_of_birth".tr,
                              style: TextStyle(
                                  fontSize: 16.0,
                                  color: MyColors.unSelectedColor,
                                  fontWeight: FontWeight.bold),
                            ),
                            Expanded(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () {
                                    _selectDate(context);
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        formattedDate(selectedDate).toString(),
                                        style: TextStyle(
                                            fontSize: 16.0, color: Colors.black),
                                      ),
                                      SizedBox(
                                        width: 5.0,
                                      ),
                                      IconButton(
                                          onPressed: () {},
                                          icon: Icon(FontAwesomeIcons.calendar,
                                              color: Colors.black, size: 20.0))
                                    ],
                                  ),
                                )
                              ],
                            ))
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Row(
                          children: [
                            Text(
                              "edit_profile_country".tr,
                              style: TextStyle(
                                  fontSize: 16.0,
                                  color: MyColors.unSelectedColor,
                                  fontWeight: FontWeight.bold),
                            ),
                            Expanded(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    DropdownButtonHideUnderline(
                                      child: DropdownButton(
                                        items: getItems(),
                                        onChanged: (value) async {
                                          print(value);
                                          setState(() {
                                            selectedCountry = value;
                                            updateUserCountry(value);
                                          });
                                        },
                                        value: selectedCountry,
                                        dropdownColor: MyColors.darkColor,
                                        menuMaxHeight: 200.0,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5.0,
                                    ),
                                    IconButton(
                                        onPressed: () {},
                                        icon: Icon(FontAwesomeIcons.flag,
                                            color: Colors.black, size: 20.0))
                                  ],
                                )
                              ],
                            ))
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 6.0,
                  color: MyColors.solidDarkColor,
                  margin: EdgeInsetsDirectional.only(top: 20.0),
                ),
                Container(
                  padding: EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 8.0,
                            height: 30.0,
                            decoration: BoxDecoration(
                                color: MyColors.primaryColor,
                                borderRadius: BorderRadius.circular(3.0)),
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          Text(
                            "edit_profile_my_tags".tr,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children:
                              hoppies!.map((e) => hoppyListItem(e)).toList(),
                        ),
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              showModalBottomSheet(
                                  context: context,
                                  builder: (ctx) => TagsBottomSheet());
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15.0, vertical: 8.0),
                              decoration: BoxDecoration(
                                  color: Colors.black45,
                                  borderRadius: BorderRadius.circular(25.0)),
                              child: Text(
                                "edit_profile_update".tr,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15.0),
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ],
            )),
          ),
        ),
      ),
    );
  }

  String formattedDate(dateTime) {
    const DATE_FORMAT = 'dd/MM/yyyy';
    print('dateTime ($dateTime)');
    return DateFormat(DATE_FORMAT).format(DateTime.parse(dateTime));
  }

  List<DropdownMenuItem> getItems() {
    return countries
        .where((element) => element.id > 0)
        .map<DropdownMenuItem<String>>((Country country) {
      return DropdownMenuItem<String>(
        value: country.id.toString(),
        child: Container(
          child: Row(
            children: [
              SizedBox(
                width: 5.0,
              ),
              Image(
                image:
                    CachedNetworkImageProvider(ASSETSBASEURL + 'Countries/' + country.icon),
                width: 20.0,
              ),
              SizedBox(
                width: 5.0,
              ),
              Text(
                country.name,
                style: TextStyle(color: Colors.black, fontSize: 15.0),
              )
            ],
          ),
        ),
      );
    }).toList();
  }

  List<DropdownMenuItem> getGenders() {
    return [
    DropdownMenuItem<String>(
      value: '0',
      child: Container(
        child: Row(
          children: [
            SizedBox(
              width: 5.0,
            ),
            Icon(FontAwesomeIcons.male , size: 20.0 , color: Colors.black,),
            SizedBox(
              width: 5.0,
            ),
            Text(
              'edit_profile_male'.tr,
              style: TextStyle(color: Colors.black, fontSize: 15.0),
            )
          ],
        ),
      ),
    ),
      DropdownMenuItem<String>(
        value: '1',
        child: Container(
          child: Row(
            children: [
              SizedBox(
                width: 5.0,
              ),
              Icon(FontAwesomeIcons.female , size: 20.0 , color: Colors.black,),
              SizedBox(
                width: 5.0,
              ),
              Text(
                'edit_profile_female'.tr,
                style: TextStyle(color: Colors.black, fontSize: 15.0),
              )
            ],
          ),
        ),
      ),

    ].toList();


  }


  Widget hoppyListItem(tag) => Container(
        margin: EdgeInsets.symmetric(horizontal: 10.0),
        child: DottedBorder(
          options: RectDottedBorderOptions(
           // borderType: BorderType.RRect,
            color: MyColors.primaryColor,
            strokeWidth: 1,
            dashPattern: [8, 4],
            strokeCap: StrokeCap.round,
           // radius: Radius.circular(100.0),
          ),

          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
            decoration: BoxDecoration(
                border: Border.all(
                    color: Colors.transparent,
                    width: 1.0,
                    style: BorderStyle.solid),
                borderRadius: BorderRadius.circular(25.0),
                color: MyColors.blueColor.withAlpha(100)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  '#${tag.name}',
                  style: TextStyle(color: MyColors.whiteColor, fontSize: 15.0),
                )
              ],
            ),
          ),
        ),
      );

  Widget tagListItem(tag) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () async {
          if (hoppies!.where((element) => element.id == tag.id).length == 0) {
            user = await AppUserServices().addHoppy(user!.id, tag.id, "ADD");
            setState(() {
              hoppies = user!.hoppies;
              print(hoppies);
            });
          } else {
            user = await AppUserServices().addHoppy(user!.id, tag.id, "DEL");
            setState(() {
              hoppies = user!.hoppies;
            });
          }
          Fluttertoast.showToast(
              msg: "edit_profile_tag_msg".tr,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.black26,
              textColor: Colors.orange,
              fontSize: 16.0);
          Navigator.pop(context);
        },
        child: Container(
          height: 60.0,
          width: MediaQuery.of(context).size.width / 3,
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
          decoration: BoxDecoration(
              border: Border.all(
                  color: Colors.transparent,
                  width: 1.0,
                  style: BorderStyle.solid),
              borderRadius: BorderRadius.circular(25.0),
              color: hoppies!.where((element) => element.id == tag.id).isEmpty
                  ? MyColors.solidDarkColor.withAlpha(100)
                  : MyColors.primaryColor.withAlpha(100)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '#${tag.name}',
                style: TextStyle(color: MyColors.whiteColor, fontSize: 15.0),
              )
            ],
          ),
        ),
      );

  Widget TagsBottomSheet() => Container(
      color: MyColors.darkColor,
      padding: EdgeInsets.all(10.0),
      child: GridView.count(
        crossAxisCount: 3,
        childAspectRatio: (MediaQuery.of(context).size.width / 180),
        padding: const EdgeInsets.all(4.0),
        mainAxisSpacing: 20.0,
        crossAxisSpacing: 10.0,
        children: tags.map((tag) => tagListItem(tag)).toList(),
      ));

  updateUserCountry(val) async {
    AppUser? res = await AppUserServices().updateCountry(user!.id, val);
    AppUserServices().userSetter(res!);
    setState(() {
      user = res;
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.parse(selectedDate),
      firstDate: DateTime(1900, 8),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.fromSwatch(
              primarySwatch: Colors.orange,
              accentColor: MyColors.blueColor,
              backgroundColor: MyColors.darkColor,
              cardColor: MyColors.darkColor,
            ),
            dialogBackgroundColor: MyColors.darkColor,
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != selectedDate) {
      print(formattedDate(picked.toString()));
      setState(() {
        selectedDate = (picked.toString());
        updateUserBirthDate(selectedDate);
      });
    }
  }

  updateUserBirthDate(date) async {
    AppUser? res = await AppUserServices().updateBirthdate(user!.id, date);
    AppUserServices().userSetter(res!);
    setState(() {
      user = res;
    });
  }

  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return Container(
          child: AlertDialog(
            backgroundColor: MyColors.darkColor,
            title: Text(
              'edit_profile_user_name_title'.tr,
              style: TextStyle(color: Colors.white, fontSize: 20.0),
              textAlign: TextAlign.center,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "edit_profile_characters !".tr,
                      style: TextStyle(
                          color: MyColors.unSelectedColor, fontSize: 13.0),
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
                Container(
                  height: 70.0,
                    child: TextField(
                      controller: userNameController,
                      style: TextStyle(color: Colors.white),
                      cursorColor: MyColors.primaryColor,
                      maxLength: 20,
                      decoration: InputDecoration(
                          hintText: "edit_profile_enter_user_name".tr,
                          hintStyle: TextStyle(color: Colors.white),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(color: MyColors.whiteColor)),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0))),
                    ),
                ),
              ],
            ),
            actions: <Widget>[
              Container(
                decoration: BoxDecoration(
                    color: MyColors.solidDarkColor,
                    borderRadius: BorderRadius.circular(15.0)),
                child: MaterialButton(
                  child: Text(
                    'edit_profile_cancel'.tr,
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    Navigator.pop(context);
                  },
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    color: MyColors.primaryColor,
                    borderRadius: BorderRadius.circular(15.0)),
                child: MaterialButton(
                  child: Text(
                    'edit_profile_edit'.tr,
                    style: TextStyle(color: MyColors.darkColor),
                  ),
                  onPressed: () async {
                    AppUser? res = await AppUserServices()
                        .updateName(user!.id, userNameController.text);
                    ChangeUserName(res!.name , res.id) ;
                    setState(() {
                      user = res;
                      AppUserServices().userSetter(res!);
                      Navigator.pop(context);
                    });
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }




  Future getImageFromGalleryOrCamera(ImageSource _source , which) async {
    final pickedFile = await ImagePicker().pickImage(source: _source);

    setState(() {
      if (pickedFile != null) {
        if(which == "PHOTO"){
          _image = File(pickedFile.path);
          uploadProfileImg();
        } else if(which == "COVER"){
          _cover = File(pickedFile.path);
        // uploadCoverPhoto();
        }

      }
    });
  }

  uploadProfileImg() async {
    await AppUserServices().updateProfileImg(user!.id, _image);
    AppUser? res = await AppUserServices().getUser(user!.id);
    AppUserServices().userSetter(res!);
    ChangeProfilePhoto(res.img , res.id) ;
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

  uploadCoverPhoto() async {
    setState(() {
      _isLoading = true ;
    });

    await AppUserServices().updateProfileCover(user!.id, _cover);
    AppUser? res = await AppUserServices().getUser(user!.id);
    AppUserServices().userSetter(res!);
    setState(() {
      user = res;
      _isLoading = false ;
    });
    Fluttertoast.showToast(
        msg: 'edit_profile_Cover_msg'.tr,
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

  updateUserGender(gender) async {
    AppUser? res = await AppUserServices().updateGender(user!.id, gender);
    AppUserServices().userSetter(res!);
    setState(() {
      user = res;
    });
  }
}
