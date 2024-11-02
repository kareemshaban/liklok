class AgencyTarget {
  final int id ;
  final String order ;
  final String gold ;
  final String dollar_amount ;
  final String agent_amount ;
  final String icon ;

  AgencyTarget({required this.id , required this.order , required this.gold , required this.dollar_amount , required this.agent_amount ,
  required this.icon});

  factory AgencyTarget.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
      'id': int id,
      'order': String order,
      'gold': String gold,
      'dollar_amount': String dollar_amount,
      'agent_amount': String agent_amount,
      'icon': String icon,

      } =>
          AgencyTarget(
            id: id,
            order: order,
            gold: gold,
            dollar_amount: dollar_amount,
            agent_amount: agent_amount,
            icon: icon,

          ),
      _ => throw const FormatException('Failed to load album.'),
    };
  }
}