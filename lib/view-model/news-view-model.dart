import 'package:newsmania/models/categories-news-model.dart';
import 'package:newsmania/models/news-channel-headlines-model.dart';
import 'package:newsmania/repository/news-repository.dart';

class NewsViewModel
{
  final _rep=NewsRepository();
  
  Future<NewsChannelsHeadlinesModel> fetchNewsChannelHeadlinesApi() async{
    final response=await _rep.fetchNewsChannelHeadlinesApi();
    return response;
  }
    
   Future<CategoriesNewsModel> fetchNewsCategoriesApi(String category) async{
    final response=await _rep.fetchNewsCategoriesApi(category);
    return response;
  }  
} 