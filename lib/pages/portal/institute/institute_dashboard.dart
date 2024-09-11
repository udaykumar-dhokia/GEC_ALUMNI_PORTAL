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
  List<Map<String, dynamic>> alumni = [];
  int? totalEvents;
  User? user = FirebaseAuth.instance.currentUser;
  int? totalDonation;
  List<Map<String, dynamic>> events = [];

  void getData() async {
    try {
      setState(() {
        _isLoading = true;
        totalDonation = 0;
      });
      final data = await FirebaseFirestore.instance
          .collection("gec")
          .doc(user!.email)
          .get();

      final atotal = await FirebaseFirestore.instance
          .collection("alumni")
          .where("college", isEqualTo: data["name"])
          .get();

      for (var doc in atotal.docs) {
        int? donationAmount = doc.data()["donationAmount"] as int?;
        if (donationAmount != null) {
          totalDonation = totalDonation! + donationAmount;
        }
        print(totalDonation);
      }

      final etotal = await FirebaseFirestore.instance
          .collection("gec")
          .doc(user!.email)
          .collection("event_request")
          .where("isVerified", isEqualTo: true)
          .get();

      for (var doc in etotal.docs) {
        setState(() {
          this.events.add(doc.data());
        });
      }

      if (etotal.docs.isNotEmpty) {
        setState(() {
          totalEvents = etotal.size;
        });
      }

      final alumniData = await FirebaseFirestore.instance
          .collection("alumni")
          .where("college", isEqualTo: data["name"])
          .limit(5)
          .get();

      for (var doc in alumniData.docs) {
        setState(() {
          alumni.add(doc.data());
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
                  name: details!["name"],
                ),
                SliverList(
                    delegate: SliverChildListDelegate([
                  Container(
                    height: height,
                    padding: const EdgeInsets.only(
                        left: 15, right: 15, bottom: 15, top: 15),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Dashboard",
                            style: GoogleFonts.manrope(
                                fontSize: width * 0.022,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
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
                                      totalDonation != null
                                          ? "₹ ${totalDonation.toString()}"
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
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Alumni",
                                style: GoogleFonts.manrope(
                                    fontSize: width * 0.02,
                                    fontWeight: FontWeight.bold),
                              ),
                              IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.arrow_forward_ios_outlined),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 10,
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
                                          style: GoogleFonts.manrope()),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        a['passout'].toString(),
                                        style: GoogleFonts.manrope(),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        a['enrollment'].toString(),
                                        style: GoogleFonts.manrope(),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        a['email'].toString(),
                                        style: GoogleFonts.manrope(),
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                      
                          //Events
                      
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Events",
                                style: GoogleFonts.manrope(
                                    fontSize: width * 0.02,
                                    fontWeight: FontWeight.bold),
                              ),
                              IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.arrow_forward_ios_outlined),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Table(
                            border: TableBorder.all(),
                            children: [
                              TableRow(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "Title",
                                      style: GoogleFonts.manrope(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text("Decription",
                                        style: GoogleFonts.manrope(
                                          fontWeight: FontWeight.w600,
                                        )),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text("Date",
                                        style: GoogleFonts.manrope(
                                          fontWeight: FontWeight.w600,
                                        )),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text("Is approved?",
                                        style: GoogleFonts.manrope(
                                          fontWeight: FontWeight.w600,
                                        )),
                                  ),
                                ],
                              ),
                              for (var a in events)
                                TableRow(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(a['title'] ?? 'No Name',
                                          style: GoogleFonts.manrope()),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        a['description'].toString(),
                                        style: GoogleFonts.manrope(),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        a['date'].toString(),
                                        style: GoogleFonts.manrope(),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        a['isVerified'].toString(),
                                        style: GoogleFonts.manrope(),
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                      
                        ],
                      ),
                    ),
                  ),
                  const Footer(),
                ])),
              ],
            ),
          );
  }
}
