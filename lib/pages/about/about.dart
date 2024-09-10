import 'package:flutter/material.dart';
import 'package:gecap/components/appbar/appbar.dart';
import 'package:gecap/components/footer/footer.dart';
import 'package:google_fonts/google_fonts.dart';

class About extends StatefulWidget {
  const About({super.key});

  @override
  State<About> createState() => _AboutState();
}

class _AboutState extends State<About> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    double titleFontSize = width * 0.02;
    // double subtitleFontSize = width * 0.015;
    double toolbarHeight = height * 0.2;
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          Appbar(toolbarHeight: toolbarHeight, titleFontSize: titleFontSize),
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
                        "About",
                        style: GoogleFonts.manrope(
                          fontSize: width * 0.02,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                              onPressed: () {}, icon: const Icon(Icons.share)),
                          IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.facebook)),
                          IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.newspaper)),
                        ],
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 20, left: 15, right: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome to the Alumni Platform of Government Engineering College (GECAP)',
                        style: GoogleFonts.manrope(
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16.0),
                      Text(
                        'Our college has a rich legacy of producing exceptional engineers, innovators, and leaders who have made significant contributions to various fields globally. This platform serves as a bridge between the past and present, fostering a strong network of alumni, students, and faculty members.',
                        style: GoogleFonts.manrope(fontSize: 16.0),
                      ),
                      SizedBox(height: 16.0),
                      Text(
                        'Our Mission',
                        style: GoogleFonts.manrope(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        'Our mission is to build a vibrant and supportive alumni community that helps current students and recent graduates navigate their careers while maintaining lifelong ties with their alma mater.',
                        style: GoogleFonts.manrope(fontSize: 16.0),
                      ),
                      SizedBox(height: 16.0),
                      Text(
                        'Through our Alumni Platform, you can:',
                        style: GoogleFonts.manrope(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      BulletPoint(
                          text:
                              'Reconnect with former classmates and stay in touch.'),
                      BulletPoint(
                          text: 'Find alumni in your industry and network.'),
                      BulletPoint(
                          text:
                              'Post and apply for job openings through the alumni network.'),
                      BulletPoint(
                          text: 'Participate in events like reunions, seminars.'),
                      BulletPoint(
                          text:
                              'Engage in mentorship programs for professional guidance.'),
                      BulletPoint(
                          text:
                              'Stay updated with college news, achievements, and events.'),
                      SizedBox(height: 16.0),
                      Text(
                        'Conclusion',
                        style: GoogleFonts.manrope(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        'By joining this network, you become part of a global family that continues to uphold the values and standards of excellence that define Government Engineering College.',
                        style: GoogleFonts.manrope(fontSize: 16.0),
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

class BulletPoint extends StatelessWidget {
  final String text;
  const BulletPoint({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '• ',
            style: GoogleFonts.manrope(fontSize: 16.0, height: 1.5),
          ),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.manrope(fontSize: 16.0, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}
