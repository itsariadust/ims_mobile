import 'package:json_annotation/json_annotation.dart';

part 'login_response_dto.g.dart';
@JsonSerializable()
class LoginResponseDto {
  @JsonKey(name: 'access_token') final String accessToken;
  @JsonKey(name: 'expires_in') final int expiresIn;
  @JsonKey(name: 'refresh_expires_in') final int refreshExpiresIn;
  @JsonKey(name: 'refresh_token') final String refreshToken;
  @JsonKey(name: 'token_type') final String tokenType;
  @JsonKey(name: 'not-before-policy') final int? notBeforePolicy;
  @JsonKey(name: 'session_state') final String? sessionState;
  @JsonKey(name: 'scope') final String? scope;

  LoginResponseDto({
    required this.accessToken,
    required this.expiresIn,
    required this.refreshExpiresIn,
    required this.refreshToken,
    required this.tokenType,
    required this.notBeforePolicy,
    required this.sessionState,
    required this.scope
  });

  factory LoginResponseDto.fromJson(Map<String, dynamic> json) => _$LoginResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResponseDtoToJson(this);
}