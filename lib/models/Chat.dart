import 'message.dart';

class ChatResponse {
  final String state;
  final List<Chat> chats;

  ChatResponse({
    required this.state,
    required this.chats,
  });

  factory ChatResponse.fromJson(Map<String, dynamic> json) {
    return ChatResponse(
      state: json['state'] ?? '',
      chats: (json['chats'] as List<dynamic>?)
          ?.map((chatJson) => Chat.fromJson(chatJson))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'state': state,
      'chats': chats.map((c) => c.toJson()).toList(),
    };
  }
}

class Chat {
  final int id;
  final int senderId;
  final int receiverId;
  final String lastActionDate;
  final String lastMessage;
  final int lastSender;
  final String createdAt;
  final String updatedAt;
  final String senderName;
  final String senderImg;
  final String receiverName;
  final String receiverImg;
  final List<Message> messages;

  Chat({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.lastActionDate,
    required this.lastMessage,
    required this.lastSender,
    required this.createdAt,
    required this.updatedAt,
    required this.senderName,
    required this.senderImg,
    required this.receiverName,
    required this.receiverImg,
    required this.messages,
  });

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      id: json['id'] ?? 0,
      senderId: json['sender_id'] ?? 0,
      receiverId: json['reciver_id'] ?? 0,
      lastActionDate: json['last_action_date'] ?? '',
      lastMessage: json['last_message'] ?? '',
      lastSender: json['last_sender'] ?? 0,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      senderName: json['sender_name'] ?? '',
      senderImg: json['sender_img'] ?? '',
      receiverName: json['receiver_name'] ?? '',
      receiverImg: json['receiver_img'] ?? '',
      messages: (json['messages'] as List<dynamic>?)
          ?.map((msg) => Message.fromJson(msg))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sender_id': senderId,
      'reciver_id': receiverId,
      'last_action_date': lastActionDate,
      'last_message': lastMessage,
      'last_sender': lastSender,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'sender_name': senderName,
      'sender_img': senderImg,
      'receiver_name': receiverName,
      'receiver_img': receiverImg,
      'messages': messages.map((m) => m.toJson()).toList(),
    };
  }
}

