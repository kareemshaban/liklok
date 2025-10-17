// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'generate_zego_token_params.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GenerateZegoTokenParams _$GenerateZegoTokenParamsFromJson(
  Map<String, dynamic> json,
) => GenerateZegoTokenParams(
  roomId: json['room_id'] as String?,
  userId: (json['user_id'] as num?)?.toInt(),
);

Map<String, dynamic> _$GenerateZegoTokenParamsToJson(
  GenerateZegoTokenParams instance,
) => <String, dynamic>{
  'user_id': ?instance.userId,
  'room_id': ?instance.roomId,
};
