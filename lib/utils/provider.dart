import 'package:flutter/material.dart';
import 'package:news/models/NewsModel.dart';
import 'package:news/utils/web_service.dart';
enum LoadingStatus {
  completed,
  searching,
  empty
}

class NewsProvider extends ChangeNotifier{

  var loadingStatus = LoadingStatus.searching;

  List<NewsArticle> articles = List<NewsArticle>();
  List<NewsArticle> articleSearched = List<NewsArticle>();

  Future<void> search(String keyword) async {
    this.loadingStatus = LoadingStatus.searching;
    notifyListeners();
    List<NewsArticle> newsArticles = await Webservice().fetchHeadlinesByKeyword(keyword);
    this.articleSearched = newsArticles;
    // this.articles = newsArticles.map((article) => NewsArticleViewModel(article: article)).toList();

    this.loadingStatus = this.articleSearched.isEmpty ? LoadingStatus.empty : LoadingStatus.completed;
    notifyListeners();
  }

  Future<void> populateTopHeadlines() async {
    this.loadingStatus = LoadingStatus.searching;
    notifyListeners();
    List<NewsArticle> newsArticles = await Webservice().fetchTopHeadlines();
    // this.articles = newsArticles.map((article) => NewsArticleViewModel(article: article)).toList();
    this.articles = newsArticles;
    this.loadingStatus = this.articles.isEmpty ? LoadingStatus.empty : LoadingStatus.completed;
    notifyListeners();
  }
}