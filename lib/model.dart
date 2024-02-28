class NewsQueryModel{
  String newsHead;
  String newsDes;
  String newsImg;
  String newsUrl;

  NewsQueryModel({this.newsHead="sdsds",this.newsDes="sdsds",this.newsImg="sdsds",this.newsUrl="dssdsd"});

  factory NewsQueryModel.fromMap(Map news){
    return NewsQueryModel(
      newsHead: news["title"]??"",
      newsDes: news["description"]??"",
      newsImg: news["urlToImage"]??"",
      newsUrl: news["url"]??""
    );
  }


}