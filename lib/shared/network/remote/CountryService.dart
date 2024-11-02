import 'dart:convert';

import 'package:LikLok/models/Country.dart';
import 'package:LikLok/shared/components/Constants.dart';
import 'package:http/http.dart' as http;

class CountryService {
  static List<Country> countries = [] ;
  countrySetter( List<Country> u){
    countries = u ;
  }
  List<Country> countryGetter(){
    return countries ;
  }
  Future<List<Country>> getAllCountries() async {
    final response = await http.get(Uri.parse('${BASEURL}Countries/getAll'));
    List<Country> countries  = [];
    if (response.statusCode == 200) {
      List<dynamic>  jsonData = json.decode(response.body);
      Country hot = Country(id: 0, name: "on Fire", code: "", order: 0, dial_code: "", icon:"assets/images/fire.png" , enable: 1);
      countries.add(hot);
      for( var i = 0 ; i < jsonData.length ; i ++ ){
        Country banner = Country.fromJson(jsonData[i]);
        countries.add(banner);
      }
      return countries ;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load country');
    }

  }



}