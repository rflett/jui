import 'package:json_annotation/json_annotation.dart';

part 'signup.g.dart';

@JsonSerializable()
class Signup {
  final String name;
  final String nickName;
  final String email;
  final String password;

  Signup(this.name, this.nickName, this.email, this.password);

  factory Signup.fromJson(Map<String, dynamic> json) => _$SignupFromJson(json);

  Map<String, dynamic> toJson() => _$SignupToJson(this);
}
