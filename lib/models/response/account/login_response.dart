import 'package:json_annotation/json_annotation.dart';
import 'package:jui/models/response/user/user.dart';

part 'login_response.g.dart';

@JsonSerializable()
class LoginResponse {
  final UserResponse user;
  final String token;
  final String tokenType;

  LoginResponse(this.user, this.token, this.tokenType);

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}
