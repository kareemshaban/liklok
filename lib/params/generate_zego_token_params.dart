import 'package:json_annotation/json_annotation.dart';
part 'generate_zego_token_params.g.dart';

@JsonSerializable()
class GenerateZegoTokenParams {
  @JsonKey(name: "user_id", includeIfNull: false)
  int? userId;
  @JsonKey(name: "room_id", includeIfNull: false)
  String? roomId;

  GenerateZegoTokenParams({
    this.roomId,
    this.userId,
  });

  factory GenerateZegoTokenParams.fromJson(Map<String, dynamic> json) =>
      _$GenerateZegoTokenParamsFromJson(json);

  Map<String, dynamic> toJson() => _$GenerateZegoTokenParamsToJson(this);
}
