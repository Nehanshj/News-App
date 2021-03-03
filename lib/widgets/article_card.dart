import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:news/models/NewsModel.dart';
import 'package:news/utils/time.dart';

class ArticleCard extends StatelessWidget {
  final NewsArticle article;

  ArticleCard(this.article);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
      //open News Detail Page
          Navigator.of(context).pushNamed('/detail', arguments: article),
      child: Card(
        color: Color(0xFFF5F9FD),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        elevation: 5.0,
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.all(8),
                width: MediaQuery.of(context).size.width * 0.65,
                height: 120,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      article.source,
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF303F60),
                          fontStyle: FontStyle.italic),
                    ),
                    Text(article.title,
                        maxLines: 4,
                        overflow: TextOverflow.fade,
                        style: TextStyle(
                          color: Color(0xFF303F60),
                        )),
                    TimeText(DateTime.now().difference(article.time))
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(right: 8),
              width: 100,
              height: 100,
              child: Hero(
                tag: article.urlToImage ?? 111,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: FadeInImage.assetNetwork(
                    fit: BoxFit.cover,
                    placeholder: 'assets/loading.gif',
                    image: article.urlToImage ??
                        "https://st3.depositphotos.com/1030956/16846/v/1600/depositphotos_168466294-stock-illustration-news-logo-on-globe.jpg",
                    imageErrorBuilder:
                        (BuildContext context, Object y, StackTrace z) {
                      return Center(
                          child: Icon(
                        Icons.broken_image,
                        size: 60,
                        color: Colors.blueGrey,
                      ));
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
