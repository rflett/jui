import 'package:json_annotation/json_annotation.dart';
import 'package:jui/models/dto/shared/vote.dart';

part 'votes.g.dart';

@JsonSerializable()
class VotesResponse {
  final List<Vote>? votes;

  VotesResponse(this.votes);

  factory VotesResponse.fromJson(Map<String, dynamic> json) =>
      _$VotesResponseFromJson(json);

  Map<String, dynamic> toJson() => _$VotesResponseToJson(this);
}