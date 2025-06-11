// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'article_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ArticleImpl _$$ArticleImplFromJson(Map<String, dynamic> json) =>
    _$ArticleImpl(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      description: json['description'] as String,
      resume: json['resume'] as String,
      categorieLabel: json['categorieLabel'] as String,
      image: json['image'] as String,
      isVideo: json['isVideo'] as bool,
      video: json['video'] as String?,
      typeVideo: json['typeVideo'] as String?,
      match: json['match'],
      competitionId: (json['competitionId'] as num?)?.toInt(),
      publishedAt: DateTime.parse(json['publishedAt'] as String),
    );

Map<String, dynamic> _$$ArticleImplToJson(_$ArticleImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'resume': instance.resume,
      'categorieLabel': instance.categorieLabel,
      'image': instance.image,
      'isVideo': instance.isVideo,
      'video': instance.video,
      'typeVideo': instance.typeVideo,
      'match': instance.match,
      'competitionId': instance.competitionId,
      'publishedAt': instance.publishedAt.toIso8601String(),
    };
