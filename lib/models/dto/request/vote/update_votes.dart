import 'package:json_annotation/json_annotation.dart';
import 'package:jui/models/dto/shared/vote.dart';

part 'update_votes.g.dart';

@JsonSerializable()
class UpdateVotesDto {
  final List<Vote> upsert;
  final List<String> delete;

  UpdateVotesDto(this.upsert, this.delete);

  Map<String, dynamic> toJson() => _$UpdateVotesDtoToJson(this);
}
