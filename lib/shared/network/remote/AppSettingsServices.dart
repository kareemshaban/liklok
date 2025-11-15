import 'package:LikLok/models/AppSettings.dart';
import 'package:LikLok/shared/components/Constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
class AppSettingsServices {

  static AppSettings? appSettings  ;
  appSettingSetter(AppSettings u){
    appSettings = u ;
  }
  AppSettings? appSettingGetter(){
    return appSettings ;
  }


  Future<AppSettings?> getAppSettings() async{
     AppSettings appSettings = AppSettings(id: 0, agora_id: "", enableGooglePayments: 0, enableStripePayments: 0  , game1: 0 , game7: 0 , game8: 0 ,
     game10: 0 , game15: 0 ,game20: 0 , game25: 0 , game26: 0 , isTest:0 , zegoAppId: '' , zegoAppSign: '', );
     final response = await http.get(Uri.parse('${BASEURL}appSettings'));
     if (response.statusCode == 200){
       final Map jsonData = json.decode(response.body);
       if(jsonData['state'] == "success"){
         appSettings= AppSettings.fromJson(jsonData['settings']);
       }
     } else {
       throw Exception('Failed to load album');
     }

     return appSettings ;

  }


}