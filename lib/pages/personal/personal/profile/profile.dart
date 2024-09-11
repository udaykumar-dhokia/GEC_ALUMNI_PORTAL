import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gecap/constants/color.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gecap/components/appbar/dbappbar.dart'; // Import your custom appbar
import 'package:gecap/constants/color.dart';
import 'package:side_sheet/side_sheet.dart'; // Import your color definitions

class Profile extends StatefulWidget {
  const Profile({
    super.key,
  });

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Map<String, dynamic> details = {};
  User? user = FirebaseAuth.instance.currentUser;
  bool _isLoading = false;

  void getDetails() async {
    try {
      setState(() {
        _isLoading = true;
      });
      final data = await FirebaseFirestore.instance
          .collection("alumni")
          .doc(user!.email)
          .get();

      setState(() {
        details = data.data()!;
      });
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDetails();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return _isLoading
        ? const Scaffold(
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
                DBAppbar(
                  toolbarHeight: height * 0.1,
                  titleFontSize: width * 0.02,
                ),
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      Padding(
                        padding: EdgeInsets.all(width * 0.05),
                        child: Container(
                          padding: EdgeInsets.all(width * 0.04),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Profile",
                                style: GoogleFonts.manrope(
                                    fontSize: width * 0.02,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: height * 0.02),
                              _buildProfileItem(
                                  "Name:", details["name"], width),
                              _buildProfileItem(
                                  "Email:", details["email"], width),
                              _buildProfileItem(
                                  "College:", details["college"], width),
                              _buildProfileItem(
                                  "Enrollment:", details["enrollment"], width),
                              _buildProfileItem("Passout Year:",
                                  details["passout"].toString(), width),
                              SizedBox(height: height * 0.02),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
  }

  Widget _buildProfileItem(String label, String value, double width) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: width * 0.005),
      child: Row(
        children: [
          Text(
            label,
            style: GoogleFonts.manrope(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: primary,
            ),
          ),
          SizedBox(width: width * 0.02),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.manrope(
                fontSize: 16,
                color: Colors.blueGrey[600],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
