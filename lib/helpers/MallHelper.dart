import 'package:LikLok/models/Category.dart';
import 'package:LikLok/models/Design.dart';
import 'package:LikLok/models/Mall.dart';
import 'package:LikLok/models/Relation.dart';

class MallHelper {
  List<Mall>? designs = [];
  List<Category>?   categories  = [];
  List<RelationModel>? relations = [] ;

  MallHelper({this.categories , this.designs , this.relations});
}