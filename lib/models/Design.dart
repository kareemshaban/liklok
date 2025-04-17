class Design {
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
  final String available_until ;
  final int count ;
  final int? isDefault ;
  final int? design_cat ;
  int? send_count ;
  final int relation_id ;


  Design({required this.id , required this.name , required this.tag , required this.icon , required this.available_until ,
    required this.behaviour , required this.category_id , required this.dark_icon , required this.days , required this.gift_category_id ,
  required this.is_store , required this.motion_icon , required this.order , required this.price , required this.subject ,
    required this.vip_id , required this.count ,  this.isDefault ,  this.design_cat , required this.relation_id });

  factory Design.fromJson(Map<String, dynamic> json) {
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
      'available_until': String available_until,
      'count': int count,
       'isDefault': int isDefault,
      'design_cat': int design_cat,
      'relation_id': int relation_id



      } =>
          Design(
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
              available_until: available_until,
              count: count,
              isDefault: isDefault,
              design_cat: design_cat,
              relation_id: relation_id

          ),
      _ => throw const FormatException('Failed to load Country.'),
    };
  }
}