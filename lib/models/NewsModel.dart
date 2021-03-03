class NewsArticle {

  final String title;
  final String description;
  final String urlToImage;
  final String url;
  final String source;
  final DateTime time;
  final String content;

  NewsArticle({this.title, this.description, this.urlToImage, this.url, this.source, this.time, this.content});

  factory NewsArticle.fromJSON(Map<String, dynamic> json) {
    return NewsArticle(
        source: json['source']['name'] ?? "",
        title: json["title"].toString().split(' - ').first ?? "",
        description: json["description"] ?? "",
        urlToImage: json["urlToImage"] ?? "",
        url: json["url"] ?? "",
        time: DateTime.parse(json['publishedAt']),
        content: json['content'] ?? "");
  }

}