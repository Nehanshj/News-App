import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:news/models/NewsModel.dart';
import 'package:news/models/sourcesModel.dart';

class Webservice {
  static const String TOP_HEADLINES_URL =  "https://newsapi.org/v2/top-headlines?country=IN&apiKey=$apiKey";
  static const String apiKey = 'c2bb106adb5f425bade571b6b025bbf7';

  Future<List<NewsArticle>> fetchHeadlinesByKeyword(String keyword) async {

    final response = await http.get("https://newsapi.org/v2/everything?q=$keyword&apiKey=$apiKey");

    if(response.statusCode == 200) {
      final result = jsonDecode(response.body);
      Iterable list = result["articles"];
      return list.map((json) => NewsArticle.fromJSON(json)).toList();
    } else {
      throw Exception("Failed to get news");
    }


  }

  Future<List<Source>> fetchSources() async {

    final response = await http.get("https://newsapi.org/v2/sources?apiKey=$apiKey");

    if(response.statusCode == 200) {
      final result = jsonDecode(response.body);
      Iterable list = result["sources"];
      return list.map((json) => Source.fromJSON(json)).toList();
    } else {
      throw Exception("Failed to get news");
    }


  }

  Future<List<NewsArticle>> fetchTopHeadlines(String country) async {

    final response = await http.get("https://newsapi.org/v2/top-headlines?country=$country&apiKey=$apiKey");

    if(response.statusCode == 200) {

      final result = jsonDecode(response.body);
      Iterable list = result["articles"];
      return list.map((article) => NewsArticle.fromJSON(article)).toList();

    } else {
      throw Exception("Failed to get top news");
    }

  }
  Future<List<NewsArticle>> fetchFromSources(String country, String sources) async {
    print("SOURCES:: $sources");
    final response = await http.get("https://newsapi.org/v2/top-headlines?sources=$sources&apiKey=$apiKey");

    if(response.statusCode == 200) {

      final result = jsonDecode(response.body);
      Iterable list = result["articles"];
      return list.map((article) => NewsArticle.fromJSON(article)).toList();

    } else {
      throw Exception("Failed to get News from Specific Sources");
    }

  }
}