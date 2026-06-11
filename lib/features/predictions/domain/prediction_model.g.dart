// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prediction_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PredictionImpl _$$PredictionImplFromJson(Map<String, dynamic> json) =>
    _$PredictionImpl(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      matchId: json['match_id'] as String,
      homeScore: (json['home_score'] as num).toInt(),
      awayScore: (json['away_score'] as num).toInt(),
      pointsEarned: (json['points_earned'] as num?)?.toInt(),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$$PredictionImplToJson(_$PredictionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'match_id': instance.matchId,
      'home_score': instance.homeScore,
      'away_score': instance.awayScore,
      'points_earned': instance.pointsEarned,
      'created_at': instance.createdAt?.toIso8601String(),
    };
