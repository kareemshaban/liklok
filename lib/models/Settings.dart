class AppSettings {
  final int id ;
  final String diamond_to_gold_ratio ;
  final String gift_sender_diamond_back;
  final String gift_room_owner_diamond_back ;

  AppSettings({required this.id , required this.diamond_to_gold_ratio , required this.gift_room_owner_diamond_back , required this.gift_sender_diamond_back});

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
      'id': int id,
      'diamond_to_gold_ratio': String diamond_to_gold_ratio,
      'gift_sender_diamond_back': String gift_sender_diamond_back ,
      'gift_room_owner_diamond_back': String gift_room_owner_diamond_back,
      } =>
          AppSettings(
            id: id,
            diamond_to_gold_ratio: diamond_to_gold_ratio,
            gift_sender_diamond_back: gift_sender_diamond_back,
            gift_room_owner_diamond_back: gift_room_owner_diamond_back,
          ),
      _ => throw const FormatException('Failed to load album.'),
    };
  }
}