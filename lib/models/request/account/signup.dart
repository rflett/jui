import 'package:json_annotation/json_annotation.dart';

part 'signup.g.dart';

@JsonSerializable()
class SignUpRequest {
  final String name;
  final String nickName;
  final String email;
  final String password;

  SignUpRequest(this.name, this.nickName, this.email, this.password);

  factory SignUpRequest.fromJson(Map<String, dynamic> json) => _$SignUpRequestFromJson(json);

  Map<String, dynamic> toJson() => _$SignUpRequestToJson(this);
}
