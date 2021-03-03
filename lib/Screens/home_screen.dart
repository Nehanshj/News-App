import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:news/models/NewsModel.dart';
import 'package:news/utils/provider.dart';
import 'package:news/utils/web_service.dart';
import 'package:news/widgets/article_card.dart';
import 'package:news/widgets/location_bottomsheet.dart';
import 'package:news/widgets/sources_bottomsheet.dart';
import 'package:provider/provider.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


  @override
  initState(){
    Provider.of<NewsProvider>(context,listen: false).pagingController.addPageRequestListener((pageKey) {
      Provider.of<NewsProvider>(context,listen: false).fetchPage(pageKey);
    });
  super.initState();
  Provider.of<NewsProvider>(context,listen: false).fetchSources();
  }


  String getFullCountryName(String countryTag){
    switch(countryTag) {
      case "in":
        return "India";
      case "us":
        return "USA";
      case "fr":
        return "France";
      case "za":
        return "South Africa";
      case "nl":
        return "Netherlands";
      default:
        return "India";
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<NewsProvider>(context);

    return Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.filter_alt_outlined, color: Colors.white,),
          foregroundColor: Colors.blue,
          onPressed: () =>
              showModalBottomSheet(
                  context: context,
                  builder: (context) => SourcesFilter()),
        ),
        appBar: AppBar(
          title: Text("MyNEWS"),
          actions: [
            GestureDetector(
              onTap: () =>
                  showModalBottomSheet(
                      context: context,
                      builder: (context) => LocationSelector()),
              child: Column(
                children: [
                  Text("Location"),
                  Row(
                    children: [
                      Icon(Icons.location_on),
                      Text(getFullCountryName(NewsProvider.country)),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
        body: RefreshIndicator(
            onRefresh: () =>
                Future.sync(
                      () => data.pagingController.refresh(),
                ),
            child:
            Column(
                children: [
                  ///Search Box
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed('/search');
                    },
                    child: Container(
                      height: 37,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white),
                      child: Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left: 22.0),
                            child: Icon(
                              Icons.search,
                              color: Colors.black,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: Text(
                              "Search for a service",
                              style:
                              TextStyle(fontSize: 17, color: Colors.black),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Top Headlines"),
                      PopupMenuButton<sortType>(
                        child: Text("Sort: ${data.sortBy}"),
                        onSelected: (sortType result) {
                          //   setState(() { _sortType =enumToString(result);
                          //   print(_sortType);
                          // });
                          switch (enumToString(result)) {
                            case "Newest":
                              data.updateSortCriteria("Newest");
                              break;
                            case "Oldest":
                              data.updateSortCriteria("Oldest");
                              break;

                          }
                          // if(enumToString(result)=="Newest") data.sortNewest();
                          // if(enumToString(result)=="Oldest") data.sortOldest();
                        },
                        itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<sortType>>[
                          const PopupMenuItem<sortType>(
                            value: sortType.Newest,
                            child: Text('Newest'),
                          ),
                          const PopupMenuItem<sortType>(
                            value: sortType.Oldest,
                            child: Text('Oldest'),
                          ),
                         ],
                      )
                    ],
                  ),
                  Expanded(
                    child: PagedListView<int, NewsArticle>.separated(
                      pagingController: data.pagingController,
                      builderDelegate: PagedChildBuilderDelegate<NewsArticle>(
                          itemBuilder: (context, item, index) {
                            print("ITEM: ${item.title} $index");
                            return ArticleCard(item);
                          }
                      ),
                      separatorBuilder: (context, index) => const Divider(),
                    ),
                  ),
                ])
        )
    );
  }
  @override
  void dispose() {
    Provider.of(context).pagingController.dispose();
    super.dispose();
  }
  // String _sortType = "Newest";
  //
  // Widget _buildList(BuildContext context,NewsProvider newsData) {
  //   switch(newsData.loadingStatus) {
  //     case LoadingStatus.searching:
  //       return Align(child: CircularProgressIndicator());
  //     case LoadingStatus.empty:
  //       return Align(child: Text("No results found!"));
  //     case LoadingStatus.completed:
  //       return Expanded(child: ListView.builder(
  //           itemCount: context.read<NewsProvider>().articles.length,
  //           itemBuilder: (context,index){
  //             NewsArticle instance = newsData.articles[index];
  //               print("NUNNNNNNNNNNNNNNNNNNNNNNNNNN\n${instance.title}\n${instance.source}\n${instance.description}");
  //             return Container(
  //               color: Colors.orange,
  //               child: ArticleCard(instance)
  //             );
  //           }));
  //   }
  //
  // }
  // @override
  // Widget build(BuildContext context) {
  //
  //   final data = Provider.of<NewsProvider>(context);
  //   return Scaffold(
  //     floatingActionButton: FloatingActionButton(
  //       child: Icon(Icons.filter_alt_outlined, color: Colors.white,),
  //       foregroundColor: Colors.blue,
  //       onPressed: ()=>showModalBottomSheet(
  //           context: context,
  //           builder: (context) => SourcesFilter()),
  //     ),
  //     appBar: AppBar(
  //       title: Text("MyNEWS"),
  //       actions: [
  //         GestureDetector(
  //           onTap: ()=>
  //             showModalBottomSheet(
  //                 context: context,
  //                 builder: (context) => LocationSelector()),
  //           child: Column(
  //             children: [
  //               Text("Location"),
  //               Row(
  //                 children: [
  //                   Icon(Icons.location_on),
  //                   Text(NewsProvider.country),
  //                 ],
  //               )
  //             ],
  //           ),
  //         )
  //       ],
  //     ),
  //     body: Column(
  //       children:[
  //         ///Search Box
  //       GestureDetector(
  //         onTap: () {
  //         Navigator.of(context).pushNamed('/search');
  //         },
  //         child: Container(
  //           height: 37,
  //           decoration: BoxDecoration(
  //               borderRadius: BorderRadius.circular(10),
  //               color: Colors.white),
  //           child: Row(
  //             children: <Widget>[
  //               Padding(
  //                 padding: const EdgeInsets.only(left: 22.0),
  //                 child: Icon(
  //                   Icons.search,
  //                   color: Colors.black,
  //                 ),
  //               ),
  //               Padding(
  //                 padding: const EdgeInsets.only(left: 20.0),
  //                 child: Text(
  //                   "Search for a service",
  //                   style:
  //                   TextStyle(fontSize: 17, color: Colors.black),
  //                 ),
  //               )
  //             ],
  //           ),
  //         ),
  //       ),
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         children: [
  //           Text("Top Headlines"),
  //           PopupMenuButton<sortType>(
  //             child: Text("Sort: $_sortType"),
  //             onSelected: (sortType result) {
  //             //   setState(() { _sortType =enumToString(result);
  //             //   print(_sortType);
  //             // });
  //               switch(enumToString(result)){
  //                 case "Newest":
  //                   data.sortNewest();
  //                   break;
  //                 case "Oldest":
  //                   data.sortOldest();
  //                   break;
  //                 case "Popularity":
  //                   data.populateTopHeadlines();
  //                   break;
  //               }
  //               // if(enumToString(result)=="Newest") data.sortNewest();
  //               // if(enumToString(result)=="Oldest") data.sortOldest();
  //               },
  //             itemBuilder: (BuildContext context) => <PopupMenuEntry<sortType>>[
  //               const PopupMenuItem<sortType>(
  //                 value: sortType.Newest,
  //                 child: Text('Newest'),
  //               ),
  //               const PopupMenuItem<sortType>(
  //                 value: sortType.Oldest,
  //                 child: Text('Oldest'),
  //               ),
  //               const PopupMenuItem<sortType>(
  //                 value: sortType.Popular,
  //                 child: Text('Popular'),
  //               ),
  //             ],
  //           )
  //         ],
  //       ),
  //        _buildList(context,data),
  //    ]
  //     ),
  //   );
  // }
}

