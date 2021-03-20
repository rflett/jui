import 'package:json_annotation/json_annotation.dart';

part 'deregister_device.g.dart';

@JsonSerializable()
class DeregisterDevice {
  final String endpoint;
  final String platform;

  DeregisterDevice(this.endpoint, this.platform);

  factory DeregisterDevice.fromJson(Map<String, dynamic> json) =>
      _$DeregisterDeviceFromJson(json);

  Map<String, dynamic> toJson() => _$DeregisterDeviceToJson(this);
}
