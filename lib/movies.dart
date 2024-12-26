import 'package:flutter/material.dart';
import 'package:movie_app/apiKey/allapi.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:movie_app/function/slider.dart';

class Movies extends StatefulWidget {
  const Movies({super.key});

  @override
  State<Movies> createState() => _movies();
}

class _movies extends State<Movies> {
  List<Map<String, dynamic>> topRatedMovies = [];
  List<Map<String, dynamic>> popularMovies = [];
  List<Map<String, dynamic>> nowPlayingMovies = [];

  Future<void> moviesList() async {
    var popularmoviesres = await http.get(Uri.parse(popularmoviesurl));
    if (popularmoviesres.statusCode == 200) {
      var popularmoviesdata = jsonDecode(popularmoviesres.body);
      var popularMoviesJson = popularmoviesdata['results'];
      for (var i = 0; i < popularMoviesJson.length; i++) {
        popularMovies.add({
          "name": popularMoviesJson[i]["original_title"],
          "poster_path": popularMoviesJson[i]["poster_path"],
          "vote_average": popularMoviesJson[i]["vote_average"],
          "Date": popularMoviesJson[i]["release_date"],
          "id": popularMoviesJson[i]["id"],
        });
      }
    } else {
      print(popularmoviesres.statusCode);
    }

    
    var topratedmoviesres = await http.get(Uri.parse(topratedmoviesurl));
    if (topratedmoviesres.statusCode == 200) {
      var topratedmoviedata = jsonDecode(topratedmoviesres.body);
      var topratedmovieJSON = topratedmoviedata['results'];
      for (var i = 0; i < topratedmovieJSON.length; i++) {
        topRatedMovies.add({
          "name": topratedmovieJSON[i]["original_title"],
          "poster_path": topratedmovieJSON[i]["poster_path"],
          "vote_average": topratedmovieJSON[i]["vote_average"],
          "Date": topratedmovieJSON[i]["release_date"],
          "id": topratedmovieJSON[i]["id"],
        });
      }
    } else {
      print(topratedmoviesres.statusCode);
    }

    
    var nowplayingMoviesres = await http.get(Uri.parse(nowplayingmovieurl));
    if (nowplayingMoviesres.statusCode == 200) {
      var nowplayingmoviedata = jsonDecode(nowplayingMoviesres.body);
      var nowplayingmovieJSON = nowplayingmoviedata['results'];
      for (var i = 0; i < nowplayingmovieJSON.length; i++) {
        nowPlayingMovies.add({
          "name": nowplayingmovieJSON[i]["original_title"],
          "poster_path": nowplayingmovieJSON[i]["poster_path"],
          "vote_average": nowplayingmovieJSON[i]["vote_average"],
          "Date": nowplayingmovieJSON[i]["release_date"],
          "id": nowplayingmovieJSON[i]["id"],
        });
      }
    } else {
      print(nowplayingMoviesres.statusCode);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: moviesList(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.amber,
            ),
          );
        } else {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                  child: slider(
                      nowPlayingMovies, 'Now Playing Movies', 'Movie', 15)),
              Expanded(
                  child: slider(popularMovies, 'Popular Movies', 'Movie', 15)),
              Expanded(
                  child:
                      slider(topRatedMovies, 'Top Rated Movies', 'Movie', 15)),
            ],
          );
        }
      },
    );
  }
}
