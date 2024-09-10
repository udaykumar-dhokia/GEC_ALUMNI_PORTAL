import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gecap/components/appbar/institute_appbar.dart';
import 'package:gecap/components/footer/footer.dart';
import 'package:gecap/constants/color.dart';
import 'package:google_fonts/google_fonts.dart';

class Alumni extends StatefulWidget {
  const Alumni({super.key});

  @override
  State<Alumni> createState() => _AlumniState();
}

class _AlumniState extends State<Alumni> {
  Map<String, dynamic>? details;
  bool _isLoading = false;
  List<Map<String, dynamic>> alumni = [];
  User? user = FirebaseAuth.instance.currentUser;

  void getData() async {
    try {
      setState(() {
        _isLoading = true;
      });
      final data = await FirebaseFirestore.instance
          .collection("gec")
          .doc(user!.email)
          .get();

      final alumniData = await FirebaseFirestore.instance
          .collection("alumni")
          .where("college", isEqualTo: data["name"])
          .get();

      for (var doc in alumniData.docs) {
        setState(() {
          alumni.add(doc.data());
        });
      }

      setState(() {
        details = data.data();
      });
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      return;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    double titleFontSize = width * 0.02;
    // double subtitleFontSize = width * 0.015;
    double toolbarHeight = height * 0.2;
    return _isLoading
        ? const Scaffold(
            backgroundColor: white,
            body: Center(
              child: CircularProgressIndicator(
                color: primary,
              ),
            ),
          )
        : Scaffold(
            backgroundColor: white,
            body: CustomScrollView(
              slivers: [
                InstituteAppBar(
                  toolbarHeight: toolbarHeight,
                  titleFontSize: titleFontSize,
                  name: details!["name"],
                ),
                SliverList(
                    delegate: SliverChildListDelegate([
                  Container(
                    height: height / 1.5,
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Alumni",
                          style: GoogleFonts.manrope(
                              fontSize: width * 0.02,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Table(
                          border: TableBorder.all(),
                          children: [
                            TableRow(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Name",
                                    style: GoogleFonts.manrope(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("Passout",
                                      style: GoogleFonts.manrope(
                                        fontWeight: FontWeight.w600,
                                      )),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("Enrollment",
                                      style: GoogleFonts.manrope(
                                        fontWeight: FontWeight.w600,
                                      )),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("Email",
                                      style: GoogleFonts.manrope(
                                        fontWeight: FontWeight.w600,
                                      )),
                                ),
                              ],
                            ),
                            for (var a in alumni)
                              TableRow(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(a['name'] ?? 'No Name',
                                        style: GoogleFonts
                                            .manrope()), // Display the name field
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      a['passout'].toString(),
                                      style: GoogleFonts.manrope(),
                                    ), // Display the total alumni count
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      a['enrollment'].toString(),
                                      style: GoogleFonts.manrope(),
                                    ), // Display the total alumni count
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      a['email'].toString(),
                                      style: GoogleFonts.manrope(),
                                    ), // Display the total alumni count
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Footer(),
                ]))
              ],
            ),
          );
  }
}
