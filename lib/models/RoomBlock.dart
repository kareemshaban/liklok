class RoomBlock {
  final int id  ;
  final int room_id ;
  final int user_id ;
  final String blocked_date ;
  final String block_type ;
  final String block_until ;
  final String? mic_user_tag ;
  final String? mic_user_name ;
  final String? mic_user_img ;
  final int? mic_user_gender ;
  final String? mic_user_birth_date ;
  final String? mic_user_share_level ;
  final String? mic_user_karizma_level ;
  final String? mic_user_charging_level ;


  RoomBlock({required this.id , required this.room_id , required this.user_id ,
    this.mic_user_tag , this.mic_user_name , this.mic_user_img , this.mic_user_gender , this.mic_user_birth_date ,
    this.mic_user_share_level , this.mic_user_karizma_level , this.mic_user_charging_level , required this.blocked_date , required this.block_type , required this.block_until});


  factory RoomBlock.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
      'id': int id,
      'room_id': int room_id,
      'user_id': int user_id,
      'mic_user_tag': String mic_user_tag,
      'blocked_date': String blocked_date,
      'block_type': String block_type,
      'block_until': String block_until,
      'mic_user_name': String mic_user_name,
      'mic_user_img': String mic_user_img,
      'mic_user_gender': int mic_user_gender,
      'mic_user_birth_date': String mic_user_birth_date,
      'mic_user_share_level': String mic_user_share_level,
      'mic_user_karizma_level': String mic_user_karizma_level,
      'mic_user_charging_level': String mic_user_charging_level,
      } =>
          RoomBlock(
            id: id,
            room_id: room_id,
            user_id: user_id,
            mic_user_tag: mic_user_tag,
            blocked_date: blocked_date,
            block_type: block_type,
            block_until: block_until,
            mic_user_name: mic_user_name,
            mic_user_img: mic_user_img,
            mic_user_gender: mic_user_gender,
            mic_user_birth_date: mic_user_birth_date,
            mic_user_share_level: mic_user_share_level,
            mic_user_karizma_level: mic_user_karizma_level,
            mic_user_charging_level: mic_user_charging_level,
          ),
      _ => throw const FormatException('Failed to load album.'),
    };
  }

}