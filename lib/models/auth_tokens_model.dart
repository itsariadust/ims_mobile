import 'package:json_annotation/json_annotation.dart';

part 'auth_tokens_model.g.dart';
@JsonSerializable()
class AuthTokens {
  @JsonKey(name: 'access_token') final String accessToken;
  @JsonKey(name: 'refresh_token') final String refreshToken;
  @JsonKey(name: 'expires_in') final int expiresIn;
  @JsonKey(name: 'refresh_expires_in') final int refreshExpiresIn;
  @JsonKey(name: 'token_type') final String tokenType;

  AuthTokens({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresIn,
    required this.refreshExpiresIn,
    required this.tokenType
  });

  factory AuthTokens.fromJson(Map<String, dynamic> json) => _$AuthTokensFromJson(json);

  Map<String, dynamic> toJson() => _$AuthTokensToJson(this);
}