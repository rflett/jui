import 'package:json_annotation/json_annotation.dart';
import 'package:jui/models/dto/shared/vote_artwork.dart';

part 'vote.g.dart';

@JsonSerializable()
class Vote {
  final String songId; // Spotify song ID
  final String name;
  final String album;
  final String artist;
  final List<VoteArtwork> artwork;
  final int? playedPosition;
  final DateTime? playedAt;
  final DateTime createdAt;

  Vote(this.songId, this.name, this.album, this.artist, this.artwork,
      this.playedPosition, this.playedAt, this.createdAt);

  factory Vote.fromJson(Map<String, dynamic> json) => _$VoteFromJson(json);

  Map<String, dynamic> toJson() => _$VoteToJson(this);
}