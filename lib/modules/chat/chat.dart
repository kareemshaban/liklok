import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:LikLok/models/AppUser.dart';
import 'package:LikLok/models/Chat.dart';
import 'package:LikLok/models/message.dart';
import 'package:LikLok/modules/Loading/loadig_screen.dart';
import 'package:LikLok/modules/chat_bubble/chat_bubble_sender.dart';
import 'package:LikLok/shared/network/remote/AppUserServices.dart';
import 'package:LikLok/shared/network/remote/ChatServic.dart';
import 'package:LikLok/shared/network/remote/Notification_service.dart';
import 'package:LikLok/shared/styles/colors.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../shared/components/Constants.dart';
import '../chat_bubble/chat_bubble_reciever.dart';
import '../chat_service/chat_service.dart';

class ChatScreen extends StatefulWidget {
  final String receiverUserEmail ;
  final int receiverUserID ;
  final AppUser receiver ;
  const ChatScreen({
    super.key,
    required this.receiverUserEmail,
    required this.receiverUserID,
    required this.receiver
  });
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}
class _ChatScreenState extends State<ChatScreen> {
  bool _isLoading = false ;
  AppUser? user ;
  final NotificationService send_notification= new NotificationService();
  ScrollController _controller = ScrollController() ;
  final ChatApiService send_Message=  ChatApiService();
  int prevSender = 0 ;
  String? currentUserId = "" ;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      user = AppUserServices().userGetter();
    });

    getId();
    // Future.delayed(Duration(milliseconds: 1000)).then((value) => {
    //   _controller.animateTo(_controller.position.maxScrollExtent,
    //       duration: Duration(milliseconds: 300), curve: Curves.linear)
    // });
  }

  getId() async{
    final prefs = await SharedPreferences.getInstance();
    String? googleUserId = prefs.getString('googleUserId');

    setState(() {
      currentUserId  =googleUserId ;
    });
  }
  final TextEditingController _messageController = TextEditingController();
  final _scrollController = ScrollController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore= FirebaseFirestore.instance;
  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(
          widget.receiverUserID, _messageController.text , 0);
    }
    //clear the text controller after sending the message
    _messageController.clear();
  }
  bool emojiShowing = false;
  Future<void> deleteMessage (currentUserId , receiverId) async{

    // List<int> ids = [currentUserId , receiverId];
    // ids.sort() ;
    // String chatRoomId = ids.join("_");
    // _firestore.collection('chat_rooms').doc(chatRoomId).collection('messages'),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: MyColors.solidDarkColor,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back_ios_outlined, color: Colors.black,)
          ),
          title: Row(
            children: [
              CircleAvatar(
                backgroundColor: widget.receiver.gender == 0 ? MyColors.blueColor : MyColors.pinkColor ,
                backgroundImage: widget.receiver.img != "" ? (widget.receiver.img.startsWith('https') ? CachedNetworkImageProvider(widget.receiver.img)  :  CachedNetworkImageProvider('${ASSETSBASEURL}AppUsers/${widget.receiver.img}'))  :    null,
                radius: 22,
                child: widget.receiver.img== "" ?
                Text(widget.receiver.name.toUpperCase().substring(0 , 1) +
                    (widget.receiver.name.contains(" ") ? widget.receiver.name.substring(widget.receiver.name.indexOf(" ")).toUpperCase().substring(1 , 2) : ""),
                  style: const TextStyle(color: Colors.white , fontSize: 22.0 , fontWeight: FontWeight.bold),) : null,
              ),
              SizedBox(width: 5.0,),
              Text(widget.receiver.name,
                style: TextStyle(color: Colors.black, fontSize: 18.0),),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    PopupMenuButton<int>(
                      onSelected: (item) => {
                      },
                      iconColor: Colors.black,
                      iconSize: 25.0,
                      color: Colors.white,
                      itemBuilder: (context) => [
                        PopupMenuItem<int>(onTap: (){

                        },value: 0, child: Text('delete_chat'.tr , style: TextStyle(color: Colors.black),)),
                        PopupMenuItem<int>(value: 1, child: Text('block_user'.tr , style: TextStyle(color: Colors.black))),
                      ],
                    )
                  ],
                ),
              )
            ],
          )
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    //messages
                    child: _buildMessageList(),
                  ),
                  Offstage(
                      offstage: !emojiShowing,
                      child: SizedBox(
                          height: 250,
                          child: EmojiPicker(
                            textEditingController: _messageController,
                            scrollController: _scrollController,
                            config: Config(
                              height: 256,
                              checkPlatformCompatibility: true,
                              viewOrderConfig: const ViewOrderConfig(),
                              emojiViewConfig: EmojiViewConfig(
                                // Issue: https://github.com/flutter/flutter/issues/28894
                                emojiSizeMax: 28 *
                                    (foundation.defaultTargetPlatform ==
                                        TargetPlatform.iOS
                                        ? 1.2
                                        : 1.0),
                              ),
                              skinToneConfig: const SkinToneConfig(),
                              categoryViewConfig: const CategoryViewConfig(),
                              bottomActionBarConfig: const BottomActionBarConfig(),
                              searchViewConfig: const SearchViewConfig(),
                            ),
                          ),
                      )
                  ),
                  Container(
                    height: 70,
                    color: MyColors.solidDarkColor,
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                      children: [
                        Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(13.0)
                              ),
                              height: 45.0,
                              child: TextFormField(
                                  controller: _messageController,
                                  cursorColor: Colors.grey,
                                  style: TextStyle(color: Colors.black),
                                  decoration: InputDecoration(
                                      hintText: 'chat_hint_text_form'.tr,
                                      hintStyle: TextStyle(
                                          color: Colors.white, fontSize: 14),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(13.0),
                                        borderSide: BorderSide(
                                            color: Colors.grey),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.black,),
                                        borderRadius: BorderRadius.circular(13.0),
                                      ),
                                      suffixIcon: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            emojiShowing = !emojiShowing;
                                            print(emojiShowing);
                                          });
                                        },
                                        icon: Icon(Icons.emoji_emotions_outlined,
                                          color: MyColors.primaryColor,), iconSize: 30.0,
                                      )
                                  )
                              ),
                            )
                        ),
                        SizedBox(width: 15.0,),
                        Container(
                          decoration: BoxDecoration(
                            color: MyColors.primaryColor,
                            borderRadius: BorderRadius.circular(10.0)
                          ),
                          height: 45.0,
                          width: 80.0,
                          child: MaterialButton(
                            onPressed: () async{
                              //
                              // sendMessage();
                             await send_Message.send_Message(user!.id, widget.receiver.id, _messageController.text);
                              sendMessage();
                             send_notification.send_notification(widget.receiver.token , _messageController.text , user!.name);
                            }, //sendMessage
                            child: Text('gift_send'.tr, style: TextStyle(
                                color: MyColors.darkColor,
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold),),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

// build message list
  Widget _buildMessageList() {
    return StreamBuilder(
        stream: _chatService.getMessages(
            widget.receiverUserID,
            user!.id
        ),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('chat_error'.tr + snapshot.error.toString());
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Loading() ;
          }
          return Container(
            color: MyColors.darkColor,
            // child: ListView(
            //   children: snapshot.data!.docs
            //       .map((document) => _buildMessageItem(document))
            //       .toList(),
            // ),
            child:  Padding(
              padding: const EdgeInsets.only(top:8.0),
              child: ListView.builder(itemBuilder: (context, index) => _buildMessageItem(snapshot.data!.docs , index) , itemCount: snapshot.data!.docs.length, ),
            ),
          );
        }
    );
  }

// build message item
  Widget _buildMessageItem( List<DocumentSnapshot> documents , index) {
    DocumentSnapshot document = documents[index];
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    bool showImg = true ;
    bool showImg2 = true ;
    if(index == 0){
      showImg = true ;
      showImg2 = true ;
    } else {
      DocumentSnapshot prev_document = documents[index - 1];
      Map<String, dynamic> prev_data = prev_document.data() as Map<String, dynamic>;
        if(data['senderId'] == prev_data['senderId']){
          showImg = false ;
        } else {
          showImg = true ;
        }
      if(data['receiverId'] == prev_data['receiverId']){
        showImg2 = false ;
      } else {
        showImg2 = true ;
      }
    }



    // allign the message to the right if the sender is the current user, otherwise to the left
    var alignment = (data['senderId'] == currentUserId)
        ? AlignmentDirectional.centerStart
        : AlignmentDirectional.centerEnd;
    return Container(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Row(
          mainAxisAlignment: (data['senderId'] == widget.receiver.id)
              ? MainAxisAlignment.start
              : MainAxisAlignment.end,
          children: [
            (data['senderId'] == user!.id ) ? Row(
              children: [
                ChatBubble1(
                  message: data['message'],
                  sender_id: data['receiverId'],
                  current_user_id: user!.id,
                  reciver_id: data['senderId'],
                ),
                SizedBox(width: 5.0,),
                showImg ?   CircleAvatar(
                  backgroundColor: user!.gender == 0 ? MyColors.blueColor : MyColors.pinkColor ,
                  backgroundImage: user!.img != "" ? (user!.img.startsWith('https') ? CachedNetworkImageProvider(user!.img)  :  CachedNetworkImageProvider('${ASSETSBASEURL}AppUsers/${user?.img}'))  :null,
                  radius: 15.0,
                  child: user?.img== "" ?
                  Text(user!.name.toUpperCase().substring(0,1)+
                      (user!.name.contains(" ") ? user!.name.substring(user!.name.indexOf(" ")).toUpperCase().substring(1 , 2) : ""),
                    style: const TextStyle(color: Colors.white , fontSize: 13.0 , fontWeight: FontWeight.bold),) : null,
                ) : SizedBox(width: 30.0,),
              ],
            ) : Row(
              children: [
                showImg2 ?  CircleAvatar(
                    backgroundColor: widget.receiver.gender == 0 ? MyColors.blueColor : MyColors.pinkColor ,
                    backgroundImage: widget.receiver.img != "" ? (widget.receiver.img.startsWith('https') ? CachedNetworkImageProvider(widget.receiver.img)  :  CachedNetworkImageProvider('${ASSETSBASEURL}AppUsers/${widget.receiver.img}'))  :    null,
                    radius: 15.0,
                    child: widget.receiver.img== "" ?
                    Text(widget.receiver.name.toUpperCase().substring(0 , 1) +
                        (widget.receiver.name.contains(" ") ? widget.receiver.name.substring(widget.receiver.name.indexOf(" ")).toUpperCase().substring(1 , 2) : ""),
                      style: const TextStyle(color: Colors.white , fontSize: 13.0 , fontWeight: FontWeight.bold),) : null,
                  ) : SizedBox(width: 30.0,),
                SizedBox(width: 5.0,),
                ChatBubble(
                  message: data['message'],
                  sender_id: data['receiverId'],
                  current_user_id: user!.id,
                  reciver_id: data['senderId'],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
