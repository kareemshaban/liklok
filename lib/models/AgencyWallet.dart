class AgencyWallet {
  final int id ;
  final int agency_id;
  final int balance ;
  AgencyWallet({required this.id , required this.agency_id , required this.balance});
  factory AgencyWallet.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
      'id': int id,
      'agency_id': int agency_id,
      'balance': int balance,
      } =>
          AgencyWallet(
              id: id,
              agency_id: agency_id,
              balance: balance,
          ),
      _ => throw const FormatException('Failed to load album.'),
    };
  }
}