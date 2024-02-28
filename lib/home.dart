import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart';
import 'package:news_app/category.dart';
import 'package:news_app/newsview.dart';
import 'model.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isLoading = true;

  //Text Controller
  TextEditingController textEditingController = TextEditingController();

  //horizontal toggle button
  List<String> navBarItem = [
    "Top News",
    "Sports",
    "Business",
    "Finance",
    "Health",
    "Politics"
  ];

  //list for api
  List<NewsQueryModel> newsModelList = [];
  List<NewsQueryModel> newsModelListCarousel = [];
  late Map element;
  int i=0;
  int j=0;
  //function for api
  Future<void> getNewsByQuery(String query) async {
    String url = "https://newsapi.org/v2/everything?q=$query&sortBy=publishedAt&apiKey=fc249e49af954bd5af444f6b3fce7c95";
    Response response = await get(Uri.parse(url));
    Map data = jsonDecode(response.body);

    for (element in data["articles"]) {
      try {
        i++;
        NewsQueryModel newsModel = NewsQueryModel();
        newsModel = NewsQueryModel.fromMap(element);
        newsModelList.add(newsModel);
        setState(() {
          isLoading = false;
        });
        if (i ==7) {
          break;
        }
      }catch(e){
        print(e);
      }

    }
  }

  //function for carousel
  Future<void> getNewsForCarousel() async {
    Response response = await get(Uri.parse(
        "https://newsapi.org/v2/top-headlines?country=in&apiKey=fc249e49af954bd5af444f6b3fce7c95"));
    Map data = jsonDecode(response.body);
    for(element in data["articles"]) {
      try {
        j++;
        NewsQueryModel newsModel = NewsQueryModel();
        newsModel = NewsQueryModel.fromMap(element);
        newsModelListCarousel.add(newsModel);
        setState(() {
          isLoading = false;
        });
      }catch(e){
        print(e);
      }
    }
  }

  @override
  void initState() {
    getNewsByQuery("Tech");
    getNewsForCarousel();
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
        child: Column(
          children: [
            Container(
              //search bar
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      if((textEditingController.text).replaceAll(" ", "")==""){
                        print("blank space");
                      }else{
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>CategoryPage(query: textEditingController.text)));
                      }
                    },
                    child: Container(
                      margin: const EdgeInsets.only(left: 10, right: 10),
                      //icon padding ke liye
                      child: const Icon(Icons.search),
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: textEditingController,
                      textInputAction: TextInputAction.search,
                      onSubmitted: (value) {
                          if ((textEditingController.text).replaceAll(
                              " ", "") == "") {
                            print("blank space");
                          } else {
                            Navigator.push(context, MaterialPageRoute(
                                builder: (context) =>
                                    CategoryPage(
                                        query: textEditingController.text)));
                          }
                      },
                      decoration: const InputDecoration(
                        hintText: "search something",
                        border: InputBorder.none,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              height: 60,
              child: ListView.builder(
                  itemCount: navBarItem.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    CategoryPage(query: navBarItem[index])));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.purple.shade200,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 5),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: Center(
                          child: Text(
                            navBarItem[index],
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    );
                  }),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: isLoading
                  ? Container(
                      height: 200,
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : CarouselSlider(
                      items: newsModelListCarousel.map((instance) {
                        return Builder(builder: (BuildContext context) {
                          try{
                          return Container(
                            child: InkWell(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>NewsViews(instance.newsUrl)));
                              },
                              child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Image.network(
                                        instance.newsImg,
                                        fit: BoxFit.cover,
                                        height: double.infinity,
                                        width: double.infinity,
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      right: 0,
                                      left: 0,
                                      child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5, horizontal: 10),
                                          decoration: const BoxDecoration(
                                              gradient: LinearGradient(
                                                  colors: [
                                                    Colors.black,
                                                    Colors.black26
                                                  ],
                                                  begin: Alignment.bottomCenter,
                                                  end: Alignment.topCenter),
                                              borderRadius: BorderRadius.only(
                                                  bottomLeft: Radius.circular(20),
                                                  bottomRight:
                                                      Radius.circular(20))),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                instance.newsHead,
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w900,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          )),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                          }catch(e){
                            print(e);
                            return Container();
                          }
                        });
                      }).toList(),
                      options: CarouselOptions(
                          height: 200, autoPlay: true, enlargeCenterPage: true),
                    ),
            ),
            Container(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Latest News",
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  isLoading?Container(
                          height: MediaQuery.of(context).size.height - 400,
                          child:
                              const Center(child: CircularProgressIndicator()),
                        ):ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: newsModelList.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            try{
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
                                                    : newsModelList[index]
                                                        .newsDes,
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
                            }catch(e){
                              print(e);
                              return Container();
                            }
                          }),
                  Container(
                    margin: EdgeInsets.only(bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateColor.resolveWith(
                                (states) => Colors.blue),
                            foregroundColor: MaterialStateColor.resolveWith(
                                (states) => Colors.black),
                          ),
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>CategoryPage(query: "Technology")));
                          },
                          child: const Text("Read More.."),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
