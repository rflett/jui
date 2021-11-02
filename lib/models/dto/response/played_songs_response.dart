import 'package:json_annotation/json_annotation.dart';
import 'package:jui/models/dto/shared/vote.dart';

part 'played_songs_response.g.dart';

@JsonSerializable()
class PlayedSongsResponse {
  final int playedCount;
  final List<Vote> songs;

  PlayedSongsResponse(this.playedCount, this.songs);

  factory PlayedSongsResponse.fromJson(Map<String, dynamic> json) =>
      _$PlayedSongsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PlayedSongsResponseToJson(this);
}
