import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gecap/components/appbar/dbappbar.dart';
import 'package:gecap/components/footer/footer.dart';
import 'package:gecap/constants/color.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:side_sheet/side_sheet.dart';

class Jobs extends StatefulWidget {
  const Jobs({super.key});

  @override
  State<Jobs> createState() => _JobsState();
}

class _JobsState extends State<Jobs> {
  TextEditingController _title = TextEditingController();
  TextEditingController _description = TextEditingController();
  TextEditingController _venue = TextEditingController();
  User? user = FirebaseAuth.instance.currentUser;

  void addJob(final data) async {
    try {
      final job = await FirebaseFirestore.instance.collection("jobs").add(data);
      _title.clear();
      _description.clear();
      _venue.clear();
      Navigator.pop(context);
      CherryToast.success(
        animationType: AnimationType.fromTop,
        title: const Text(
          "Successfully posted job.",
          style: TextStyle(color: Colors.black),
        ),
      ).show(context);
    } catch (e) {
      CherryToast.error(
        animationType: AnimationType.fromTop,
        title: Text("Error: $e", style: const TextStyle(color: Colors.black)),
      ).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    double titleFontSize = width * 0.02;
    double toolbarHeight = height * 0.2;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          SideSheet.right(
              width: width / 2,
              body: Scaffold(
                floatingActionButton: FloatingActionButton(
                  shape: const CircleBorder(),
                  backgroundColor: primary,
                  onPressed: () {
                    if (_title.text.isEmpty ||
                        _description.text.isEmpty ||
                        _venue.text.isEmpty) {
                      CherryToast.error(
                        animationType: AnimationType.fromTop,
                        title: const Text("Please fill up all the fields.",
                            style: TextStyle(color: Colors.black)),
                      ).show(context);
                    } else {
                      final data = {
                        "title": _title.text,
                        "description": _description.text,
                        "venue": _venue.text,
                        "postedBy": user!.email,
                      };
                      addJob(data);
                    }
                  },
                  child: const Icon(
                    Icons.done,
                    color: white,
                  ),
                ),
                backgroundColor: white,
                body: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 30),
                      Text(
                        "Job Details",
                        style: GoogleFonts.manrope(
                            fontSize: 24,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: _title,
                        decoration: InputDecoration(
                          labelText: "Job Title",
                          labelStyle: GoogleFonts.manrope(),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _description,
                        decoration: InputDecoration(
                          labelText: "Description",
                          labelStyle: GoogleFonts.manrope(),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _venue,
                        decoration: InputDecoration(
                          labelText: "Job Venue",
                          labelStyle: GoogleFonts.manrope(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              context: context);
        },
        shape: const CircleBorder(),
        backgroundColor: primary,
        child: const Icon(
          Icons.add,
          color: white,
        ),
      ),
      backgroundColor: white,
      body: CustomScrollView(
        slivers: [
          DBAppbar(toolbarHeight: toolbarHeight, titleFontSize: titleFontSize),
          SliverList(
            delegate: SliverChildListDelegate([
              Container(
                height: height/1.4,
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20,),
                    Text("Jobs", style: GoogleFonts.manrope(fontSize: width*0.02, fontWeight: FontWeight.bold),),
                    const SizedBox(height: 15,),
                    StreamBuilder<QuerySnapshot>(
                      stream:
                          FirebaseFirestore.instance.collection('jobs').snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                    
                        if (snapshot.hasError) {
                          return Center(
                            child: Text(
                              'Error: ${snapshot.error}',
                              style: GoogleFonts.epilogue(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.red,
                              ),
                            ),
                          );
                        }
                    
                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return Padding(
                            padding: const EdgeInsets.all(15),
                            child: Text(
                              'No jobs available',
                              style: GoogleFonts.manrope(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                          );
                        }
                    
                        final jobs = snapshot.data!.docs;
                    
                        return Table(
                          border: TableBorder.all(),
                          columnWidths: const {
                            0: FlexColumnWidth(1),
                            1: FlexColumnWidth(2),
                            2: FlexColumnWidth(1),
                          },
                          children: [
                            TableRow(
                              children: [
                                TableCell(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Title',
                                      style: GoogleFonts.epilogue(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                                TableCell(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Description',
                                      style: GoogleFonts.epilogue(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                                TableCell(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Venue',
                                      style: GoogleFonts.epilogue(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            for (var job in jobs) ...[
                              TableRow(
                                children: [
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        (job.data()
                                                as Map<String, dynamic>)['title'] ??
                                            'No title',
                                        style: GoogleFonts.epilogue(
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ),
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        (job.data() as Map<String, dynamic>)[
                                                'description'] ??
                                            'No description',
                                        style: GoogleFonts.epilogue(
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ),
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        (job.data()
                                                as Map<String, dynamic>)['venue'] ??
                                            'No venue',
                                        style: GoogleFonts.epilogue(
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
              const Footer()
            ]),
          ),
        ],
      ),
    );
  }
}
