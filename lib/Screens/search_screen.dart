import 'package:flutter/material.dart';
import 'package:news/models/NewsModel.dart';
import 'package:news/utils/provider.dart';
import 'package:news/widgets/article_card.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatelessWidget {
  final _controller = TextEditingController();

  Widget _buildList(BuildContext context,NewsProvider newsData) {
    switch (newsData.loadingStatus) {
      case LoadingStatus.searching:
        return Align(child: CircularProgressIndicator());
      case LoadingStatus.empty:
        return Center(
            child: Column(
          children: [
            SizedBox(height: 50),
            Icon(
              Icons.library_books_outlined,
              size: MediaQuery.of(context).size.width * 0.6,
              color: Color(0xFF303F60),
            ),
            Text("No results found!"),
          ],
        ));
      case LoadingStatus.completed:
        return Expanded(
            child: ListView.builder(
                itemCount: context.read<NewsProvider>().articleSearched.length,
                itemBuilder: (context, index) {
                  NewsArticle instance = newsData.articleSearched[index];
                  return ArticleCard(instance);
                }));
    }
  }

  @override
  Widget build(BuildContext context) {
    final news = Provider.of<NewsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Search"),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_outlined),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
                controller: _controller,
                onSubmitted: (value) {
                  // fetch all the news related to the keyword
                  if (value.isNotEmpty) {
                    news.search(value);
                  }
                },
                decoration: InputDecoration(
                  fillColor: Colors.blueGrey[200],
                  focusColor: Colors.blueGrey[200],
                  disabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey,
                    ),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  border: OutlineInputBorder(),
                  hintText: "Enter search term",
                  suffixIcon: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.search),
                  ),
                )
            ),
          ),
          _buildList(context, news)
        ],
      ),
    );
  }
}
