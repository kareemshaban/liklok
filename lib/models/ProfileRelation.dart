class ProfileRelation {
  final int id ;
  final String name ;
  final String tag ;
  final String price ;
  final String icon ;
  final String motion_icon ;
  final int sender_id ;
  final int reciver_id ;
  final int isAccepted ;
  final int is_ended ;
  final String sender_name ;
  final String sender_img ;
  final String recivier_name ;
  final String recivier_img ;
  final int sender_gender ;
  final int recivier_gender ;
  final String frame ;

  ProfileRelation({required this.id , required this.name , required this.tag , required this.price , required this.icon , required this.motion_icon , required this.sender_id , required this.reciver_id ,
                   required this.isAccepted , required this.is_ended , required this.sender_name , required this.sender_img , required this.recivier_img , required this.recivier_name,
                   required this.sender_gender , required this.recivier_gender , required this.frame
  });


  factory ProfileRelation.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
      'id': int id,
      'name': String name,
      'tag': String tag,
      'price': String price,
      'icon': String icon ,
      'motion_icon': String motion_icon ,
      'sender_id': int sender_id ,
      'reciver_id': int reciver_id ,
      'isAccepted': int isAccepted ,
      'is_ended': int is_ended ,
      'sender_name': String sender_name ,
      'sender_img': String sender_img ,
      'recivier_img': String recivier_img ,
      'recivier_name': String recivier_name ,
      'sender_gender': int sender_gender ,
      'recivier_gender': int recivier_gender ,
      'frame': String frame ,

      } =>
          ProfileRelation(
            id: id,
            name: name,
            tag: tag,
            price: price,
            icon: icon,
            motion_icon: motion_icon,
            sender_id: sender_id,
            reciver_id: reciver_id,
            isAccepted: isAccepted,
            is_ended: is_ended,
            sender_name: sender_name,
            sender_img: sender_img,
            recivier_img: recivier_img,
            recivier_name: recivier_name,
            sender_gender: sender_gender,
            recivier_gender: recivier_gender,
            frame: frame,
          ),
      _ => throw const FormatException('Failed to load album.'),
    };
  }
}