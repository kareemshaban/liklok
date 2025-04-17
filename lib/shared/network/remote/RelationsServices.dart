//relations/purchase
import 'dart:convert';

import 'package:LikLok/models/ProfileRelation.dart';
import 'package:LikLok/shared/components/Constants.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
class RelationsServices {


  Future<bool> purchaseRelation( user_id , relation ,reciver_id) async {
    var response = await http.post(
      Uri.parse('${BASEURL}relations/purchase'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'user_id': user_id.toString(),
        'relation': relation.toString()  ,
        'reciver_id': reciver_id.toString()
      }),
    );
    print('response.body');
    print(response.body);
    if (response.statusCode == 200) {

      final Map jsonData = json.decode(response.body);
      Fluttertoast.showToast(
          msg: jsonData['message'].toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black26,
          textColor: Colors.orange,
          fontSize: 16.0
      );
      if(jsonData['state'] == "success"){
        return true ;
      } else {
        return false ;
      }


    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }


  Future<bool> acceptRelation( user_id , relation ,reciver_id) async {
    var response = await http.post(
      Uri.parse('${BASEURL}relations/Accept'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'user_id': user_id.toString(),
        'relation': relation.toString()  ,
        'reciver_id': reciver_id.toString()
      }),
    );
    if (response.statusCode == 200) {

      final Map jsonData = json.decode(response.body);
      Fluttertoast.showToast(
          msg: jsonData['message'].toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black26,
          textColor: Colors.orange,
          fontSize: 16.0
      );
      if(jsonData['state'] == "success"){
        return true ;
      } else {
        return false ;
      }


    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }


  Future<bool> refuseRelation( user_id , relation ,reciver_id) async {
    var response = await http.post(
      Uri.parse('${BASEURL}relations/Accept'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'user_id': user_id.toString(),
        'relation': relation.toString()  ,
        'reciver_id': reciver_id.toString()
      }),
    );
    if (response.statusCode == 200) {

      final Map jsonData = json.decode(response.body);

      if(jsonData['state'] == "success"){
        return true ;
      } else {
        return false ;
      }


    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }



  Future<bool> getRelation( user_id , relation ,reciver_id) async {
    var response = await http.post(
      Uri.parse('${BASEURL}relations/getRelation'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'user_id': user_id.toString(),
        'relation': relation.toString()  ,
        'reciver_id': reciver_id.toString()
      }),
    );
    print('response.body');
    print(response.body);
    if (response.statusCode == 200) {

      final Map jsonData = json.decode(response.body);

      if(jsonData['isAccepted'] == 1){
        return true ;
      } else {
        return false ;
      }


    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }



  Future<List<ProfileRelation>> getProfileRelations(user_id) async {
    final response = await http.get(Uri.parse('${BASEURL}profile/getUserRelations/${user_id}'));
    print(response.body);
    List<ProfileRelation> relations  = [];
    if (response.statusCode == 200) {
      final Map jsonData = json.decode(response.body);
      for( var i = 0 ; i < jsonData['relations'].length ; i ++ ){
        ProfileRelation banner = ProfileRelation.fromJson(jsonData['relations'][i]);
        relations.add(banner);
      }
      return relations ;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }

  }





}