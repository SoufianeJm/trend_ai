class Bookmark {
  final int id;
  final String userId;
  final int articleId;
  final DateTime createdAt;

  const Bookmark({
    required this.id,
    required this.userId,
    required this.articleId,
    required this.createdAt,
  });

  factory Bookmark.fromJson(Map<String, dynamic> json) {
    return Bookmark(
      id: json['id'] as int,
      userId: json['user_id'] as String,
      articleId: json['article_id'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'article_id': articleId,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
