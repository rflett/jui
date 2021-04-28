import 'package:json_annotation/json_annotation.dart';

part 'auth_token.g.dart';

@JsonSerializable()
class AuthToken {
  final String name;
  final String? picture;
  @JsonKey(name: 'https://delegator.com.au/AuthProvider')
  final String authProvider;
  @JsonKey(name: 'https://delegator.com.au/AuthProviderId')
  final String authProviderId;
  final String aud;
  final int exp;
  final String jti;
  final int iat;
  final String iss;
  final int nbf;
  final String sub;

  AuthToken(this.name, this.picture, this.authProvider, this.authProviderId, this.aud, this.exp, this.jti, this.iat, this.iss, this.nbf, this.sub);

  factory AuthToken.fromJson(Map<String, dynamic> json) => _$AuthTokenFromJson(json);

  Map<String, dynamic> toJson() => _$AuthTokenToJson(this);
}