import 'dart:convert';
import 'dart:io';

import 'package:LikLok/helpers/DesigGiftHelper.dart';
import 'package:LikLok/helpers/MallHelper.dart';
import 'package:LikLok/models/AppUser.dart';
import 'package:LikLok/models/Category.dart';
import 'package:LikLok/models/Design.dart';
import 'package:LikLok/models/Mall.dart';
import 'package:LikLok/models/Medal.dart';
import 'package:LikLok/models/Relation.dart';
import 'package:LikLok/shared/components/Constants.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
class DesignServices {
  static MallHelper? helper  ;
  helperSetter(MallHelper u){
    helper = u ;
  }
  MallHelper? helperGetter(){
    return helper ;
  }

  Future<MallHelper> getAllCatsAndDesigns() async {
    final response = await http.get(Uri.parse('${BASEURL}designa/all'));
    print(response.body);
    List<Category> cats = [] ;
    List<Mall> designs = [] ;
    List<RelationModel> relations = [] ;
    MallHelper helper  = MallHelper(categories: cats , designs: designs);
    if (response.statusCode == 200) {
      final Map jsonData = json.decode(response.body);
      for( var i = 0 ; i < jsonData['categories'].length ; i ++ ){
        Category cat = Category.fromJson(jsonData['categories'][i]);
        cats.add(cat);
      }
      for( var i = 0 ; i < jsonData['designs'].length ; i ++ ){
        Mall design = Mall.fromJson(jsonData['designs'][i]);
        designs.add(design);
      }
      for( var i = 0 ; i < jsonData['relations'].length ; i ++ ){
        RelationModel relation = RelationModel.fromJson(jsonData['relations'][i]);
        relations.add(relation);
      }

       helper.designs = designs ;
       helper.categories = cats ;
       helper.relations = relations ;
      return helper ;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }

  }

  Future  purchaseDesign(user_id , benefit_user , design_id  ) async {
    print(user_id);
    print(benefit_user);
    print(design_id);
    var response = await http.post(
      Uri.parse('${BASEURL}store/design/purchase'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'user_id': user_id.toString(),
        'benefit_user': benefit_user.toString()  ,
        'design_id': design_id.toString() ,
      }),
    );
    if (response.statusCode == 200) {
      final Map jsonData = json.decode(response.body);
      if(jsonData['state'] == "success"){
        Fluttertoast.showToast(
            msg: jsonData['message'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black26,
            textColor: Colors.orange,
            fontSize: 16.0
        );

      } else if(jsonData['state'] == "failed"){
        Fluttertoast.showToast(
            msg: jsonData['message'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black26,
            textColor: Colors.orange,
            fontSize: 16.0
        );
      }

    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  Future<DesignGiftHelper> useDesign(user_id , design_cat , design_id) async {
    List<Design> designs  = [];
    List<Design> gifts  = [];
    DesignGiftHelper helper = DesignGiftHelper(designs: designs , gifts: gifts) ;
    var response = await http.post(
      Uri.parse('${BASEURL}designa/use'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
          'user_id': user_id.toString(),
        'design_cat': design_cat.toString(),
        'design_id': design_id.toString()
      }),
    );
    if (response.statusCode == 200) {
      final Map jsonData = json.decode(response.body);
      for( var i = 0 ; i < jsonData['designs'].length ; i ++ ){
        Design design = Design.fromJson(jsonData['designs'][i]);
        if(getRemainDays(design)){
          designs.add(design);
        }

      }
      for( var i = 0 ; i < jsonData['gifts'].length ; i ++ ){
        Design gift = Design.fromJson(jsonData['gifts'][i]);
        gifts.add(gift);
      }
      helper.designs = designs ;
      helper.gifts = gifts ;
      Fluttertoast.showToast(
          msg: 'remote_design_msg_design'.tr,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black26,
          textColor: Colors.orange,
          fontSize: 16.0
      );
      return helper ;

    } else {
      final Map jsonData = json.decode(response.body);
      Fluttertoast.showToast(
          msg: jsonData['message'],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black26,
          textColor: Colors.orange,
          fontSize: 16.0
      );
      throw Exception('Failed to load tags');
    }
  }

  bool getRemainDays(design){

    final DateTime dateOne = DateTime.parse(design.available_until);
    final DateTime dateTwo = DateTime.now() ;

    final Duration duration = dateOne.difference(dateTwo);
    print(duration.inDays );
    return duration.inDays > -1  ;
  }

  Future<List<Medal>> getAllMedals() async{
    final response = await http.get(Uri.parse('${BASEURL}designs/medal/all'));
    List<Medal> medals = [] ;
    if (response.statusCode == 200) {
      final Map jsonData = json.decode(response.body);
      for( var i = 0 ; i < jsonData['medals'].length ; i ++ ){
        Medal cat = Medal.fromJson(jsonData['medals'][i]);
        medals.add(cat);
      }

      return medals ;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }


  Future<void> purchaseVip(user_id , vip   ) async {

    var response = await http.post(
      Uri.parse('${BASEURL}vip/purchaseVip'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'user_id': user_id.toString(),
        'vip': vip.toString()  ,
      }),
    );
    print(response.body);
    if (response.statusCode == 200) {
      final Map jsonData = json.decode(response.body);
      if(jsonData['state'] == "success"){
        Fluttertoast.showToast(
            msg: jsonData['message'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black26,
            textColor: Colors.orange,
            fontSize: 16.0
        );

      } else if(jsonData['state'] == "failed"){
        Fluttertoast.showToast(
            msg: jsonData['message'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black26,
            textColor: Colors.orange,
            fontSize: 16.0
        );
      }

    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }
}