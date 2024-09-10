import 'package:flutter/material.dart';
import 'package:gecap/constants/color.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gecap/components/appbar/dbappbar.dart'; // Import your custom appbar
import 'package:gecap/constants/color.dart'; // Import your color definitions

class Profile extends StatelessWidget {
  final String name;
  final String email;
  final String college;
  final String enrollment;
  final int passout;

  const Profile({
    Key? key,
    required this.name,
    required this.email,
    required this.college,
    required this.enrollment,
    required this.passout,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          DBAppbar(
            toolbarHeight: height * 0.1, // Adjust as needed
            titleFontSize: width * 0.02, // Adjust as needed
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
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildProfileItem("Name:", name, width),
                        _buildProfileItem("Email:", email, width),
                        _buildProfileItem("College:", college, width),
                        _buildProfileItem("Enrollment:", enrollment, width),
                        _buildProfileItem(
                            "Passout Year:", passout.toString(), width),
                        SizedBox(height: height * 0.02),
                        Center(
                          child: ElevatedButton(
                            onPressed: () {
                              // Handle button press
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primary,
                              padding: EdgeInsets.symmetric(
                                horizontal: width * 0.1,
                                vertical: height * 0.015,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: Text(
                              "Edit Profile",
                              style: GoogleFonts.manrope(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
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
