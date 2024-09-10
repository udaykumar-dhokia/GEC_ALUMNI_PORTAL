import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gecap/components/appbar/institute_appbar.dart';
import 'package:gecap/components/footer/footer.dart';
import 'package:gecap/constants/color.dart';
import 'package:google_fonts/google_fonts.dart';

class Requests extends StatefulWidget {
  const Requests({super.key});

  @override
  State<Requests> createState() => _RequestsState();
}

class _RequestsState extends State<Requests> {
  Map<String, dynamic>? details;
  bool _isLoading = false;
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
      print(data.data());
      setState(() {
        details = data.data();
        _isLoading = false;
      });
    } catch (e) {
      return;
    }
  }

  void approveCandidate(String email) async {
    try {
      final data = await FirebaseFirestore.instance
          .collection("alumni")
          .doc(email)
          .update({"isVerified": true});

      final alumni = await FirebaseFirestore.instance
          .collection("gec")
          .doc(user!.email)
          .collection("alumni_request")
          .where("email", isEqualTo: email)
          .get();
      if (alumni.docs.isNotEmpty) {
        String id = alumni.docs.first.id;
        await FirebaseFirestore.instance
            .collection("gec")
            .doc(user!.email)
            .collection("alumni_request")
            .doc(id)
            .delete();
      }
      CherryToast.success(
        animationType: AnimationType.fromTop,
        title: const Text("Alumni approved.",
            style: TextStyle(color: Colors.black)),
      ).show(context);
    } catch (e) {
      CherryToast.error(
        animationType: AnimationType.fromTop,
        title: const Text("Something went wrong.",
            style: TextStyle(color: Colors.black)),
      ).show(context);
    }
  }

  void approveEvent(String email, String title, String date) async {
    try {
      final data = await FirebaseFirestore.instance
          .collection("alumni")
          .doc(email)
          .collection("events")
          .where("title", isEqualTo: title)
          .get();

      if (data.docs.isNotEmpty) {
        String id = data.docs.first.id;
        await FirebaseFirestore.instance
            .collection("alumni")
            .doc(email)
            .collection("events")
            .doc(id)
            .update({"isVerified": true});
      }

      final alumni = await FirebaseFirestore.instance
          .collection("gec")
          .doc(user!.email)
          .collection("event_request")
          .where("title", isEqualTo: title)
          .where("date", isEqualTo: date)
          .get();
      if (alumni.docs.isNotEmpty) {
        String id = alumni.docs.first.id;
        await FirebaseFirestore.instance
            .collection("gec")
            .doc(user!.email)
            .collection("event_request")
            .doc(id)
            .update({"isVerified": true});
      }
      CherryToast.success(
        animationType: AnimationType.fromTop,
        title: const Text("Alumni approved.",
            style: TextStyle(color: Colors.black)),
      ).show(context);
    } catch (e) {
      CherryToast.error(
        animationType: AnimationType.fromTop,
        title: const Text("Something went wrong.",
            style: TextStyle(color: Colors.black)),
      ).show(context);
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
                  delegate: SliverChildListDelegate(
                    [
                      Padding(
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              "Requests",
                              style: GoogleFonts.manrope(
                                fontSize: width * 0.02,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 15, right: 15),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.only(
                                        top: 15, left: 10, right: 10),
                                    decoration: BoxDecoration(
                                      border: Border.all(),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    height: height / 1.5,
                                    width: width * 0.5 - 35,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "New Alumni",
                                          style: GoogleFonts.manrope(
                                              fontSize: width * 0.015,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        StreamBuilder(
                                          stream: FirebaseFirestore.instance
                                              .collection("gec")
                                              .doc(user!.email)
                                              .collection("alumni_request")
                                              .snapshots(),
                                          builder: (context,
                                              AsyncSnapshot<QuerySnapshot>
                                                  snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return const Center(
                                                  child:
                                                      CircularProgressIndicator());
                                            }

                                            if (snapshot.hasError) {
                                              return const Center(
                                                  child: Text(
                                                      'Something went wrong'));
                                            }

                                            if (!snapshot.hasData ||
                                                snapshot.data!.docs.isEmpty) {
                                              return Text(
                                                'Approval request for new alumni will appear here.',
                                                style: GoogleFonts.epilogue(
                                                    color: black),
                                              );
                                            }

                                            List<QueryDocumentSnapshot>
                                                requests = snapshot.data!.docs;

                                            return ListView.builder(
                                              shrinkWrap: true,
                                              itemCount: requests.length,
                                              itemBuilder: (context, index) {
                                                Map<String, dynamic> data =
                                                    requests[index].data()!
                                                        as Map<String, dynamic>;

                                                return Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          data["name"],
                                                          style: GoogleFonts
                                                              .manrope(
                                                            fontSize:
                                                                width * 0.01,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        Text(
                                                          "Enrollment: ${data["enrollment"]}",
                                                          style: GoogleFonts
                                                              .manrope(),
                                                        ),
                                                        Text(
                                                          "Passout year: ${data["passout"].toString()}",
                                                          style: GoogleFonts
                                                              .manrope(),
                                                        ),
                                                        Text(
                                                          "Email: ${data["email"]}",
                                                          style: GoogleFonts
                                                              .manrope(),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        IconButton(
                                                            onPressed: () {
                                                              approveCandidate(
                                                                  data[
                                                                      "email"]);
                                                            },
                                                            icon: const Icon(
                                                              Icons.done,
                                                              color:
                                                                  Colors.green,
                                                            )),
                                                        // const SizedBox(width: 5,),
                                                        IconButton(
                                                          onPressed: () {},
                                                          icon: const Icon(
                                                            Icons.delete,
                                                            color: Colors.red,
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(
                                        top: 15, left: 10, right: 10),
                                    decoration: BoxDecoration(
                                      border: Border.all(),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    height: height / 1.5,
                                    width: width * 0.5 - 35,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "New Events",
                                          style: GoogleFonts.manrope(
                                              fontSize: width * 0.015,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        StreamBuilder(
                                            stream: FirebaseFirestore.instance
                                                .collection("gec")
                                                .doc(user!.email)
                                                .collection("event_request")
                                                .where("isVerified", isEqualTo: false)
                                                .snapshots(),
                                            builder: (context,
                                                AsyncSnapshot<QuerySnapshot>
                                                    snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return const Center(
                                                    child:
                                                        CircularProgressIndicator());
                                              }

                                              if (snapshot.hasError) {
                                                return const Center(
                                                    child: Text(
                                                        'Something went wrong'));
                                              }

                                              if (!snapshot.hasData ||
                                                  snapshot.data!.docs.isEmpty) {
                                                return Text(
                                                  'Event approval requested by alumni will appear here.',
                                                  style: GoogleFonts.epilogue(
                                                      color: black),
                                                );
                                              }

                                              List<QueryDocumentSnapshot>
                                                  requests =
                                                  snapshot.data!.docs;

                                              return ListView.builder(
                                                shrinkWrap: true,
                                                itemCount: requests.length,
                                                itemBuilder: (context, index) {
                                                  Map<String, dynamic> data =
                                                      requests[index].data()!
                                                          as Map<String,
                                                              dynamic>;

                                                  return Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              "Requested by: ${data["name"]}",
                                                              style: GoogleFonts
                                                                  .manrope(
                                                                fontSize:
                                                                    width *
                                                                        0.01,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                            Text(
                                                              data["title"],
                                                              style: GoogleFonts
                                                                  .manrope(
                                                                fontSize:
                                                                    width *
                                                                        0.01,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                            Text(
                                                              "Description: ${data["description"]}",
                                                              style: GoogleFonts
                                                                  .manrope(),
                                                            ),
                                                            Text(
                                                              "Venue: ${data["venue"].toString()}",
                                                              style: GoogleFonts
                                                                  .manrope(),
                                                            ),
                                                            Text(
                                                              "Date: ${data["date"]}",
                                                              style: GoogleFonts
                                                                  .manrope(),
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          children: [
                                                            IconButton(
                                                                onPressed:
                                                                    () {
                                                                      approveEvent(data["email"], data["title"], data["date"]);
                                                                    },
                                                                icon:
                                                                    const Icon(
                                                                  Icons.done,
                                                                  color: Colors
                                                                      .green,
                                                                )),
                                                            // const SizedBox(width: 5,),
                                                            IconButton(
                                                                onPressed:
                                                                    () {},
                                                                icon:
                                                                    const Icon(
                                                                  Icons.delete,
                                                                  color: Colors
                                                                      .red,
                                                                )),
                                                          ],
                                                        )
                                                      ]);
                                                },
                                              );
                                            }),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Footer(),
                    ],
                  ),
                ),
              ],
            ),
          );
  }
}
