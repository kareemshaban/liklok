import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:LikLok/models/AppUser.dart';
import 'package:LikLok/models/message.dart';
import 'package:LikLok/modules/chat_bubble/chat_bubble_sender.dart';
import 'package:LikLok/shared/network/remote/AppUserServices.dart';
import 'package:LikLok/shared/network/remote/ChatServic.dart';
import 'package:LikLok/shared/network/remote/Notification_service.dart';
import 'package:LikLok/shared/styles/colors.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../helpers/zego_handler/live_audio_room_manager.dart';
import '../../layout/tabs_screen.dart';
import '../../shared/components/Constants.dart';
import '../../shared/network/remote/ChatRoomService.dart';
import '../Room/Components/app_utils/app_snack_bar.dart';
import '../chat_bubble/chat_bubble_reciever.dart';
import '../chat_service/chat_service.dart';

class ChatScreen extends StatefulWidget {
  final String receiverUserEmail;

  final int receiverUserID;

  final AppUser receiver;

  final List<Message> messages;

  const ChatScreen({
    super.key,
    required this.receiverUserEmail,
    required this.receiverUserID,
    required this.receiver,
    required this.messages,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool _isLoading = false;

  AppUser? user;

  final NotificationService send_notification = new NotificationService();
  ScrollController _controller = ScrollController();

  final ChatApiService send_Message = ChatApiService();
  int prevSender = 0;

  String? currentUserId = "";

  int appID = 1364585881;
  String appSign =
      'c65c2660926c15c386764de74a7330df068a35830a77bd059db1fb9dbbc99c24';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      user = AppUserServices().userGetter();
      if(widget.messages != null){
        messages = widget.messages ;
      }
    });
    print('messages.length');
    print(messages.length);

    initZego();

    getId();
    // Future.delayed(Duration(milliseconds: 1000)).then((value) => {
    //   _controller.animateTo(_controller.position.maxScrollExtent,
    //       duration: Duration(milliseconds: 300), curve: Curves.linear)
    // });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  getId() async {
    final prefs = await SharedPreferences.getInstance();
    String? googleUserId = prefs.getString('googleUserId');

    setState(() {
      currentUserId = googleUserId;
    });
  }

  final TextEditingController _messageController = TextEditingController();
  final _scrollController = ScrollController();
  final ChatService _chatService = ChatService();
  List<Message> messages = [];
  late final users = [user!.id, widget.receiverUserID]..sort();
  late final roomId = "room_${users[0]}_${users[1]}";

  // void sendMessage() async {
  //   if (_messageController.text.isNotEmpty) {
  //     await _chatService.sendMessage(
  //         widget.receiverUserID, _messageController.text , 0);
  //   }
  //   //clear the text controller after sending the message
  //   _messageController.clear();
  // }
  bool emojiShowing = false;

  // Future<void> deleteMessage (currentUserId , receiverId) async{
  //
  //   // List<int> ids = [currentUserId , receiverId];
  //   // ids.sort() ;
  //   // String chatRoomId = ids.join("_");
  //   // _firestore.collection('chat_rooms').doc(chatRoomId).collection('messages'),
  //   // );
  // }

  void sendChatRoomMessage() async {
    if (_messageController.text.trim().isEmpty) {
      showSnackBarWidget(
        message: 'اكتب رسالة قبل الإرسال',
        color: Colors.orange,
      );
      return;
    }

    final Message message = Message(
      senderId: user!.id,
      receiverId: widget.receiverUserID,
      message: _messageController.text,
    );

    try {
      final String jsonMessage = jsonEncode(message.toJson());

      final result = await ZegoExpressEngine.instance.sendBroadcastMessage(
        roomId,
        jsonMessage,
      );

      if (result.errorCode == 0) {
        if(mounted){
          setState(() {
            messages.insert(messages.length, message);

            _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 2),
              curve: Curves.fastOutSlowIn,
            );

            _messageController.clear();
          });
        }
      } else {

        showSnackBarWidget(
          message: 'حدث خطأ أثناء إرسال الرسالة (كود: ${result.errorCode})',
          color: Colors.red,
        );
      }
    } catch (e) {
      print('result.errorCode');
      print(e);
      showSnackBarWidget(message: 'فشل إرسال الرسالة: $e', color: Colors.red);
    }
  }

  Future<void> initZego() async {

    await ZEGOSDKManager().init(
      appID,
      appSign,
      scenario: ZegoScenario.HighQualityChatroom,
    );

    await ZEGOSDKManager().connectUser(user!.id.toString(), user!.name);

    final token = await ChatRoomService().generateToken(user!.id);
    print('token');
    print(token.token);

    ZegoLiveAudioRoomManager().logoutRoom();

    await ZegoLiveAudioRoomManager()
        .loginRoom(
          roomId,
          ZegoLiveAudioRoomRole.audience,
          token: token.token,
        )
        .then((result) {
          if (result.errorCode == 0) {
            print("✅ Login Room Success");
          } else {
            print("❌ Login Room Failed: ${result.errorCode}");
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => TabsScreen()),
                  (Route<dynamic> route) => false,
            );
          }
        })
        .onError((error, _) {
          print("❌ Login Room Exception: $error");
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => TabsScreen()),
                (Route<dynamic> route) => false,
          );
        });

    ZegoExpressEngine.onIMRecvBroadcastMessage =
        (String roomID, List<ZegoBroadcastMessageInfo> messageList) {
          if (messageList.isEmpty) {
            debugPrint("⚠️ لا توجد رسائل مستلمة في القائمة");
            return;
          }

          final ZegoBroadcastMessageInfo zegoMessage = messageList.last;

          debugPrint("📩 استلمت رسالة نصها: ${zegoMessage.message}");

          try {
            if(mounted){
              setState(() {
                final Map<String, dynamic> jsonMap =
                jsonDecode(zegoMessage.message) as Map<String, dynamic>;

                final Message receivedMessage = Message.fromJson(
                  jsonMap,
                );

                messages.insert(messages.length, receivedMessage);

                debugPrint("✅ تم إضافة الرسالة لقائمة الرسائل");

              });

              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (_scrollController.hasClients) {
                  _scrollController.animateTo(
                    _scrollController.position.maxScrollExtent,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                  );
                }
              });

            }
          } catch (e) {
            debugPrint("❌ خطأ أثناء فك رسالة JSON أو التعامل معها: $e");
          }
        };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.9,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
            ZegoLiveAudioRoomManager().logoutRoom();
          },
          icon: Icon(Icons.arrow_back_ios_outlined, color: Colors.black),
        ),
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: widget.receiver.gender == 0
                  ? MyColors.blueColor
                  : MyColors.pinkColor,
              backgroundImage: widget.receiver.img != ""
                  ? (widget.receiver.img.startsWith('https')
                        ? CachedNetworkImageProvider(widget.receiver.img)
                        : CachedNetworkImageProvider(
                            '${ASSETSBASEURL}AppUsers/${widget.receiver.img}',
                          ))
                  : null,
              radius: 22,
              child: widget.receiver.img == ""
                  ? Text(
                      widget.receiver.name.toUpperCase().substring(0, 1) +
                          (widget.receiver.name.contains(" ")
                              ? widget.receiver.name
                                    .substring(
                                      widget.receiver.name.indexOf(" "),
                                    )
                                    .toUpperCase()
                                    .substring(1, 2)
                              : ""),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : null,
            ),
            SizedBox(width: 5.0),
            Text(
              widget.receiver.name,
              style: TextStyle(color: Colors.black, fontSize: 18.0),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  PopupMenuButton<int>(
                    onSelected: (item) => {},
                    iconColor: Colors.black,
                    iconSize: 25.0,
                    color: Colors.white,
                    itemBuilder: (context) => [
                      PopupMenuItem<int>(
                        onTap: () {},
                        value: 0,
                        child: Text(
                          'delete_chat'.tr,
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      PopupMenuItem<int>(
                        value: 1,
                        child: Text(
                          'block_user'.tr,
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    //messages
                    child: buildMessageList(),
                  ),
                  Container(
                    height: 70,
                    color: Colors.grey[100],
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(13.0),
                            ),
                            height: 50.0,
                            child: TextFormField(
                              controller: _messageController,
                              cursorColor: Colors.grey,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                              ),
                              decoration: InputDecoration(
                                hintText: 'chat_hint_text_form'.tr,
                                hintStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(13.0),
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                  borderRadius: BorderRadius.circular(13.0),
                                ),
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      emojiShowing = !emojiShowing;
                                      print(emojiShowing);
                                    });
                                  },
                                  icon: Icon(
                                    Icons.emoji_emotions_outlined,
                                    color: MyColors.primaryColor,
                                  ),
                                  iconSize: 30.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 15.0),
                        Container(
                          decoration: BoxDecoration(
                            color: MyColors.primaryColor,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          height: 45.0,
                          width: 80.0,
                          child: MaterialButton(
                            onPressed: () async {
                              //
                              // sendMessage();
                              await send_Message.send_Message(
                                user!.id,
                                widget.receiver.id,
                                _messageController.text,
                                0
                              );
                              sendChatRoomMessage();
                              // send_notification.send_notification(widget.receiver.token , _messageController.text , user!.name);
                            }, //sendMessage
                            child: Text(
                              'gift_send'.tr,
                              style: TextStyle(
                                color: MyColors.darkColor,
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
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
                            emojiSizeMax:
                            28 *
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
  //   Widget _buildMessageList() {
  //     return StreamBuilder(
  //         stream: _chatService.getMessages(
  //             widget.receiverUserID,
  //             user!.id
  //         ),
  //         builder: (context, snapshot) {
  //           if (snapshot.hasError) {
  //             return Text('chat_error'.tr + snapshot.error.toString());
  //           }
  //           if (snapshot.connectionState == ConnectionState.waiting) {
  //             return Loading() ;
  //           }
  //           return Container(
  //             color: MyColors.darkColor,
  //             // child: ListView(
  //             //   children: snapshot.data!.docs
  //             //       .map((document) => _buildMessageItem(document))
  //             //       .toList(),
  //             // ),
  //             child:  Padding(
  //               padding: const EdgeInsets.only(top:8.0),
  //               child: ListView.builder(itemBuilder: (context, index) => _buildMessageItem(snapshot.data!.docs , index) , itemCount: snapshot.data!.docs.length, ),
  //             ),
  //           );
  //         }
  //     );
  //   }

  // build message item
  Widget _buildMessageItem(Message message, index) {
    // DocumentSnapshot document = documents[index];
    // Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    bool showImg = true ;
    bool showImg2 = true ;
    if(index == 0){
      showImg = true ;
      showImg2 = true ;
    } else {
      final Message prev_data = messages[index - 1];
        if(message.senderId == prev_data.senderId){
          showImg = false ;
        } else {
          showImg = true ;
        }
      if(message.receiverId == prev_data.receiverId){
        showImg2 = false ;
      } else {
        showImg2 = true ;
      }
    }

    // allign the message to the right if the sender is the current user, otherwise to the left
    var alignment = ( message.senderId == currentUserId)
        ? AlignmentDirectional.centerStart
        : AlignmentDirectional.centerEnd;
    return Container(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Row(
          mainAxisAlignment: ( message.receiverId == user!.id)
              ? MainAxisAlignment.start
              : MainAxisAlignment.end,
          children: [
            (message.senderId == user!.id)
                ? Row(
                    children: [
                      ChatBubble1(
                        message: message.message,
                        sender_id: message.receiverId,
                        current_user_id: user!.id,
                        reciver_id: message.senderId,
                      ),
                      SizedBox(width: 5.0),
                      showImg
                          ? CircleAvatar(
                              backgroundColor: user!.gender == 0
                                  ? MyColors.blueColor
                                  : MyColors.pinkColor,
                              backgroundImage: user!.img != ""
                                  ? (user!.img.startsWith('https')
                                        ? CachedNetworkImageProvider(user!.img)
                                        : CachedNetworkImageProvider(
                                            '${ASSETSBASEURL}AppUsers/${user?.img}',
                                          ))
                                  : null,
                              radius: 15.0,
                              child: user?.img == ""
                                  ? Text(
                                      user!.name.toUpperCase().substring(0, 1) +
                                          (user!.name.contains(" ")
                                              ? user!.name
                                                    .substring(
                                                      user!.name.indexOf(" "),
                                                    )
                                                    .toUpperCase()
                                                    .substring(1, 2)
                                              : ""),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 13.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  : null,
                            )
                          : SizedBox(width: 30.0),
                    ],
                  )
                : Row(
                    children: [
                      showImg2
                          ? CircleAvatar(
                              backgroundColor: widget.receiver.gender == 0
                                  ? MyColors.blueColor
                                  : MyColors.pinkColor,
                              backgroundImage: widget.receiver.img != ""
                                  ? (widget.receiver.img.startsWith('https')
                                        ? CachedNetworkImageProvider(
                                            widget.receiver.img,
                                          )
                                        : CachedNetworkImageProvider(
                                            '${ASSETSBASEURL}AppUsers/${widget.receiver.img}',
                                          ))
                                  : null,
                              radius: 15.0,
                              child: widget.receiver.img == ""
                                  ? Text(
                                      widget.receiver.name
                                              .toUpperCase()
                                              .substring(0, 1) +
                                          (widget.receiver.name.contains(" ")
                                              ? widget.receiver.name
                                                    .substring(
                                                      widget.receiver.name
                                                          .indexOf(" "),
                                                    )
                                                    .toUpperCase()
                                                    .substring(1, 2)
                                              : ""),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 13.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  : null,
                            )
                          : SizedBox(width: 30.0),
                      SizedBox(width: 5.0),
                      ChatBubble(
                        message: message.message,
                        sender_id: message.receiverId,
                        current_user_id: user!.id,
                        reciver_id: message.receiverId,
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  Widget buildMessageList() {
    return Container(
      color: Colors.white,
      // child: ListView(
      //   children: snapshot.data!.docs
      //       .map((document) => _buildMessageItem(document))
      //       .toList(),
      // ),
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: ListView.builder(
          controller: _scrollController,
          itemBuilder: (context, index) =>
              _buildMessageItem(messages[index], index),
          itemCount: messages.length,
        ),
      ),
    );
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    ZegoLiveAudioRoomManager().logoutRoom();
  }
}
