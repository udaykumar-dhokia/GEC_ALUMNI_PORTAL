import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gecap/components/appbar/appbar.dart';
import 'package:gecap/components/footer/footer.dart';
import 'package:gecap/constants/color.dart';
import 'package:google_fonts/google_fonts.dart';

class Event extends StatefulWidget {
  const Event({super.key});

  @override
  State<Event> createState() => _EventState();
}

class _EventState extends State<Event> {
  bool isLoading = false;
  User? user = FirebaseAuth.instance.currentUser;
  String? selectedCollege;
  List<Map<String, dynamic>> events = [];
  String errorMessage = "";

  final List<String> colleges = [
    "Government Engineering College, Godhra",
    "Government Engineering College, Valsad",
    "Vishwakarma Government Engineering College, Chandkheda, Gandhinagar",
    "Government Engineering College, Bharuch",
    "L.E.College, Morbi",
    "Government Engineering College, Modasa",
    "Government Engineering College, Patan",
    "Government Engineering College, Palanpur",
    "Government Engineering College, Sector 28 Gandhinagar",
    "Faculty Of Technology And Engineering (GIA), Dharmisinh Desai University (DDU), Nadiad",
    "Government Engineering College, Dahod",
    "Government Engineering College, Bhuj",
    "Shantilal Shah Engineering College, Bhavnagar",
    "Government Engineering College, Rajkot",
    "DR. S & S.S. Ghandhi Government Engineering College, Surat",
    "L.D. College Of Engineering, Ahmedabad",
    "Government Engineering College, Bhavnagar",
    "Birla Vishvakarma Maha Vidhyalaya (GIA), V.V. Nagar",
    "Faculty Of Technology & Engineering (MSU), Vadodara",
  ];

  void getData(String college) async {
    setState(() {
      isLoading = true;
      errorMessage = "";
      events.clear(); // Clear the list at the start
    });

    try {
      final etotal = await FirebaseFirestore.instance
          .collection("gec")
          .where('name', isEqualTo: college)
          .limit(1)
          .get();

      if (etotal.docs.isNotEmpty) {
        String id = etotal.docs.first.id;

        final data = await FirebaseFirestore.instance
            .collection("gec")
            .doc(id)
            .collection("event_request")
            .get();

        List<Map<String, dynamic>> fetchedEvents =
            data.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

        if (fetchedEvents.isEmpty) {
          setState(() {
            errorMessage = "No events available for the selected college.";
          });
        }

        setState(() {
          events.addAll(fetchedEvents);
        });
      } else {
        setState(() {
          errorMessage = "No events available for the selected college.";
        });
      } 
    } catch (e) {
      setState(() {
        errorMessage = 'Error fetching data: $e';
      });
      debugPrint('Error fetching data: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    double titleFontSize = width * 0.02;
    double toolbarHeight = height * 0.2;

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          Appbar(toolbarHeight: toolbarHeight, titleFontSize: titleFontSize),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Container(
                  height: MediaQuery.sizeOf(context).height,
                  child: Column(
                    children: [
                      const SizedBox(height: 40),
                      _buildHeader(width),
                      const SizedBox(height: 10),
                      _buildDropdown(),
                      const SizedBox(height: 40),
                      _buildEventsList(),
                      const SizedBox(height: 40),
                      // const Footer(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(double width) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Find alumni events in your college",
            style: GoogleFonts.manrope(
              fontSize: width * 0.02,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: DropdownButton<String>(
        style: GoogleFonts.manrope(),
        hint: Text(
          "Select a College",
          style: GoogleFonts.manrope(fontWeight: FontWeight.w600),
        ),
        value: selectedCollege,
        isExpanded: true,
        onChanged: (String? newValue) {
          setState(() {
            selectedCollege = newValue;
            if (newValue != null) {
              getData(newValue);
            }
          });
        },
        items: colleges.map((String college) {
          return DropdownMenuItem<String>(
            value: college,
            child: Text(
              college,
              style: GoogleFonts.manrope(),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildEventsList() {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: primary,
        ),
      );
    }

    if (errorMessage.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Text(
          errorMessage,
          style: GoogleFonts.manrope(
              color: Colors.red, fontWeight: FontWeight.w600),
        ),
      );
    }

    if (events.isEmpty) {
      return Container(
        height: MediaQuery.sizeOf(context).height / 2,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Text(
          selectedCollege == null? "Select the college from above dropdown. All events of that college will appear here." : "No events available for the selected college.",
          style: GoogleFonts.manrope(),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: events.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Number of columns
          crossAxisSpacing: 10, // Spacing between columns
          mainAxisSpacing: 10, // Spacing between rows
          childAspectRatio: 5,
        ),
        itemBuilder: (context, index) {
          final event = events[index];

          return Card(
            color: white,
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event['title'] ?? 'No title',
                    style: GoogleFonts.manrope(
                      fontSize: 16,
                      fontWeight: FontWeight.bold, // Bold title text
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Date: ${event['date'] ?? 'No date'}',
                    style: GoogleFonts.manrope(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[600], // Lighter text color for date
                    ),
                  ),
                  const SizedBox(height: 5), 
                  Expanded(
                    child: Text(
                      event['description'] ?? 'No description available',
                      style: GoogleFonts.manrope(
                        fontWeight: FontWeight.w400,
                        fontSize: 14, // Slightly smaller font for description
                      ),
                      overflow: TextOverflow
                          .ellipsis, // Truncate text if it's too long
                      maxLines: 2, // Limit description to 2 lines
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Venue: ${event['venue'] ?? 'No venue information'}',
                    style: GoogleFonts.manrope(
                      fontWeight: FontWeight.w500,
                      fontSize: 14, // Medium weight for venue text
                      color: Colors
                          .blueAccent, // Accent color for venue information
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
