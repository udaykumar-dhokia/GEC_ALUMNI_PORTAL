import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gecap/components/appbar/appbar.dart';
import 'package:gecap/components/footer/footer.dart';
import 'package:gecap/constants/color.dart';
import 'package:gecap/pages/mainpage/total_aumni.dart';
import 'package:google_fonts/google_fonts.dart';

class Mainpage extends StatefulWidget {
  const Mainpage({super.key});

  @override
  State<Mainpage> createState() => _MainpageState();
}

class _MainpageState extends State<Mainpage> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    List<Map<String, dynamic>> total = [];

    void totalAlumni() async {
      final data = await FirebaseFirestore.instance.collection("gec").get();
      for (var doc in data.docs) {
        setState(() {
          total.add(doc.data());
        });
      }
      print(total);
    }

    @override
    void initState() {
      // TODO: implement initState
      super.initState();
      totalAlumni();
    }

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
                Container(
                  height: height * 0.6,
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          height: height * 0.6,
                          width: width / 2,
                          decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [Colors.white60, Colors.white])),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Stack(
                          children: [
                            Container(
                              height: height * 0.6,
                              width: width / 2,
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage("lib/assets/acpc.webp"),
                                  fit: BoxFit.cover,
                                  filterQuality: FilterQuality.high,
                                  opacity: 0.9,
                                ),
                              ),
                            ),
                            Container(
                              height: height * 0.6,
                              width: width / 2,
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.transparent,
                                    Colors.white,
                                  ],
                                  begin: Alignment.centerRight,
                                  end: Alignment.centerLeft,
                                  stops: [0.0, 1.0],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Welcome to GECAP',
                              style: GoogleFonts.manrope(
                                fontSize: width * 0.03,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: height * 0.02),
                            Text(
                              'Join the Alumni Network of Government Engineering Colleges in Gujarat.',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.manrope(
                                fontSize: width * 0.015,
                                color: Colors.grey.shade700,
                              ),
                            ),
                            SizedBox(height: height * 0.03),
                            Row(
                              children: [
                                ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    elevation: 5,
                                    backgroundColor: primary,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: width * 0.025,
                                        vertical: height * 0.025),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                  ),
                                  child: Text(
                                    "Login",
                                    style: GoogleFonts.manrope(
                                      fontSize: width * 0.01,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: width * 0.025,
                                        vertical: height * 0.025),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                  ),
                                  child: Text(
                                    "Join now",
                                    style: GoogleFonts.manrope(
                                      fontSize: width * 0.01,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: width * 0.05, vertical: height * 0.05),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Portal Features",
                        style: GoogleFonts.manrope(
                          fontSize: width * 0.02,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: height * 0.03),
                      Wrap(
                        spacing: width * 0.01,
                        runSpacing: height * 0.01,
                        children: [
                          featureCard("Find Alumni", Icons.people, Colors.blue,
                              "Connect with fellow alumni from engineering colleges in Gujarat."),
                          featureCard(
                              "Post Job Openings",
                              Icons.work,
                              Colors.green,
                              "Share and explore job opportunities within the alumni network."),
                          featureCard(
                              "Upcoming Events",
                              Icons.event,
                              Colors.purple,
                              "Stay updated with upcoming alumni events and activities."),
                          featureCard(
                              "Mentorship Programs",
                              Icons.school,
                              Colors.orange,
                              "Join or offer mentorship to support fellow alumni or students."),
                        ],
                      ),
                    ],
                  ),
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

  /// The `featureCard` function creates a card widget with a title, icon, color, and description.
  ///
  /// Args:
  ///   title (String): The `title` parameter in the `featureCard` widget represents the title or heading
  /// that will be displayed on the card. It is a string value that you can customize to provide a brief
  /// description or name for the feature represented by the card.
  ///   icon (IconData): The `icon` parameter in the `featureCard` widget function is of type `IconData`.
  /// It is used to specify the icon that will be displayed in the card. You can pass an icon data such
  /// as `Icons.home`, `Icons.star`, `Icons.favorite`, etc., to represent different
  ///   color (Color): The `color` parameter in the `featureCard` widget function is used to specify the
  /// background color of the Card widget that is being created. In the provided code snippet, the color
  /// is set to a constant value `const Color(0xfff7ac1c)`. This color is a shade
  ///   description (String): The `description` parameter in the `featureCard` widget function is a
  /// string that represents the description or details of the feature being displayed on the card. It
  /// provides additional information about the feature to the user.
  ///
  /// Returns:
  ///   The `featureCard` function is returning a Container widget containing a Card widget with a
  /// specific color and shape. Inside the Card widget, there is a Padding widget with a Column
  /// containing an Icon, a Text widget for the title, and another Text widget for the description. The
  /// styling of the text and icon is based on the provided parameters and the width of the screen.
  Widget featureCard(
      String title, IconData icon, Color color, String description) {
    var width = MediaQuery.of(context).size.width;
    return Container(
      width: width * 0.4,
      child: Card(
        color: secondPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: EdgeInsets.all(width * 0.04),
          child: Column(
            children: [
              Icon(icon, size: width * 0.03, color: primary),
              SizedBox(height: width * 0.02),
              Text(
                title,
                textAlign: TextAlign.center,
                style: GoogleFonts.manrope(
                  fontSize: width * 0.015,
                  color: primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: width * 0.015),
              Text(
                description,
                textAlign: TextAlign.center,
                style: GoogleFonts.manrope(
                  fontSize: width * 0.01,
                  color: primary,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
