import 'package:json_annotation/json_annotation.dart';

part 'deregister_device.g.dart';

@JsonSerializable()
class DeregisterDeviceRequest {
  final String endpoint;
  final String platform;

  DeregisterDeviceRequest(this.endpoint, this.platform);

  factory DeregisterDeviceRequest.fromJson(Map<String, dynamic> json) =>
      _$DeregisterDeviceRequestFromJson(json);

  Map<String, dynamic> toJson() => _$DeregisterDeviceRequestToJson(this);
}
