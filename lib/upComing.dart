import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:movie_app/apiKey/allapi.dart';
import 'package:movie_app/function/slider.dart';

class Upcoming extends StatefulWidget {
  const Upcoming({super.key});

  @override
  State<Upcoming> createState() => _upcoming();
}

class _upcoming extends State<Upcoming> {
  List<Map<String, dynamic>> upcomingmovies = [];

  Future<void> upcomingSeriespage() async {
    var upcomingres = await http.get(Uri.parse(upcomingmoviesurl));
    if (upcomingres.statusCode == 200) {
      var upcomingdata = jsonDecode(upcomingres.body);
      var upcomingJson = upcomingdata['results'];
      for (var i = 0; i < upcomingJson.length; i++) {
        upcomingmovies.add({
          "name": upcomingJson[i]["original_title"],
          "poster_path": upcomingJson[i]["poster_path"],
          "vote_average": upcomingJson[i]["vote_average"],
          "Date": upcomingJson[i]["release_date"],
          "id": upcomingJson[i]['id'],
        });
      }
    } else {
      print(upcomingres.statusCode);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: upcomingSeriespage(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.deepPurple,
            ),
          );
        } else {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              slider(upcomingmovies, 'Upcoming Movies', 'Movie', 15),
            ],
          );
        }
      },
    );
  }
}
