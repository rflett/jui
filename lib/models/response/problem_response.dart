import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';

part 'problem_response.g.dart';

@JsonSerializable()
class ProblemResponse {
  String title;
  int status;
  String detail;
  String traceId;
  Map<String, List<String>> errors;

  ProblemResponse(this.title, this.status, this.detail, this.traceId, this.errors);

  factory ProblemResponse.fromJson(Map<String, dynamic> json) =>
      _$ProblemResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ProblemResponseToJson(this);
}
