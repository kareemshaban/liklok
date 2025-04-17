import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:LikLok/models/AppUser.dart';
import 'package:LikLok/shared/network/remote/AppUserServices.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../models/message.dart';

class ChatService extends ChangeNotifier {
  // get instance of auth and firestore
  AppUser? user = AppUserServices().userGetter();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance ;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance ;
  //send message
  Future<void> sendMessage(int receiverId , String message  , int isRelation  )async {
    //get current user information
    final int currentUserId = user!.id;
    final String currentUserEmail = user!.email;
    final Timestamp timestamp = Timestamp.now() ;
    //create a new message
    Message newMessage = Message(
        senderId: isRelation == 0 ? currentUserId :receiverId ,
        senderEmail: currentUserEmail,
        receiverId: isRelation == 0 ? receiverId : currentUserId,
        message: message,
        timestamp: timestamp
    );

    //construct chat rood id from current user id and receiver id (sorted to ensure uniqueness)
    List<int> ids = [currentUserId , receiverId];
    ids.sort() ; //sort the id (this ensures the chat room id is always the same for any pair of people)
    String chatRoomId = ids.join("_"); // combine the ids into a sigle string to use as a chatroomID
    // add new message to database
    await _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .add(newMessage.toMap()
    );
    print('chatRoomId');
    print(chatRoomId);


    // call sendMess

  }
//get messages
  Stream<QuerySnapshot> getMessages(int userId , int otherUserId){
    // construct chat room id from user id (sorted to ensure it matches the id used when sending message
    List<int> ids = [userId , otherUserId] ;
    ids.sort() ;
    String chatRoomId = ids.join("_");
    Stream<QuerySnapshot> stream =  _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp',descending: false)
        .snapshots();
    return  stream ;
  }
}