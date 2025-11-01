class UserBadge {
  final String badge_name;
  final String badge;

  UserBadge({required this.badge_name, required this.badge});

  factory UserBadge.fromJson(Map<String, dynamic> json) {
    return UserBadge(
      badge_name: json['badge_name'] ?? '',
      badge: json['badge'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'badge_name': badge_name,
      'badge': badge,
    };
  }
}
