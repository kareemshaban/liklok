import 'package:LikLok/models/AppUser.dart';
import 'package:LikLok/models/Gift.dart';
import 'package:LikLok/shared/components/Constants.dart';
import 'package:LikLok/shared/network/remote/AppUserServices.dart';
import 'package:LikLok/shared/network/remote/ChatRoomService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class GiftHelper {
  final int user_id ;
  final int receiver ;
  final int room_owner ;
  final int room_id ;
  final int gift_id ;
  final int sendGiftCount ;
  final List<Gift> gifts  ;
  GiftHelper({required this.user_id , required this.receiver , required this.room_id , required this.room_owner ,  required this.gift_id , required this.sendGiftCount , required this.gifts});


   sendGift() async{
     if(receiver! > 0){
       int reward = await ChatRoomService().sendGift(user_id , receiver , room_owner , room_id ,  gift_id , sendGiftCount );


       if(reward > -1){
         AppUser? reciver_obj = await AppUserServices().getUser(receiver);
         AppUser? user = await AppUserServices().getUser(user_id);


         Gift gift = gifts.where((element) => element.id == gift_id).toList()[0] ;
         await FirebaseFirestore.instance.collection("gifts").add({
           'room_id': room_id,
           'sender_id': user_id ,
           'sender_name': user!.name ,
           'sender_img': '${ASSETSBASEURL}AppUsers/${user.img}'  ,
           'receiver_id': reciver_obj!.id ,
           'receiver_name': reciver_obj.name ,
           'receiver_img': '${ASSETSBASEURL}AppUsers/${reciver_obj.img}',
           'gift_name':  gift.name ,
           'gift_audio': gift.audio_url != "" ? '${ASSETSBASEURL}Designs/Audio/${gift.audio_url}' : "" ,
           'gift_img': '${gift.motion_icon}',
           'giftImgSmall':'${ASSETSBASEURL}Designs/${gift.icon}',
           'count' : sendGiftCount,
           'sender_share_level': user.share_level_icon,
           'available_untill':DateTime.now().add(Duration(minutes: 1)) ,
           'gift_category_id': gift.gift_category_id,
           'reward': reward,
           'gift_id': gift_id

         });

         AppUserServices().userSetter(user);

       }
     } else {
       Fluttertoast.showToast(
           msg: 'choose_receiver'.tr,
           toastLength: Toast.LENGTH_SHORT,
           gravity: ToastGravity.CENTER,
           timeInSecForIosWeb: 1,
           backgroundColor: Colors.black26,
           textColor: Colors.orange,
           fontSize: 16.0
       );
     }
   }


  sendGiftMicUser() async{

    int  reward = await ChatRoomService().sendGiftMicUsers(user_id  , room_owner , room_id ,  gift_id , sendGiftCount );


      if(reward > -1){
        AppUser? user = await AppUserServices().getUser(user_id);


        Gift gift = gifts.where((element) => element.id == gift_id).toList()[0] ;
        await FirebaseFirestore.instance.collection("gifts").add({
          'room_id': room_id,
          'sender_id': user_id ,
          'sender_name': user!.name ,
          'sender_img': '${ASSETSBASEURL}AppUsers/${user.img}'  ,
          'receiver_id': receiver ,
          'receiver_name': 'Mic Users' ,
          'receiver_img': '',
          'gift_name':  gift.name ,
          'gift_audio': gift.audio_url != "" ? '${ASSETSBASEURL}Designs/Audio/${gift.audio_url}' : "" ,
          'gift_img': '${gift.motion_icon}',
          'giftImgSmall':'${ASSETSBASEURL}Designs/${gift.icon}',
          'count' : sendGiftCount,
          'sender_share_level': user!.share_level_icon,
          'available_untill':DateTime.now().add(Duration(minutes: 1)) ,
          'gift_category_id': gift.gift_category_id,
          'reward': reward,
          'gift_id': gift_id

        });

        AppUserServices().userSetter(user);

      }

  }

}