import 'package:freezed_annotation/freezed_annotation.dart';

part 'article_model.freezed.dart';
part 'article_model.g.dart';

@freezed
class Article with _$Article {
  const factory Article({
    required int id,
    required String title,
    required String description,
    required String resume,
    required String categorieLabel,
    required String image,
    required bool isVideo,
    String? video,
    String? typeVideo,
    dynamic match,
    int? competitionId,
    required DateTime publishedAt,
  }) = _Article;

  factory Article.fromJson(Map<String, dynamic> json) => _$ArticleFromJson(json);
}
