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
        return Align(child: Text("No results found!"));
      case LoadingStatus.completed:
        return Expanded(child: ListView.builder(
            itemCount: context
                .read<NewsProvider>()
                .articleSearched
                .length,
            itemBuilder: (context, index) {
              NewsArticle instance = newsData.articleSearched[index];
              return Container(
                  color: Colors.orange,
                  child: ArticleCard(instance)
              );
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
      ),
      body: Column(
        children: [
          TextField(
            controller: _controller,
            onSubmitted: (value) {
              // fetch all the news related to the keyword
              if(value.isNotEmpty) {
                news.search(value);
              }

            },
            decoration: InputDecoration(
                labelText: "Enter search term",
                icon: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.search),
                ),
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    _controller.clear();
                  },
                )
            ),
          ),
        _buildList(context, news)
        ],
      ),
    );
  }
}
