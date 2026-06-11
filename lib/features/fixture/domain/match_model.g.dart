// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'match_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MatchImpl _$$MatchImplFromJson(Map<String, dynamic> json) => _$MatchImpl(
      id: json['id'] as String,
      homeTeam: json['home_team'] as String,
      awayTeam: json['away_team'] as String,
      homeScore: (json['home_score'] as num?)?.toInt(),
      awayScore: (json['away_score'] as num?)?.toInt(),
      matchTime: DateTime.parse(json['match_time'] as String),
      status: json['status'] as String,
      stage: json['stage'] as String?,
      groupName: json['group_name'] as String?,
      apiFootballId: (json['api_football_id'] as num?)?.toInt(),
      homeFlag: json['home_flag'] as String?,
      awayFlag: json['away_flag'] as String?,
    );

Map<String, dynamic> _$$MatchImplToJson(_$MatchImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'home_team': instance.homeTeam,
      'away_team': instance.awayTeam,
      'home_score': instance.homeScore,
      'away_score': instance.awayScore,
      'match_time': instance.matchTime.toIso8601String(),
      'status': instance.status,
      'stage': instance.stage,
      'group_name': instance.groupName,
      'api_football_id': instance.apiFootballId,
      'home_flag': instance.homeFlag,
      'away_flag': instance.awayFlag,
    };
