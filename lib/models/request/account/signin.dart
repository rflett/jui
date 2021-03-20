import 'package:json_annotation/json_annotation.dart';

part 'signin.g.dart';

@JsonSerializable()
class SignIn {
  final String email;
  final String password;

  SignIn(this.email, this.password);

  factory SignIn.fromJson(Map<String, dynamic> json) => _$SignInFromJson(json);

  Map<String, dynamic> toJson() => _$SignInToJson(this);
}
