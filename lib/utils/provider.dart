import 'package:flutter/material.dart';
import 'package:news/models/NewsModel.dart';
import 'package:news/models/sourcesModel.dart';
import 'package:news/utils/web_service.dart';

enum LoadingStatus {
  completed,
  searching,
  empty
}

enum sortType { Oldest, Newest, Popular }

String enumToString(Object o) => o.toString().split('.').last;

class NewsProvider extends ChangeNotifier{
   static String country = "in";
   List<String> sourcesToBeFetched=[];
  var loadingStatus = LoadingStatus.searching;

  List<NewsArticle> articles = List<NewsArticle>();
  List<NewsArticle> articleSearched = List<NewsArticle>();
   List<Source> sources = List<Source>();

  Future<void> search(String keyword) async {
    this.loadingStatus = LoadingStatus.searching;
    notifyListeners();
    List<NewsArticle> newsArticles = await Webservice().fetchHeadlinesByKeyword(keyword);
    this.articleSearched = newsArticles;
    // this.articles = newsArticles.map((article) => NewsArticleViewModel(article: article)).toList();

    this.loadingStatus = this.articleSearched.isEmpty ? LoadingStatus.empty : LoadingStatus.completed;
    notifyListeners();
  }

  sortNewest(){
    articles.sort((b, a) => a.time.compareTo(b.time));
    this.loadingStatus = LoadingStatus.completed;
    notifyListeners();
  }
  sortOldest(){
    articles.sort((a, b) => a.time.compareTo(b.time));
    this.loadingStatus = LoadingStatus.completed;
    notifyListeners();
  }

  Future<void> populateTopHeadlines() async {
    this.loadingStatus = LoadingStatus.searching;
    notifyListeners();
    List<NewsArticle> newsArticles = await Webservice().fetchTopHeadlines(country);
    // this.articles = newsArticles.map((article) => NewsArticleViewModel(article: article)).toList();
    this.articles = newsArticles;
    this.loadingStatus = this.articles.isEmpty ? LoadingStatus.empty : LoadingStatus.completed;
    notifyListeners();
  }

   Future<void> populateFromSources() async {
     this.loadingStatus = LoadingStatus.searching;
     notifyListeners();
     print("SOURCES UNALTERED ${sourcesToBeFetched.toString()}");
     String sourcesAsString = sourcesToBeFetched.toString().replaceAll("[", "").replaceAll(" ", "");

     List<NewsArticle> newsArticles = await Webservice().fetchFromSources(country,sourcesAsString);

     this.articles = newsArticles;
     this.loadingStatus = this.articles.isEmpty ? LoadingStatus.empty : LoadingStatus.completed;
     notifyListeners();
   }
   Future<void> fetchSources() async {
     List<Source> sources = await Webservice().fetchSources();
      this.sources = sources;

      notifyListeners();

     sources.forEach((element) {
       sourcesToBeFetched.add(element.id);
     });
   }
}