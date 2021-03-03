import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:news/models/NewsModel.dart';
import 'package:news/utils/provider.dart';
import 'package:news/widgets/article_card.dart';
import 'package:news/widgets/location_bottomsheet.dart';
import 'package:news/widgets/sources_bottomsheet.dart';
import 'package:provider/provider.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:connectivity/connectivity.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


  @override
  initState() {
    checkConnectivity();
    Provider.of<NewsProvider>(context, listen: false)
        .pagingController
        .addPageRequestListener((pageKey) {
      Provider.of<NewsProvider>(context, listen: false).fetchPage(pageKey);
    });
    super.initState();
    Provider.of<NewsProvider>(context, listen: false).fetchSources();
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

  String internet = "";

  void checkConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      internet = "online";
    }
    else
      internet = "offline";
  }

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<NewsProvider>(context);

    return Scaffold(
        floatingActionButton: internet == "online" ? FloatingActionButton(
          child: Icon(
            Icons.filter_alt_outlined, color: Colors.white, size: 28,),
          backgroundColor: Color(0xFF0C54BE),
          onPressed: () =>
              showModalBottomSheet(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  context: context,
                  builder: (context) => SourcesFilter()),
        ) : null,
        appBar: AppBar(
          title: Text("MyNEWS", style: TextStyle(
              fontWeight: FontWeight.w400
          ),),
          actions: [
            GestureDetector(
              onTap: () =>
                  showModalBottomSheet(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      context: context,
                      builder: (context) => LocationSelector()),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("LOCATION", style: TextStyle(
                        fontFamily: "Helvetica",
                        fontWeight: FontWeight.w400,
                        fontSize: 12
                    ),),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.location_on),
                        Text(getFullCountryName(NewsProvider.country),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
        body:
        internet == "online" ?
        RefreshIndicator(
            onRefresh: () =>
                Future.sync(
                      () => data.pagingController.refresh(),
                ),
            child:
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                  children: [

                    ///Search Box
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed('/search');
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 20),
                        height: 37,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.blueGrey[200]),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: Text(
                                "Search for news,topics...",
                                style:
                                TextStyle(fontSize: 15, color: Colors.blueGrey),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 22.0),
                              child: Icon(
                                Icons.search,
                                color: Colors.blueGrey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    ///Top Headlines Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Top Headlines", style: TextStyle(
                            color: Color(0xFF303F60),
                            fontWeight: FontWeight.w500,
                            fontSize: 18),),
                        PopupMenuButton<String>(
                          child: Text("Sort: ${data.sortBy}▼",
                            style: TextStyle(
                                color: Color(0xFF303F60)
                            ),),
                          onSelected: (String result) {
                            switch (result) {
                              case "Newest":
                                data.updateSortCriteria("Newest");
                                break;
                              case "Oldest":
                                data.updateSortCriteria("Oldest");
                                break;
                            }
                          },
                          itemBuilder: (BuildContext context) =>
                          <PopupMenuEntry<String>>[
                            const PopupMenuItem<String>(
                              value: "Newest",
                              child: Text('Newest'),
                            ),
                            const PopupMenuItem<String>(
                              value: "Oldest",
                              child: Text('Oldest'),
                            ),
                          ],
                        )
                      ],
                    ),
                    SizedBox(height: 10,),
                    Expanded(
                      child: PagedListView<int, NewsArticle>(
                        pagingController: data.pagingController,
                        builderDelegate: PagedChildBuilderDelegate<NewsArticle>(
                            itemBuilder: (context, item, index) {
                              return ArticleCard(item);
                            }
                        ),
                      ),
                    ),
                  ]),
            )
        )
            : Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.portable_wifi_off, size: MediaQuery
                  .of(context)
                  .size
                  .width * 0.6, color: Color(0xFF303F60),),
              Text("No Internet Connection",),
              FlatButton(
                  color: Color(0xFF0C54BE),
                  onPressed: () {
                    checkConnectivity(); //Check for connectivity
                    setState(() {});
                  }, child: Text("Try Again"))
            ],
          ),
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

