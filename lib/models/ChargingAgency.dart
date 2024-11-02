import 'package:LikLok/models/AgencyWallet.dart';

class ChargingAgency {
  final int id ;
  final int user_id ;
  final String name;
  final int active ;
  final String notes ;
  AgencyWallet? wallet ;

  ChargingAgency({required this.id , required this.user_id , required this.name , required this.active , required this.notes , this.wallet });

  factory ChargingAgency.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
      'id': int id,
      'user_id': int user_id,
      'name': String name,
      'active': int active,
      'notes': String notes
      } =>
          ChargingAgency(
              id: id,
              name: name,
              user_id: user_id,
              active: active,
              notes: notes,
          ),
      _ => throw const FormatException('Failed to load album.'),
    };
  }
}