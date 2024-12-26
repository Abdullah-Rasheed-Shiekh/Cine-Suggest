import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_app/movie_details.dart';

Widget slider(List listname, String category, String type, int noOfItems) {
  return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Padding(
        padding: const EdgeInsets.only(left: 10.0, top: 15, bottom: 24),
        child: Text(
          category.toString(),
          style: GoogleFonts.teko(fontSize: 28),
        )),
    SizedBox(
      height: 250,
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: noOfItems,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              if (type == 'Movie') {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            MovieDetails(listname[index]['id'])));
              } else {
                Text(
                  'NO DETAILS AVAILABLE',
                  style: GoogleFonts.teko(
                    fontSize: 36,
                  ),
                );
              }
            },
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  image: DecorationImage(
                      colorFilter: const ColorFilter.mode(
                          Colors.black12, BlendMode.darken),
                      image: NetworkImage(
                          'https://image.tmdb.org/t/p/w500${listname[index]['poster_path']}'),
                      fit: BoxFit.cover)),
              margin: const EdgeInsets.only(left: 13),
              width: 170,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 2, right: 6),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black26,
                        borderRadius: BorderRadius.circular(9),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 1, bottom: 2, left: 2, right: 5),
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              listname[index]['Date'],
                              style: const TextStyle(color: Colors.white),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 2, right: 6),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black26,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 2, bottom: 2, left: 5, right: 5),
                        child: Row(
                          children: [
                            Icon(
                              Icons.star,
                              color: Colors.yellow.shade700,
                              size: 15,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              listname[index]['vote_average'].toString(),
                              style: const TextStyle(color: Colors.white),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    ),
    const SizedBox(
      height: 20,
    )
  ]);
}
