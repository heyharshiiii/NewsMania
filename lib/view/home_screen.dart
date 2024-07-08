import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:newsmania/models/categories-news-model.dart';
import 'package:newsmania/models/news-channel-headlines-model.dart';
import 'package:newsmania/view-model/news-view-model.dart';
import 'package:newsmania/view/categories_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  NewsViewModel newsViewModel = NewsViewModel();
  final format = DateFormat("MMMM dd, yyyy");

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CategoriesScreen()),
            );
          },
          icon: Icon(
            Icons.category,
            size: 30,
            color: Colors.black,
          ),
        ),
        title: Text(
          'NEWSMANIA',
          style: GoogleFonts.dmSerifDisplay(
            letterSpacing: 4.0,
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.black,
          ),
        ),
      ),
      body: ListView(
        children: [
          FutureBuilder<NewsChannelsHeadlinesModel>(
            future: newsViewModel.fetchNewsChannelHeadlinesApi(),
            builder: (BuildContext context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: SpinKitCircle(
                    size: 50,
                    color: Colors.black,
                  ),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text("Error: ${snapshot.error}"),
                );
              } else if (!snapshot.hasData ||
                  snapshot.data!.articles!.isEmpty) {
                return Center(
                  child: Text("No data available"),
                );
              } else {
                return Container(
                  height: height * 0.6,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data!.articles!.length,
                    itemBuilder: (context, index) {
                      DateTime dateTime = DateTime.parse(
                        snapshot.data!.articles![index].publishedAt.toString(),
                      );
                      return SizedBox(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              height: height * 0.59,
                              width: width * 0.9,
                              padding: EdgeInsets.symmetric(
                                horizontal: height * 0.02,
                                vertical: 10,
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: CachedNetworkImage(
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
                            ),
                            Positioned(
                              bottom: 20,
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Container(
                                  padding: EdgeInsets.all(15),
                                  height: height * 0.22,
                                  alignment: Alignment.bottomCenter,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: width * 0.7,
                                        child: Text(
                                          snapshot.data!.articles![index].title
                                              .toString(),
                                          maxLines: 4,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.poppins(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                      Spacer(),
                                      Container(
                                        width: width * 0.7,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              snapshot.data!.articles![index]
                                                  .source!.name
                                                  .toString(),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.poppins(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            Text(
                                              format.format(dateTime),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.poppins(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              }
            },
          ),
          FutureBuilder<CategoriesNewsModel>(
            future: newsViewModel.fetchNewsCategoriesApi('General'),
            builder: (BuildContext context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: SpinKitCircle(
                    size: 50,
                    color: Colors.black,
                  ),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text("Error: ${snapshot.error}"),
                );
              } else if (!snapshot.hasData ||
                  snapshot.data!.articles!.isEmpty) {
                return Center(
                  child: Text("No data available"),
                );
              } else {
                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: snapshot.data!.articles!.length,
                  itemBuilder: (context, index) {
                    DateTime dateTime = DateTime.parse(
                      snapshot.data!.articles![index].publishedAt.toString(),
                    );
                    return Padding(
                      padding: EdgeInsets.all(20),
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
                            child: Column(
                              children: [
                                Text(
                                  snapshot.data!.articles![index].title
                                      .toString(),
                                  maxLines: 2,
                                  style: GoogleFonts.poppins(
                                    fontSize: 15,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
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
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

const spinKit2 = SpinKitFadingCircle(
  color: Colors.amber,
  size: 50,
);
