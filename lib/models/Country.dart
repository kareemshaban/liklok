class Country {
   final int id ;
   final String name ;
   final String code ;
   final int order ;
   final String dial_code ;
   final String icon ;
   final int enable ;


  Country({required this.id, required this.name, required this.code, required this.order, required this.dial_code, required this.icon, required this.enable});

   factory Country.fromJson(Map<String, dynamic> json) {
     return switch (json) {
       {
       'id': int id,
       'name': String name,
       'code': String code,
       'order': int order,
       'dial_code': String dial_code,
       'icon': String icon,
       'enable': int enable,
       } =>
           Country(
             id: id,
             name: name,
             code: code,
             order: order,
             dial_code: dial_code,
             icon: icon,
             enable: enable
           ),
       _ => throw const FormatException('Failed to load Country.'),
     };
   }

}