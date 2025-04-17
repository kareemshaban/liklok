import 'package:LikLok/models/Intro.dart';
import 'package:LikLok/shared/components/Constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class IntroServices {

  static Intro? intro  ;
  static int firstShow = 0;
  introSetter(Intro? u){
    intro = u ;
  }
  Intro? introGetter(){
    return intro ;
  }
  setFirstShow(int x) {
    firstShow = 1 ;
  }

  int getFirstShow() {
    return firstShow ;
  }


  Future<Intro?> getRandomIntro() async {
    final response = await http.get(Uri.parse('${BASEURL}randomIntro'));
    if (response.statusCode == 200) {
      final Map jsonData = json.decode(response.body);
      if(jsonData['state'] == 'success'){

        Intro intro = Intro.fromJson(jsonData['intro']);
        return intro ;
      } else {
        return null ;
      }

    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }

  }
}