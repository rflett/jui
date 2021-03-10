import 'package:json_annotation/json_annotation.dart';
import 'login_request.dart';

part 'registration_request.g.dart';

@JsonSerializable()
class RegistrationRequest extends LoginRequest {
  final String username;

  RegistrationRequest(this.username, String email, String password) : super(email, password);

  Map<String, dynamic> toJson() => _$RegistrationRequestToJson(this);
}
