import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:LikLok/helpers/GiftHelper.dart';
import 'package:LikLok/models/AppSettings.dart';
import 'package:LikLok/models/Badge.dart';
import 'package:LikLok/models/Mic.dart';
import 'package:LikLok/models/token_model.dart';
import 'package:LikLok/modules/Room/Components/gift_image.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:LikLok/helpers/ChatRoomMessagesHelper.dart';
import 'package:LikLok/helpers/DesigGiftHelper.dart';
import 'package:LikLok/helpers/EnterRoomHelper.dart';
import 'package:LikLok/helpers/ExitRoomHelper.dart';
import 'package:LikLok/helpers/MicHelper.dart';
import 'package:LikLok/helpers/RoomBasicDataHelper.dart';
import 'package:LikLok/layout/tabs_screen.dart';
import 'package:LikLok/models/AppUser.dart';
import 'package:LikLok/models/Category.dart' as Cat;
import 'package:LikLok/models/ChatRoom.dart';
import 'package:LikLok/models/ChatRoomMessage.dart';
import 'package:LikLok/models/Design.dart';
import 'package:LikLok/models/Emossion.dart';
import 'package:LikLok/models/Gift.dart';
import 'package:LikLok/models/LuckyCase.dart';
import 'package:LikLok/models/Rollet.dart';
import 'package:LikLok/models/RoomMember.dart';
import 'package:LikLok/models/RoomTheme.dart';
import 'package:crypto/crypto.dart';
import 'package:LikLok/modules/Chats/Chats_Screen.dart';
import 'package:LikLok/modules/Loading/loadig_screen.dart';
import 'package:LikLok/modules/Room/Components/emoj_modal.dart';
import 'package:LikLok/modules/Room/Components/gift_modal.dart';
import 'package:LikLok/modules/Room/Components/menu_modal.dart';
import 'package:LikLok/modules/Room/Components/rollet_create_modal.dart';
import 'package:LikLok/modules/Room/Components/rollet_modal.dart';
import 'package:LikLok/modules/Room/Components/room_close_modal.dart';
import 'package:LikLok/modules/Room/Components/room_cup_modal.dart';
import 'package:LikLok/modules/Room/Components/room_info_modal.dart';
import 'package:LikLok/modules/Room/Components/room_members_modal.dart';
import 'package:LikLok/modules/SmallProfile/Small_Profile_Screen.dart';
import 'package:LikLok/shared/components/Constants.dart';
import 'package:LikLok/shared/network/remote/AppUserServices.dart';
import 'package:LikLok/shared/network/remote/ChatRoomService.dart';
import 'package:LikLok/shared/styles/colors.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svga/flutter_svga.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/services.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import '../../helpers/zego_handler/live_audio_room_manager.dart';
import '../../shared/network/remote/AppSettingsServices.dart';
import 'Components/app_utils/app_snack_bar.dart';

//const appId = "f26e793582cb48359a4cb36dba3a9d3f";
//const appId = "36fdda9bf58b40caa90d34b1893909f0";

class RoomScreen extends StatefulWidget {
  const RoomScreen({super.key});

  @override
  State<RoomScreen> createState() => _RoomScreenState();
}

class _RoomScreenState extends State<RoomScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  Timer? _leaveTimer;
  late final SVGAAnimationController _controller;
  bool isSending = false;
  AppUser? user;
  List<Design> designs = [];
  String frame = "";
  ChatRoom? room;
  String room_img = "";
  List<Emossion> emossions = [];
  List<RoomTheme> themes = [];
  List<Gift> gifts = [];
  List<Cat.Category> categories = [];
  TabController? _tabController;
  List<Widget> giftTabs = [];

  List<Widget> giftViews = [];

  String sendGiftReceiverType = "";
  int? selectedGift;

  String userRole = 'USER';
  List<ChatRoomMessage> messages = [];

  late RtcEngine _engine;
  bool showMsgInput = false;

  final TextEditingController _messageController = TextEditingController();
  FocusNode focusNode = FocusNode();
  String channel = "";
  bool emojiShowing = false;
  String entery = "";
  String giftImg = "";
  List<String> micEmojs = ["", "", "", "", "", "", "", "", "", "", "", ""];
  bool _localUserJoined = false;
  bool _localUserMute = false;

  int bannerState = 0;

  bool showBanner = false;

  bool showBannerSmallWin = false;

  bool showBannerBigWin = false;

  bool showCounterButton = false;

  int bannerRoom = 0;

  bool showLuckyBanner = false;

  String luckySenderimg = "";

  String bannerMsg = "";

  String bannerMsg2 = "";

  String giftImgSmall = "";

  ScrollController _scrollController = new ScrollController();
  List<int> speakers = [];

  String enteryBanner = "";
  String enteryMessage = "";
  bool showEnteryBanner = false;

  bool isVip = false;

  bool showRainLuckyCase = false;

  bool showLuckyCase = false;

  int lucky_id = 0;

  bool canOpenLuckyCase = true;

  final player = AudioPlayer();
  late Timer timer;

  var passwordController = TextEditingController();
  String local = '';

  bool isNewCommer = false;

  final CountDownController _countDownController = CountDownController();

  final int _duration = 5;

  int luckyGiftId = 0;

  int luckyGiftCount = 0;

  int luckyGiftReciver = 0;

  int appID = 0;

  String appSign = '';
  TokenModel? zegoToken;

  List<ZegoUser> users = [];

  List<StreamSubscription> subscriptions = [];

  late ZegoExpressEngine zegoEngine;

  ZegoMediaPlayer? audioPlayer;

  List<RoomMember>? matchedMembers;

  final List<Map<String, dynamic>> queue = [];

  bool isPlaying = false;

  List<String> entryQueue = [];

  bool isShowingEntry = false;

  TokenModel? tokenModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    if (mounted) {
      _controller = SVGAAnimationController(vsync: this);
      setState(() {
        isNewCommer = false;
        sendGiftReceiverType = "select_one_ore_more";
        user = AppUserServices().userGetter();
        room = ChatRoomService().roomGetter();
        print('room!.roomCup');
        print(room!.members!.length);
        print(room!.roomCup);
        setState(() {
          channel = room!.tag;
        });
        if (user!.id == room!.userId) {
          setState(() {
            userRole = 'OWNER';
          });
        } else if (room!.admins!
                .where((element) => element.user_id == user!.id)
                .length >
            0) {
          setState(() {
            userRole = 'ADMIN';
          });
        } else {
          setState(() {
            userRole = 'USER';
          });
        }
      });
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkRoomBlock();
    });

    EnterRoomHelper(user!.id, room!.id, context);

    messages = ChatRoomService().messages;

    if (ChatRoomService.savedRoom == null) {
      initZego();
    } else {
      ChatRoomService().savedRoomSetter(null);
      initZego();
    }
    getRoomImage();
    print('room!.id');
    print(room!.id);
    geAdminDesigns();
    getRoomBasicData();
    focusNode.addListener(() {
      if (!focusNode.hasFocus) {
        FocusScope.of(context).unfocus();
        if (mounted) {
          setState(() {
            emojiShowing = false;
          });
        }

        toggleMessageInput();
      }
    });
    luckyCaseForNewComers();
    Future.delayed(Duration(seconds: 5)).then((_) {
      refreshRoom(user!.id);
    });
  }

  void playNext() async {
    if (isPlaying || queue.isEmpty) return;

    isPlaying = true;
    final gift = queue.removeAt(0);

    await playGift(gift);

    isPlaying = false;
    playNext();
  }

  Future<void> playGift(Map<String, dynamic> gift) async {
    if (gift['gift_img'].toLowerCase().endsWith('.svga')) {
      await svgaImagesListener(
        gift['room_id'],
        gift['gift_img'],
        gift['gift_name'],
        gift['receiver_name'],
        gift['sender_name'],
        gift['sender_share_level'],
        gift['sender_img'],
        gift['sender_id'],
        gift['gift_audio'],
        gift['giftImgSmall'],
        gift['sender'],
        gift['gift_category_id'],
        gift['reward'],
        gift['gift_id'],
        gift['receiver_id'],
        gift['count'],
      );
    }
    await Future.delayed(const Duration(milliseconds: 800));
  }

  void addGift(Map<String, dynamic> giftData) {
    queue.add(giftData);
    print('queue.length');
    print(queue.length);
    playNext();
  }

  void addUserToEntryQueue(String userId) {
    entryQueue.add(userId);
    print('entryQueue[0]');
    print(entryQueue[0]);
    _playNextEntry();
  }

  void _playNextEntry() async {
    if (isShowingEntry || entryQueue.isEmpty) return;

    isShowingEntry = true;

    while (entryQueue.isNotEmpty) {
      final nextUserId = entryQueue.removeAt(0);
      print('next id');
      print(nextUserId);
      Future.delayed(Duration(milliseconds: 350));
      await userJoinRoomWelcome(nextUserId);
    }

    isShowingEntry = false;
    print('All users have joined the room!');
  }

  Future<void> initZego() async {
    final token = await ChatRoomService().generateToken(user!.id);
    print('token');
    print(token.token);

    await ZEGOSDKManager().init(
      appID,
      appSign,
      scenario: ZegoScenario.HighQualityChatroom,
    );

    await ZEGOSDKManager().connectUser(
      user!.id.toString(),
      user!.name,
      token: token.token,
    );

    final zimService = ZEGOSDKManager().zimService;
    final expressService = ZEGOSDKManager().expressService;

    createMediaPlayer();

    ZegoLiveAudioRoomManager().logoutRoom();

    await ZegoLiveAudioRoomManager()
        .loginRoom(room!.id.toString(), ZegoLiveAudioRoomRole.audience)
        .then((result) {
          setState(() {
            _localUserJoined = true;
          });
          if (result.errorCode == 0) {
            print("✅ Login Room Success");
            refreshMicState();
            if (messages.isEmpty) {
              ChatRoomMessage message = ChatRoomMessage(
                message: 'room_msg'.tr,
                user_name: 'APP',
                user_share_level_img: '',
                user_img: '',
                user_id: 0,
                type: "TEXT",
              );
              List<ChatRoomMessage> old = [...messages];
              old.add(message);
              if (mounted) {
                setState(() {
                  ChatRoomService().addMessage(message);
                });
              }
              if (room!.hello_message != "") {
                message = ChatRoomMessage(
                  message: room!.hello_message,
                  user_name: 'ROOM',
                  user_share_level_img: '',
                  user_img: '',
                  user_id: 0,
                  type: "TEXT",
                );
                old.add(message);
                if (mounted) {
                  setState(() {
                    ChatRoomService().addMessage(message);
                  });
                }
              }
              if (mounted) {
                setState(() {
                  messages = old;
                });
              }
              // remove await from refreshRoom
              ChatRoomMessagesHelper(
                room_id: room!.id,
                user_id: user!.id,
                message: 'user_enter_message'.tr,
                type: 'TEXT',
                user_name: user!.name,
                user_share_level_img: user!.share_level_icon,
                user_img: user!.img,
                vip: user!.vips!.length > 0 ? user!.vips![0].icon : "",
                pubble: '',
                badges: [],
              ).sendRoomEvent();
            }
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

    addUserUnique(ZegoUser(user!.id.toString(), user!.name));

    ZegoExpressEngine.onRoomStreamUpdate =
        (
          String roomID,
          ZegoUpdateType updateType,
          List<ZegoStream> streamList,
          Map<String, dynamic> extendedData,
        ) {
          if (updateType == ZegoUpdateType.Add) {
            for (final stream in streamList) {
              ZegoExpressEngine.instance.startPlayingStream(stream.streamID);
              print("▶️ بدأ تشغيل الصوت: ${stream.streamID}");
            }
          } else if (updateType == ZegoUpdateType.Delete) {
            for (final stream in streamList) {
              ZegoExpressEngine.instance.stopPlayingStream(stream.streamID);
              print("⏹️ تم إيقاف الصوت: ${stream.streamID}");
            }
          }
        };
    // Listen to room user updates
    subscriptions.addAll([
      expressService.roomUserListUpdateStreamCtrl.stream.listen((event) async {
        if (event.updateType == ZegoUpdateType.Add) {
          addUserUnique(event.userList.first);
          for (var newUser in event.userList) {
            if (ChatRoomService.savedRoom == null) {
              addUserToEntryQueue(newUser.userID);
            }
          }
          for (var e in expressService.userInfoList) {
            addUserUnique(ZegoUser(e.userID, e.userName));
          }
        } else if (event.updateType == ZegoUpdateType.Delete) {
          print('User(s) exited: ${event.userList.length}');

          for (var exitedUser in event.userList) {
            ChatRoomService().exitRoom(exitedUser.userID, room!.id);
            users.removeWhere((element) => element.userID == exitedUser.userID);
          }
        }
      }),
      zimService.roomAttributeUpdateStreamCtrl.stream.listen((event) async {
        final attrs = event.updateInfo.roomAttributes;

        if (attrs.containsKey("theme_event")) {
          final rawData = attrs["theme_event"];
          if (rawData != null && rawData.isNotEmpty) {
            final data = jsonDecode(rawData);

            final eventRoomId = data['room_id'];
            final user_id = data['user_id'];
            final theme_id = data['theme_id'];

            if (user_id == user!.id) {
              await ChatRoomService().changeTheme(theme_id, eventRoomId);
            }
            if (mounted) {
              setState(() {
                refreshRoom(user!.id);
              });
            }
            print('room!.themeId');
            print(room!.themeId);
          }
          await ZEGOSDKManager().zimService.deleteRoomAttributes([
            'theme_event',
          ]);
        }

        if (attrs.containsKey("lucky_event")) {
          final rawData = attrs["lucky_event"];
          if (rawData != null && rawData.isNotEmpty) {
            final data = jsonDecode(rawData);

            final eventRoomId = data['room_id'];
            final eventUserId = data['user_id'];
            final eventUserImg = data['user_img'];
            final eventLuckyId = data['lucky_id'];
            final eventType = data['type'];
            final eventRoomName = data['room_name'];
            final eventUserName = data['user_name'];
            final eventAvailableUntil = data['available_until'];
            DateTime dateTime = DateTime.parse(eventAvailableUntil);

            luckyCaseListener(
              dateTime,
              eventLuckyId,
              eventRoomId,
              eventUserImg,
              eventType,
              eventRoomName,
              eventUserName,
            );
          }
          await ZEGOSDKManager().zimService.deleteRoomAttributes([
            'lucky_event',
          ]);
        }

        if (attrs.containsKey("mic_event")) {
          final rawData = attrs["mic_event"];

          if (rawData != null && rawData.isNotEmpty) {
            final data = jsonDecode(rawData);

            final targetMicId = data['id'];
            final targetRoomId = data['room_id'];
            final targetOrder = data['order'];
            final targetUserId = data['user_id'];
            final targetIsClosed = data['isClosed'];
            final targetIsMute = data['isMute'];
            final targetCounter = data['counter'];
            final targetChargingLevel = data['mic_user_charging_level'];
            final targetKarizmaLevel = data['mic_user_karizma_level'];
            final targetBirthDate = data['mic_user_birth_date'];
            final targetShareLevel = data['mic_user_share_level'];
            final targetTag = data['mic_user_tag'];
            final targetUserName = data['mic_user_name'];
            final targetUserImg = data['mic_user_img'];
            final targetUserGender = data['mic_user_gender'];
            String streamId = "${targetUserId}_${targetRoomId}";

            if (targetUserId.toString() == user!.id.toString()) {
              await startMicStream(streamId);
              ChatRoomService().useMic(targetUserId, targetRoomId, targetOrder);
              if (mounted) {
                _localUserMute = false;
              }
            } else {
              ZegoExpressEngine.instance.startPlayingStream(streamId);
              print('Voice done');
            }
            if (mounted) {
              setState(() {
                // refreshRoom(user!.id);
                print(room!.mics.toString());

                int index = room!.mics!.indexWhere(
                  (mic) => mic.user_id == targetUserId,
                );
                if (index != -1) {
                  room!.mics![index] = Mic(
                    id: index,
                    room_id: targetRoomId,
                    order: index + 1,
                    user_id: 0,
                    isClosed: 0,
                    isMute: 0,
                    counter: 0,
                    mic_user_gender: null,
                    mic_user_img: null,
                    mic_user_name: null,
                    mic_user_tag: null,
                    mic_user_share_level: null,
                    mic_user_birth_date: null,
                    mic_user_karizma_level: null,
                    mic_user_charging_level: null,
                    frame: '',
                  );
                }

                room!.mics![targetOrder - 1] = Mic(
                  id: targetMicId,
                  room_id: targetRoomId,
                  order: targetOrder,
                  user_id: targetUserId,
                  isClosed: targetIsClosed,
                  isMute: targetIsMute,
                  counter: targetCounter,
                  mic_user_gender: targetUserGender,
                  mic_user_img: targetUserImg,
                  mic_user_name: targetUserName,
                  mic_user_tag: targetTag,
                  mic_user_share_level: targetShareLevel,
                  mic_user_birth_date: targetBirthDate,
                  mic_user_karizma_level: targetKarizmaLevel,
                  mic_user_charging_level: targetChargingLevel,
                  frame: frame,
                );
              });
            }
          }
          await ZEGOSDKManager().zimService.deleteRoomAttributes(['mic_event']);
        }

        if (attrs.containsKey("mic_leave_event")) {
          final rawData = attrs["mic_leave_event"];

          if (rawData != null && rawData.isNotEmpty) {
            final data = jsonDecode(rawData);

            final targetRoomId = data['room_id'];
            final targetOrder = data['order'];
            final targetUserId = data['user_id'];

            if (targetUserId.toString() == user!.id.toString()) {
              await ZegoExpressEngine.instance.stopPublishingStream();
              await ZegoExpressEngine.instance.muteMicrophone(true);
              ChatRoomService().leaveMic(
                targetUserId,
                targetRoomId,
                targetOrder,
                user!.id,
              );
              await audioPlayer?.stop();
            } else {
              final streamId = "${targetUserId}_${targetRoomId}";
              ZegoExpressEngine.instance.stopPlayingStream(streamId);
            }
            if (mounted) {
              setState(() {
                int index = room!.mics!.indexWhere(
                  (mic) => mic.user_id == targetUserId,
                );
                if (index != -1) {
                  room!.mics![index] = Mic(
                    id: index,
                    room_id: targetRoomId,
                    order: index + 1,
                    user_id: 0,
                    isClosed: 0,
                    isMute: _localUserMute ? 1 : 0,
                    counter: 0,
                    mic_user_gender: null,
                    mic_user_img: null,
                    mic_user_name: null,
                    mic_user_tag: null,
                    mic_user_share_level: null,
                    mic_user_birth_date: null,
                    mic_user_karizma_level: null,
                    mic_user_charging_level: null,
                    frame: '',
                  );
                }
              });
            }
          }
          await ZEGOSDKManager().zimService.deleteRoomAttributes([
            'mic_leave_event',
          ]);
        }

        if (attrs.containsKey("gift_event")) {
          final rawData = attrs["gift_event"];
          if (rawData != null && rawData.isNotEmpty) {
            final data = jsonDecode(rawData);

            dynamic availableUntil = DateTime.parse(data['available_untill']);
            if (checkGiftShow(availableUntil)) {
              AppUser? sender = await AppUserServices().getUser(
                data['sender_id'],
              );

              final giftData = {
                'room_id': data['room_id'],
                'sender_id': data['sender_id'],
                'sender_name': data['sender_name'],
                'sender_img': data['sender_img'],
                'receiver_id': data['receiver_id'],
                'receiver_name': data['receiver_name'],
                'receiver_img': data['receiver_img'],
                'gift_name': data['gift_name'],
                'gift_audio': data['gift_audio'],
                'gift_img': data['gift_img'],
                'giftImgSmall': data['giftImgSmall'],
                'count': data['count'],
                'sender_share_level': data['sender_share_level'],
                'sender': sender,
                'gift_category_id': data['gift_category_id'],
                'reward': data['reward'],
                'gift_id': data['gift_id'],
              };
              print('giftData[gift_img]');
              print(giftData['gift_img']);
              addGift(giftData);
            }
          }

          refreshRoom(0);
          await ZEGOSDKManager().zimService.deleteRoomAttributes([
            'gift_event',
          ]);
        }

        if (attrs.containsKey("emoji_event")) {
          print('emoji_event');
          final rawData = attrs["emoji_event"];
          if (rawData != null && rawData.isNotEmpty) {
            final data = jsonDecode(rawData);

            final roomId = data['room_id'];
            final userId = data['user_id'];
            final mic = data['mic'];
            final emoji = data['emoj'];
            print('mic');
            print(mic);

            if (roomId == room!.id && micEmojs[mic - 1] == '') {
              if (mounted) {
                setState(() {
                  micEmojs[mic - 1] = emoji;
                });
              }
              print('micEmojs[mic - 1]');
              print(micEmojs[mic - 1]);

              await Future.delayed(Duration(seconds: 5));
              if (mounted) {
                setState(() {
                  micEmojs[mic - 1] = "";
                });
              }
            } else {
              await Future.delayed(Duration(seconds: 4));
              if (mounted) {
                setState(() {
                  micEmojs[mic - 1] = emoji;
                });
              }
              print('micEmojs[mic - 1]');
              print(micEmojs[mic - 1]);

              await Future.delayed(Duration(seconds: 5));
              if (mounted) {
                setState(() {
                  micEmojs[mic - 1] = "";
                });
              }
            }

            print("😄 Emoji event received from user $userId: $emoji , $mic");
          }
          await ZEGOSDKManager().zimService.deleteRoomAttributes([
            'emoji_event',
          ]);
        }

        if (attrs.containsKey("room_event")) {
          final rawData = attrs["room_event"];
          if (rawData != null && rawData.isNotEmpty) {
            final data = jsonDecode(rawData);

            final roomId = data['room_id'];
            if (roomId == room!.id) {
              final message = ChatRoomMessage(
                roomId: data['room_id'],
                user_id: data['user_id'],
                message: data['message'] ?? '',
                type: data['type'] ?? 'TEXT',
                user_name: data['user_name'] ?? '',
                user_share_level_img: data['user_share_level_img'] ?? '',
                user_img: data['user_img'] ?? '',
                vip: data['vip'],
                pubble: data['pubble'],
                badges: data['badges'] != null
                    ? (data['badges'] as List)
                          .map((b) => UserBadge.fromJson(b))
                          .toList()
                    : null,
              );

              if (mounted) {
                setState(() {
                  messages.add(message);
                  if (mounted) {
                    setState(() {
                      ChatRoomService().addMessage(message);
                    });
                  }
                  Future.delayed(Duration(seconds: 2)).then(
                    (value) => {
                      _scrollController.animateTo(
                        _scrollController.position.maxScrollExtent,
                        duration: const Duration(milliseconds: 1),
                        curve: Curves.fastOutSlowIn,
                      ),
                    },
                  );
                });
              }

              print(
                "✅ Room message received from user ${data['user_id']}: ${data['message']}",
              );
            }
          }
          await ZEGOSDKManager().zimService.deleteRoomAttributes([
            'room_event',
          ]);
        }

        if (attrs.containsKey("lock_event")) {
          final rawData = attrs["lock_event"];
          if (rawData != null && rawData.isNotEmpty) {
            print('start');
            final data = jsonDecode(rawData);
            final user_id = data['user_id'];
            final mic = data['mic'];

            print('user_id');
            print(user_id);
            print(user!.id);

            if (mounted) {
              setState(() {
                if (user!.id.toString() == user_id.toString()) {
                  ChatRoomService().lockMic(
                    user!.id,
                    room!.id,
                    mic,
                    AppUserServices().userGetter()!.id,
                  );
                }

                print('micmic');
                print(mic);

                if (mic != 0) {
                  room!.mics![mic - 1] = Mic(
                    id: mic - 1,
                    room_id: data['room_id'],
                    order: mic,
                    user_id: 0,
                    isClosed: 1,
                    isMute: 0,
                    counter: 0,
                    mic_user_gender: null,
                    mic_user_img: null,
                    mic_user_name: null,
                    mic_user_tag: null,
                    mic_user_share_level: null,
                    mic_user_birth_date: null,
                    mic_user_karizma_level: null,
                    mic_user_charging_level: null,
                    frame: '',
                  );
                } else {
                  for (int i = 0; i <= room!.mics!.length - 1; i++) {
                    room!.mics![i] = Mic(
                      id: i,
                      room_id: data['room_id'],
                      order: i + 1,
                      user_id: 0,
                      isClosed: 1,
                      isMute: 0,
                      counter: 0,
                      mic_user_gender: null,
                      mic_user_img: null,
                      mic_user_name: null,
                      mic_user_tag: null,
                      mic_user_share_level: null,
                      mic_user_birth_date: null,
                      mic_user_karizma_level: null,
                      mic_user_charging_level: null,
                      frame: '',
                    );
                  }
                }
              });
            }
          }
          await ZEGOSDKManager().zimService.deleteRoomAttributes([
            'lock_event',
          ]);
        }

        if (attrs.containsKey("unlock_event")) {
          final rawData = attrs["unlock_event"];
          if (rawData != null && rawData.isNotEmpty) {
            print('start');
            final data = jsonDecode(rawData);
            final user_id = data['user_id'];
            final mic = data['mic'];

            if (mounted) {
              setState(() {
                if (user!.id.toString() == user_id.toString()) {
                  ChatRoomService().unlockMic(
                    user!.id,
                    room!.id,
                    mic,
                    AppUserServices().userGetter()!.id,
                  );
                }

                if (mic != 0) {
                  room!.mics![mic - 1] = Mic(
                    id: mic - 1,
                    room_id: data['room_id'],
                    order: mic,
                    user_id: 0,
                    isClosed: 0,
                    isMute: 0,
                    counter: 0,
                    mic_user_gender: null,
                    mic_user_img: null,
                    mic_user_name: null,
                    mic_user_tag: null,
                    mic_user_share_level: null,
                    mic_user_birth_date: null,
                    mic_user_karizma_level: null,
                    mic_user_charging_level: null,
                    frame: '',
                  );
                } else {
                  for (int i = 0; i <= room!.mics!.length - 1; i++) {
                    room!.mics![i] = Mic(
                      id: i,
                      room_id: data['room_id'],
                      order: i + 1,
                      user_id: 0,
                      isClosed: 0,
                      isMute: 0,
                      counter: 0,
                      mic_user_gender: null,
                      mic_user_img: null,
                      mic_user_name: null,
                      mic_user_tag: null,
                      mic_user_share_level: null,
                      mic_user_birth_date: null,
                      mic_user_karizma_level: null,
                      mic_user_charging_level: null,
                      frame: '',
                    );
                  }
                }
              });
            }
          }
          await ZEGOSDKManager().zimService.deleteRoomAttributes([
            'unlock_event',
          ]);
        }

        if (attrs.containsKey("remove_event")) {
          final rawData = attrs["remove_event"];
          if (rawData != null && rawData.isNotEmpty) {
            final data = jsonDecode(rawData);
            final mic = data['mic'];
            final userIdToRemove = data['user_id'];
            final roomId = data['room_id'];
            final adminId = data['admin_id'];

            print(adminId);
            print(userIdToRemove);

            if (mounted) {
              setState(() {
                if (adminId.toString() == user!.id.toString()) {
                  ChatRoomService().leaveMic(
                    userIdToRemove,
                    roomId,
                    mic,
                    adminId,
                  );
                }
                String streamId = "${userIdToRemove}_$roomId";
                ZegoExpressEngine.instance.stopPlayingStream(streamId);
                print('Stopped voice stream of $userIdToRemove');

                room!.mics![mic - 1] = Mic(
                  id: mic - 1,
                  room_id: roomId,
                  order: mic,
                  user_id: 0,
                  isClosed: 0,
                  isMute: 0,
                  counter: 0,
                  mic_user_gender: null,
                  mic_user_img: null,
                  mic_user_name: null,
                  mic_user_tag: null,
                  mic_user_share_level: null,
                  mic_user_birth_date: null,
                  mic_user_karizma_level: null,
                  mic_user_charging_level: null,
                  frame: '',
                );
              });
            }
          }
          await ZEGOSDKManager().zimService.deleteRoomAttributes([
            'remove_event',
          ]);
        }

        if (attrs.containsKey("kick_event")) {
          final rawData = attrs["kick_event"];
          if (rawData != null && rawData.isNotEmpty) {
            final data = jsonDecode(rawData);
            final targetUserId = data['user_id'];
            final blockType = data['block_type'];
            final roomId = data['room_id'];
            final myID = data['myID'];
            if (mounted) {
              setState(() {
                print("🚨 kick event received for user: $targetUserId");
                print(myID);
                print(user!.id);
                if (user!.id.toString() == myID.toString()) {
                  ChatRoomService().blockRoomMember(
                    targetUserId,
                    roomId,
                    blockType,
                    user!.id,
                  );
                }

                final streamId = "${targetUserId}_${roomId}";
                ZegoExpressEngine.instance.stopPlayingStream(streamId);
                blockRoomListener(blockType, roomId, targetUserId);
                print('Stopped voice stream of $targetUserId');
              });
            }
          }
          await ZEGOSDKManager().zimService.deleteRoomAttributes([
            'kick_event',
          ]);
        }
      }),
    ]);

    // Add all users currently in the room
    for (var e in expressService.userInfoList) {
      addUserUnique(ZegoUser(e.userID, e.userName));
    }
    print('users.length');
    print(users.length);
    for (var member in users) {
      print('users');
      print('🧍 Member ID: ${member.userID}, Name: ${member.userName}');
      print(user!.id);
    }

    print('users.length');
    print(users[0].userID);
    print(user!.id);

    bool exists = room!.members!.any((member) => member.user_id == user!.id);

    if (exists) {
      print('user is exist');
    } else {
      print('user is not exist');
    }
    matchedMembers = room!.members!.where((member) {
      return users.any(
        (zegoUser) => zegoUser.userID.toString() == member.user_id.toString(),
      );
    }).toList();

    print(matchedMembers!.length);

    print(users.length);

    ZegoExpressEngine.onIMRecvBroadcastMessage =
        (String roomID, List<ZegoBroadcastMessageInfo> messageList) {
          if (messageList.isEmpty) {
            debugPrint("⚠️ لا توجد رسائل مستلمة في القائمة");
            return;
          }

          final ZegoBroadcastMessageInfo zegoMessage = messageList.last;

          debugPrint("📩 استلمت رسالة نصها: ${zegoMessage.message}");

          try {
            final Map<String, dynamic> jsonMap =
                jsonDecode(zegoMessage.message) as Map<String, dynamic>;

            final ChatRoomMessage receivedMessage = ChatRoomMessage.fromJson(
              jsonMap,
            );

            messages.insert(messages.length, receivedMessage);
            if (mounted) {
              setState(() {
                ChatRoomService().addMessage(receivedMessage);
              });
            }

            debugPrint("✅ تم إضافة الرسالة لقائمة الرسائل");
          } catch (e) {
            debugPrint("❌ خطأ أثناء فك رسالة JSON أو التعامل معها: $e");
          }
        };
  }

  void addUserUnique(ZegoUser newUser) {
    if (!users.any((u) => u.userID == newUser.userID)) {
      users.add(newUser);
    }
  }

  Future<void> refreshMicState() async {
    print('🎤 start refresh mic state');
    try {
      if (!mounted || room == null) return;

      setState(() {
        for (int i = 0; i < room!.mics!.length; i++) {
          final mic = room!.mics![i];
          print(
            "🎙️ Mic ${mic.order}: user_id=${mic.user_id}, mute=${mic.isMute}, closed=${mic.isClosed}",
          );

          if (mic.user_id == user!.id && mic.isMute == 0 && mic.isClosed == 0) {
            String streamId = "${mic.user_id}_${room!.id}";
            startMicStream(streamId);
            print("✅ User ${user!.name} should re-enable mic stream");
            print("🎧 Mic stream re-enabled successfully!");
          }
        }
      });
    } catch (e, s) {
      print("❌ Error refreshing mic state: $e");
      print(s);
    }
  }

  logoutRoom() async {
    await ZEGOSDKManager().disconnectUser();

    for (final subscription in subscriptions) {
      subscription.cancel();
    }
  }

  unUnitZego() async {
    for (final subscription in subscriptions) {
      subscription.cancel();
    }
    ZegoExpressEngine.onRoomStreamUpdate = null;
    ZegoExpressEngine.onCapturedSoundLevelUpdate = null;
    ZegoExpressEngine.onRemoteSoundLevelUpdate = null;
    ZegoExpressEngine.onIMRecvBroadcastMessage = null;
    ZegoExpressEngine.instance.stopSoundLevelMonitor();
    if (audioPlayer != null) {
      ZegoExpressEngine.instance.destroyMediaPlayer(audioPlayer!);
      audioPlayer = null;
    }
    await logoutRoom();
  }

  Future<void> createMediaPlayer() async {
    final profile = ZegoEngineProfile(
      appID,
      appSign: appSign,
      ZegoScenario.Live,
    );

    await ZegoExpressEngine.createEngineWithProfile(profile);

    zegoEngine = ZegoExpressEngine.instance;

    print("✅ Zego Engine Initialized");

    if (audioPlayer == null) {
      print("🎵 Creating ZegoMediaPlayer...");

      final player = await zegoEngine.createMediaPlayer();

      if (player != null) {
        audioPlayer = player;
        print("🎶 ZegoMediaPlayer Created Successfully");
      } else {
        print("⚠️ Failed to create MediaPlayer instance");
      }
    } else {
      print("ℹ️ MediaPlayer already initialized");
    }
  }

  Future<void> startMicStream(String streamId) async {
    try {
      await ZegoExpressEngine.instance.muteMicrophone(false);
      await ZegoExpressEngine.instance.startPublishingStream(streamId);

      print("🎙️ تم تشغيل المايك وبدء البث الصوتي");
    } catch (e) {
      print("❌ فشل في تشغيل المايك: $e");
    }
  }

  getLocal() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? l = await prefs.getString('local_lang');
    if (l == null) l = 'en';
    if (l == '') l = 'en';
    if (mounted) {
      setState(() {
        local = l!;
      });
    }
  }

  checkRoomBlock() {
    if (room!.blockers!.where((element) => element.user_id == user!.id).length >
        0) {
      //  checkBlockDate(room!.blockers!.where((element) => element.user_id == user!.id).)
      //blocked
      Fluttertoast.showToast(
        msg: 'room_blocked_msg'.tr,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black26,
        textColor: Colors.orange,
        fontSize: 16.0,
      );
      ExitRoomHelper(user!.id, room!.id);
      Future.delayed(const Duration(seconds: 2), () {
        if (!mounted) return;
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const TabsScreen()),
          (route) => false,
        );
      });
    } else {
      // not blocked
    }
  }

  getRoomImage() {
    String img = '';
    if (room!.img == room!.admin_img) {
      if (room!.admin_img != "") {
        img = '${ASSETSBASEURL}AppUsers/${room?.img}';
      } else {
        img = '${ASSETSBASEURL}Defaults/room_default.png';
      }
    } else {
      if (room?.img != "") {
        img = '${ASSETSBASEURL}Rooms/${room?.img}';
      } else {
        img = '${ASSETSBASEURL}Defaults/room_default.png';
      }
    }
    if (mounted) {
      setState(() {
        room_img = img;
      });
    }
  }

  RoomAdminsListener() {
    CollectionReference reference = FirebaseFirestore.instance.collection(
      'roomAdmins',
    );
    reference.snapshots().listen((querySnapshot) {
      if (querySnapshot.docChanges.length > 0) {
        DocumentChange change = querySnapshot.docChanges[0];
        if (change.newIndex > 0) {
          Map<String, dynamic>? data =
              change.doc.data() as Map<String, dynamic>;
          int room_id = data['room_id'];
          if (room_id == room!.id) {
            refreshRoom(0);
          }
        }
      }
    });
  }

  // enterRoomListener() {
  //   CollectionReference reference = FirebaseFirestore.instance.collection(
  //     'enterRoom',
  //   );
  //   reference.snapshots().listen((querySnapshot) async {
  //     if (querySnapshot.docChanges.length > 0) {
  //       DocumentChange change = querySnapshot.docChanges[0];
  //
  //       if (change.newIndex > 0) {
  //         Map<String, dynamic>? data =
  //             change.doc.data() as Map<String, dynamic>;
  //         int room_id = data['room_id'];
  //         int user_id = data['user_id'];
  //         if (room_id == room!.id) {
  //           await refreshRoom(0);
  //
  //           if (isNewCommer == true) {
  //             userJoinRoomWelcome(user_id);
  //           }
  //         }
  //       }
  //     }
  //   });
  // }

  exitRoomListener() {
    CollectionReference reference = FirebaseFirestore.instance.collection(
      'exitRoom',
    );
    reference.snapshots().listen((querySnapshot) {
      if (querySnapshot.docChanges.length > 0) {
        DocumentChange change = querySnapshot.docChanges[0];
        if (change.newIndex > 0) {
          reference.doc(change.doc.id).delete();
          Map<String, dynamic>? data =
              change.doc.data() as Map<String, dynamic>;
          int room_id = data['room_id'];
          if (room_id == room!.id || room_id == 0) {
            refreshRoom(0);
          }
        }
      }
    });
  }

  micListener() {
    CollectionReference reference = FirebaseFirestore.instance.collection(
      'mic-state',
    );
    reference.snapshots().listen((querySnapshot) {
      if (querySnapshot.docChanges.length > 0) {
        DocumentChange change = querySnapshot.docChanges[0];
        if (change.newIndex > 0) {
          Map<String, dynamic>? data =
              change.doc.data() as Map<String, dynamic>;
          int room_id = data['room_id'];
          if (room_id == room!.id) {
            refreshRoom(0);
          }
        }
      }
    });
  }

  luckyCaseListener(
    available_untill,
    lucky,
    room_id,
    user_img,
    type,
    room_name,
    user_name,
  ) async {
    if (checkLuckyCaseShow(available_untill)) {
      LuckyCase? luckyCase = await ChatRoomService().getLuckyCase(lucky);
      if (luckyCase != null) {
        int duration = getLuckyCaseDuration(luckyCase, available_untill);

        if (duration > 0) {
          if (room!.id == room!.id) {
            if (mounted) {
              setState(() {
                if (room_id == room!.id) {
                  showLuckyCase = true;
                  showRainLuckyCase = true;
                  lucky_id = lucky;
                }
              });
            }

            Future.delayed(Duration(seconds: duration)).then(
              (value) => setState(() {
                showLuckyCase = false;
                lucky_id = 0;
                canOpenLuckyCase = true;
              }),
            );
          }

          if (type == "1") {
            if (mounted) {
              setState(() {
                bannerRoom = room_id;
                showLuckyBanner = true;
                luckySenderimg = user_img;
                lucky_id = lucky;
                bannerMsg =
                    '${user_name} sent a Lucky Case inside  ${room_name}';
              });
            }
          }

          Future.delayed(Duration(seconds: 20)).then((value) {
            if (type == "1") {
              if (mounted) {
                setState(() {
                  showLuckyBanner = false;
                  luckySenderimg = "";
                  bannerRoom = 0;
                  giftImgSmall = '';
                  bannerMsg = '';
                });
              }
            }
            if (mounted) {
              setState(() {
                showRainLuckyCase = false;
              });
            }
          });
        } else {
          if (mounted) {
            setState(() {
              showLuckyCase = false;
              showRainLuckyCase = false;
            });
          }
        }
      }
    }
  }

  luckyCaseForNewComers() async {
    LuckyCase? luckyCase = await ChatRoomService().getRoomLuckyCase(room!.id);
    if (luckyCase != null) {
      DateTime available_untill = DateTime.parse(
        luckyCase.created_date,
      ).add(Duration(minutes: 2));
      int duration = getRoomLuckyCaseDuration(luckyCase, available_untill);
      print('luckyCaseduration');
      print(duration);

      if (duration > 0) {
        if (mounted) {
          setState(() {
            showLuckyCase = true;
            lucky_id = luckyCase.id;
          });
        }
        await Future.delayed(Duration(seconds: duration));
        if (mounted) {
          setState(() {
            showLuckyCase = false;
            lucky_id = 0;
            canOpenLuckyCase = true;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            showLuckyCase = false;
          });
        }
      }
    }
  }

  micCounterListener() {
    CollectionReference reference = FirebaseFirestore.instance.collection(
      'mic-counter',
    );
    reference.snapshots().listen((querySnapshot) {
      if (querySnapshot.docChanges.length > 0) {
        DocumentChange change = querySnapshot.docChanges[0];
        if (change.newIndex > 0) {
          Map<String, dynamic>? data =
              change.doc.data() as Map<String, dynamic>;
          int room_id = data['room_id'];
          if (room_id == room!.id) {
            refreshRoom(0);
          }
        }
      }
    });
  }

  micUsageListener() {
    CollectionReference reference = FirebaseFirestore.instance.collection(
      'mic-usage',
    );
    reference.snapshots().listen((querySnapshot) {
      if (querySnapshot.docChanges.length > 0) {
        DocumentChange change = querySnapshot.docChanges[0];
        if (change.newIndex > 0) {
          Map<String, dynamic>? data =
              change.doc.data() as Map<String, dynamic>;
          int room_id = data['room_id'];
          if (room_id == room!.id) {
            refreshRoom(0);
          }
        }
      }
    });
  }

  micRemoveListener() {
    CollectionReference reference = FirebaseFirestore.instance.collection(
      'mic-remove',
    );
    reference.snapshots().listen((querySnapshot) async {
      if (querySnapshot.docChanges.length > 0) {
        DocumentChange change = querySnapshot.docChanges[0];
        if (change.newIndex > 0) {
          Map<String, dynamic>? data =
              change.doc.data() as Map<String, dynamic>;
          int room_id = data['room_id'];
          int user_id = data['user_id'];
          print(room_id);
          if (room_id == room!.id) {
            refreshRoom(0);
          }
          if (user_id == user!.id) {
            // if this is the user
            // show toast and stop publish
            try {
              await _engine.setClientRole(
                role: ClientRoleType.clientRoleAudience,
              );
              ChatRoomService.userRole = 'clientRoleAudience';
              if (mounted) {
                setState(() {
                  _localUserMute = true;
                });
              }
            } catch (err) {}
            Fluttertoast.showToast(
              msg: 'room_remove_mic'.tr,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.black26,
              textColor: Colors.orange,
              fontSize: 16.0,
            );
          }
        }
      }
    });
  }

  blockRoomListener(block_type, room_id, user_id) {
    String kickout_period = "";
    if (block_type == "HOUR") {
      kickout_period = 'kick_out_hour'.tr;
    } else if (block_type == "DAY") {
      kickout_period = 'kick_out_day'.tr;
    } else {
      kickout_period = 'kick_out_forever'.tr;
    }
    if (room_id.toString() == room!.id.toString()) {
      if (user_id == user!.id) {
        Fluttertoast.showToast(
          msg: 'kickout_msg'.tr + ' ' + kickout_period,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black26,
          textColor: Colors.orange,
          fontSize: 16.0,
        );
        exitRoom();
      }
      refreshRoom(0);
    }
  }

  exitRoom() async {
    print('start exit');
    int index = room!.mics!.indexWhere((mic) => mic.user_id == user!.id);
    await MicHelper(
      user!,
      user_id: user!.id,
      room_id: room!.id,
      mic: index,
    ).sendMicLeaveEvent(audioPlayer, zegoEngine);
    await ChatRoomService().leaveMic(user!.id, room!.id, index, 0);
    ExitRoomHelper(user!.id, room!.id);
    await unUnitZego();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const TabsScreen()),
      (route) => false,
    );
  }

  // themesListener() {
  //   CollectionReference reference = FirebaseFirestore.instance.collection(
  //     'themes',
  //   );
  //   reference.snapshots().listen((querySnapshot) {
  //     if (querySnapshot.docChanges.length > 0) {
  //       DocumentChange change = querySnapshot.docChanges[0];
  //       if (change.newIndex > 0) {
  //         Map<String, dynamic>? data =
  //             change.doc.data() as Map<String, dynamic>;
  //         int room_id = data['room_id'];
  //         if (room_id == room!.id) {
  //           refreshRoom(0);
  //         }
  //       }
  //     }
  //   });
  // }

  // micEmossionListener() async {
  //   reference.snapshots().listen((querySnapshot) async {
  //     if (querySnapshot.docChanges.length > 0) {
  //       DocumentChange change = querySnapshot.docChanges[0];
  //       if (change.newIndex > 0) {
  //         Map<String, dynamic>? data =
  //             change.doc.data() as Map<String, dynamic>;
  //         int room_id = data['room_id'];
  //         int mic = data['mic'];
  //         int user = data['user'];
  //         String emoj = data['emoj'];
  //
  //       }
  //     }
  //     // });
  //   });
  // }

  // messagesListener() async {
  //   CollectionReference reference = FirebaseFirestore.instance.collection(
  //     'RoomMessages',
  //   );
  //   reference.snapshots().listen((querySnapshot) async {
  //     if (querySnapshot.docChanges.length > 0) {
  //       DocumentChange change = querySnapshot.docChanges[0];
  //
  //       if (change.newIndex > 0) {
  //         Map<String, dynamic>? data =
  //             change.doc.data() as Map<String, dynamic>;
  //         int room_id = data['room_id'];
  //         int user_id = data['user_id'];
  //         String msg = data['message'];
  //         String type = data['type'];
  //
  //         print('room_idroom_idroom_id');
  //         ChatRoom? res = await ChatRoomService().openRoomById(room!.id);
  //         if (mounted) {
  //           setState(() {
  //             room = res;
  //             ChatRoomService().roomSetter(room!);
  //           });
  //         }
  //         RoomMember member = room!.members!
  //             .where((element) => element.user_id == user_id)
  //             .toList()[0];
  //         AppUser? sender = await AppUserServices().getUser(user_id);
  //         String pubble = "";
  //         if (member.pubble != "") {
  //           pubble =
  //               ASSETSBASEURL + 'Designs/Motion/' + member.pubble.toString();
  //         }
  //
  //         if (room_id == room!.id) {
  //           ChatRoomMessage message = ChatRoomMessage(
  //             message: msg.tr,
  //             user_name: sender!.name.toString(),
  //             user_share_level_img: sender.share_level_icon.toString(),
  //             user_img: sender.img.toString(),
  //             user_id: sender.id,
  //             type: type,
  //             vip: sender.vips!.length > 0 ? sender.vips![0].icon : "",
  //             pubble: pubble,
  //             badges: member.badges!,
  //           );
  //           List<ChatRoomMessage> old = [...messages];
  //           old.add(message);
  //           if (mounted) {
  //             setState(() {
  //               messages = old;
  //             });
  //           }
  //
  //           await Future.delayed(Duration(seconds: 2));
  //           if (_scrollController.hasClients) {
  //             _scrollController.animateTo(
  //               _scrollController.position.maxScrollExtent,
  //               duration: const Duration(milliseconds: 1),
  //               curve: Curves.fastOutSlowIn,
  //             );
  //           }
  //         }
  //       }
  //     }
  //   });
  // }

  // giftListener() async {
  //   //gifts
  //   CollectionReference reference = FirebaseFirestore.instance.collection(
  //     'gifts',
  //   );
  //   reference.snapshots().listen((querySnapshot) async {
  //     if (querySnapshot.docChanges.length > 0) {
  //       DocumentChange change = querySnapshot.docChanges[0];
  //
  //       if (change.newIndex > 0) {
  //         Map<String, dynamic>? data =
  //             change.doc.data() as Map<String, dynamic>;
  //         int room_id = data['room_id'];
  //         int sender_id = data['sender_id'];
  //         String sender_name = data['sender_name'];
  //         String sender_img = data['sender_img'];
  //         int receiver_id = data['receiver_id'];
  //         String receiver_name = data['receiver_name'];
  //         String receiver_img = data['receiver_img'];
  //         String gift_name = data['gift_name'];
  //         String gift_img = data['gift_img'];
  //         int count = data['count'];
  //         String gift_audio = data['gift_audio'];
  //         String sender_share_level = data['sender_share_level'];
  //         String small_gift = data['giftImgSmall'];
  //         dynamic available_untill = data['available_untill'];
  //         int gift_category_id = data['gift_category_id'];
  //         int reward = data['reward'];
  //         int gift_id = data['gift_id'];
  //
  //         if (checkGiftShow(available_untill)) {
  //           AppUser? sender = await AppUserServices().getUser(sender_id);
  //
  //           if (room_id == room!.id) {
  //             refreshRoom(0);
  //           }
  //           if (gift_img.toLowerCase().endsWith('.svga')) {
  //             if (giftImg == '') {
  //               svgaImagesListener(
  //                 room_id,
  //                 gift_img,
  //                 gift_name,
  //                 receiver_name,
  //                 sender_name,
  //                 sender_share_level,
  //                 sender_img,
  //                 sender_id,
  //                 gift_audio,
  //                 small_gift,
  //                 sender,
  //                 gift_category_id,
  //                 reward,
  //                 gift_id,
  //                 receiver_id,
  //                 count,
  //               );
  //             } else {
  //               await Future.delayed(
  //                 Duration(seconds: gift_category_id != 5 ? 5 : 8),
  //               ).then(
  //                 (value) => {
  //                   svgaImagesListener(
  //                     room_id,
  //                     gift_img,
  //                     gift_name,
  //                     receiver_name,
  //                     sender_name,
  //                     sender_share_level,
  //                     sender_img,
  //                     sender_id,
  //                     gift_audio,
  //                     small_gift,
  //                     sender,
  //                     gift_category_id,
  //                     reward,
  //                     gift_id,
  //                     receiver_id,
  //                     count,
  //                   ),
  //                 },
  //               );
  //             }
  //           }
  //         }
  //       }
  //     }
  //   });
  // }

  svgaImagesListener(
    room_id,
    gift_img,
    gift_name,
    receiver_name,
    sender_name,
    sender_share_level,
    sender_img,
    sender_id,
    gift_audio,
    small_gift,
    AppUser? sender,
    gift_category_id,
    reward,
    gift_id,
    receiver_id,
    count,
  ) async {
    if (room_id == room!.id) {
      RoomMember member = room!.members!
          .where((element) => element.user_id == sender_id)
          .toList()[0];
      //show gift
      if (mounted) {
        setState(() {
          giftImg = '';
        });
      }

      await Future.delayed(const Duration(milliseconds: 50));
      if (mounted) {
        setState(() {
          giftImg = '${ASSETSBASEURL}Designs/Motion/${gift_img}';
          if (gift_category_id == 5) {
            showCounterButton = true;
            luckyGiftId = gift_id;
            luckyGiftCount = count;
            luckyGiftReciver = receiver_id;
            if (_countDownController.isStarted == false)
              _countDownController.start();
          } else {
            showCounterButton = false;
          }
        });
      }
      print('giftImg');
      print(giftImg);

      await Future.delayed(Duration(seconds: 1));
      if (gift_audio != "") {
        // final duration = await player.setUrl(gift_audio);
        // player.play();
      }
      // show on tetx
      String pubble = "";
      if (member.pubble != "") {
        pubble = ASSETSBASEURL + 'Designs/Motion/' + member.pubble.toString();
      }

      ChatRoomMessage message = ChatRoomMessage(
        message: 'sent a ${gift_name} to ${receiver_name}',
        user_name: sender_name.toString(),
        user_share_level_img: sender_share_level.toString(),
        user_img: sender_img.toString(),
        user_id: sender_id,
        type: 'GIFT',
        vip: user!.vips!.length > 0 ? user!.vips![0].icon : "",
        pubble: pubble,
        badges: member.badges!,
      );
      List<ChatRoomMessage> old = [...messages];
      old.add(message);
      if (mounted) {
        setState(() {
          messages = old;
        });
        setState(() {
          ChatRoomService().addMessage(message);
        });
      }
    }

    if (mounted) {
      setState(() {
        if (gift_category_id != 5) {
          showBanner = true;
          bannerRoom = room_id;
          bannerMsg = '${sender_name} sent a ${gift_name} to ${receiver_name}';
        } else {
          if (reward == 1 ||
              reward == 2 ||
              reward == 5 ||
              reward == 10 ||
              reward == 20) {
            showBannerSmallWin = true;
            bannerRoom = room_id;
            bannerMsg = "Get X" + reward.toString();
          } else if (reward == 30 ||
              reward == 40 ||
              reward == 50 ||
              reward == 100) {
            showBannerBigWin = true;
            bannerRoom = room_id;
            bannerMsg =
                '${sender_name} Get X${reward} from Lucky Gift ${gift_name}';
            "Get X" + reward;
          }
        }

        giftImgSmall = small_gift;
      });
    }
    await Future.delayed(Duration(seconds: 5)).then(
      (value) => {
        if (mounted)
          {
            setState(() {
              showBannerSmallWin = false;
            }),
          },
      },
    );

    //show banner in all rooms
    if (mounted) {
      setState(() {
        showBanner = false;
        bannerState = 0;
        bannerRoom = 0;
        bannerMsg = "";
        giftImgSmall = "";
        showBannerBigWin = false;
      });
    }
    print('giftImg');
    print(giftImg);
  }

  // mp4GiftsListener(
  //   room_id,
  //   gift_img,
  //   gift_name,
  //   receiver_name,
  //   sender_name,
  //   sender_share_level,
  //   sender_img,
  //   sender_id,
  // ) async {
  //   if (room_id == room!.id) {
  //     //show gift
  //
  //     // show on tetx
  //     ChatRoomMessage message = ChatRoomMessage(
  //       message: 'sent a ${gift_name} to ${receiver_name}',
  //       user_name: sender_name.toString(),
  //       user_share_level_img: sender_share_level.toString(),
  //       user_img: sender_img.toString(),
  //       user_id: sender_id,
  //       type: 'GIFT',
  //     );
  //     List<ChatRoomMessage> old = [...messages];
  //     old.add(message);
  //     if (mounted) {
  //       setState(() {
  //         messages = old;
  //       });
  //     }
  //   }
  //   //show banner in all rooms
  //   if (mounted) {
  //     setState(() {
  //       showBanner = true;
  //       giftImgSmall = gift_img;
  //       bannerMsg = '${sender_name} sent a ${gift_name} to ${receiver_name}';
  //     });
  //   }
  //   await Future.delayed(Duration(seconds: 10)).then(
  //     (value) => {
  //       if (mounted)
  //         {
  //           setState(() {
  //             showBanner = false;
  //             bannerState = 0;
  //             bannerMsg = "";
  //             giftImgSmall = "";
  //           }),
  //         },
  //     },
  //   );
  // }

  // smallGiftsListener(
  //   room_id,
  //   gift_img,
  //   gift_name,
  //   receiver_name,
  //   sender_name,
  //   sender_share_level,
  //   sender_img,
  //   sender_id,
  // ) async {
  //   if (room_id == room!.id) {
  //     //show gift
  //     if (mounted) {
  //       setState(() {
  //         giftImg = gift_img;
  //       });
  //     }
  //     await Future.delayed(Duration(seconds: 5)).then(
  //       (value) => {
  //         if (mounted)
  //           {
  //             setState(() {
  //               giftImg = '';
  //             }),
  //           },
  //       },
  //     );
  //     // show on tetx
  //     ChatRoomMessage message = ChatRoomMessage(
  //       message: 'sent a ${gift_name} to ${receiver_name}',
  //       user_name: sender_name.toString(),
  //       user_share_level_img: sender_share_level.toString(),
  //       user_img: sender_img.toString(),
  //       user_id: sender_id,
  //       type: 'GIFT',
  //     );
  //     List<ChatRoomMessage> old = [...messages];
  //     old.add(message);
  //     if (mounted) {
  //       setState(() {
  //         messages = old;
  //       });
  //     }
  //   }
  //   //show banner in all rooms
  // }

  RolletCreatListner() async {
    CollectionReference reference = FirebaseFirestore.instance.collection(
      'roulette',
    );
    reference.snapshots().listen((querySnapshot) {
      if (querySnapshot.docChanges.length > 0) {
        DocumentChange change = querySnapshot.docChanges[0];
        if (change.newIndex > 0) {
          Map<String, dynamic>? data =
              change.doc.data() as Map<String, dynamic>;
          int room_id = data['room_id'];
          int rollet_id = data['rollet_id'];
          if (room_id == room!.id) {
            showRolletWheal(rollet_id);
          }
        }
      }
    });
  }

  showRolletWheal(rollet_id) async {
    Rollet? rollet = await ChatRoomService().getRollet(rollet_id);
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (ctx) => roomRolletModal(rollet!),
    );
  }

  refreshRoom(joiner_id) async {
    print('refresh room');
    ChatRoom? res = await ChatRoomService().openRoomById(room!.id);

    if (mounted) {
      setState(() {
        room = res;
        ChatRoomService().roomSetter(room!);
      });
    }

    getRoomImage();
  }

  Future<void> userJoinRoomWelcome(String joiner_id) async {
    refreshRoom(user!.id);
    print('room!.members!.length');
    print(room!.members!.length);

    RoomMember joiner = room!.members!.firstWhere(
      (element) => element.user_id.toString() == joiner_id.toString(),
    );

    print('enter room');
    print(joiner.entery);
    print(joiner.banner);

    if (joiner.entery != "" || joiner.banner != "") {
      if (joiner.entery != "") {
        if (mounted) {
          setState(() {
            entery =
                ASSETSBASEURL +
                'Designs/Motion/' +
                joiner.entery! +
                '?raw=true';
          });
        }
        if (joiner.banner != "") {
          if (mounted) {
            setState(() {
              enteryBanner =
                  ASSETSBASEURL +
                  'Designs/Motion/' +
                  joiner.banner! +
                  '?raw=true';
              enteryMessage = '${joiner.mic_user_name} entered the room';
            });
          }
        }

        if (joiner.entery_audio != "" && isNewCommer) {}

        await Future.delayed(Duration(seconds: 1));
        if (joiner.entery_audio != "" && isNewCommer && entery != "") {
          showEnteryBanner = true;
          setState(() {});
        }

        await Future.delayed(Duration(seconds: 9));

        if (mounted) {
          setState(() {
            entery = '';
            enteryBanner = '';
            enteryMessage = '';
            showEnteryBanner = false;
          });
        }
      } else {
        if (joiner.banner != "") {
          if (mounted) {
            setState(() {
              enteryBanner =
                  ASSETSBASEURL +
                  'Designs/Motion/' +
                  joiner.banner! +
                  '?raw=true';
              enteryMessage = '${joiner.mic_user_name} entered the room';
              showEnteryBanner = true;
            });
          }

          await Future.delayed(Duration(seconds: 9));

          if (mounted) {
            setState(() {
              enteryBanner = '';
              enteryMessage = '';
              showEnteryBanner = false;
            });
          }
        }
      }
    } else {
      if (mounted) {
        setState(() {
          isVip = true;
          enteryMessage = '${joiner.mic_user_name} entered the room';
          showEnteryBanner = true;
        });

        await Future.delayed(Duration(seconds: 3));
        if (mounted) {
          setState(() {
            enteryMessage = '';
            showEnteryBanner = false;
          });
        }
      }
      _playNextEntry();

      print('data');
      print(enteryMessage);
      print(isVip);
      print(showEnteryBanner);
    }
  }

  geAdminDesigns() async {
    DesignGiftHelper _helper = await AppUserServices().getMyDesigns(
      room!.userId,
    );
    if (mounted) {
      setState(() {
        designs = _helper.designs!;
      });
    }
    if (designs
            .where(
              (element) => (element.category_id == 4 && element.isDefault == 1),
            )
            .toList()
            .length >
        0) {
      String icon = designs
          .where(
            (element) => (element.category_id == 4 && element.isDefault == 1),
          )
          .toList()[0]
          .motion_icon;
      if (mounted) {
        setState(() {
          frame = ASSETSBASEURL + 'Designs/Motion/' + icon + '?raw=true';
          print('frame22222');
          print(frame);
        });
      }
    }
  }

  getRoomBasicData() async {
    RoomBasicDataHelper? helper = await ChatRoomService().getRoomBasicData();
    ChatRoomService().roomBasicDataHelperSetter(helper!);
    if (mounted) {
      setState(() {
        emossions = helper.emossions;
        themes = helper.themes;
        gifts = helper.gifts;
        categories = helper.categories;
        _tabController = new TabController(
          vsync: this,
          length: categories.length,
        );
      });
    }
  }

  // Future<void> initAgora() async {
  //   //create the engine
  //   print('initAgora');
  //   print(AppSettingsServices().appSettingGetter()!.agora_id);
  //   _engine = createAgoraRtcEngine();
  //   await _engine.initialize(
  //     RtcEngineContext(
  //       appId: appId,
  //       channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
  //     ),
  //   );
  //   print('_engine.initialize end');
  //   //audio indicator
  //   await _engine.enableAudioVolumeIndication(
  //     interval: 1000,
  //     smooth: 5,
  //     reportVad: false,
  //   );
  //
  //   _engine.registerEventHandler(
  //     RtcEngineEventHandler(
  //       onJoinChannelSuccess: (RtcConnection connection, int elapsed) async {
  //         if (mounted) {
  //           setState(() {
  //             _localUserJoined = true;
  //           });
  //           print('_localUserJoined');
  //           print(_localUserJoined);
  //         }
  //
  //         // remove await from refreshRoom
  //         refreshRoom(connection.localUid);
  //       },
  //       onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
  //         debugPrint("remote user $remoteUid joined");
  //       },
  //       onUserOffline:
  //           (
  //             RtcConnection connection,
  //             int remoteUid,
  //             UserOfflineReasonType reason,
  //           ) async {
  //             debugPrint("remote user $remoteUid left channel");
  //             try {
  //               await ExitRoomHelper(remoteUid, room!.id);
  //               refreshRoom(0);
  //             } catch (err) {}
  //             if (mounted) {
  //               setState(() {
  //                 // _remoteUid = null;
  //               });
  //             }
  //           },
  //       onTokenPrivilegeWillExpire: (RtcConnection connection, String token) {
  //         debugPrint(
  //           '[onTokenPrivilegeWillExpire] connection: ${connection.toJson()}, token: $token',
  //         );
  //       },
  //
  //       onAudioVolumeIndication:
  //           (connection, _speakers, speakerNumber, totalVolume) {
  //             List<int> sp = [];
  //             if (mounted) {
  //               setState(() {
  //                 speakers = sp;
  //               });
  //             }
  //             _speakers.forEach((element) {
  //               sp.add(element.uid!);
  //             });
  //             if (mounted) {
  //               setState(() {
  //                 speakers = sp;
  //               });
  //             }
  //           },
  //       onAudioMixingFinished: () {
  //         print('onAudioMixingFinished');
  //       },
  //       onAudioMixingStateChanged:
  //           (AudioMixingStateType state, AudioMixingReasonType reason) {
  //             print(
  //               'audioMixingStateChanged state:${state.toString()}, reason: ${reason.toString()}}',
  //             );
  //           },
  //       onAudioMixingPositionChanged: (pos) {
  //         // print('onAudioMixingPositionChanged' );
  //       },
  //     ),
  //   );
  //
  //   // await _engine.enableVideo();
  //   // await _engine.startPreview();
  //
  //   await _engine.joinChannel(
  //     token: token,
  //     channelId: channel,
  //     uid: int.parse(user!.tag),
  //
  //     options: const ChannelMediaOptions(
  //       clientRoleType: ClientRoleType.clientRoleAudience,
  //     ),
  //   );
  //
  //   ChatRoomService.engine = _engine;
  // }

  @override
  void dispose() {
    _tabController!.dispose();
    WidgetsBinding.instance.removeObserver(this);
    _leaveTimer?.cancel();
    super.dispose();
    _dispose();
    try {
      // player.stop();
    } catch (err) {}
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print("📱 App state changed to: $state");

    if (state == AppLifecycleState.paused) {
      print("⏳ Starting 1-minute timer...");
      _leaveTimer = Timer(const Duration(minutes: 1), () {
        print("🚪 1 minutes passed, leaving room...");
        int index = room!.mics!.indexWhere((mic) => mic.user_id == user!.id);
        MicHelper(
          user!,
          user_id: user!.id,
          room_id: room!.id,
          mic: index,
        ).sendMicLeaveEvent(audioPlayer, zegoEngine);
        ChatRoomService().leaveMic(user!.id, room!.id, index, 0);
      });
    } else if (state == AppLifecycleState.resumed) {
      if (_leaveTimer?.isActive ?? false) {
        print("✅ User returned, canceling leave timer.");
        _leaveTimer?.cancel();
      }
    } else if (state == AppLifecycleState.detached) {
      print("⏳ Starting 1-minute timer...");
      _leaveTimer = Timer(const Duration(minutes: 1), () {
        print("🚪 1 minutes passed, leaving room...");
        int index = room!.mics!.indexWhere((mic) => mic.user_id == user!.id);
        MicHelper(
          user!,
          user_id: user!.id,
          room_id: room!.id,
          mic: index,
        ).sendMicLeaveEvent(audioPlayer, zegoEngine);
        ChatRoomService().leaveMic(user!.id, room!.id, index, 0);
      });
    }
  }

  bool get wantKeepAlive => true;

  Future<void> _dispose() async {
    print('start dispose');
    if (ChatRoomService.savedRoom == null) {
      await ExitRoomHelper(user!.id, room!.id);
      await unUnitZego();
      // await _engine.leaveChannel();
      // await _engine.release();
      int index = room!.mics!.indexWhere((mic) => mic.user_id == user!.id);
      MicHelper(
        user!,
        user_id: user!.id,
        room_id: room!.id,
        mic: index,
      ).sendMicLeaveEvent(audioPlayer, zegoEngine);
      await ChatRoomService().leaveMic(user!.id, room!.id, index, 0);
      users.clear();
      await ZegoExpressEngine.instance.stopPublishingStream();
      await ZegoExpressEngine.instance.muteMicrophone(true);
      if (audioPlayer != null) {
        await ZegoExpressEngine.instance.destroyMediaPlayer(audioPlayer!);
        audioPlayer = null;
      }
      await ZegoExpressEngine.destroyEngine();
      audioPlayer = null;
    }
  }

  toggleMessageInput() {
    if (mounted) {
      setState(() {
        showMsgInput = !showMsgInput;
      });
    }
  }

  void sendChatRoomMessage() async {
    RoomMember member = room!.members!
        .where((element) => element.user_id == user!.id)
        .toList()[0];

    String pubble = "";
    if (member.pubble != "") {
      pubble = ASSETSBASEURL + 'Designs/Motion/' + member.pubble.toString();
    }

    if (_messageController.text.trim().isEmpty) {
      showSnackBarWidget(
        message: 'اكتب رسالة قبل الإرسال',
        color: Colors.orange,
      );
      return;
    }

    final ChatRoomMessage message = ChatRoomMessage(
      message: _messageController.text.trim(),
      user_name: user!.name,
      user_share_level_img: user!.share_level_icon,
      user_img: user!.img,
      user_id: user!.id,
      type: 'TEXT',
      vip: user!.vips!.length > 0 ? user!.vips![0].icon : "",
      badges: member.badges!,
      pubble: pubble,
    );

    try {
      final String jsonMessage = jsonEncode(message.toJson());

      final result = await ZegoExpressEngine.instance.sendBroadcastMessage(
        room!.id.toString(),
        jsonMessage,
      );

      if (result.errorCode == 0) {
        ChatRoomService().addMessage(message);
        setState(() {
          messages = ChatRoomService().messages;
        });

        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 1),
          curve: Curves.fastOutSlowIn,
        );

        _messageController.clear();
      } else {
        showSnackBarWidget(
          message: 'حدث خطأ أثناء إرسال الرسالة (كود: ${result.errorCode})',
          color: Colors.red,
        );
      }
    } catch (e) {
      showSnackBarWidget(message: 'فشل إرسال الرسالة: $e', color: Colors.red);
    }
  }

  Future<void> sendGlobalMessage(String messageBody, String fromUserId) async {
    const String appId = '1364585881';
    const String serverSecret = 'f17120be21fb4342160ff49228c42475';

    try {
      final timestamp = (DateTime.now().millisecondsSinceEpoch ~/ 1000);

      final plainText = '$appId$serverSecret$timestamp';
      final signature = sha256.convert(utf8.encode(plainText)).toString();

      final uri = Uri.https('zim-api.zego.im', '/', {
        'Action': 'SendMessageToAllUsers',
        'AppId': appId,
        'Signature': signature,
        'Timestamp': timestamp.toString(),
        'SignatureVersion': '1',
      });

      final body = {
        "FromUserId": fromUserId,
        "MessageType": 1,
        "MessageBody": {"Message": messageBody, "ExtendedData": "optional"},
        "SubMsgType": 0,
      };

      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        print('✅ تم إرسال الرسالة بنجاح!');
        print(response.body);
      } else {
        print('❌ فشل الإرسال: ${response.statusCode}');
        print(response.body);
      }
    } catch (e) {
      print('⚠️ خطأ أثناء الإرسال: $e');
    }
  }

  Future<void> _refresh() async {
    await refreshRoom(0);
    for (var member in room!.members!) {
      print('🧍 Member ID: ${member.user_id}, Name: ${member.user_id}');
      print(user!.id);
      setState(() {
        matchedMembers = room!.members!.where((member) {
          return users.any(
            (zegoUser) =>
                zegoUser.userID.toString() == member.user_id.toString(),
          );
        }).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor:
            MyColors.primaryColor, //or set color with: Color(0xFF0000FF)
      ),
    );
    return WillPopScope(
      onWillPop: () async {
        showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          builder: (ctx) => roomCloseModal(),
        );
        return false;
      },
      child: Scaffold(
        body: DefaultTextStyle(
          style: TextStyle(decoration: TextDecoration.none),
          child: Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: CachedNetworkImageProvider(
                  ASSETSBASEURL + 'Themes/' + room!.room_bg!,
                ),
                fit: BoxFit.cover,
              ),
            ),
            padding: EdgeInsetsDirectional.only(top: 5.0),
            child: SafeArea(
              child: Stack(
                alignment: AlignmentDirectional.bottomEnd,
                children: [
                  Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Column(
                                children: [
                                  Expanded(
                                    flex: 57,
                                    child: RefreshIndicator(
                                      onRefresh: _refresh,
                                      color: MyColors.primaryColor,
                                      child: SingleChildScrollView(
                                        physics:
                                            AlwaysScrollableScrollPhysics(),
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    showModalBottomSheet(
                                                      context: context,
                                                      builder: (ctx) =>
                                                          RoomInfoBottomSheet(),
                                                    );
                                                  },
                                                  child: Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                          horizontal: 10.0,
                                                          vertical: 5.0,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      color: Colors.black26,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            10.0,
                                                          ),
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                          width: 40.0,
                                                          height: 40.0,
                                                          child: SizedBox(),
                                                          clipBehavior: Clip
                                                              .antiAliasWithSaveLayer,
                                                          decoration: BoxDecoration(
                                                            color: Colors.red,
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  10.0,
                                                                ),
                                                            image:
                                                                room_img == ""
                                                                ? DecorationImage(
                                                                    image: AssetImage(
                                                                      'assets/images/user.png',
                                                                    ),
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  )
                                                                : DecorationImage(
                                                                    image: CachedNetworkImageProvider(
                                                                      room_img,
                                                                    ),
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  ),
                                                          ),
                                                        ),
                                                        SizedBox(width: 10.0),
                                                        Column(
                                                          children: [
                                                            Text(
                                                              room!.name,
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 14.0,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 5.0,
                                                            ),
                                                            Text(
                                                              'ID:' + room!.tag,
                                                              style: TextStyle(
                                                                color: MyColors
                                                                    .unSelectedColor,
                                                                fontSize: 11.0,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () {
                                                          showModalBottomSheet(
                                                            isScrollControlled:
                                                                true,
                                                            context: context,
                                                            builder: (ctx) =>
                                                                RoomCup(),
                                                          );
                                                        },

                                                        child: Container(
                                                          padding:
                                                              EdgeInsets.all(
                                                                5.0,
                                                              ),
                                                          decoration: BoxDecoration(
                                                            color:
                                                                Colors.black26,
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  10.0,
                                                                ),
                                                          ),
                                                          child: Row(
                                                            children: [
                                                              Image(
                                                                image: AssetImage(
                                                                  'assets/images/chatroom_rank_ic.png',
                                                                ),
                                                                height: 18.0,
                                                                width: 18.0,
                                                              ),
                                                              SizedBox(
                                                                width: 5.0,
                                                              ),
                                                              Text(
                                                                double.parse(
                                                                  room!.roomCup
                                                                      .toString(),
                                                                ).floor().toString(),
                                                                style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize:
                                                                      13.0,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(width: 7.0),
                                                      GestureDetector(
                                                        child: Container(
                                                          margin:
                                                              EdgeInsets.symmetric(
                                                                horizontal:
                                                                    10.0,
                                                              ),
                                                          child: Icon(
                                                            FontAwesomeIcons
                                                                .shareFromSquare,
                                                            color: Colors.white,
                                                            size: 20.0,
                                                          ),
                                                        ),
                                                      ),
                                                      GestureDetector(
                                                        onTap: () {
                                                          ChatRoomService()
                                                              .roomSetter(
                                                                room!,
                                                              );
                                                          showModalBottomSheet(
                                                            isScrollControlled:
                                                                true,
                                                            context: context,
                                                            builder: (ctx) =>
                                                                roomCloseModal(),
                                                          );
                                                        },
                                                        child: Container(
                                                          margin:
                                                              EdgeInsets.symmetric(
                                                                horizontal:
                                                                    10.0,
                                                              ),
                                                          child: Icon(
                                                            FontAwesomeIcons
                                                                .powerOff,
                                                            color: Colors.white,
                                                            size: 20.0,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Row(
                                                  children: room!.members!
                                                      .where(
                                                        (element) =>
                                                            element.user_id ==
                                                            room!.userId,
                                                      )
                                                      .map(
                                                        (e) =>
                                                            roomMemberItmeBuilder(
                                                              e,
                                                            ),
                                                      )
                                                      .toList(),
                                                ),

                                                GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      matchedMembers = room!
                                                          .members!
                                                          .where((member) {
                                                            return users.any(
                                                              (zegoUser) =>
                                                                  zegoUser
                                                                      .userID
                                                                      .toString() ==
                                                                  member.user_id
                                                                      .toString(),
                                                            );
                                                          })
                                                          .toList();
                                                    });
                                                    showModalBottomSheet(
                                                      isScrollControlled: true,
                                                      context: context,
                                                      builder: (ctx) =>
                                                          roomMembersModal(),
                                                    );
                                                  },
                                                  child: Container(
                                                    width: 60.0,
                                                    padding: EdgeInsets.all(
                                                      5.0,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      color: Colors.black26,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            10.0,
                                                          ),
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                          Icons.people_alt,
                                                          color: MyColors
                                                              .primaryColor,
                                                          size: 20.0,
                                                        ),
                                                        SizedBox(width: 5.0),
                                                        Text(
                                                          users.length
                                                              .toString(),
                                                          style: TextStyle(
                                                            color: MyColors
                                                                .primaryColor,
                                                            fontSize: 13.0,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 5.0),
                                            GridView.count(
                                              shrinkWrap: true,
                                              crossAxisCount: 4,
                                              children: room!.mics!
                                                  .map(
                                                    (mic) => micListItem(mic),
                                                  )
                                                  .toList(),
                                              mainAxisSpacing: 0.0,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 43,
                                    child: Row(
                                      children: [
                                        Container(
                                          padding: EdgeInsetsDirectional.only(
                                            start: 10.0,
                                          ),
                                          width:
                                              MediaQuery.sizeOf(context).width *
                                              .8,

                                          child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                showMsgInput = false;
                                              });
                                            },
                                            child: ListView.separated(
                                              itemBuilder: (context, index) =>
                                                  roomMessageBuilder(index),
                                              separatorBuilder:
                                                  (context, index) =>
                                                      roomMessageSeperator(),
                                              itemCount: messages.length,
                                              controller: _scrollController,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 10.0,
                                      vertical: 10.0,
                                    ),
                                    child: !showMsgInput
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () {
                                                          toggleMessageInput();
                                                        },
                                                        child: Image(
                                                          image: AssetImage(
                                                            'assets/images/messages.png',
                                                          ),
                                                          width: 40.0,
                                                        ),
                                                      ),
                                                      SizedBox(width: 5.0),
                                                      GestureDetector(
                                                        onTap: () {
                                                          showModalBottomSheet(
                                                            context: context,
                                                            builder: (ctx) =>
                                                                ChatBottomSheet(),
                                                          );
                                                        },
                                                        child: Image(
                                                          image: AssetImage(
                                                            'assets/images/chats.png',
                                                          ),
                                                          width: 40.0,
                                                        ),
                                                      ),
                                                      SizedBox(width: 5.0),
                                                      GestureDetector(
                                                        onTap: () {
                                                          showModalBottomSheet(
                                                            context: context,
                                                            builder: (ctx) =>
                                                                MenuBottomSheet(),
                                                          );
                                                        },
                                                        child: Image(
                                                          image: AssetImage(
                                                            'assets/images/menu.png',
                                                          ),
                                                          width: 40.0,
                                                        ),
                                                      ),
                                                      SizedBox(width: 5.0),
                                                      GestureDetector(
                                                        onTap: () async {
                                                          if (room!.mics!
                                                                  .where(
                                                                    (element) =>
                                                                        element
                                                                            .user_id ==
                                                                        user!
                                                                            .id,
                                                                  )
                                                                  .toList()
                                                                  .length >
                                                              0) {
                                                            if (!_localUserMute) {
                                                              await ZegoExpressEngine
                                                                  .instance
                                                                  .muteMicrophone(
                                                                    true,
                                                                  );
                                                              if (mounted) {
                                                                setState(() {
                                                                  _localUserMute =
                                                                      true;
                                                                });
                                                              }
                                                            } else {
                                                              await ZegoExpressEngine
                                                                  .instance
                                                                  .muteMicrophone(
                                                                    false,
                                                                  );
                                                              if (mounted) {
                                                                setState(() {
                                                                  _localUserMute =
                                                                      false;
                                                                });
                                                              }
                                                            }
                                                          } else {
                                                            Fluttertoast.showToast(
                                                              msg:
                                                                  'You are not using any mic !',
                                                              toastLength: Toast
                                                                  .LENGTH_SHORT,
                                                              gravity:
                                                                  ToastGravity
                                                                      .CENTER,
                                                              timeInSecForIosWeb:
                                                                  1,
                                                              backgroundColor:
                                                                  Colors
                                                                      .black26,
                                                              textColor:
                                                                  Colors.orange,
                                                              fontSize: 16.0,
                                                            );
                                                          }
                                                        },
                                                        child: Image(
                                                          image: _localUserMute
                                                              ? AssetImage(
                                                                  'assets/images/mic_off.png',
                                                                )
                                                              : AssetImage(
                                                                  'assets/images/mic_on.png',
                                                                ),
                                                          width: 40.0,
                                                        ),
                                                      ),
                                                      SizedBox(width: 5.0),
                                                      GestureDetector(
                                                        onTap: () {
                                                          showModalBottomSheet(
                                                            context: context,
                                                            builder: (ctx) =>
                                                                EmojBottomSheet(),
                                                          );
                                                        },
                                                        child: Image(
                                                          image: AssetImage(
                                                            'assets/images/emoj.png',
                                                          ),
                                                          width: 40.0,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    showCounterButton
                                                        ? GestureDetector(
                                                            onTap: () {
                                                              if (showCounterButton) {
                                                                RoomBasicDataHelper?
                                                                helper =
                                                                    ChatRoomService()
                                                                        .roomBasicDataHelperGetter();
                                                                gifts = helper!
                                                                    .gifts;
                                                                GiftHelper(
                                                                  gift_id:
                                                                      luckyGiftId,
                                                                  user_id:
                                                                      user!.id,
                                                                  room_id:
                                                                      room!.id,
                                                                  receiver:
                                                                      luckyGiftReciver,
                                                                  room_owner:
                                                                      room!
                                                                          .userId,
                                                                  sendGiftCount:
                                                                      luckyGiftCount,
                                                                  gifts: gifts,
                                                                ).sendGiftEvent();
                                                              }
                                                            },
                                                            child: CircularCountDownTimer(
                                                              duration:
                                                                  _duration,
                                                              initialDuration:
                                                                  0,
                                                              controller:
                                                                  _countDownController,
                                                              width: 50.0,
                                                              height: 50.0,
                                                              ringColor: Colors
                                                                  .grey[300]!,
                                                              ringGradient:
                                                                  null,
                                                              fillColor: Colors
                                                                  .purpleAccent[100]!,
                                                              fillGradient:
                                                                  null,
                                                              backgroundColor:
                                                                  Colors
                                                                      .purple[500],
                                                              backgroundGradient:
                                                                  null,
                                                              strokeWidth: 5.0,
                                                              strokeCap:
                                                                  StrokeCap
                                                                      .round,
                                                              textStyle:
                                                                  const TextStyle(
                                                                    fontSize:
                                                                        25.0,
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),

                                                              textFormat:
                                                                  CountdownTextFormat
                                                                      .S,
                                                              isReverse: true,
                                                              isReverseAnimation:
                                                                  true,
                                                              isTimerTextShown:
                                                                  true,
                                                              autoStart: true,
                                                              onStart: () {
                                                                // Here, do whatever you want
                                                                debugPrint(
                                                                  'Countdown Started',
                                                                );
                                                              },
                                                              onComplete: () async {
                                                                // Here, do whatever you want
                                                                debugPrint(
                                                                  'Countdown Ended',
                                                                );
                                                                setState(() {
                                                                  showCounterButton =
                                                                      false;
                                                                  giftImg = '';
                                                                  luckyGiftId =
                                                                      0;
                                                                  luckyGiftCount =
                                                                      0;
                                                                  luckyGiftReciver =
                                                                      0;
                                                                });

                                                                // await player.stop();
                                                              },
                                                              onChange:
                                                                  (
                                                                    String
                                                                    timeStamp,
                                                                  ) {
                                                                    // Here, do whatever you want
                                                                    debugPrint(
                                                                      'Countdown Changed $timeStamp',
                                                                    );
                                                                  },
                                                              timeFormatterFunction:
                                                                  (
                                                                    defaultFormatterFunction,
                                                                    duration,
                                                                  ) {
                                                                    // other durations by it's default format
                                                                    return Function.apply(
                                                                      defaultFormatterFunction,
                                                                      [
                                                                        duration,
                                                                      ],
                                                                    );
                                                                  },
                                                            ),
                                                          )
                                                        : SizedBox(),
                                                    SizedBox(height: 5.0),
                                                    GestureDetector(
                                                      onTap: () {
                                                        ChatRoomService()
                                                            .roomSetter(room!);
                                                        showModalBottomSheet(
                                                          context: context,
                                                          builder: (ctx) =>
                                                              giftBottomSheet(),
                                                        );
                                                      },
                                                      child: Image(
                                                        image: AssetImage(
                                                          'assets/images/gift_box.webp',
                                                        ),
                                                        width: 40.0,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          )
                                        : Row(
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey[600],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          13.0,
                                                        ),
                                                  ),
                                                  height: 45.0,
                                                  child: TextFormField(
                                                    controller:
                                                        _messageController,
                                                    autofocus: true,
                                                    focusNode: focusNode,
                                                    cursorColor: Colors.grey,
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                    decoration: InputDecoration(
                                                      hintText:
                                                          'chat_hint_text_form'
                                                              .tr,
                                                      hintStyle: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 14,
                                                      ),
                                                      border: OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              13.0,
                                                            ),
                                                        borderSide: BorderSide(
                                                          color: Colors.grey,
                                                        ),
                                                      ),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                                  color: Colors
                                                                      .grey,
                                                                ),
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  13.0,
                                                                ),
                                                          ),
                                                      suffixIcon: IconButton(
                                                        onPressed: () {
                                                          if (mounted) {
                                                            setState(() {
                                                              emojiShowing =
                                                                  !emojiShowing;
                                                            });
                                                          }
                                                        },
                                                        icon: Icon(
                                                          Icons
                                                              .emoji_emotions_outlined,
                                                          color: Colors.white,
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
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        10.0,
                                                      ),
                                                ),
                                                height: 45.0,
                                                width: 80.0,
                                                child: MaterialButton(
                                                  onPressed: () {
                                                    sendChatRoomMessage();
                                                    //   sendGlobalMessage('fgbuif' , user!.id.toString());
                                                  }, //sendMessage
                                                  child: Text(
                                                    'gift_send'.tr,
                                                    style: TextStyle(
                                                      color: MyColors.darkColor,
                                                      fontSize: 15.0,
                                                      fontWeight:
                                                          FontWeight.bold,
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
                                        textEditingController:
                                            _messageController,
                                        scrollController: _scrollController,
                                        config: Config(
                                          height: 256,
                                          checkPlatformCompatibility: true,
                                          viewOrderConfig:
                                              const ViewOrderConfig(),
                                          emojiViewConfig: EmojiViewConfig(
                                            // Issue: https://github.com/flutter/flutter/issues/28894
                                            emojiSizeMax:
                                                28 *
                                                (foundation.defaultTargetPlatform ==
                                                        TargetPlatform.iOS
                                                    ? 1.2
                                                    : 1.0),
                                          ),
                                          skinToneConfig:
                                              const SkinToneConfig(),
                                          categoryViewConfig:
                                              const CategoryViewConfig(),
                                          bottomActionBarConfig:
                                              const BottomActionBarConfig(),
                                          searchViewConfig:
                                              const SearchViewConfig(),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              entery != ""
                                  ? SVGAEasyPlayer(resUrl: entery)
                                  : Container(),
                              giftImg != ""
                                  ? GiftSVGAWidget(
                                      giftImg: giftImg,
                                      onComplete: () {
                                        playNext();
                                      },
                                      counter: 0,
                                    )
                                  : Container(),
                              showRainLuckyCase
                                  ? Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        SVGAEasyPlayer(
                                          resUrl:
                                              ASSETSBASEURL +
                                              'AppBanners/lucky_bags.svga?raw=true',
                                        ),
                                        Container(
                                          width: MediaQuery.sizeOf(
                                            context,
                                          ).width,
                                          height: MediaQuery.sizeOf(
                                            context,
                                          ).height,
                                          color: Colors.black12,
                                        ),
                                      ],
                                    )
                                  : Container(),

                              AnimatedPositioned(
                                top: MediaQuery.sizeOf(context).height * .5,
                                left: !showEnteryBanner
                                    ? -300.0
                                    : MediaQuery.sizeOf(context).width,
                                duration: const Duration(seconds: 3),
                                curve: Curves.slowMiddle,
                                child: showEnteryBanner
                                    ? isVip
                                          ? Container(
                                              constraints: BoxConstraints(
                                                maxWidth:
                                                    MediaQuery.of(
                                                      context,
                                                    ).size.width *
                                                    0.8,
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 4,
                                                    horizontal: 16,
                                                  ),
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  begin: Alignment.topRight,
                                                  end: Alignment.bottomLeft,
                                                  stops: [0, 0.3],
                                                  colors: <Color>[
                                                    Colors.white,
                                                    MyColors.primaryColor,
                                                  ],
                                                  tileMode: TileMode.mirror,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Text(
                                                enteryMessage,
                                                style: Get.textTheme.bodySmall!
                                                    .copyWith(
                                                      fontSize: 12,
                                                      color: Colors.white,
                                                    ),
                                              ),
                                            )
                                          : Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                Container(
                                                  width: 200.0,
                                                  child: SVGAEasyPlayer(
                                                    resUrl: enteryBanner,
                                                  ),
                                                ),
                                                Container(
                                                  padding: EdgeInsets.only(
                                                    left: 70.0,
                                                    right: 10.0,
                                                  ),
                                                  width: 190.0,
                                                  child: Text(
                                                    enteryMessage,
                                                    style: TextStyle(
                                                      fontSize: 10.0,
                                                    ),
                                                    softWrap: true,
                                                    maxLines: 3,
                                                  ),
                                                ),
                                              ],
                                            )
                                    : SizedBox(),
                              ),
                            ],
                          ),
                          !_localUserJoined ? Loading() : Container(),
                        ],
                      ),
                      showBanner
                          ? GestureDetector(
                              onTap: () {
                                openBannerRoom(bannerRoom);
                              },
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  GiftSVGAWidget(
                                    giftImg:
                                        ASSETSBASEURL +
                                        'AppBanners/gift_red_banner.svga?raw=true',
                                    counter: 1,
                                  ),
                                  SizedBox(height: 100),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        bannerMsg,
                                        style: TextStyle(fontSize: 11.0),
                                      ),
                                      SizedBox(width: 10.0),
                                      SizedBox(
                                        height: 40.0,
                                        width: 40.0,
                                        child: Image(
                                          image: CachedNetworkImageProvider(
                                            giftImgSmall,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          : Container(),
                      showLuckyBanner
                          ? GestureDetector(
                              onTap: () {
                                openBannerRoom(bannerRoom);
                              },
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  SizedBox(height: 150.0),
                                  SVGAEasyPlayer(
                                    resUrl: local == 'en'
                                        ? ASSETSBASEURL +
                                              'AppBanners/lucky_case_banner.svga?raw=true'
                                        : ASSETSBASEURL +
                                              'AppBanners/luckybox-banar-ar.svga?raw=true',
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(width: 100, height: 40),
                                      Expanded(
                                        child: Text(
                                          bannerMsg,
                                          style: TextStyle(fontSize: 11.0),
                                        ),
                                      ),
                                      Container(
                                        child: CircleAvatar(
                                          backgroundColor: user!.gender == 0
                                              ? MyColors.blueColor
                                              : MyColors.pinkColor,
                                          backgroundImage: luckySenderimg != ""
                                              ? CachedNetworkImageProvider(
                                                  '${ASSETSBASEURL}AppUsers/${luckySenderimg}',
                                                )
                                              : null,
                                          radius: 20,
                                          child: user?.img == ""
                                              ? Text(
                                                  "LC",
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 22.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                )
                                              : null,
                                        ),

                                        //Image(image: CachedNetworkImageProvider(ASSETSBASEURL + 'AppUsers/' + luckySenderimg ) , width: 50.0 , height: 50.0,),
                                      ),
                                      Container(width: 50, height: 40),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          : Container(),
                      showBannerBigWin
                          ? GestureDetector(
                              onTap: () {},
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  SVGAEasyPlayer(
                                    resUrl:
                                        ASSETSBASEURL +
                                        'AppBanners/banar_big_win.svga?raw=true',
                                  ),
                                  SizedBox(height: 100),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        bannerMsg,
                                        style: TextStyle(fontSize: 11.0),
                                      ),
                                      SizedBox(width: 10.0),
                                      SizedBox(
                                        height: 40.0,
                                        width: 40.0,
                                        child: Image(
                                          image: CachedNetworkImageProvider(
                                            giftImgSmall,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          : Container(),
                    ],
                  ),
                  Stack(
                    alignment: AlignmentDirectional.topEnd,

                    children: [
                      showBannerSmallWin
                          ? GestureDetector(
                              onTap: () {},
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,

                                children: [
                                  Container(
                                    margin: EdgeInsets.only(
                                      bottom:
                                          MediaQuery.sizeOf(context).height / 2,
                                    ),
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        SizedBox(
                                          width: 200,
                                          child: SVGAEasyPlayer(
                                            resUrl:
                                                ASSETSBASEURL +
                                                'AppBanners/banar_small_win.svga?raw=true',
                                          ),
                                        ),
                                        SizedBox(height: 100),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              bannerMsg,
                                              style: TextStyle(fontSize: 18.0),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Container(),
                    ],
                  ),

                  showLuckyCase
                      ? GestureDetector(
                          onTap: () async {
                            if (canOpenLuckyCase) {
                              if (mounted) {
                                setState(() {
                                  canOpenLuckyCase = false;
                                });
                              }
                              var rng = Random();
                              int rand = rng.nextInt(30);
                              LuckyCase? res = await ChatRoomService()
                                  .useLuckyCase(
                                    room!.id,
                                    user!.id,
                                    lucky_id,
                                    rand,
                                  );
                              if (res!.id > 0) {
                                Fluttertoast.showToast(
                                  msg:
                                      'lucky_case_msg'.tr +
                                      ' ' +
                                      rand.toString(),
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.black26,
                                  textColor: Colors.orange,
                                  fontSize: 16.0,
                                );
                              }
                            }
                          },
                          child: Container(
                            margin: EdgeInsetsDirectional.only(
                              bottom: 60.0,
                              end: 10.0,
                            ),
                            child: Image(
                              image: AssetImage(
                                'assets/images/luckyCaseIcon.png',
                              ),
                              width: 45,
                            ),
                          ),
                        )
                      : SizedBox(),

                  // GestureDetector(
                  //     onTap: (){
                  //
                  //       openRollet();
                  //     },
                  //     child: Container( margin: EdgeInsetsDirectional.only(bottom: 60.0 , end: 10.0 ),  child: Image(image: AssetImage('assets/images/rollet_icon.png') , width: 45,))),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget ProfileBottomSheet(user) {
    ChatRoomService.showMsgInput = showMsgInput;
    return SmallProfileModal(visitor: user, type: 1);
  }

  openRollet() async {
    Rollet? rollet = await ChatRoomService().getRoomActiveRollet(room!.id);
    if (rollet == null) {
      if (userRole == 'ADMIN' || userRole == 'OWNER') {
        showModalBottomSheet(
          context: context,
          builder: (ctx) => RolletBottomSheet(),
        );
      } else {
        Fluttertoast.showToast(
          msg: 'no_active_rollet'.tr,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black26,
          textColor: Colors.orange,
          fontSize: 16.0,
        );
      }
    } else {
      showRolletWheal(rollet.id);
    }
  }

  Widget micListItem(Mic mic) => StreamBuilder<Object>(
    stream: null,
    builder: (context, snapshot) {
      return Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Column(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          mic.mic_user_img == null
                              ? CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  radius: 22,
                                  backgroundImage: getMicUserImg(mic),
                                )
                              : CircleAvatar(
                                  backgroundColor: mic.mic_user_gender == 0
                                      ? MyColors.blueColor
                                      : MyColors.pinkColor,
                                  backgroundImage: mic.mic_user_img != ""
                                      ? (mic.mic_user_img!.startsWith('https')
                                            ? CachedNetworkImageProvider(
                                                mic.mic_user_img!,
                                              )
                                            : CachedNetworkImageProvider(
                                                '${ASSETSBASEURL}AppUsers/${mic.mic_user_img}',
                                              ))
                                      : null,
                                  radius: 22,
                                  child: mic.mic_user_img == ""
                                      ? mic.mic_user_name != ''
                                            ? Text(
                                                mic.mic_user_name!
                                                        .toUpperCase()
                                                        .substring(0, 1) +
                                                    (mic.mic_user_name!
                                                            .contains(" ")
                                                        ? mic.mic_user_name!
                                                              .substring(
                                                                mic.mic_user_name!
                                                                    .indexOf(
                                                                      " ",
                                                                    ),
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
                                            : null
                                      : null,
                                ),
                          Container(
                            height: 65.0,
                            width: 65.0,
                            child: mic.frame != ""
                                ? SVGAEasyPlayer(
                                    resUrl:
                                        ASSETSBASEURL +
                                        'Designs/Motion/' +
                                        mic.frame! +
                                        '?raw=true',
                                  )
                                : null,
                          ),
                          // Image(image: AssetImage('assets/images/mute.png') , width: 25 , height: 25,)
                          // Container(height: 70.0, width: 70.0,
                          // child: speakers.where((element) => element.toString() == mic!.mic_user_tag ).toList().length > 0  ?
                          // SizedBox( height: 50.0, width: 50.0,
                          //     child: SVGASimpleImage(   resUrl: ASSETSBASEURL + 'Defaults/wave.svga')) : null),

                          //frame
                        ],
                      ),
                      micEmojs[mic.order - 1] != ""
                          ? Container(
                              height: 65.0,
                              width: 65.0,
                              child: SVGAEasyPlayer(
                                resUrl: micEmojs[mic.order - 1] + '?raw=true',
                              ),
                            )
                          : Container(),
                    ],
                  ),
                  Text(
                    mic.mic_user_name == null
                        ? mic.order.toString()
                        : mic.mic_user_name!,
                    style: TextStyle(color: Colors.white, fontSize: 13.0),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              PopupMenuButton(
                position: PopupMenuPosition.under,
                shadowColor: MyColors.unSelectedColor,
                elevation: 4.0,
                color: Colors.white,
                icon: Container(),
                onSelected: (int result) {
                  micActions(result, mic);
                },
                itemBuilder: (BuildContext context) => AdminMicListItems(mic),
              ),
            ],
          ),
          (mic.user_id > 0 && room!.isCounter == 1)
              ? Transform.translate(
                  offset: Offset(0, 8.0),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    decoration: BoxDecoration(
                      color: MyColors.primaryColor,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Text(
                      mic.counter.toString(),
                      style: TextStyle(
                        color: MyColors.darkColor,
                        fontSize: 14.0,
                      ),
                    ),
                  ),
                )
              : SizedBox(),
        ],
      );
    },
  );

  micActions(result, mic) async {
    if (result == 1) {
      //use_mic
      await MicHelper(
        user_id: user!.id,
        room_id: room!.id,
        mic: mic.order,
        user!,
      ).sendMicEvent();
    } else if (result == 2) {
      //lock_mic
      MicHelper(
        user_id: user!.id,
        room_id: room!.id,
        mic: mic.order,
        user!,
      ).lockMic();
    } else if (result == 3) {
      //lock_all_mics
      MicHelper(user_id: user!.id, room_id: room!.id, mic: 0, user!).lockMic();
    } else if (result == 4) {
      //unlock_mic
      MicHelper(
        user_id: user!.id,
        room_id: room!.id,
        mic: mic.order,
        user!,
      ).unlockMic();
    } else if (result == 5) {
      //unlock_all_mic
      MicHelper(
        user_id: user!.id,
        room_id: room!.id,
        mic: 0,
        user!,
      ).unlockMic();
    } else if (result == 6) {
      //remove_from_mic
      MicHelper(
        user_id: mic!.user_id,
        room_id: room!.id,
        mic: mic.order,
        user!,
      ).removeFromMic(room!.userId);
    } else if (result == 7) {
      //un_use_mic
      MicHelper(
        user_id: user!.id,
        room_id: room!.id,
        mic: mic.order,
        user!,
      ).sendMicLeaveEvent(audioPlayer, zegoEngine);
      if (mounted) {
        setState(() {
          _localUserMute = true;
        });
      }
    } else if (result == 8) {
      //mute
      if (_localUserMute) {
        if (mounted) {
          setState(() {
            _localUserMute = false;
          });
          await ZegoExpressEngine.instance.muteMicrophone(false);
        }
      } else {
        if (mounted) {
          setState(() {
            _localUserMute = true;
          });
        }
        await ZegoExpressEngine.instance.muteMicrophone(true);
      }
    } else if (result == 9) {
      //showprofile
      AppUser? res = await AppUserServices().getUser(mic!.user_id);
      showModalBottomSheet(
        context: context,
        builder: (ctx) => ProfileBottomSheet(res),
      ).whenComplete(() {
        if (mounted) {
          setState(() {
            showMsgInput = ChatRoomService.showMsgInput;
          });
        }
        if (showMsgInput) {
          _messageController.text = "@" + res!.name + '.';
        }
      });
    } else if (result == 10) {
      //kickout
      showCupertinoModalPopup(
        context: context,
        builder: (context) => CupertinoActionSheet(
          actions: [
            Container(
              color: MyColors.darkColor,
              child: CupertinoActionSheetAction(
                child: Text(
                  'kick_out_hour'.tr,
                  style: TextStyle(color: MyColors.primaryColor),
                ),
                onPressed: () {
                  MicHelper(
                    user_id: mic!.user_id,
                    room_id: room!.id,
                    mic: mic.order,
                    user!,
                  ).kickOut('HOUR', user!.id);
                },
              ),
            ),
            Container(
              color: MyColors.darkColor,
              child: CupertinoActionSheetAction(
                child: Text(
                  'kick_out_day'.tr,
                  style: TextStyle(color: MyColors.primaryColor),
                ),
                onPressed: () {
                  MicHelper(
                    user_id: mic!.user_id,
                    room_id: room!.id,
                    mic: mic.order,
                    user!,
                  ).kickOut('DAY', user!.id);
                },
              ),
            ),
            Container(
              color: MyColors.darkColor,
              child: CupertinoActionSheetAction(
                child: Text(
                  'kick_out_forever'.tr,
                  style: TextStyle(color: MyColors.primaryColor),
                ),
                onPressed: () {
                  MicHelper(
                    user_id: mic!.user_id,
                    room_id: room!.id,
                    mic: mic.order,
                    user!,
                  ).kickOut('ALL', user!.id);
                },
              ),
            ),
          ],
        ),
      );
    }
  }

  ImageProvider getMicUserImg(mic) {
    //if (mic!.mic_user_img == null) {
    if (mic.isClosed == 0)
      return AssetImage('assets/images/mic_open.png');
    else
      return AssetImage('assets/images/mic_close.png');
    // } else {
    //
    //   return CachedNetworkImageProvider(ASSETSBASEURL + 'AppUsers/' + mic!.mic_user_img);
    // }
  }

  Widget RoomCup() => RoomCupModal();

  Widget EmojBottomSheet() => EmojModal();

  Widget giftBottomSheet() => GiftModal(reciverId: 0);

  Widget MenuBottomSheet() => MenuModal(
    scrollController: _scrollController,
    zegoEngine: zegoEngine,
    audioPlayer: audioPlayer!,
  );

  Widget ChatBottomSheet() => ChatsScreen();

  Widget RoomInfoBottomSheet() => RoomInfoModal();

  Widget roomCloseModal() => RoomCloseModal(
    pcontext: context,
    audioPlayer: audioPlayer!,
    zegoEngine: zegoEngine,
  );

  Widget roomMembersModal() => RoomMembersModal(members: matchedMembers!);

  Widget roomRolletModal(Rollet rollet) => RolletModal(rollet: rollet);

  List<PopupMenuEntry<int>> AdminMicListItems(mic) {
    if (userRole == 'OWNER' || userRole == 'ADMIN') {
      if (mic.user_id == 0) {
        if (mic.isClosed == 0) {
          return [
            PopupMenuItem<int>(
              value: 1,
              child: Text('use_mic'.tr, style: TextStyle(color: Colors.black)),
            ),
            PopupMenuItem<int>(
              value: 2,
              child: Text('lock_mic'.tr, style: TextStyle(color: Colors.black)),
            ),
            PopupMenuItem<int>(
              value: 3,
              child: Text(
                'lock_all_mics'.tr,
                style: TextStyle(color: Colors.black),
              ),
            ),
          ];
        } else {
          return [
            PopupMenuItem<int>(
              value: 4,
              child: Text(
                'unlock_mic'.tr,
                style: TextStyle(color: Colors.black),
              ),
            ),
            PopupMenuItem<int>(
              value: 5,
              child: Text(
                'unlock_all_mic'.tr,
                style: TextStyle(color: Colors.black),
              ),
            ),
          ];
        }
      } else {
        if (mic.user_id != user!.id) {
          return [
            PopupMenuItem<int>(
              value: 6,
              child: Text(
                'remove_from_mic'.tr,
                style: TextStyle(color: Colors.black),
              ),
            ),
            PopupMenuItem<int>(
              value: 10,
              child: Text('kick_out'.tr, style: TextStyle(color: Colors.black)),
            ),
            PopupMenuItem<int>(
              value: 9,
              child: Text(
                'show_user'.tr,
                style: TextStyle(color: Colors.black),
              ),
            ),
          ];
        } else {
          return [
            PopupMenuItem<int>(
              value: 7,
              child: Text(
                'un_use_mic'.tr,
                style: TextStyle(color: Colors.black),
              ),
            ),
            PopupMenuItem<int>(
              value: 8,
              child: _localUserMute
                  ? Text('unmute'.tr, style: TextStyle(color: Colors.black))
                  : Text('mute'.tr, style: TextStyle(color: Colors.black)),
            ),
          ];
        }
      }
    } else {
      // not admin
      if (mic.user_id == 0) {
        if (mic.isClosed == 0) {
          if (mic.order > 1) {
            return [
              PopupMenuItem<int>(
                value: 1,
                child: Text(
                  'use_mic'.tr,
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ];
          } else {
            Fluttertoast.showToast(
              msg: 'admin_mic_alert'.tr,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.black26,
              textColor: Colors.orange,
              fontSize: 16.0,
            );
            return [];
          }
        } else {
          Fluttertoast.showToast(
            msg: 'room_close_mic'.tr,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black26,
            textColor: Colors.orange,
            fontSize: 16.0,
          );
          return [];
        }
      } else {
        if (mic.user_id != user!.id) {
          return [
            PopupMenuItem<int>(
              value: 9,
              child: Text(
                'show_user'.tr,
                style: TextStyle(color: Colors.black),
              ),
            ),
          ];
        } else {
          return [
            PopupMenuItem<int>(
              value: 7,
              child: Text(
                'un_use_mic'.tr,
                style: TextStyle(color: Colors.black),
              ),
            ),
            PopupMenuItem<int>(
              value: 8,
              child: _localUserMute
                  ? Text('unmute'.tr, style: TextStyle(color: Colors.black))
                  : Text('mute'.tr, style: TextStyle(color: Colors.black)),
            ),
          ];
        }
      }
    }
  }

  Widget roomMessageBuilder(index) => messages[index].user_id == 0
      ? Flex(
          direction: Axis.horizontal,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                color: Colors.black54,
              ),
              constraints: BoxConstraints(
                maxWidth: (MediaQuery.of(context).size.width * 0.8) - 20.0,
              ),
              child: messages[index].user_name == 'APP'
                  ? Text(
                      messages[index].message,
                      style: TextStyle(
                        color: MyColors.secondaryColor,
                        fontSize: 11.0,
                      ),
                    )
                  : Text(
                      'notice'.tr + messages[index].message,
                      style: TextStyle(
                        color: MyColors.secondaryColor,
                        fontSize: 13.0,
                      ),
                    ),
            ),
          ],
        )
      : Flex(
          direction: Axis.horizontal,

          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                color: messages[index].pubble == ""
                    ? Colors.black.withOpacity(.5)
                    : Colors.transparent,
                image: messages[index].pubble != ""
                    ? DecorationImage(
                        image: CachedNetworkImageProvider(
                          messages[index].pubble.toString(),
                        ),
                        fit: BoxFit.fill,
                      )
                    : null,
              ),

              padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
              constraints: BoxConstraints(
                maxWidth: (MediaQuery.of(context).size.width * 0.7) - 20.0,
              ),
              child: GestureDetector(
                onTap: () async {
                  AppUser? res = await AppUserServices().getUser(
                    messages[index].user_id,
                  );
                  showModalBottomSheet(
                    context: context,
                    builder: (ctx) => ProfileBottomSheet(res),
                  ).whenComplete(() {
                    if (mounted) {
                      setState(() {
                        showMsgInput = ChatRoomService.showMsgInput;
                      });
                    }
                    if (showMsgInput) {
                      _messageController.text = "@" + res!.name + '.';
                    }
                  });
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${messages[index].user_name}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13.0,
                              ),
                            ),
                            const SizedBox(width: 5.0),
                            if (messages[index].user_share_level_img.isNotEmpty)
                              Image(
                                image: CachedNetworkImageProvider(
                                  '${ASSETSBASEURL}Levels/${messages[index].user_share_level_img}',
                                ),
                                width: 25,
                              ),
                            const SizedBox(width: 5.0),
                            if ((messages[index].vip ?? "").isNotEmpty)
                              Image(
                                image: CachedNetworkImageProvider(
                                  '${ASSETSBASEURL}VIP/${messages[index].vip}',
                                ),
                                width: 25,
                              ),
                          ],
                        ),

                        const SizedBox(height: 5.0),

                        if ((messages[index].badges ?? []).isNotEmpty)
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              for (var item in messages[index].badges ?? [])
                                Padding(
                                  padding: const EdgeInsets.only(right: 3.0),
                                  child: Image(
                                    image: CachedNetworkImageProvider(
                                      '${ASSETSBASEURL}Badges/${item.badge}',
                                    ),
                                    width: 25,
                                  ),
                                ),
                            ],
                          ),

                        const SizedBox(height: 2.0),
                        getMessageContent(messages[index]),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        );

  Widget roomMessageSeperator() => SizedBox(height: 5.0);

  Widget getMessageContent(ChatRoomMessage message) {
    switch (message.type.toUpperCase()) {
      case "TEXT":
      case "GIFT":
        return Text(
          message.message,
          style: const TextStyle(color: Colors.white, fontSize: 13.0),
          overflow: TextOverflow.ellipsis,
          maxLines: 4,
          textAlign: TextAlign.start,
        );

      case "NURD":
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image(
              image: CachedNetworkImageProvider(
                '${ASSETSBASEURL}Nurd/${message.message}.webp',
              ),
              width: 40.0,
            ),
          ],
        );

      case "PAPER":
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image(
              image: CachedNetworkImageProvider(
                '${ASSETSBASEURL}rock-paper-scissors/${message.message}.webp',
              ),
              width: 40.0,
            ),
          ],
        );

      case "LUCKY":
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message.message,
              style: TextStyle(
                color: MyColors.primaryColor,
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        );

      default:
        return const SizedBox.shrink();
    }
  }

  Widget roomMemberItmeBuilder(RoomMember user) => GestureDetector(
    onTap: () async {
      AppUser? res = await AppUserServices().getUser(user.user_id);
      showModalBottomSheet(
        context: context,
        builder: (ctx) => ProfileBottomSheet(res),
      ).whenComplete(() {
        if (mounted) {
          setState(() {
            showMsgInput = ChatRoomService.showMsgInput;
          });
        }
        if (showMsgInput) {
          _messageController.text = "@" + res!.name + '.';
        }
      });
    },
    child: Stack(
      alignment: Alignment.center,
      children: [
        CircleAvatar(radius: 15.0, backgroundImage: getUserAvatar(user)),
        user.user_id == room!.userId
            ? Image(
                image: AssetImage('assets/images/room_user_small_border.png'),
                width: 50,
                height: 50,
              )
            : SizedBox(),
      ],
    ),
  );

  ImageProvider getUserAvatar(RoomMember user) {
    if (user.mic_user_img == '') {
      return AssetImage('assets/images/user.png');
    } else {
      return CachedNetworkImageProvider(
        '${ASSETSBASEURL}AppUsers/${user.mic_user_img}',
      );
    }
  }

  Widget RolletBottomSheet() => CreateRolletModal();

  int getLuckyCaseDuration(LuckyCase luckyCase, DateTime available_untill) {
    final DateTime luckyCaseCreatedDate = DateTime.parse(
      luckyCase.created_date,
    );

    var dateTwo = available_untill;
    print(luckyCaseCreatedDate);
    print(dateTwo);

    final Duration duration = dateTwo.difference(luckyCaseCreatedDate);
    print(duration.inSeconds);
    return duration.inSeconds;
  }

  int getRoomLuckyCaseDuration(LuckyCase luckyCase, DateTime available_untill) {
    final DateTime luckyCaseCreatedDate = DateTime.parse(
      luckyCase.created_date,
    );
    final DateTime currentDate = DateTime.now();
    print('getRoomLuckyCaseDuration');
    print(available_untill);
    print(currentDate);
    final Duration duration = available_untill.difference(currentDate);
    print(duration.inSeconds);
    return duration.inSeconds;
  }

  bool checkGiftShow(DateTime available_untill) {
    final DateTime giftAvaliable = available_untill;
    final DateTime currentDate = DateTime.now();

    final Duration duration = giftAvaliable.difference(currentDate);
    print('checkGiftShow');
    print(duration);
    return duration.inSeconds <= 60 && duration.inSeconds > 0;
  }

  bool checkLuckyCaseShow(DateTime available_untill) {
    final DateTime giftAvaliable = available_untill;
    final DateTime currentDate = DateTime.now();

    final Duration duration = giftAvaliable.difference(currentDate);
    print('checkLuckyCaseShow');
    print(duration);
    return duration.inSeconds < 120;
  }

  openBannerRoom(room_id) async {
    if (room_id != room!.id) {
      MicHelper(
        user_id: user!.id,
        room_id: room!.id,
        mic: 0,
        user!,
      ).sendMicLeaveEvent(audioPlayer, zegoEngine);
      ExitRoomHelper(user!.id, room!.id);
      await _engine.leaveChannel();
      await _engine.release();
      ChatRoom? res = await ChatRoomService().openRoomById(room_id);
      if (res != null) {
        if (res.password.isEmpty || res.userId == user!.id) {
          ChatRoomService().roomSetter(res);
          //  Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RoomScreen()),
          );
        } else {
          //showPassword popup
          _displayTextInputDialog(context, res);
        }
      }
    }
  }

  Future<void> _displayTextInputDialog(
    BuildContext context,
    ChatRoom room,
  ) async {
    return showDialog(
      context: context,
      builder: (context) {
        return Container(
          child: AlertDialog(
            backgroundColor: MyColors.darkColor,
            title: Text(
              'room_password_label'.tr,
              style: TextStyle(color: Colors.white, fontSize: 20.0),
              textAlign: TextAlign.center,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 70.0,
                  child: TextField(
                    controller: passwordController,
                    style: TextStyle(color: Colors.white),
                    cursorColor: MyColors.primaryColor,
                    maxLength: 20,
                    keyboardType: TextInputType.visiblePassword,
                    decoration: InputDecoration(
                      hintText: "XXXXXXX",
                      hintStyle: TextStyle(color: Colors.white),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: MyColors.whiteColor),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            actions: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: MyColors.solidDarkColor,
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: MaterialButton(
                  child: Text(
                    'edit_profile_cancel'.tr,
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    Navigator.pop(context);
                  },
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: MyColors.primaryColor,
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: MaterialButton(
                  child: Text(
                    'OK',
                    style: TextStyle(color: MyColors.darkColor),
                  ),
                  onPressed: () async {
                    if (passwordController.text == room.password) {
                      ChatRoomService().roomSetter(room);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RoomScreen()),
                      );
                    } else {
                      Fluttertoast.showToast(
                        msg: "room_password_wrong".tr,
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.black26,
                        textColor: Colors.orange,
                        fontSize: 16.0,
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget getUserBadges(UserBadge badge) => Container();
}
