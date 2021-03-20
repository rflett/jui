import 'package:json_annotation/json_annotation.dart';

part 'register_device.g.dart';

@JsonSerializable()
class RegisterDevice {
  final String token;
  final String platform;

  RegisterDevice(this.token, this.platform);

  factory RegisterDevice.fromJson(Map<String, dynamic> json) =>
      _$RegisterDeviceFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterDeviceToJson(this);
}
