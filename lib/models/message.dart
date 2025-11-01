class Message {
  int? id;
  int? chatId;
  final int senderId;
  final int receiverId;
  String? messageDate;
  final String message;
  String? img;
  int? type;
  int? isSeen;
  String? createdAt;
  String? updatedAt;

  Message({
    this.id,
    this.chatId,
    required this.senderId,
    required this.receiverId,
    this.messageDate,
    required this.message,
    this.img,
    this.type,
    this.isSeen,
    this.createdAt,
    this.updatedAt,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] ?? 0,
      chatId: json['chat_id'] ?? 0,
      senderId: json['sender_id'] ?? 0,
      receiverId: json['reciver_id'] ?? 0,
      messageDate: json['message_date'] ?? '',
      message: json['message'] ?? '',
      img: json['img'] ?? '',
      type: json['type'] ?? 0,
      isSeen: json['isSeen'] ?? 0,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chat_id': chatId,
      'sender_id': senderId,
      'reciver_id': receiverId,
      'message_date': messageDate,
      'message': message,
      'img': img,
      'type': type,
      'isSeen': isSeen,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
