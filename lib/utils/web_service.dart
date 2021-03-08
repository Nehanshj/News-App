import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:news/models/NewsModel.dart';
import 'package:news/models/sourcesModel.dart';

class Webservice {
  static const String apiKey = 'c2bb106adb5f425bade571b6b025bbf7';

  ///Used on Search Screen to query results as per given search keyword
  Future<List<NewsArticle>> fetchHeadlinesByKeyword(String keyword) async {
    final response = await http
        .get("https://newsapi.org/v2/everything?q=$keyword&apiKey=$apiKey");

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      Iterable list = result["articles"];
      return list.map((json) => NewsArticle.fromJSON(json)).toList();
    } else {
      throw Exception("Failed to get news");
    }
  }

  ///Used to fetch all the available sources
  Future<List<Source>> fetchSources() async {
    final response =
        await http.get("https://newsapi.org/v2/sources?apiKey=$apiKey");

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      Iterable list = result["sources"];
      return list.map((json) => Source.fromJSON(json)).toList();
    } else {
      throw Exception("Failed to fetch Sources");
    }
  }

  ///Used to fetch one Page of newsArticles from the API at a time
  ///for pagination
  Future<List<NewsArticle>> fetchPage(
      int pageNo, String criteria, String value) async {
    switch (criteria) {
      case "country":
        final response = await http.get(
            "https://newsapi.org/v2/top-headlines?country=$value&pageSize=10&page=$pageNo&apiKey=$apiKey");

        if (response.statusCode == 200) {
          final result = jsonDecode(response.body);
          Iterable list = result["articles"];
          return list.map((json) => NewsArticle.fromJSON(json)).toList();
        } else {
          throw Exception("Failed to get news");
        }
        break;

      case "source":
        final response = await http.get(
            "https://newsapi.org/v2/top-headlines?sources=$value&apiKey=$apiKey");

        if (response.statusCode == 200) {
          final result = jsonDecode(response.body);
          Iterable list = result["articles"];
          return list.map((article) => NewsArticle.fromJSON(article)).toList();
        } else {
          throw Exception("Failed to get News from Specific Sources");
        }
        break;
    }
  }
}
