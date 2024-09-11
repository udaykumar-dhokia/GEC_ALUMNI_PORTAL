import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gecap/components/appbar/dbappbar.dart';
import 'package:gecap/constants/color.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    double toolbarHeight = height * 0.2;
    double titleFontSize = width * 0.02;

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          DBAppbar(toolbarHeight: toolbarHeight, titleFontSize: titleFontSize),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                const SizedBox(height: 40),
                Container(
                  padding: EdgeInsets.all(width * 0.05),
                  child: Text(
                    'Upcoming Events',
                    style: GoogleFonts.manrope(
                      fontSize: width * 0.03,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(width * 0.05),
                  child: Column(
                    children: List.generate(
                      5,
                      (index) => ListTile(
                        title: Text(
                          'Event $index',
                          style: GoogleFonts.manrope(fontSize: width * 0.02),
                        ),
                        subtitle: Text(
                          'Event details here',
                          style: GoogleFonts.manrope(fontSize: width * 0.015),
                        ),
                      ),
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
}
