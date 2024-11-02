import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:LikLok/models/ChargingOperation.dart';
import 'package:LikLok/models/Settings.dart';
import 'package:LikLok/shared/components/Constants.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class WalletServices {

  Future<List<ChargingOperation>> getUserChargingOperations(user_id) async {
    final response = await http.get(Uri.parse('${BASEURL}wallet/getChargingTransactions/${user_id}'));
    List<ChargingOperation> operatins  = [];
    if (response.statusCode == 200) {
      final Map jsonData = json.decode(response.body);
      if(jsonData['state'] == "success"){
        for (var j = 0; j < jsonData['transactions'].length; j ++) {
          ChargingOperation op = ChargingOperation.fromJson(jsonData['transactions'][j]);
          operatins.add(op);

        }
        return operatins ;
      } else {
        operatins = [] ;
        return operatins ;
      }

    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load country');
    }

  }

  Future<AppSettings?> getAppSettings() async {
    final response = await http.get(Uri.parse('${BASEURL}wallet/getSettings'));
    AppSettings settings ;
    print(response.body);
    if (response.statusCode == 200) {
      final Map jsonData = json.decode(response.body);
      if(jsonData['state'] == "success"){

        settings = AppSettings.fromJson(jsonData['setting']);


        return settings ;
      } else {
        throw Exception('Failed to load country');
      }

    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load country');
    }

  }

  Future<void> exchangeDiamond(user_id , diamond  ) async {
    final response = await http.post(Uri.parse('${BASEURL}wallet/exchangeDiamond') ,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'user_id': user_id.toString(),
        'diamond': diamond.toString()
      }),
    );
    print('exchangeDiamond');
    print(response.body);
    if (response.statusCode == 200) {
      Fluttertoast.showToast(
          msg: 'Diamond Converted to gold successfully',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black26,
          textColor: Colors.orange,
          fontSize: 16.0
      );

    }
    else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }

  }



  Future<void> chargeWallet(user_id , gold , source  ) async {
    final response = await http.post(Uri.parse('${BASEURL}wallet/charge') ,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'user_id': user_id.toString(),
        'gold': gold.toString(),
        'source': source.toString()
      }),
    );
    print('exchangeDiamond');
    print(response.body);
    if (response.statusCode == 200) {
      Fluttertoast.showToast(
          msg: 'Wallet Charged successfully',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black26,
          textColor: Colors.orange,
          fontSize: 16.0
      );

    }
    else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }

  }

}