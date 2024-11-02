import 'package:LikLok/utils/ar.dart';
import 'package:LikLok/utils/bn.dart';
import 'package:LikLok/utils/br.dart';
import 'package:LikLok/utils/en.dart';
import 'package:LikLok/utils/fr.dart';
import 'package:LikLok/utils/hi.dart';
import 'package:LikLok/utils/id.dart';
import 'package:LikLok/utils/ph.dart';
import 'package:LikLok/utils/zh.dart';
import 'package:get/get.dart';

class Translation extends Translations{
  @override
  // TODO: implement keys
  Map<String, Map<String, String>> get keys => {
    'en' : en,
    'ar' : ar,
    'hi' : hi,
    'bn' : bn,
    'br' : br,
    'fr' : fr,
    'ph' : ph,
    'id' : id,
    'zh' : zhHans,


  };
}