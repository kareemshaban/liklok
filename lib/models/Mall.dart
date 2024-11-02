class Mall {
  final int id ;
  final int is_store ;
  final String name ;
  final String tag ;
  final int order ;
  final int category_id ;
  final int gift_category_id ;
  final String price ;
  final int days ;
  final int behaviour ;
  final String icon ;
  final String motion_icon ;
  final String dark_icon ;
  final int subject  ;
  final int vip_id ;


  Mall({required this.id , required this.name , required this.tag , required this.icon  ,
    required this.behaviour , required this.category_id , required this.dark_icon , required this.days , required this.gift_category_id ,
    required this.is_store , required this.motion_icon , required this.order , required this.price , required this.subject ,
    required this.vip_id });

  factory Mall.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
      'id': int id,
      'is_store': int is_store,
      'name': String name,
      'tag': String tag,
      'order': int order,
      'category_id': int category_id,
      'gift_category_id': int gift_category_id,
      'price': String price,
      'days': int days,
      'behaviour': int behaviour,
      'icon': String icon,
      'motion_icon': String motion_icon,
      'dark_icon': String dark_icon,
      'subject': int subject,
      'vip_id': int vip_id,


      } =>
          Mall(
              id: id,
              is_store: is_store,
              name: name,
              tag: tag,
              order: order,
              category_id: category_id,
              gift_category_id: gift_category_id,
              price: price,
              days: days,
              behaviour: behaviour,
              icon: icon,
              motion_icon: motion_icon,
              dark_icon: dark_icon,
              subject: subject,
              vip_id: vip_id,
          ),
      _ => throw const FormatException('Failed to load Country.'),
    };
  }
}