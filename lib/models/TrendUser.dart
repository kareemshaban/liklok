class TrendUser {
    final int id ;
    final String tag ;
    final String name ;
    final String img ;
    final String share_level_icon ;
    final String karizma_level_icon ;
    final String charging_level_icon ;
    final int gender ;

    TrendUser({required this.id , required this.tag , required this.name , required this.img , required this.share_level_icon , required this.karizma_level_icon , required this.charging_level_icon , required this.gender});

    factory TrendUser.fromJson(Map<String, dynamic> json) {
      return switch (json) {
        {
        'id': int id,
        'tag': String tag,
        'name': String name,
        'img': String img,
        'share_level_icon': String share_level_icon,
        'karizma_level_icon': String karizma_level_icon,
        'charging_level_icon': String charging_level_icon,
        'gender': int gender,
        } =>
            TrendUser(
              id: id,
              tag: tag,
              name: name,
              img: img,
              share_level_icon: share_level_icon,
              karizma_level_icon: karizma_level_icon,
              charging_level_icon: charging_level_icon,
              gender: gender,
            ),
        _ => throw const FormatException('Failed to load album.'),
      };
    }

}