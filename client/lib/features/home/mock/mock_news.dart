class NewsItem {
  final String imagePath;
  final String category;
  final String timeAgo;
  final String title;
  final String publisher;
  final String publisherLogo;

  NewsItem({
    required this.imagePath,
    required this.category,
    required this.timeAgo,
    required this.title,
    required this.publisher,
    required this.publisherLogo,
  });
}

final List<NewsItem> mockNewsItems = [
  NewsItem(
    imagePath: 'assets/images/news_sample.webp',
    category: 'IA',
    timeAgo: '30 min ago',
    title: 'Mark Zuckerberg assure que Meta AI a un milliard...',
    publisher: 'Snrt News',
    publisherLogo: 'assets/icons/news.png',
  ),
  NewsItem(
    imagePath: 'assets/images/news_ronaldo.webp',
    category: 'Sport',
    timeAgo: '1h ago',
    title: 'L\'Arabie saoudite voudrait garder Cristiano...',
    publisher: 'Botola',
    publisherLogo: 'assets/icons/botola.png',
  ),
  NewsItem(
    imagePath: 'assets/images/news_movie.jpeg',
    category: 'Cinema',
    timeAgo: '2h ago',
    title: 'Top 10 Moroccan movies you should watch now',
    publisher: 'Forja',
    publisherLogo: 'assets/icons/forja.png',
  ),
];
