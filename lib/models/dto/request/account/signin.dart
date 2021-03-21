import 'package:json_annotation/json_annotation.dart';

part 'signin.g.dart';

@JsonSerializable()
class SignInRequest {
  final String email;
  final String password;

  SignInRequest(this.email, this.password);

  factory SignInRequest.fromJson(Map<String, dynamic> json) => _$SignInRequestFromJson(json);

  Map<String, dynamic> toJson() => _$SignInRequestToJson(this);
}
