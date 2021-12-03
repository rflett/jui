import 'package:json_annotation/json_annotation.dart';

part 'problem_response.g.dart';

@JsonSerializable()
class ProblemResponse {
  final String? error;

  ProblemResponse(this.error);

  factory ProblemResponse.fromJson(Map<String, dynamic> json) =>
      _$ProblemResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ProblemResponseToJson(this);
}
