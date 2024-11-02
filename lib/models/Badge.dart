class UserBadge {

  final String badge_name ;
  final String badge ;

  UserBadge({ required this.badge_name , required this.badge});

  factory UserBadge.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {

      'badge_name': String badge_name,
      'badge': String badge,

      } =>
          UserBadge(
            badge_name: badge_name,
            badge: badge,
          ),
      _ => throw const FormatException('Failed to load album.'),
    };
  }
}