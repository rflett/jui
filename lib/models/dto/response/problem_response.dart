import 'package:json_annotation/json_annotation.dart';

part 'problem_response.g.dart';

@JsonSerializable()
class ProblemResponse {
  final bool success;
  final String error;

  ProblemResponse(this.success, this.error);

  factory ProblemResponse.fromJson(Map<String, dynamic> json) =>
      _$ProblemResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ProblemResponseToJson(this);
}
