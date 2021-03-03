import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:news/models/NewsModel.dart';
import 'package:news/models/sourcesModel.dart';
import 'package:news/utils/web_service.dart';

enum LoadingStatus { finished, searching, empty }

class NewsProvider extends ChangeNotifier {
  // for initial loading status at search screen
  var loadingStatus = LoadingStatus.empty;
  //Deafult CountryCode
  static String country = "in";

  List<String> sourcesToBeFetched = []; //used for Api call
  List<NewsArticle> articleSearched = List<NewsArticle>();
  List<Source> sources = List<Source>(); //retreived sources list

  String sortBy = "Default";
  String criteria = "country";

  void updateSortCriteria(String sortCriteria) {
    //sortCriteria=Newest/Oldest
    sortBy = sortCriteria;
    notifyListeners();
    pagingController.refresh(); //Update News Feed
  }

  void updateCriteria(String Criteria) {
    //criteria=country/source
    criteria = Criteria;
    notifyListeners();
    pagingController.refresh(); //Update News Feed
  }

  void updateCountry(String countryCode) {
    country = countryCode;
    notifyListeners();
    pagingController.refresh(); //Update News Feed
  }

  ///Called from Search Screen
  Future<void> search(String keyword) async {
    this.loadingStatus = LoadingStatus.searching;
    notifyListeners();
    List<NewsArticle> newsArticles =
        await Webservice().fetchHeadlinesByKeyword(keyword); //Api Call
    this.articleSearched = newsArticles;

    this.loadingStatus = this.articleSearched.isEmpty
        ? LoadingStatus.empty
        : LoadingStatus.finished;
    notifyListeners();
  }

  ///USed for PAgination
  static const _pageSize = 10;

  final PagingController<int, NewsArticle> pagingController =
      PagingController(firstPageKey: 1);

  Future<void> fetchPage(int pageKey) async {
    try {
      String sourcesAsString =
          sourcesToBeFetched.toString().replaceAll("[", "").replaceAll(" ", "");

      //Api Call as per the Criteria
      final newItems = criteria == "country"
          ? await Webservice().fetchPage(pageKey, "country", country)
          : await Webservice().fetchPage(pageKey, "source", sourcesAsString);

      final isLastPage = newItems.length < _pageSize;
      if (isLastPage) {
        pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + 1;
        pagingController.appendPage(newItems, nextPageKey);
      }

      //Sorting after every Page as per sorting criteria
      if (sortBy == "Oldest")
        pagingController.itemList.sort((a, b) => a.time.compareTo(b.time));
      if (sortBy == "Newest")
        pagingController.itemList.sort((b, a) => a.time.compareTo(b.time));
    } catch (error) {
      pagingController.error = error;
    }
  }

  Future<void> fetchSources() async {
    List<Source> sources = await Webservice().fetchSources();
    this.sources = sources;
    sources.forEach((element) {
      sourcesToBeFetched.add(element.id);
    });
    notifyListeners();
  }
}
