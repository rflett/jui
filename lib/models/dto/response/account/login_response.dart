import 'package:json_annotation/json_annotation.dart';
import 'package:jui/models/dto/response/user/user.dart';

part 'login_response.g.dart';

@JsonSerializable()
class LoginResponse {
  final UserResponse user;
  final String token; // JWT token for use in Authorization header of API requests
  final String tokenType; // always Bearer

  LoginResponse(this.user, this.token, this.tokenType);

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}
