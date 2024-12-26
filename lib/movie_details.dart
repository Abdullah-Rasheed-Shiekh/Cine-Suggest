import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:movie_app/home_page.dart';
import 'package:movie_app/apiKey/allapi.dart';
import 'package:movie_app/function/slider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_app/function/trailerwatch.dart';
import 'package:movie_app/function/userreview.dart';

class MovieDetails extends StatefulWidget {
  var movieId;

  MovieDetails(this.movieId);

  @override
  State<StatefulWidget> createState() => _movieDetail();
}

class _movieDetail extends State<MovieDetails> {
  List<Map<String, dynamic>> moviedetails = [];
  List<Map<String, dynamic>> userreview = [];
  List<Map<String, dynamic>> similarmovies = [];
  List<Map<String, dynamic>> recommendedmovies = [];
  List<Map<String, dynamic>> trailers = [];
  List Moviegenre = [];
  List ProductionCompaning = [];

  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    checkFavoriteStatus();
  }

  // Check if the movie is already in favorites
  Future<void> checkFavoriteStatus() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      DocumentSnapshot favoriteDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .collection('favorites')
          .doc(widget.movieId.toString())
          .get();

      setState(() {
        isFavorite = favoriteDoc.exists;
      });
    }
  }

  // Toggle favorite status in Firestore
  Future<void> toggleFavorite() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      try {
        final favoriteRef = FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .collection('favorites')
            .doc(widget.movieId.toString());

        if (isFavorite) {
          // Remove from favorites
          await favoriteRef.delete();
          setState(() {
            isFavorite = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Removed from favorites')),
          );
        } else {
          // Add to favorites
          await favoriteRef.set({
            'movieId': widget.movieId,
            'title': moviedetails[0]['title'],
            'backdropPath': moviedetails[0]['backdrop_path'],
            'voteAverage': moviedetails[0]['vote_average'],
            'addedAt': FieldValue.serverTimestamp(),
          });
          setState(() {
            isFavorite = true;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Added to favorites')),
          );
        }
      } catch (e) {
        print('Error toggling favorite: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Failed to update favorites: ${e.toString()}')),
        );
      }
    } else {
      // Show login prompt
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please log in to add favorites')),
      );
    }
  }

  Future<List<Map<String, dynamic>>> getUserFavorites() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      return [];
    }

    try {
      QuerySnapshot favoritesSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .collection('favorites')
          .get();

      return favoritesSnapshot.docs.map((doc) {
        return {'id': doc.id, ...doc.data() as Map<String, dynamic>};
      }).toList();
    } catch (e) {
      print('Error fetching favorites: $e');
      return [];
    }
  }

  Future<void> MovieDetails() async {
    var movieDetailurl = 'https://api.themoviedb.org/3/movie/' +
        widget.movieId.toString() +
        '?api_key=$apiKey';
    var userReviewurl = 'https://api.themoviedb.org/3/movie/' +
        widget.movieId.toString() +
        '/reviews?api_key=$apiKey';
    var similarMoviesurl = 'https://api.themoviedb.org/3/movie/' +
        widget.movieId.toString() +
        '/similar?api_key=$apiKey';
    var recommendedMoviesurl = 'https://api.themoviedb.org/3/movie/' +
        widget.movieId.toString() +
        '/recommendations?api_key=$apiKey';
    var movieTrailersurl = 'https://api.themoviedb.org/3/movie/' +
        widget.movieId.toString() +
        '/videos?api_key=$apiKey';

    var moviedetailresponse = await http.get(Uri.parse(movieDetailurl));
    if (moviedetailresponse.statusCode == 200) {
      var moviedetailjson = jsonDecode(moviedetailresponse.body);
      for (var i = 0; i < 1; i++) {
        moviedetails.add({
          "backdrop_path": moviedetailjson['backdrop_path'],
          "title": moviedetailjson['title'],
          "vote_average": moviedetailjson['vote_average'],
          "overview": moviedetailjson['overview'],
          "release_date": moviedetailjson['release_date'],
          "runtime": moviedetailjson['runtime'],
          "budget": moviedetailjson['budget'],
          "revenue": moviedetailjson['revenue'],
          "origin_country": moviedetailjson['origin_country'],
          "status": moviedetailjson['status'],
        });
      }
      for (var i = 0; i < moviedetailjson['genres'].length; i++) {
        Moviegenre.add(moviedetailjson['genres'][i]['name']);
      }
      for (var i = 0; i < moviedetailjson['production_companies'].length; i++) {
        ProductionCompaning.add(
            moviedetailjson['production_companies'][i]['name']);
      }
    } else {
      print(moviedetailresponse.statusCode);
    }

    var UserReviewresponse = await http.get(Uri.parse(userReviewurl));
    if (UserReviewresponse.statusCode == 200) {
      var UserReviewjson = jsonDecode(UserReviewresponse.body);
      for (var i = 0; i < UserReviewjson['results'].length; i++) {
        userreview.add({
          "name": UserReviewjson['results'][i]['author'],
          "review": UserReviewjson['results'][i]['content'],
          "rating":
              UserReviewjson['results'][i]['author_details']['rating'] == null
                  ? "Not Rated"
                  : UserReviewjson['results'][i]['author_details']['rating']
                      .toString(),
          "avatarphoto": UserReviewjson['results'][i]['author_details']
                      ['avatar_path'] ==
                  null
              ? "https://www.pngitem.com/pimgs/m/146-1468479_my-profile-icon-blank-profile-picture-circle-hd.png"
              : "https://image.tmdb.org/t/p/w500" +
                  UserReviewjson['results'][i]['author_details']['avatar_path'],
          "creationdate":
              UserReviewjson['results'][i]['created_at'].substring(0, 10),
          "fullreviewurl": UserReviewjson['results'][i]['url'],
        });
      }
    } else {
      print(UserReviewresponse.statusCode);
    }

    var similarmoviesresponse = await http.get(Uri.parse(similarMoviesurl));
    if (similarmoviesresponse.statusCode == 200) {
      var similarmoviesjson = jsonDecode(similarmoviesresponse.body);
      for (var i = 0; i < similarmoviesjson['results'].length; i++) {
        similarmovies.add({
          "poster_path": similarmoviesjson['results'][i]['poster_path'],
          "name": similarmoviesjson['results'][i]['title'],
          "vote_average": similarmoviesjson['results'][i]['vote_average'],
          "Date": similarmoviesjson['results'][i]['release_date'],
          "id": similarmoviesjson['results'][i]['id'],
        });
      }
    } else {
      print(similarmoviesresponse.statusCode);
    }

    var recommendedmoviesresponse =
        await http.get(Uri.parse(recommendedMoviesurl));
    if (recommendedmoviesresponse.statusCode == 200) {
      var recommendedmoviesjson = jsonDecode(recommendedmoviesresponse.body);
      for (var i = 0; i < recommendedmoviesjson['results'].length; i++) {
        recommendedmovies.add({
          "poster_path": recommendedmoviesjson['results'][i]['poster_path'],
          "name": recommendedmoviesjson['results'][i]['title'],
          "vote_average": recommendedmoviesjson['results'][i]['vote_average'],
          "Date": recommendedmoviesjson['results'][i]['release_date'],
          "id": recommendedmoviesjson['results'][i]['id'],
        });
      }
    } else {
      print(recommendedmoviesresponse.statusCode);
    }

    var movietrailersresponse = await http.get(Uri.parse(movieTrailersurl));
    if (movietrailersresponse.statusCode == 200) {
      var movietrailersjson = jsonDecode(movietrailersresponse.body);
      for (var i = 0; i < movietrailersjson['results'].length; i++) {
        if (movietrailersjson['results'][i]['type'] == "Trailer") {
          trailers.add({
            "key": movietrailersjson['results'][i]['key'],
          });
        }
      }
      trailers.add({'key': 'aJ0cZTcTh90'});
    } else {
      print(movietrailersresponse.statusCode);
    }
    print(trailers);
    //await checkFavoriteStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 242, 239, 239),
      body: FutureBuilder(
          future: MovieDetails(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverAppBar(
                    automaticallyImplyLeading: false,
                    leading: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        FontAwesomeIcons.circleArrowLeft,
                        color: const Color.fromARGB(255, 182, 158, 219),
                      ),
                      iconSize: 28,
                      color: Colors.white,
                    ),
                    actions: [
                      IconButton(
                        onPressed: toggleFavorite,
                        icon: Icon(
                          isFavorite
                              ? FontAwesomeIcons.solidBookmark
                              : FontAwesomeIcons.bookmark,
                          color: isFavorite
                              ? Colors.yellow.shade400
                              : const Color.fromARGB(255, 182, 158, 219),
                        ),
                        iconSize: 25,
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const HomePage()),
                              (route) => false);
                        },
                        icon: Icon(
                          FontAwesomeIcons.houseUser,
                          color: const Color.fromARGB(255, 182, 158, 219),
                        ),
                        iconSize: 25,
                        color: Colors.white,
                      )
                    ],
                    backgroundColor: Colors.white,
                    centerTitle: false,
                    pinned: true,
                    expandedHeight: MediaQuery.of(context).size.height * 0.4,
                    flexibleSpace: FlexibleSpaceBar(
                      collapseMode: CollapseMode.parallax,
                      background: FittedBox(
                        fit: BoxFit.fill,
                        child: Trailerwatch(trailerid: trailers[0]['key']),
                      ),
                    ),
                  ),
                  SliverList(
                      delegate: SliverChildListDelegate([
                    Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.only(left: 10, top: 10),
                              height: 50,
                              width: MediaQuery.of(context).size.width,
                              child: ListView.builder(
                                physics: BouncingScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                itemCount: Moviegenre.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    margin: EdgeInsets.only(right: 10),
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.deepPurple.shade700,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      Moviegenre[index],
                                      style: GoogleFonts.teko(
                                          fontSize: 18, color: Colors.white),
                                    ),
                                  );
                                },
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                                padding: EdgeInsets.all(10),
                                margin: EdgeInsets.only(left: 10, top: 10),
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.deepPurple.shade700,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  moviedetails[0]['runtime'].toString() + 'min',
                                  style: GoogleFonts.teko(
                                      fontSize: 18, color: Colors.white),
                                ))
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 20, top: 10),
                          child: Text(
                            'Production Companies ',
                            style: GoogleFonts.teko(
                              fontSize: 24,
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.only(left: 10, top: 10),
                                  height: 50,
                                  width: MediaQuery.of(context).size.width,
                                  child: ListView.builder(
                                    physics: BouncingScrollPhysics(),
                                    scrollDirection: Axis.horizontal,
                                    itemCount: ProductionCompaning.length,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        margin: EdgeInsets.only(right: 10),
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: Colors.deepPurple.shade700,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Text(
                                          ProductionCompaning[index],
                                          style: GoogleFonts.teko(
                                              fontSize: 14,
                                              color: Colors.white),
                                        ),
                                      );
                                    },
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20, top: 10),
                      child: Text(
                        'Origin Country: ' +
                            moviedetails[0]['origin_country'].toString(),
                        style: GoogleFonts.teko(
                          fontSize: 24,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20, top: 10),
                      child: Text(
                        'Movie Story: ',
                        style: GoogleFonts.teko(
                          fontSize: 24,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20, top: 10),
                      child: Text(
                        moviedetails[0]['overview'].toString(),
                        style: GoogleFonts.teko(
                          fontSize: 20,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20, top: 10),
                      child: Userreview(
                        userreviewdetails: userreview,
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.only(left: 20, top: 10),
                        child: Text(
                          'Release Date: ' +
                              moviedetails[0]['release_date'].toString(),
                          style: GoogleFonts.teko(
                            fontSize: 20,
                          ),
                        )),
                    Padding(
                        padding: EdgeInsets.only(left: 20, top: 10),
                        child: Text(
                          'Budget: ' + moviedetails[0]['budget'].toString(),
                          style: GoogleFonts.teko(
                            fontSize: 20,
                          ),
                        )),
                    Padding(
                        padding: EdgeInsets.only(left: 20, top: 10),
                        child: Text(
                          'Revenue: ' + moviedetails[0]['revenue'].toString(),
                          style: GoogleFonts.teko(
                            fontSize: 20,
                          ),
                        )),
                    Padding(
                      padding: EdgeInsets.only(left: 20, top: 10),
                      child: Text(
                        'Status: ' + moviedetails[0]['status'].toString(),
                        style: GoogleFonts.teko(
                          fontSize: 24,
                        ),
                      ),
                    ),
                    slider(similarmovies, "Similar Movies", "Movie",
                        similarmovies.length),
                    slider(recommendedmovies, "Recommended Movie", "movie",
                        recommendedmovies.length),
                  ]))
                ],
              );
            } else {
              return Center(
                child: CircularProgressIndicator(
                  color: Colors.deepPurple.shade700,
                ),
              );
            }
          }),
    );
  }
}
