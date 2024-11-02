class Chat {
  final int id ;
  final int sender_id ;
  final int reciver_id ;
  final String last_action_date ;
  final String last_message ;
  final int last_sender ;
  final String created_at ;
  final String updated_at ;
  final String sender_name ;
  final String sender_img ;
  final String receiver_name ;
  final String receiver_img ;
  // final int message_id ;
  // final String message_sender ;
  // final String message_reciver ;
  // final String message_date ;
  // final String message ;
  // final String img ;
  // final String type ;
  // final String isSeen ;

  Chat({required this.id, required this.sender_id, required this.reciver_id,
    required this.last_action_date, required this.last_message , required this.last_sender ,
    required this.created_at , required this.updated_at , required this.sender_name ,
    required this.sender_img , required this.receiver_name, required this.receiver_img,
 });

  factory Chat.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
       'id': int id ,
       'sender_id': int sender_id ,
      'reciver_id': int reciver_id ,
      'last_action_date': String last_action_date ,
      'last_message': String last_message ,
      'last_sender': int last_sender ,
      'created_at': String created_at ,
      'updated_at': String updated_at ,
      'sender_name': String sender_name ,
      'sender_img': String sender_img ,
      'receiver_name': String receiver_name ,
      'receiver_img': String receiver_img ,

      } =>
          Chat(
              id: id,
              sender_id: sender_id,
              reciver_id: reciver_id,
              last_action_date: last_action_date,
              last_message: last_message,
              last_sender:last_sender,
              created_at: created_at,
              updated_at: updated_at,
              sender_name: sender_name,
              sender_img: sender_img,
              receiver_name: receiver_name,
              receiver_img: receiver_img,

          ),
      _ => throw const FormatException('Failed to load Chat.'),
    };
  }
}