import 'package:json_annotation/json_annotation.dart';

part 'remove_vote.g.dart';

@JsonSerializable()
class RemoveVoteRequest {
  final String songID;
  final String name;
  final String artist;
  final int position;

  RemoveVoteRequest(this.songID, this.name, this.artist, this.position);

  factory RemoveVoteRequest.fromJson(Map<String, dynamic> json) =>
      _$RemoveVoteRequestFromJson(json);

  Map<String, dynamic> toJson() => _$RemoveVoteRequestToJson(this);
}
