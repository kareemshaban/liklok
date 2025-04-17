import 'dart:convert';

import 'package:LikLok/models/Banner.dart';
import 'package:LikLok/shared/components/Constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class BannerServices {
  static List<BannerData> banners = [] ;
  bannerSetter( List<BannerData> u){
    banners = u ;
  }
  List<BannerData> bannerGetter(){
    return banners ;
  }


  Future<List<BannerData>> getAllBanners() async {
    final response = await http.get(Uri.parse('${BASEURL}Banners/getAll'));
    print(response.body);
    List<BannerData> banners  = [];
    if (response.statusCode == 200) {
      List<dynamic>  jsonData = json.decode(response.body);
      for( var i = 0 ; i < jsonData.length ; i ++ ){
        BannerData banner = BannerData.fromJson(jsonData[i]);
        banners.add(banner);
      }
      return banners ;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }

  }


}