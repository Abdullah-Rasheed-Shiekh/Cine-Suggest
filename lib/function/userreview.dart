import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Userreview extends StatefulWidget {
  List userreviewdetails;
  Userreview({required this.userreviewdetails});
  @override
  State<StatefulWidget> createState() => _userReviewState();
}

class _userReviewState extends State<Userreview> {
  bool showall = false;
  @override
  Widget build(BuildContext context) {
    List reviewDetails = widget.userreviewdetails;
    if (reviewDetails.length == 0) {
      return Center(
        child: Text(
          'No Reviews Available',
          style: GoogleFonts.teko(
            fontSize: 18,
          ),
        ),
      );
    } else {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 20, bottom: 10, top: 10),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'User Review',
                    style: GoogleFonts.teko(
                      fontSize: 24,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      showall = !showall;
                    });
                  },
                  child: Row(
                    children: [
                      showall == false
                          ? Text(
                              'All Reviews ' + '${reviewDetails.length}',
                              style: GoogleFonts.teko(
                                fontSize: 20,
                              ),
                            )
                          : Text(
                              'Show Less',
                              style: GoogleFonts.teko(
                                fontSize: 20,
                              ),
                            ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.black,
                        size: 20,
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          showall == true
              ? Container(
                  height: MediaQuery.of(context).size.height * 0.65,
                  child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: reviewDetails.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(
                          top: 20,
                          right: 20,
                          bottom: 10,
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Row(
                                    children: [
                                      Container(
                                        height: 50,
                                        width: 50,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                                image: NetworkImage(
                                                    reviewDetails[index]
                                                        ['avatarphoto']),
                                                fit: BoxFit.cover)),
                                      ),
                                      SizedBox(width: 10),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          FittedBox(
                                            fit: BoxFit.scaleDown,
                                            child: Text(
                                              reviewDetails[index]['name'],
                                              style: GoogleFonts.teko(
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            reviewDetails[index]
                                                ['creationdate'],
                                            style: GoogleFonts.teko(
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Icon(
                                          Icons.star,
                                          color: Colors.yellow,
                                          size: 20,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text(
                                          reviewDetails[index]['rating'],
                                          style: GoogleFonts.teko(
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Expanded(
                                    child: Text(
                                  reviewDetails[index]['review'],
                                  style: GoogleFonts.teko(
                                    fontSize: 16,
                                  ),
                                ))
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                )
              : Container(
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: 20, right: 20, bottom: 10),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Row(
                                children: [
                                  Container(
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                            image: NetworkImage(reviewDetails[0]
                                                ['avatarphoto']),
                                            fit: BoxFit.cover)),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text(
                                          reviewDetails[0]['name'],
                                          style: GoogleFonts.teko(
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        reviewDetails[0]['creationdate'],
                                        style: GoogleFonts.teko(
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Icon(
                                      Icons.star,
                                      color: Colors.yellow,
                                      size: 20,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      reviewDetails[0]['rating'],
                                      style: GoogleFonts.teko(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              flex: 1,
                            )
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Expanded(
                                child: Text(
                              reviewDetails[0]['review'],
                              style: GoogleFonts.teko(
                                fontSize: 16,
                              ),
                            ))
                          ],
                        )
                      ],
                    ),
                  ),
                )
        ],
      );
    }
  }
}
