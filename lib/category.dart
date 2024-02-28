import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:news_app/newsview.dart';
import 'model.dart';

class CategoryPage extends StatefulWidget {
  String? query;

  CategoryPage({required this.query, super.key});

  @override
  State<CategoryPage> createState() => _CategoryState();
}

class _CategoryState extends State<CategoryPage> {
  bool isLoading = true;

  //list for api
  List<NewsQueryModel> newsModelList = [];
  late String url;

  Future<void> getNewsByQuery(String query) async {
    if (query == "Top News") {
      url =
          "https://newsapi.org/v2/top-headlines?country=in&category=business&apiKey=fc249e49af954bd5af444f6b3fce7c95";
    } else {
      url =
          "https://newsapi.org/v2/everything?q=$query&sortBy=publishedAt&apiKey=fc249e49af954bd5af444f6b3fce7c95";
    }

    Response response = await get(Uri.parse(url));
    Map data = jsonDecode(response.body);

    data["articles"].forEach((element) {
      try{
      NewsQueryModel newsModel = NewsQueryModel();
      newsModel = NewsQueryModel.fromMap(element);
      newsModelList.add(newsModel);
      setState(() {
        isLoading = false;
      });
      }catch(e){
        print(e);
      }
    });
  }

  @override
  void initState() {
    getNewsByQuery((widget.query).toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("News App"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      (widget.query).toString(),
                      style: const TextStyle(
                          fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              isLoading
                  ? Container(
                      height: MediaQuery.of(context).size.height - 500,
                      child: const Center(child: CircularProgressIndicator()),
                    )
                  : ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: newsModelList.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        try {
                          return Container(
                            height: 250,
                            margin: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            child: InkWell(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>NewsViews(newsModelList[index].newsUrl)));
                              },
                              child: Card(
                                elevation: 10,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(
                                        newsModelList[index].newsImg,
                                        fit: BoxFit.cover,
                                        height: double.infinity,
                                        width: double.infinity,
                                      ),
                                    ),
                                    Positioned(
                                      left: 0,
                                      bottom: 0,
                                      right: 0,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5, horizontal: 10),
                                        decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(10),
                                              bottomRight: Radius.circular(10)),
                                          gradient: LinearGradient(
                                              colors: [
                                                Colors.black,
                                                Colors.black26
                                              ],
                                              begin: Alignment.bottomCenter,
                                              end: Alignment.topCenter),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              newsModelList[index].newsHead,
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w900),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              newsModelList[index]
                                                          .newsDes
                                                          .length >=
                                                      55
                                                  ? "${newsModelList[index].newsDes.substring(0, 55)}...."
                                                  : newsModelList[index].newsDes,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        } catch (e) {
                          print(e);
                          return Container();
                        }
                      }),
            ],
          ),
        ),
      ),
    );
  }
}
