
import 'dart:io';

import 'package:LikLok/models/Post.dart';
import 'package:LikLok/models/PostLike.dart';
import 'package:LikLok/models/PostReport.dart';
import 'package:LikLok/models/Comment.dart';
import 'package:LikLok/models/Tag.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:LikLok/shared/components/Constants.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';

class PostServices {

  Future<List<Post>> getAllPosts() async {
    final res = await http.get(Uri.parse('${BASEURL}posts/getAll'));
    List<Post> posts = [];
    List<PostLike> likes = [];
    List<PostReport> reports = [];
    List<Comment> comments = [];
    if (res.statusCode == 200) {
      final Map resonse = json.decode(res.body);
      for (var i = 0; i < resonse['posts'].length; i ++) {
        Post post = Post.fromJson(resonse['posts'][i]);
        likes = [];
        reports = [] ;
        comments = [] ;
        for (var j = 0; j < resonse['likes'].length; j ++) {
          if (resonse['likes'][j]['post_id'] == post.id) {
            PostLike like = PostLike.fromJson(resonse['likes'][j]);
            likes.add(like);
          }
        }
        for (var n = 0; n < resonse['reports'].length; n ++) {
          if (resonse['reports'][n]['post_id'] == post.id) {
            PostReport report = PostReport.fromJson(resonse['reports'][n]);
            reports.add(report);
          }
        }
        for (var c = 0; c < resonse['comments'].length; c ++) {
          if (resonse['comments'][c]['post_id'] == post.id) {
            Comment comment = Comment.fromJson(resonse['comments'][c]);
            comments.add(comment);
          }
        }

        post.likes = likes;
        post.reports = reports ;
        post.comments = comments ;

        posts.add(post);
      }
      return posts;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load post');
    }
  }

  Future<List<Post>> likePost(post_id, user_id) async {
    final res = await http.get(
        Uri.parse('${BASEURL}posts/like/$post_id/$user_id'));
    print(res.body);
    List<Post> posts = [];
    List<PostLike> likes = [];
    List<PostReport> reports = [];
    print(post_id  );
    print(user_id  );
    if (res.statusCode == 200) {
      final Map resonse = json.decode(res.body);

      for (var i = 0; i < resonse['posts'].length; i ++) {
        Post post = Post.fromJson(resonse['posts'][i]);
        likes = [];
        reports = [] ;
        for (var j = 0; j < resonse['likes'].length; j ++) {
          if (resonse['likes'][j]['post_id'] == post.id) {
            PostLike like = PostLike.fromJson(resonse['likes'][j]);
            likes.add(like);
          }
        }
        for (var n = 0; n < resonse['reports'].length; n ++) {
          if (resonse['reports'][n]['post_id'] == post.id) {
            PostReport report = PostReport.fromJson(resonse['reports'][n]);
            reports.add(report);
          }
        }

        post.likes = likes;
        post.reports = reports ;

        posts.add(post);
      }
      return posts;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load post');
    }
  }

  Future<List<Post>> unlike(post_id, user_id) async {
    final res = await http.get(
        Uri.parse('${BASEURL}posts/unlike/$post_id/$user_id'));
    List<Post> posts = [];
    List<PostReport> reports = [];

    List<PostLike> likes = [];
    if (res.statusCode == 200) {
      final Map resonse = json.decode(res.body);
      for (var i = 0; i < resonse['posts'].length; i ++) {
        Post post = Post.fromJson(resonse['posts'][i]);
        likes = [];
        reports = [] ;
        for (var j = 0; j < resonse['likes'].length; j ++) {
          if (resonse['likes'][j]['post_id'] == post.id) {
            PostLike like = PostLike.fromJson(resonse['likes'][j]);
            likes.add(like);
          }
        }
        for (var n = 0; n < resonse['reports'].length; n ++) {
          if (resonse['reports'][n]['post_id'] == post.id) {
            PostReport report = PostReport.fromJson(resonse['reports'][n]);
            reports.add(report);
          }
        }

        post.likes = likes;
        post.reports = reports ;

        posts.add(post);
      }
      return posts;
    }
    else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load post');
    }
  }

  Future<List<Post>> reportPost(post_id, user_id , type) async {
    final res = await http.get(
        Uri.parse('${BASEURL}posts/report/$post_id/$user_id/$type'));
    List<Post> posts = [];
    List<PostLike> likes = [];
    if (res.statusCode == 200) {

      Fluttertoast.showToast(
          msg: "Post Reported Successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black26,
          textColor: Colors.orange,
          fontSize: 16.0
      );
      final Map resonse = json.decode(res.body);
      if (resonse['state'] == 'success') {
        for (var i = 0; i < resonse['posts'].length; i ++) {
          Post post = Post.fromJson(resonse['posts'][i]);
          likes = [];
          for (var j = 0; j < resonse['likes'].length; j ++) {
            if (resonse['likes'][j]['post_id'] == post.id) {
              PostLike like = PostLike.fromJson(resonse['likes'][j]);
              likes.add(like);
            }
          }
          print(likes);
          post.likes = likes;

          posts.add(post);
        }
      }

      return posts;
    }
    else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load post');
    }
  }

  Future<List<Comment>> addComment( post_id , user_id , content) async {
    List<Comment> comments = [] ;
    var res = await http.post(
      Uri.parse('${BASEURL}Comments/addComment'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'post_id': post_id.toString(),
        'user_id': user_id.toString()  ,
        'content': content.toString()  ,
      }),
    );
    print(res.body);
    if (res.statusCode == 200) {
      final Map resonse = json.decode(res.body);
      for (var i = 0; i < resonse['comments'].length; i ++) {
        Comment comment = Comment.fromJson(resonse['comments'][i]);
        comments.add(comment);
      }

      return comments ;
    } else {
      throw Exception('Failed to load post');
    }
  }
  Future<List<Tag>> getAllTags() async {
    final response = await http.get(Uri.parse('${BASEURL}posts/tags/all'));
    List<Tag> tags  = [];

    if (response.statusCode == 200) {
      final Map jsonData = json.decode(response.body);
      for( var i = 0 ; i < jsonData['tags'].length ; i ++ ){
        Tag tag = Tag.fromJson(jsonData['tags'][i]);
        tags.add(tag);
      }
      return tags ;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load tags');
    }

  }


  AddPost(File? imageFile , content , user_id , tag_id) async {

    var uri = Uri.parse(BASEURL+'posts/add');

    var request = new http.MultipartRequest("POST", uri);
    if(imageFile != null){
      var stream = new http.ByteStream(DelegatingStream.typed(imageFile!.openRead()));
      var length = await imageFile.length();
      var multipartFile = new http.MultipartFile('img', stream, length,
          filename: basename(imageFile.path));
      //contentType: new MediaType('image', 'png'));

      request.files.add(multipartFile);
    }

    request.fields.addAll(<String, String>{
      'content': content,
      'user_id': user_id.toString() ,
      'auth': "0"  ,
      'tag_id': tag_id.toString()
    });
    var response = await request.send();
    print(response.statusCode);
    response.stream.transform(utf8.decoder).listen((value) {
      print(value);
    });
  }



  Future<List<Post>> getMyPosts(user_id) async {
    final res = await http.get(Uri.parse('${BASEURL}posts/getUserPosts/${user_id}'));
    List<Post> posts = [];
    List<PostLike> likes = [];
    List<PostReport> reports = [];
    List<Comment> comments = [];
    if (res.statusCode == 200) {
      final Map resonse = json.decode(res.body);
      for (var i = 0; i < resonse['posts'].length; i ++) {
        Post post = Post.fromJson(resonse['posts'][i]);
        likes = [];
        reports = [] ;
        comments = [] ;
        for (var j = 0; j < resonse['likes'].length; j ++) {
          if (resonse['likes'][j]['post_id'] == post.id) {
            PostLike like = PostLike.fromJson(resonse['likes'][j]);
            likes.add(like);
          }
        }
        for (var n = 0; n < resonse['reports'].length; n ++) {
          if (resonse['reports'][n]['post_id'] == post.id) {
            PostReport report = PostReport.fromJson(resonse['reports'][n]);
            reports.add(report);
          }
        }
        for (var c = 0; c < resonse['comments'].length; c ++) {
          if (resonse['comments'][c]['post_id'] == post.id) {
            Comment comment = Comment.fromJson(resonse['comments'][c]);
            comments.add(comment);
          }
        }

        post.likes = likes;
        post.reports = reports ;
        post.comments = comments ;

        posts.add(post);
      }
      return posts;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load post');
    }
  }

}