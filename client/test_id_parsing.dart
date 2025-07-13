void main() {
  // Test the ID parsing logic
  final testIds = [
    "article_6815",
    "video_1234", 
    "12345",
    "",
    null
  ];
  
  for (final testId in testIds) {
    final rawId = testId?.toString() ?? '';
    print('🔍 Raw ID: $rawId');
    final numericId = rawId.contains('_') ? int.tryParse(rawId.split('_').last) ?? 0 : int.tryParse(rawId) ?? 0;
    print('🔢 Parsed numeric ID: $numericId');
    print('---');
  }
}
