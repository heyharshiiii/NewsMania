import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:newsmania/models/categories-news-model.dart';
import 'package:newsmania/view-model/news-view-model.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  NewsViewModel newsViewModel = NewsViewModel();
  final format = DateFormat('MMMM dd, yyyy');
  String categoryName = "General";
  List<String> categoriesList = [
    'General',
    'Entertainment',
    'Health',
    'Sports',
    'Business',
    'Technology',
  ];
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width * 1;
    final height = MediaQuery.sizeOf(context).height * 1;
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(children: [
          SizedBox(
            height: 50,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categoriesList.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      categoryName = categoriesList[index];
                      setState(() {});
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: categoryName == categoriesList[index]
                              ? Color.fromARGB(255, 81, 59, 219)
                              : Colors.grey,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Center(
                              child: Text(
                            categoriesList[index].toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          )),
                        ),
                      ),
                    ),
                  );
                }),
          ),
          Expanded(
            child: FutureBuilder<CategoriesNewsModel>(
                future: newsViewModel.fetchNewsCategoriesApi(categoryName),
                builder: (BuildContext context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: SpinKitCircle(
                        size: 50,
                        color: Colors.black,
                      ),
                    );
                  } else {
                    return ListView.builder(
                        itemCount: snapshot.data!.totalResults!,
                        itemBuilder: (context, index) {
                          DateTime dateTime = DateTime.parse(snapshot
                              .data!.articles![index].publishedAt
                              .toString());
                          return Padding(
                            padding: EdgeInsets.only(top: 10.0, bottom: 20),
                            child: Column(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: CachedNetworkImage(
                                    height: height * 0.3,
                                    fit: BoxFit.cover,
                                    imageUrl: snapshot
                                        .data!.articles![index].urlToImage
                                        .toString(),
                                    placeholder: (context, url) => Container(
                                      child: spinKit2,
                                    ),
                                    errorWidget: (context, url, error) => Icon(
                                      Icons.error_outline_outlined,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                                Container(
                                  height: height * 0.08,
                                  //padding: EdgeInsets.only(left: 15),
                                  child: Column(
                                    children: [
                                      Text(
                                        snapshot.data!.articles![index].title
                                            .toString(),
                                        maxLines: 2,
                                        style: GoogleFonts.poppins(
                                            fontSize: 15,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Container(
                                        width: double.infinity,
                                        child: Text(
                                          format.format(dateTime),
                                          maxLines: 2,
                                          textAlign: TextAlign.right,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.poppins(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      
                                    ],
                                  ),
                                )
                              ],
                            ),
                          );
                        });
                  }
                }),
          ),
        ]),
      ),
    );
  }
}

const spinKit2 = SpinKitFadingCircle(
  color: Colors.amber,
  size: 50,
);
