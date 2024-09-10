import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gecap/components/appbar/appbar.dart';
import 'package:gecap/components/footer/footer.dart';
import 'package:gecap/constants/color.dart';
import 'package:gecap/pages/portal/login/signup.dart';
import 'package:google_fonts/google_fonts.dart';

class Explore extends StatefulWidget {
  const Explore({super.key});

  @override
  State<Explore> createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  List<Map<String, dynamic>> total = [];
  int totalCount = 0;
  bool isLoading = false;

  void totalAlumni() async {
    try {
      setState(() {
        isLoading = true;
      });
      final data = await FirebaseFirestore.instance.collection("gec").get();
      for (var doc in data.docs) {
        setState(() {
          total.add(doc.data());
        });
      }
      for (var doc in data.docs) {
        var totalField = doc.data()["total"];

        if (totalField != null && totalField is String) {
          try {
            totalCount += int.parse(totalField);
          } catch (e) {
            log("Failed to parse total for doc: ${doc.id}");
          }
        } else if (totalField != null && totalField is int) {
          totalCount += totalField;
        }
      }
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  void findTotal() {}

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    totalAlumni();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    double titleFontSize = width * 0.02;
    // double subtitleFontSize = width * 0.015;
    double toolbarHeight = height * 0.2;
    return isLoading
        ? const Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: CircularProgressIndicator(
                color: primary,
              ),
            ),
          )
        : Scaffold(
            backgroundColor: Colors.white,
            body: CustomScrollView(
              slivers: [
                Appbar(
                    toolbarHeight: toolbarHeight, titleFontSize: titleFontSize),
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      const SizedBox(
                        height: 40,
                      ),

                      Padding(
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Registered Alumni ($totalCount)",
                              style: GoogleFonts.manrope(
                                fontSize: width * 0.02,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation,
                                            secondaryAnimation) =>
                                        const SignIn(),
                                    transitionsBuilder: (context, animation,
                                        secondaryAnimation, child) {
                                      const begin = 0.0;
                                      const end = 1.0;
                                      const curve = Curves.easeInOut;

                                      var tween = Tween(begin: begin, end: end)
                                          .chain(CurveTween(curve: curve));
                                      var fadeAnimation =
                                          animation.drive(tween);

                                      return FadeTransition(
                                        opacity: fadeAnimation,
                                        child: child,
                                      );
                                    },
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(
                                    horizontal: width * 0.025,
                                    vertical: height * 0.025),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                              ),
                              child: Text(
                                "Join now",
                                style: GoogleFonts.manrope(
                                  fontSize: width * 0.01,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(
                            left: 15, right: 15, top: 15, bottom: 15),
                        child: Table(
                          border: TableBorder.all(),
                          children: [
                            TableRow(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "GEC",
                                    style: GoogleFonts.manrope(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("Total Alumni",
                                      style: GoogleFonts.manrope(
                                        fontWeight: FontWeight.w600,
                                      )),
                                ),
                              ],
                            ),
                            for (var alumni in total)
                              TableRow(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(alumni['name'] ?? 'No Name',
                                        style: GoogleFonts
                                            .manrope()), // Display the name field
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      alumni['total'].toString(),
                                      style: GoogleFonts.manrope(),
                                    ), // Display the total alumni count
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      //Footer
                      const Footer(),
                    ],
                  ),
                ),
              ],
            ),
          );
  }
}
