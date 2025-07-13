import 'package:freezed_annotation/freezed_annotation.dart';

part 'article_model.freezed.dart';
part 'article_model.g.dart';

@freezed
class Article with _$Article {
  const factory Article({
    required int id,
    String? title,
    String? description,
    String? resume,
    String? categorieLabel,
    String? image,
    @Default(false) bool isVideo,
    String? video,
    String? typeVideo,
    dynamic match,
    int? competitionId,
    DateTime? publishedAt,
  }) = _Article;

  factory Article.fromJson(Map<String, dynamic> json) => _$ArticleFromJson(json);
}
