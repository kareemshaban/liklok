class TrendRoom {
 final int id ;
 final String tag ;
 final String name ;
 final String img ;
 final String subject ;
 final String admin_img ;

 TrendRoom({required this.id , required this.tag , required this.name , required this.img , required this.subject , required this.admin_img});

 factory TrendRoom.fromJson(Map<String, dynamic> json) {
   return switch (json) {
     {
     'id': int id,
     'tag': String tag,
     'name': String name,
     'img': String img,
     'subject': String subject,
     'admin_img': String admin_img
     } =>
         TrendRoom(
           id: id,
           tag: tag,
           name: name,
           img: img,
           subject: subject,
           admin_img:admin_img
         ),
     _ => throw const FormatException('Failed to load album.'),
   };
 }
}