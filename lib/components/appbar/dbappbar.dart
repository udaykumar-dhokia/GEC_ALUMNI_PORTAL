import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gecap/pages/personal/personal/dashboard/dashboard.dart';
import 'package:gecap/pages/personal/personal/event/event.dart';
import 'package:gecap/pages/personal/personal/profile/profile.dart';
import 'package:gecap/pages/personal/personal/support/support.dart';
import 'package:google_fonts/google_fonts.dart';

class DBAppbar extends StatefulWidget {
  final double toolbarHeight;
  final double titleFontSize;

  DBAppbar(
      {super.key, required this.toolbarHeight, required this.titleFontSize});

  @override
  State<DBAppbar> createState() => _DBAppbarState();
}

class _DBAppbarState extends State<DBAppbar> {
  Map<String, dynamic>? details;
  Map<String, dynamic>? alumniData;
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

       final data2 = await FirebaseFirestore.instance
          .collection("alumni")
          .doc(user!.email)
          .get();
      setState(() {
        details = data.data();
        alumniData = data2.data();
        _isLoading = false;
      });
    } catch (e) {
      return;
    }
  }
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return SliverAppBar(
      expandedHeight: height * 0.2,
      floating: true,
      snap: true,
      pinned: true,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      flexibleSpace: FlexibleSpaceBar(
        title: Padding(
          padding: const EdgeInsets.only(bottom: 30, left: 15, right: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "GECAP",
                style: GoogleFonts.manrope(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xff052963),
                  fontSize: widget.titleFontSize,
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "સરકારી એન્જિનિયરિંગ કોલેજ એલ્યુમની પોર્ટલ (GECAP), ગુજરાત",
                    style: GoogleFonts.manrope(
                      color: const Color(0xff052963),
                      fontSize: width * 0.009,
                    ),
                  ),
                  Text(
                    "Government Engineering College Alumni Portal (GECAP), Gujarat",
                    style: GoogleFonts.manrope(
                      color: const Color(0xff052963),
                      fontSize: width * 0.01,
                    ),
                  ),
                ],
              ),
              Image.asset(
                "lib/assets/header.png",
                width: width * 0.065,
              ),
            ],
          ),
        ),
        centerTitle: true,
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(45),
        child: Container(
          height: 45,
          color: const Color(0xff052963),
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  const Dashboard(),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            const begin = 0.0;
                            const end = 1.0;
                            const curve = Curves.easeInOut;

                            var tween = Tween(begin: begin, end: end)
                                .chain(CurveTween(curve: curve));
                            var fadeAnimation = animation.drive(tween);

                            return FadeTransition(
                              opacity: fadeAnimation,
                              child: child,
                            );
                          },
                        ),
                      );
                    },
                    child: Text(
                      "Dashboard",
                      style: GoogleFonts.manrope(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  const Event(),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            const begin = 0.0;
                            const end = 1.0;
                            const curve = Curves.easeInOut;

                            var tween = Tween(begin: begin, end: end)
                                .chain(CurveTween(curve: curve));
                            var fadeAnimation = animation.drive(tween);

                            return FadeTransition(
                              opacity: fadeAnimation,
                              child: child,
                            );
                          },
                        ),
                      );
                    },
                    child: Text(
                      "Events",
                      style: GoogleFonts.manrope(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  Support(alumniData: alumniData,),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            const begin = 0.0;
                            const end = 1.0;
                            const curve = Curves.easeInOut;

                            var tween = Tween(begin: begin, end: end)
                                .chain(CurveTween(curve: curve));
                            var fadeAnimation = animation.drive(tween);

                            return FadeTransition(
                              opacity: fadeAnimation,
                              child: child,
                            );
                          },
                        ),
                      );
                    },
                    child: Text(
                      "Support",
                      style: GoogleFonts.manrope(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                ],
              ),
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) {
                            String passoutStr =
                                "passout";
                            int passoutYear;

                            try {
                              passoutYear = int.parse(passoutStr);
                            } catch (e) {
                              print("Error parsing passout year: $e");
                              passoutYear = 0;
                            }
                            return Profile(
                              name: "name", // Replace with actual data
                              email: "email", // Replace with actual data
                              college: "college", // Replace with actual data
                              enrollment:
                                  "enrollment", // Replace with actual data
                              passout: passoutYear,
                            );
                          },
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            const begin = 0.0;
                            const end = 1.0;
                            const curve = Curves.easeInOut;

                            var tween = Tween(begin: begin, end: end)
                                .chain(CurveTween(curve: curve));
                            var fadeAnimation = animation.drive(tween);

                            return FadeTransition(
                              opacity: fadeAnimation,
                              child: child,
                            );
                          },
                        ),
                      );
                    },
                    child: Text(
                      "Profile",
                      style: GoogleFonts.manrope(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "GECAP App",
                    style: GoogleFonts.manrope(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
