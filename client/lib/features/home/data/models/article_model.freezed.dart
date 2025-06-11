// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'article_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Article _$ArticleFromJson(Map<String, dynamic> json) {
  return _Article.fromJson(json);
}

/// @nodoc
mixin _$Article {
  int get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get resume => throw _privateConstructorUsedError;
  String get categorieLabel => throw _privateConstructorUsedError;
  String get image => throw _privateConstructorUsedError;
  bool get isVideo => throw _privateConstructorUsedError;
  String? get video => throw _privateConstructorUsedError;
  String? get typeVideo => throw _privateConstructorUsedError;
  dynamic get match => throw _privateConstructorUsedError;
  int? get competitionId => throw _privateConstructorUsedError;
  DateTime get publishedAt => throw _privateConstructorUsedError;

  /// Serializes this Article to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Article
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ArticleCopyWith<Article> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ArticleCopyWith<$Res> {
  factory $ArticleCopyWith(Article value, $Res Function(Article) then) =
      _$ArticleCopyWithImpl<$Res, Article>;
  @useResult
  $Res call({
    int id,
    String title,
    String description,
    String resume,
    String categorieLabel,
    String image,
    bool isVideo,
    String? video,
    String? typeVideo,
    dynamic match,
    int? competitionId,
    DateTime publishedAt,
  });
}

/// @nodoc
class _$ArticleCopyWithImpl<$Res, $Val extends Article>
    implements $ArticleCopyWith<$Res> {
  _$ArticleCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Article
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? resume = null,
    Object? categorieLabel = null,
    Object? image = null,
    Object? isVideo = null,
    Object? video = freezed,
    Object? typeVideo = freezed,
    Object? match = freezed,
    Object? competitionId = freezed,
    Object? publishedAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
            resume: null == resume
                ? _value.resume
                : resume // ignore: cast_nullable_to_non_nullable
                      as String,
            categorieLabel: null == categorieLabel
                ? _value.categorieLabel
                : categorieLabel // ignore: cast_nullable_to_non_nullable
                      as String,
            image: null == image
                ? _value.image
                : image // ignore: cast_nullable_to_non_nullable
                      as String,
            isVideo: null == isVideo
                ? _value.isVideo
                : isVideo // ignore: cast_nullable_to_non_nullable
                      as bool,
            video: freezed == video
                ? _value.video
                : video // ignore: cast_nullable_to_non_nullable
                      as String?,
            typeVideo: freezed == typeVideo
                ? _value.typeVideo
                : typeVideo // ignore: cast_nullable_to_non_nullable
                      as String?,
            match: freezed == match
                ? _value.match
                : match // ignore: cast_nullable_to_non_nullable
                      as dynamic,
            competitionId: freezed == competitionId
                ? _value.competitionId
                : competitionId // ignore: cast_nullable_to_non_nullable
                      as int?,
            publishedAt: null == publishedAt
                ? _value.publishedAt
                : publishedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ArticleImplCopyWith<$Res> implements $ArticleCopyWith<$Res> {
  factory _$$ArticleImplCopyWith(
    _$ArticleImpl value,
    $Res Function(_$ArticleImpl) then,
  ) = __$$ArticleImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    String title,
    String description,
    String resume,
    String categorieLabel,
    String image,
    bool isVideo,
    String? video,
    String? typeVideo,
    dynamic match,
    int? competitionId,
    DateTime publishedAt,
  });
}

/// @nodoc
class __$$ArticleImplCopyWithImpl<$Res>
    extends _$ArticleCopyWithImpl<$Res, _$ArticleImpl>
    implements _$$ArticleImplCopyWith<$Res> {
  __$$ArticleImplCopyWithImpl(
    _$ArticleImpl _value,
    $Res Function(_$ArticleImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Article
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? resume = null,
    Object? categorieLabel = null,
    Object? image = null,
    Object? isVideo = null,
    Object? video = freezed,
    Object? typeVideo = freezed,
    Object? match = freezed,
    Object? competitionId = freezed,
    Object? publishedAt = null,
  }) {
    return _then(
      _$ArticleImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        resume: null == resume
            ? _value.resume
            : resume // ignore: cast_nullable_to_non_nullable
                  as String,
        categorieLabel: null == categorieLabel
            ? _value.categorieLabel
            : categorieLabel // ignore: cast_nullable_to_non_nullable
                  as String,
        image: null == image
            ? _value.image
            : image // ignore: cast_nullable_to_non_nullable
                  as String,
        isVideo: null == isVideo
            ? _value.isVideo
            : isVideo // ignore: cast_nullable_to_non_nullable
                  as bool,
        video: freezed == video
            ? _value.video
            : video // ignore: cast_nullable_to_non_nullable
                  as String?,
        typeVideo: freezed == typeVideo
            ? _value.typeVideo
            : typeVideo // ignore: cast_nullable_to_non_nullable
                  as String?,
        match: freezed == match
            ? _value.match
            : match // ignore: cast_nullable_to_non_nullable
                  as dynamic,
        competitionId: freezed == competitionId
            ? _value.competitionId
            : competitionId // ignore: cast_nullable_to_non_nullable
                  as int?,
        publishedAt: null == publishedAt
            ? _value.publishedAt
            : publishedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ArticleImpl implements _Article {
  const _$ArticleImpl({
    required this.id,
    required this.title,
    required this.description,
    required this.resume,
    required this.categorieLabel,
    required this.image,
    required this.isVideo,
    this.video,
    this.typeVideo,
    this.match,
    this.competitionId,
    required this.publishedAt,
  });

  factory _$ArticleImpl.fromJson(Map<String, dynamic> json) =>
      _$$ArticleImplFromJson(json);

  @override
  final int id;
  @override
  final String title;
  @override
  final String description;
  @override
  final String resume;
  @override
  final String categorieLabel;
  @override
  final String image;
  @override
  final bool isVideo;
  @override
  final String? video;
  @override
  final String? typeVideo;
  @override
  final dynamic match;
  @override
  final int? competitionId;
  @override
  final DateTime publishedAt;

  @override
  String toString() {
    return 'Article(id: $id, title: $title, description: $description, resume: $resume, categorieLabel: $categorieLabel, image: $image, isVideo: $isVideo, video: $video, typeVideo: $typeVideo, match: $match, competitionId: $competitionId, publishedAt: $publishedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ArticleImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.resume, resume) || other.resume == resume) &&
            (identical(other.categorieLabel, categorieLabel) ||
                other.categorieLabel == categorieLabel) &&
            (identical(other.image, image) || other.image == image) &&
            (identical(other.isVideo, isVideo) || other.isVideo == isVideo) &&
            (identical(other.video, video) || other.video == video) &&
            (identical(other.typeVideo, typeVideo) ||
                other.typeVideo == typeVideo) &&
            const DeepCollectionEquality().equals(other.match, match) &&
            (identical(other.competitionId, competitionId) ||
                other.competitionId == competitionId) &&
            (identical(other.publishedAt, publishedAt) ||
                other.publishedAt == publishedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    title,
    description,
    resume,
    categorieLabel,
    image,
    isVideo,
    video,
    typeVideo,
    const DeepCollectionEquality().hash(match),
    competitionId,
    publishedAt,
  );

  /// Create a copy of Article
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ArticleImplCopyWith<_$ArticleImpl> get copyWith =>
      __$$ArticleImplCopyWithImpl<_$ArticleImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ArticleImplToJson(this);
  }
}

abstract class _Article implements Article {
  const factory _Article({
    required final int id,
    required final String title,
    required final String description,
    required final String resume,
    required final String categorieLabel,
    required final String image,
    required final bool isVideo,
    final String? video,
    final String? typeVideo,
    final dynamic match,
    final int? competitionId,
    required final DateTime publishedAt,
  }) = _$ArticleImpl;

  factory _Article.fromJson(Map<String, dynamic> json) = _$ArticleImpl.fromJson;

  @override
  int get id;
  @override
  String get title;
  @override
  String get description;
  @override
  String get resume;
  @override
  String get categorieLabel;
  @override
  String get image;
  @override
  bool get isVideo;
  @override
  String? get video;
  @override
  String? get typeVideo;
  @override
  dynamic get match;
  @override
  int? get competitionId;
  @override
  DateTime get publishedAt;

  /// Create a copy of Article
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ArticleImplCopyWith<_$ArticleImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
