import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
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
  var loadingStatus = LoadingStatus.empty;
  //
  // List<NewsArticle> articles = List<NewsArticle>();
  List<NewsArticle> articleSearched = List<NewsArticle>();
   List<Source> sources = List<Source>();

  String sortBy="Default";
  String criteria="country";

  void updateSortCriteria(String sortCriteria){
    sortBy=sortCriteria;
    notifyListeners();
    pagingController.refresh();
  }

   void updateCriteria(String Criteria){
     criteria=Criteria;
     notifyListeners();
     pagingController.refresh();
  }
   void updateCountry(String countryTag){
     country=countryTag;
     notifyListeners();
     pagingController.refresh();
   }


  Future<void> search(String keyword) async {
    this.loadingStatus = LoadingStatus.searching;
    notifyListeners();
    List<NewsArticle> newsArticles = await Webservice().fetchHeadlinesByKeyword(keyword);
    this.articleSearched = newsArticles;
    // this.articles = newsArticles.map((article) => NewsArticleViewModel(article: article)).toList();

    this.loadingStatus = this.articleSearched.isEmpty ? LoadingStatus.empty : LoadingStatus.completed;
    notifyListeners();
  }

  // sortNewest(){
  //   articles.sort((b, a) => a.time.compareTo(b.time));
  //   this.loadingStatus = LoadingStatus.completed;
  //   notifyListeners();
  // }
  // sortOldest(){
  //   articles.sort((a, b) => a.time.compareTo(b.time));
  //   this.loadingStatus = LoadingStatus.completed;
  //   notifyListeners();
  // }

   static const _pageSize = 10;

   final PagingController<int, NewsArticle> pagingController =
   PagingController(firstPageKey: 1);

   Future<void> fetchPage(int pageKey) async {
     try {
       String sourcesAsString = sourcesToBeFetched.toString().replaceAll("[", "").replaceAll(" ", "");

       final newItems = criteria=="country"?
       await Webservice().fetchPage(pageKey,"country",country)
           : await Webservice().fetchPage(pageKey,"source",sourcesAsString);

       final isLastPage = newItems.length < _pageSize;
       if (isLastPage) {
         pagingController.appendLastPage(newItems);
       } else {
         final nextPageKey = pageKey+1;
         pagingController.appendPage(newItems, nextPageKey);
       }

       //Sorting after every Page as per sorting criteria
       if(sortBy=="Oldest")
         pagingController.itemList.sort((a,b)=> a.time.compareTo(b.time));
       if(sortBy=="Newest")
         pagingController.itemList.sort((b,a)=> a.time.compareTo(b.time));
     } catch(error) {
       print("EX: $error");
       pagingController.error = error;
     }
   }
  // Future<void> populateTopHeadlines() async {
  //   this.loadingStatus = LoadingStatus.searching;
  //   notifyListeners();
  //   List<NewsArticle> newsArticles = await Webservice().fetchTopHeadlines(country);
  //   // this.articles = newsArticles.map((article) => NewsArticleViewModel(article: article)).toList();
  //   this.articles = newsArticles;
  //   this.loadingStatus = this.articles.isEmpty ? LoadingStatus.empty : LoadingStatus.completed;
  //   notifyListeners();
  // }

   // Future<void> populateFromSources() async {
   //   this.loadingStatus = LoadingStatus.searching;
   //   notifyListeners();
   //   print("SOURCES UNALTERED ${sourcesToBeFetched.toString()}");
   //   String sourcesAsString = sourcesToBeFetched.toString().replaceAll("[", "").replaceAll(" ", "");
   //
   //   List<NewsArticle> newsArticles = await Webservice().fetchFromSources(country,sourcesAsString);
   //
   //   this.articles = newsArticles;
   //   this.loadingStatus = this.articles.isEmpty ? LoadingStatus.empty : LoadingStatus.completed;
   //   notifyListeners();
   // }

   Future<void> fetchSources() async {
     List<Source> sources = await Webservice().fetchSources();
      this.sources = sources;

      notifyListeners();

     sources.forEach((element) {
       sourcesToBeFetched.add(element.id);
     });
   }
}