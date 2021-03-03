import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:news/models/NewsModel.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final NewsArticle article = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      backgroundColor: Color(0xFFF5F9FD),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_outlined),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          ///Image with Title
          Stack(
            children: [
              Hero(
                tag: article.urlToImage ?? 111,
                child: Image(
                  height: 200.0,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.fill,
                  image: NetworkImage(article.urlToImage ??
                      "https://st3.depositphotos.com/1030956/16846/v/1600/depositphotos_168466294-stock-illustration-news-logo-on-globe.jpg"),
                ),
              ),
              Container(
                height: 200.0,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.transparent, Colors.black87],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
              Positioned(
                  bottom: 10,
                  left: 10,
                  child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: Text(
                        article.title,
                        softWrap: true,
                        style: TextStyle(
                            color: Color(0xFFF5F9FD),
                            fontWeight: FontWeight.w500),
                      )))
            ],
          ),

          ///News Body
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(article.source,
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF303F60),
                        fontStyle: FontStyle.italic)),
                Text(DateFormat("dd MMM, yyy 'at' HH:mm aaa")
                    .format(article.time)),
                Divider(),
                Text(article.description,
                    style: TextStyle(
                        fontWeight: FontWeight.w500, color: Color(0xFF303F60))),
                SizedBox(
                  height: 10,
                ),
                Text(
                    article.content
                        .split(" [+")
                        .first, //to remove [+1738 char] which comes due to developer plan restriction
                    style: TextStyle(
                        fontWeight: FontWeight.w500, color: Color(0xFF303F60))),
                SizedBox(height: 25),
                GestureDetector(
                    onTap: () async =>
                        await launch(article.url), // launch in Web Browser
                    child: Text("See Full Story ᐳ",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF0C54BE))))
              ],
            ),
          )
        ],
      ),
    );
  }
}
