import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class NewsViews extends StatefulWidget {
  String url;
  NewsViews(this.url,{super.key});
  @override
  State<NewsViews> createState() => _NewsViewsState();
}

class _NewsViewsState extends State<NewsViews> {
  String? finalUrl;
  late WebViewController controller;
  @override
  void initState() {
    if(widget.url.toString().contains("http")){
      finalUrl=widget.url.toString().replaceAll("http://", "https://");
    }else{
      finalUrl=widget.url;
    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text("News App"),
        centerTitle: true,
      ),
      body: Container(
        child:  WebView(
          initialUrl: finalUrl,
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated:(WebViewController webViewController){
            controller=webViewController;
          },
        ),
      ),
    );
  }
}
