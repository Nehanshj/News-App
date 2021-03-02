import 'package:flutter/material.dart';
import 'package:news/models/NewsModel.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final NewsArticle article= ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.arrow_forward_ios_rounded),
        label: Text("Read Full Story"),
        onPressed: ()async=> await launch(article.url),
      ),
      body: Column(
        children: [
          Stack(
           children: [
             Hero(
               tag:article.urlToImage,
               child: Image(
                 height: 200.0,
                 width: MediaQuery.of(context).size.width,
                 fit: BoxFit.cover,
                 image: NetworkImage(article.urlToImage),
               ),
             ),
             Text(article.title)
           ],
          ),
          Text(article.source),
          Text(article.time.toString()),
          Text(article.content),
        ],
      ),
    );
  }
}
