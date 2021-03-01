import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:news/models/NewsModel.dart';
import 'file:///E:/Projects/Flutter/news/lib/utils/search_helper.dart';
import 'package:news/utils/provider.dart';
import 'package:provider/provider.dart';


class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  initState(){
  super.initState();

  Provider.of<NewsProvider>(context,listen: false).populateTopHeadlines();
  }
  String _sortType = "Newest";

  Widget _buildList(BuildContext context,NewsProvider newsData) {
    switch(newsData.loadingStatus) {
      case LoadingStatus.searching:
        return Align(child: CircularProgressIndicator());
      case LoadingStatus.empty:
        return Align(child: Text("No results found!"));
      case LoadingStatus.completed:
        return Expanded(child: ListView.builder(
            itemCount: context.read<NewsProvider>().articles.length,
            itemBuilder: (context,index){
              NewsArticle instance = newsData.articles[index];
              return Container(
                color: Colors.orange,
                child: Text("Title ${instance.title}"),
              );
            }));
    }

  }
  @override
  Widget build(BuildContext context) {

    final data = Provider.of<NewsProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("MyNEWS"),
        actions: [
          GestureDetector(
            onTap: (){
              showModalBottomSheet(
                  context: context,
                  builder: (context) => LocationSelector());
            },
            child: Column(
              children: [
                Text("Location"),
                Row(
                  children: [
                    Icon(Icons.location_on),
                    Text("India"),
                  ],
                )
              ],
            ),
          )
        ],
      ),
      body: Column(
        children:[
          ///Search Box
        GestureDetector(
          onTap: () {
          // showSearch(context: context, delegate: CustomSearchDelegate());
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
              child: Text("Sort: $_sortType"),
              onSelected: (sortType result) { setState(() { _sortType =enumToString(result);
              print(_sortType);
              }); },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<sortType>>[
                const PopupMenuItem<sortType>(
                  value: sortType.Newest,
                  child: Text('Newest'),
                ),
                const PopupMenuItem<sortType>(
                  value: sortType.Oldest,
                  child: Text('Oldest'),
                ),
                const PopupMenuItem<sortType>(
                  value: sortType.Popular,
                  child: Text('Popular'),
                ),
              ],
            )
          ],
        ),
         _buildList(context,data),

     ]
      ),
    );
  }
}

class LocationSelector extends StatefulWidget {
  @override
  _LocationSelectorState createState() => _LocationSelectorState();
}

class _LocationSelectorState extends State<LocationSelector> {
  String _radioValue;

  void _handleRadioValueChange(String value) {
    setState(() {
      _radioValue = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text("Choose your location"),
          Divider(),
          Expanded(
            // child: Container(
            //   height: MediaQuery.of(context).size.height * 0.5,
              child: ListView(
                children: [
                  ListTile(
                    title: Text("Nepal"),
                    trailing:  Radio(
                      value: "Nepal",
                      groupValue: _radioValue,
                      onChanged: _handleRadioValueChange,
                    ),
                  ),
                  ListTile(
                    title: Text("USA"),
                    trailing:  Radio(
                      value: "USA",
                      groupValue: _radioValue,
                      onChanged: _handleRadioValueChange,
                    ),
                  ),
                  ListTile(
                    title: Text("Sri Lanka"),
                    trailing:  Radio(
                      value: "Sri Lanka",
                      groupValue: _radioValue,
                      onChanged: _handleRadioValueChange,
                    ),
                  ),
                  ListTile(
                    title: Text("England"),
                    trailing:  Radio(
                      value: "England",
                      groupValue: _radioValue,
                      onChanged: _handleRadioValueChange,
                    ),
                  ),
                  ListTile(
                    title: Text("Sweden"),
                    trailing:  Radio(
                      value: "Sweden",
                      groupValue: _radioValue,
                      onChanged: _handleRadioValueChange,
                    ),
                  ),
                  ListTile(
                    title: Text("Pacific Islands"),
                    trailing:  Radio(
                      value: "Pacific Islands",
                      groupValue: _radioValue,
                      onChanged: _handleRadioValueChange,
                    ),
                  )
                ],
              ),
            ),
          MaterialButton(onPressed: null,
          child: Text("APPLY"),)
        ],
      ),

    );
  }
}
