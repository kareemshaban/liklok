import 'package:LikLok/models/AgencyMember.dart';

class HostAgency {
  final int id ;
  final String name ;
  final String tag ;
  final int user_id ;
  final String monthly_gold_target ;
  final String details ;
  final int  active ;
  final int  allow_new_joiners ;
  final int  automatic_accept_joiners ;
  final int  automatic_accept_exit ;
  List<AgencyMember>? members ;

  HostAgency({required this.id , required this.name , required this.tag , required this.user_id , required this.monthly_gold_target ,
  required this.details , required this.active , required this.allow_new_joiners , required this.automatic_accept_exit , required this.automatic_accept_joiners , this.members});

  factory HostAgency.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
      'id': int id,
      'name': String name,
      'tag': String tag,
      'user_id': int user_id,
      'monthly_gold_target': String monthly_gold_target,
      'details': String details,
      'active': int active,
      'allow_new_joiners': int allow_new_joiners,
      'automatic_accept_joiners': int automatic_accept_joiners,
      'automatic_accept_exit': int automatic_accept_exit,


      } =>
          HostAgency(
              id: id,
              name: name,
              tag: tag,
              user_id: user_id,
              monthly_gold_target: monthly_gold_target,
              details: details,
              active: active,
              allow_new_joiners: allow_new_joiners,
              automatic_accept_joiners: automatic_accept_joiners,
              automatic_accept_exit: automatic_accept_exit,
          ),
      _ => throw const FormatException('Failed to load album.'),
    };
  }


}