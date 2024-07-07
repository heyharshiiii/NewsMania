import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:newsmania/models/news-channel-headlines-model.dart';
class NewsRepository{

  Future<NewsChannelsHeadlinesModel> fetchNewsChannelHeadlinesApi() async {
    String url="https://newsapi.org/v2/top-headlines?country=in&apiKey=740cd02dd8774e0ab95ca89773c80d48";

    final response=await http.get(Uri.parse(url));
    if(kDebugMode)
    {
      print(response.body);
    }
    if(response.statusCode==200)
    {
      final body=jsonDecode(response.body);
      return NewsChannelsHeadlinesModel.fromJson(body);
    }
    throw Exception('ERROR');
  }

}