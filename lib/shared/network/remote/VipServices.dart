import 'dart:convert';

import 'package:LikLok/models/Design.dart';
import 'package:LikLok/models/Mall.dart';
import 'package:LikLok/models/Vip.dart';
import 'package:LikLok/shared/components/Constants.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class VipServices {

  Future<List<Mall>> getAllVip() async {
    final response = await http.get(Uri.parse('${BASEURL}vip/all'));
    List<Mall> designs = [] ;
    print(response.body);
    if (response.statusCode == 200) {
      final Map jsonData = json.decode(response.body);

      for( var i = 0 ; i < jsonData['designs'].length ; i ++ ){
        Mall design = Mall.fromJson(jsonData['designs'][i]);
        designs.add(design);
      }

      return designs ;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }

  }
  Future<List<Vip>> getAllVipTags() async {
    final response = await http.get(Uri.parse('${BASEURL}vip/getAll'));
    List<Vip> vips = [] ;
    if (response.statusCode == 200) {
      final Map jsonData = json.decode(response.body);

      for( var i = 0 ; i < jsonData['vips'].length ; i ++ ){
        Vip design = Vip.fromJson(jsonData['vips'][i]);
        vips.add(design);
      }

      return vips ;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }

  }

  Future<List<Vip>> getUserVips(user_id) async {
    final response = await http.get(Uri.parse('${BASEURL}vip/getUserVips/${user_id}'));
    List<Vip> vips = [] ;
    List<Mall> designs = [] ;
    if (response.statusCode == 200) {
      final Map jsonData = json.decode(response.body);

      for( var i = 0 ; i < jsonData['vips'].length ; i ++ ) {
        Vip vip = Vip.fromJson(jsonData['vips'][i]);
        if (getRemainDays(vip)) {
          designs = [];
          for (var j = 0; j < jsonData['vips'][i]['designs'].length; j ++) {
            Mall design = Mall.fromJson(jsonData['vips'][i]['designs'][i]);
            designs.add(design);
          }
          vip.designs = designs;
          vips.add(vip);
        }
      }


      return vips ;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }

  }


  Future<List<Vip>>  useDesign(user_id , vip_id ) async {
    List<Vip> vips = [] ;
    List<Mall> designs = [] ;
    var response = await http.post(
      Uri.parse('${BASEURL}vip/use'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'user_id': user_id.toString(),
        'vip_id': vip_id.toString(),
      }),
    );

    if (response.statusCode == 200) {
      final Map jsonData = json.decode(response.body);
          print(response.body);
      for( var i = 0 ; i < jsonData['vips'].length ; i ++ ){
        Vip vip = Vip.fromJson(jsonData['vips'][i]);
        designs = [] ;
        for( var j = 0 ; j < jsonData['vips'][i]['designs'].length ; j ++ ){
          Mall design =  Mall.fromJson(jsonData['vips'][i]['designs'][i])  ;
          designs.add(design);
        }
        vip.designs = designs ;
        vips.add(vip);
      }
      Fluttertoast.showToast(
          msg: 'remote_design_msg_design'.tr,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black26,
          textColor: Colors.orange,
          fontSize: 16.0
      );

      return vips ;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }

  }

  bool getRemainDays(design){

    final DateTime dateOne = DateTime.parse(design.available_untill!);
    final DateTime dateTwo = DateTime.now() ;

    final Duration duration = dateOne.difference(dateTwo);
    print(duration.inDays );
    return duration.inDays > -1  ;
  }


}