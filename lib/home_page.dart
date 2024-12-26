import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:movie_app/movie_details.dart';
import 'package:movie_app/movies.dart';
import 'package:movie_app/upComing.dart';
import 'package:movie_app/apiKey/allapi.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  List<Map<String, dynamic>> trendingweek = [];
  Future<void> trendinglisthome() async {
    if (uval == 1) {
      var trendingweekresponse = await http.get(Uri.parse(trendingweekurl));
      if (trendingweekresponse.statusCode == 200) {
        var tempdata = jsonDecode(trendingweekresponse.body);
        var trendingweekjson = tempdata['results'];
        for (var i = 0; i < trendingweekjson.length; i++) {
          trendingweek.add({
            'id': trendingweekjson[i]['id'],
            'poster_path': trendingweekjson[i]['poster_path'],
            'vote_average': trendingweekjson[i]['vote_average'],
            'media_type': trendingweekjson[i]['media_type'],
            'indexno': i,
          });
        }
      }
    } else if (uval == 2) {
      var trendingdayresponse = await http.get(Uri.parse(trendingdayurl));
      if (trendingdayresponse.statusCode == 200) {
        var tempdata = jsonDecode(trendingdayresponse.body);
        var trendingweekjson = tempdata['results'];
        for (var i = 0; i < trendingweekjson.length; i++) {
          trendingweek.add({
            'id': trendingweekjson[i]['id'],
            'poster_path': trendingweekjson[i]['poster_path'],
            'vote_average': trendingweekjson[i]['vote_average'],
            'media_type': trendingweekjson[i]['media_type'],
            'indexno': i,
          });
        }
      }
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

  Future<void> _signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Signed out successfully!'),
          duration: Duration(seconds: 2),
        ),
      );
      
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to sign out: $e'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  int uval = 1;

  @override
  Widget build(BuildContext context) {
    TabController _tabController = TabController(length: 2, vsync: this);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'CineSuggest',
          style: GoogleFonts.teko(color: Colors.white, fontSize: 36),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 53, 30, 93),
      ),
      body: _selectedIndex == 0
          ? CustomScrollView(
              slivers: [
                SliverAppBar(
                  centerTitle: true,
                  toolbarHeight: 60,
                  pinned: true,
                  expandedHeight: MediaQuery.of(context).size.height * 0.5,
                  flexibleSpace: FlexibleSpaceBar(
                    collapseMode: CollapseMode.parallax,
                    background: FutureBuilder(
                        future: trendinglisthome(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            return CarouselSlider(
                              options: CarouselOptions(
                                  viewportFraction: 1,
                                  autoPlay: true,
                                  autoPlayInterval: Duration(seconds: 4),
                                  height: MediaQuery.of(context).size.height),
                              items: trendingweek.map((i) {
                                return Builder(builder: (BuildContext context) {
                                  return GestureDetector(
                                    onTap: () {},
                                    child: GestureDetector(
                                      onTap: () {},
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                                colorFilter: const ColorFilter.mode(
                                                    Colors.black38,
                                                    BlendMode.darken),
                                                image: NetworkImage(
                                                    'https://image.tmdb.org/t/p/w500${i['poster_path']}'),
                                                fit: BoxFit.fill),),
                                      ),
                                    ),
                                  );
                                });
                              }).toList(),
                            );
                          } else {
                            return const Center(
                              child: CircularProgressIndicator(
                                color: Colors.deepPurple,
                              ),
                            );
                          }
                        }),
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Trending',
                        style: GoogleFonts.teko(
                            color: Colors.white70,
                            fontSize: 23,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Container(
                        height: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6)),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: DropdownButton(
                            onChanged: (value) {
                              setState(() {
                                trendingweek.clear();
                                uval = int.parse(value.toString());
                              });
                            },
                            autofocus: true,
                            underline:
                                Container(height: 0, color: Colors.transparent),
                            dropdownColor: Colors.black87,
                            icon: Icon(
                              Icons.arrow_drop_down_circle_sharp,
                              color: Colors.deepPurple.shade700,
                              size: 30,
                              fill: 1.00,
                            ),
                            value: uval,
                            items: [
                              DropdownMenuItem(
                                child: Text(
                                  'Weekly',
                                  style: GoogleFonts.teko(
                                      decoration: TextDecoration.none,
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                value: 1,
                              ),
                              DropdownMenuItem(
                                child: Text(
                                  'Daily',
                                  style: GoogleFonts.teko(
                                      decoration: TextDecoration.none,
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                value: 2,
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SliverList(
                    delegate: SliverChildListDelegate([
                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: Container(
                      height: 45,
                      width: MediaQuery.of(context).size.width,
                      child: TabBar(
                        physics: const BouncingScrollPhysics(),
                        isScrollable: true,
                        labelPadding: const EdgeInsets.symmetric(horizontal: 25),
                        controller: _tabController,
                        indicator: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: const Color.fromARGB(119, 114, 69, 220),
                        ),
                        tabs: [
                          Tab(
                            child: Text(
                              'Movies',
                              style: GoogleFonts.teko(
                                  fontSize: 26, color: Colors.black),
                            ),
                          ),
                          Tab(
                            child: Text(
                              'Upcoming',
                              style: GoogleFonts.teko(
                                  fontSize: 26, color: Colors.black),
                            ),
                          ),
                        ],
                        tabAlignment: TabAlignment.center,
                      ),
                    ),
                  ),
                  Center(
                    child: Container(
                      height: 1050,
                      child: TabBarView(
                        controller: _tabController,
                        children: const [
                          Movies(),
                          Upcoming(),
                        ],
                      ),
                    ),
                  ),
                ]))
              ],
            )
          : FutureBuilder<List<Map<String, dynamic>>>(
              future: getUserFavorites(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return const Center(
                    child: Text("Error loading favorites"),
                  );
                } else if (snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text("No favorites yet!"),
                  );
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      var movie = snapshot.data![index];
                      return Card(
                        shadowColor: Colors.deepPurple.shade900,
                        elevation: 20.0,
                        margin: const EdgeInsets.all(10.0),
                        color: Colors.deepPurple.shade700,
                        child: ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      MovieDetails(movie['id'])),
                            );
                          },
                          leading: movie['backdropPath'] != null
                              ? Image.network(
                                  'https://image.tmdb.org/t/p/w200${movie['backdropPath']}',
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                )
                              : const Icon(Icons.movie, size: 50),
                          title: Text(
                            movie['title'] ?? 'No title',
                            style: GoogleFonts.teko(
                              color: Colors.white,
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            "Rating: ${movie['voteAverage']}",
                            style: GoogleFonts.teko(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              }),
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Colors.white,
        selectedItemColor: Colors.white,
        backgroundColor: Colors.deepPurple.shade700,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.movie,
                color: Colors.white,
              ),
              label: 'Home',
              backgroundColor: Colors.white),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.logout,
                color: Colors.white,
              ),
              label: 'Sign Out',
              backgroundColor: Colors.white),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: 'Favorites',
          )
        ],
        currentIndex: _selectedIndex,
        onTap: (index) {
          if (index == 1) {
            _signOut(); // Redirect to login
          } else {
            setState(() {
              _selectedIndex = index;
            });
          }
        },
      ),
    );
  }
}
