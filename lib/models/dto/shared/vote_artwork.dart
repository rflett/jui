import 'package:json_annotation/json_annotation.dart';

part 'vote_artwork.g.dart';

@JsonSerializable()
class VoteArtwork {
  final String url;
  final int width;
  final int height;

  VoteArtwork(this.url, this.width, this.height);

  factory VoteArtwork.fromJson(Map<String, dynamic> json) =>
      _$VoteArtworkFromJson(json);

  Map<String, dynamic> toJson() => _$VoteArtworkToJson(this);
}
