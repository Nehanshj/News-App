import 'package:flutter/material.dart';
import 'package:news/models/NewsModel.dart';

class ArticleCard extends StatelessWidget {
  final NewsArticle article;
  ArticleCard(this.article);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=>Navigator.of(context).pushNamed('/detail',arguments: article),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 10.0,
        color: Colors.limeAccent,
        child: Row(
          children: [
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width*0.65,
                height: 100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(article.source??""),
                    Text(article.title.split("-").first??""),
                    // Text(article.description??"",maxLines: 4,overflow: TextOverflow.fade,),
                    Text(DateTime.now().difference(article.time).inMinutes.toString() + " Minutes ago" ?? "")
                  ],
                ),
              ),
            ),
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.red[500],
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(20))
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: FadeInImage.assetNetwork(
                  fit: BoxFit.cover,
                  placeholder: 'assets/loading.gif',
                  image:article.urlToImage ?? "https://ih1.redbubble.net/image.485923660.1240/fposter,small,wall_texture,product,750x1000.u1.jpg",
                  imageErrorBuilder: (BuildContext context, Object y, StackTrace z) {
                    return Center(
                        child: Icon(
                          Icons.broken_image,
                          size: 120,
                          color: Colors.lime,
                        ));
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
