import 'dart:convert';

import 'package:LikLok/models/FestivalBanner.dart';
import 'package:LikLok/shared/components/Constants.dart';
import 'package:http/http.dart' as http;

class FestivalBannerService {
  Future<List<FestivalBanner>> getAllBanners() async {
    final response = await http.get(Uri.parse('${BASEURL}festivalBanners/getAll'));
    List<FestivalBanner> banners  = [];
    if (response.statusCode == 200) {
      List<dynamic>  jsonData = json.decode(response.body);
      for( var i = 0 ; i < jsonData.length ; i ++ ){
        FestivalBanner banner = FestivalBanner.fromJson(jsonData[i]);
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