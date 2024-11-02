import 'dart:convert';

import 'package:LikLok/models/AgencyOperations.dart';
import 'package:LikLok/models/AgencyWallet.dart';
import 'package:LikLok/models/ChargingAgency.dart';
import 'package:LikLok/modules/AgencyChargeOperations/agency_charge_operations_screen.dart';
import 'package:LikLok/shared/components/Constants.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
class ChargingAgencyServices {

  Future<ChargingAgency> getAgency(user_id) async {
    final response = await http.get(Uri.parse('${BASEURL}chargingAgency/getAgency/${user_id}'));
    ChargingAgency agency ;
    AgencyWallet wallet ;
    if (response.statusCode == 200) {
      final Map jsonData = json.decode(response.body);
      agency = ChargingAgency.fromJson(jsonData['agency']) ;
      wallet = AgencyWallet.fromJson(jsonData['wallet']) ;
      agency.wallet = wallet ;
      return agency ;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }

  }

  Future<void> addBalanceToUser( agency_id , user_id , charging_value) async {

    var res = await http.post(
      Uri.parse('${BASEURL}chargingAgency/addBalance'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'agency_id': agency_id.toString(),
        'user_id': user_id.toString()  ,
        'charging_value': charging_value.toString()  ,
      }),
    );
    print(res.body);
    if (res.statusCode == 200) {
      Fluttertoast.showToast(
          msg: "balance_added".tr,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black26,
          textColor: Colors.orange,
          fontSize: 16.0
      );
    } else {
      Fluttertoast.showToast(
          msg: 'Something went wrong try again later!',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black26,
          textColor: Colors.orange,
          fontSize: 16.0
      );
      throw Exception('Failed to load post');
    }
  }

  Future<List<AgencyOperations>> getAgencyChargingOperations(agency_id) async {
    final response = await http.get(Uri.parse('${BASEURL}chargingAgency/operations/${agency_id}'));
    List<AgencyOperations> operatins  = [];
    if (response.statusCode == 200) {
      final Map jsonData = json.decode(response.body);
      if(jsonData['state'] == "success"){
        for (var j = 0; j < jsonData['operations'].length; j ++) {
          AgencyOperations op = AgencyOperations.fromJson(jsonData['operations'][j]);
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
}