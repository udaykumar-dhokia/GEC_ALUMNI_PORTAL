import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gecap/components/appbar/institute_appbar.dart';
import 'package:gecap/components/footer/footer.dart';
import 'package:gecap/constants/color.dart';
import 'package:google_fonts/google_fonts.dart';

class InstituteDashboard extends StatefulWidget {
  const InstituteDashboard({super.key});

  @override
  State<InstituteDashboard> createState() => _InstituteDashboardState();
}

class _InstituteDashboardState extends State<InstituteDashboard> {
  Map<String, dynamic>? details;
  bool _isLoading = false;
  int totalAlumni = 0;
  int? totalEvents;
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

      final atotal = await FirebaseFirestore.instance
          .collection("alumni")
          // .where("college", isEqualTo: data["name"])
          .where("college", isEqualTo: user!.email)
          .get();

      final etotal = await FirebaseFirestore.instance
          .collection("gec")
          .doc(user!.email)
          .collection("events")
          .get();

      if (etotal.docs.isNotEmpty) {
        setState(() {
          totalEvents = etotal.size;
        });
      }

      setState(() {
        totalAlumni = data["total"];
      });

      setState(() {
        details = data.data();
        _isLoading = false;
      });
    } catch (e) {
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
                    name: details!["name"]),
                SliverList(
                    delegate: SliverChildListDelegate([
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 15, right: 15, bottom: 15, top: 15),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              padding: const EdgeInsets.only(
                                  top: 15, left: 15, right: 15, bottom: 15),
                              decoration: BoxDecoration(
                                color: white,
                                border: Border.all(),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              // height: height / 4,
                              width: width / 3 - 30,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Total Alumni",
                                    style: GoogleFonts.manrope(
                                        fontSize: width * 0.012,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    totalAlumni.toString(),
                                    style: GoogleFonts.manrope(
                                        fontSize: width * 0.03,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Container(
                              padding: const EdgeInsets.only(
                                  top: 15, left: 15, right: 15, bottom: 15),
                              decoration: BoxDecoration(
                                color: white,
                                border: Border.all(),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              // height: height / 4,
                              width: width / 3 - 30,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Total Events",
                                    style: GoogleFonts.manrope(
                                        fontSize: width * 0.012,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    totalEvents != null
                                        ? totalEvents.toString()
                                        : "0",
                                    style: GoogleFonts.manrope(
                                        fontSize: width * 0.03,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Container(
                              padding: const EdgeInsets.only(
                                  top: 15, left: 15, right: 15, bottom: 15),
                              decoration: BoxDecoration(
                                color: white,
                                border: Border.all(),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              // height: height / 4,
                              width: width / 3 - 30,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Support",
                                    style: GoogleFonts.manrope(
                                        fontSize: width * 0.012,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    totalEvents != null
                                        ? "₹ ${totalEvents.toString()}"
                                        : "₹ 0.00",
                                    style: GoogleFonts.manrope(
                                        fontSize: width * 0.03,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Footer(),
                ])),
              ],
            ),
          );
  }
}
