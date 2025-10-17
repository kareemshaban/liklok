import 'call_user_info.dart';

enum ZegoCallUserState {
  inviting,
  accepted,
  rejected,
  cancelled,
  offline,
  received,
}

enum ZegoCallType {
  voice,
  video,
}

extension ZegoCallTypeExtension on ZegoCallType {
  static ZegoCallType fromInt(int callType) {
    if (callType == videoCall) {
      return ZegoCallType.video;
    }
    return ZegoCallType.voice;
  }
}

const voiceCall = 10001;
const videoCall = 10000;

class ZegoCallData {
  late CallUserInfo inviter;
  late int callType;
  late String callID;
  List<CallUserInfo> callUserList = [];
  bool get isGroupCall => callUserList.length > 2;
}
