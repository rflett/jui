import 'package:json_annotation/json_annotation.dart';

part 'register_device.g.dart';

@JsonSerializable()
class RegisterDeviceRequest {
  final String token;
  final String platform;

  RegisterDeviceRequest(this.token, this.platform);

  factory RegisterDeviceRequest.fromJson(Map<String, dynamic> json) =>
      _$RegisterDeviceRequestFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterDeviceRequestToJson(this);
}
