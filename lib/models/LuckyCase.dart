class LuckyCase {
  final dynamic id ;
  final dynamic type ;
  final dynamic value ;
  final dynamic user_id ;
  final dynamic room_id ;
  final dynamic out_value ;
  final dynamic created_date ;

  LuckyCase({required this.id , required this.type , required this.value , required this.user_id , required this.room_id , required this.out_value , required this.created_date });

  factory LuckyCase.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
      'id': dynamic id,
      'type': dynamic type,
      'value': dynamic value,
      'user_id': dynamic user_id,
      'room_id': dynamic room_id,
      'out_value': dynamic out_value,
      'created_date': dynamic created_date
      } =>
          LuckyCase(
              id: id,
              type: type,
              value: value,
              user_id: user_id,
              room_id: room_id,
              out_value: out_value,
              created_date: created_date

          ),
      _ => throw const FormatException('Failed to load album.'),
    };
  }

}