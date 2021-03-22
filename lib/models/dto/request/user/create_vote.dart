import 'package:json_annotation/json_annotation.dart';

part 'create_vote.g.dart';

@JsonSerializable()
class CreateVoteRequest {
  final int position;
  final String song; // TODO this is actually a Song object

  CreateVoteRequest(this.position, this.song);

  factory CreateVoteRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateVoteRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CreateVoteRequestToJson(this);
}