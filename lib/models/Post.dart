import 'package:LikLok/models/Comment.dart';
import 'package:LikLok/models/PostLike.dart';
import 'package:LikLok/models/PostReport.dart';

class Post {
  final int id ;
  final  String content ;
  final int user_id ;
  final String img ;
  final int auth ;
  final int accepted ;
  final String created_at ;
  final String user_name ;
  final String user_tag ;
  final int gender ;
  final String user_img ;
  final String share_level_img ;
  final String karizma_level_img ;
  final String charging_level_img ;
  final String tag ;
  final int likes_count ;
  final int comments_count ;
  List<PostLike>? likes = [];
  List<PostReport>? reports = [];
  List<Comment>? comments = [];
  Post( {required this.id, required this.content, required this.user_id, required this.img, required this.auth, required this.accepted, required this.created_at,
    required this.user_name, required this.user_tag, required this.gender, required this.user_img, required this.share_level_img, required this.karizma_level_img,
    required this.charging_level_img, required this.tag , required this.likes_count , required this.comments_count ,  this.likes , this.reports , this.comments});

  factory Post.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
      'id': int id,
      'content': String content,
      'user_id': int user_id,
      'img': String img,
      'auth': int auth,
      'accepted': int accepted,
      'created_at': String created_at,
      'user_name': String user_name,
      'user_tag': String user_tag,
      'gender': int gender,
      'user_img': String user_img,
      'share_level_img': String share_level_img,
      'karizma_level_img': String karizma_level_img,
      'charging_level_img': String charging_level_img,
      'tag': String tag,
      'likes_count': int likes_count,
      'comments_count': int comments_count,

      } =>
          Post(
              id: id,
              content: content,
              user_id: user_id,
              img: img,
              auth: auth,
              accepted: accepted,
              created_at: created_at,
              user_name: user_name,
              user_tag: user_tag,
              gender: gender,
              user_img: user_img,
              share_level_img: share_level_img,
              karizma_level_img: karizma_level_img,
              charging_level_img: charging_level_img,
              tag: tag,
              likes_count: likes_count,
              comments_count: comments_count,
          ),
      _ => throw const FormatException('Failed to load Post.'),
    };
  }
}