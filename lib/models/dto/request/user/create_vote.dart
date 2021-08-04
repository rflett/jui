import 'package:json_annotation/json_annotation.dart';
import 'package:jui/models/dto/shared/vote.dart';

part 'create_vote.g.dart';

@JsonSerializable()
class CreateVoteRequest {
  final int rank;
  final Vote vote;

  CreateVoteRequest(this.rank, this.vote);

  factory CreateVoteRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateVoteRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CreateVoteRequestToJson(this);
}