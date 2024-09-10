import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DashboardApp extends StatefulWidget {
  var toolbarHeight;
  var titleFontSize;
  DashboardApp(
      {super.key, required this.toolbarHeight, required this.titleFontSize});
  @override
  State<DashboardApp> createState() => _DashboardAppState();
}

class _DashboardAppState extends State<DashboardApp> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return SliverAppBar(
      expandedHeight: height * 0.2,
      floating: true,
      surfaceTintColor: Colors.white,
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
              Image(
                image: AssetImage("lib/assets/header.png"),
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
                    // onTap: () {
                    //   Navigator.push(
                    //     context,
                    //     PageRouteBuilder(
                    //       pageBuilder:
                    //           (context, animation, secondaryAnimation) =>
                    //               const Mainpage(),
                    //       transitionsBuilder:
                    //           (context, animation, secondaryAnimation, child) {
                    //         const begin = 0.0;
                    //         const end = 1.0;
                    //         const curve = Curves.easeInOut;

                    //         var tween = Tween(begin: begin, end: end)
                    //             .chain(CurveTween(curve: curve));
                    //         var fadeAnimation = animation.drive(tween);

                    //         return FadeTransition(
                    //           opacity: fadeAnimation,
                    //           child: child,
                    //         );
                    //       },
                    //     ),
                    //   );
                    // },
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
                    // onTap: () {
                    //   Navigator.push(
                    //     context,
                    //     PageRouteBuilder(
                    //       pageBuilder:
                    //           (context, animation, secondaryAnimation) =>
                    //               const Explore(),
                    //       transitionsBuilder:
                    //           (context, animation, secondaryAnimation, child) {
                    //         const begin = 0.0;
                    //         const end = 1.0;
                    //         const curve = Curves.easeInOut;

                    //         var tween = Tween(begin: begin, end: end)
                    //             .chain(CurveTween(curve: curve));
                    //         var fadeAnimation = animation.drive(tween);

                    //         return FadeTransition(
                    //           opacity: fadeAnimation,
                    //           child: child,
                    //         );
                    //       },
                    //     ),
                    //   );
                    // },
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
                    // onTap: () {
                    //   Navigator.push(
                    //     context,
                    //     PageRouteBuilder(
                    //       pageBuilder:
                    //           (context, animation, secondaryAnimation) =>
                    //               const About(),
                    //       transitionsBuilder:
                    //           (context, animation, secondaryAnimation, child) {
                    //         const begin = 0.0;
                    //         const end = 1.0;
                    //         const curve = Curves.easeInOut;

                    //         var tween = Tween(begin: begin, end: end)
                    //             .chain(CurveTween(curve: curve));
                    //         var fadeAnimation = animation.drive(tween);

                    //         return FadeTransition(
                    //           opacity: fadeAnimation,
                    //           child: child,
                    //         );
                    //       },
                    //     ),
                    //   );
                    // },
                    child: Text(
                      "About",
                      style: GoogleFonts.manrope(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "Contact",
                    style: GoogleFonts.manrope(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  InkWell(
                    // onTap: () {
                    //   Navigator.push(
                    //     context,
                    //     PageRouteBuilder(
                    //       pageBuilder:
                    //           (context, animation, secondaryAnimation) =>
                    //               const Login(),
                    //       transitionsBuilder:
                    //           (context, animation, secondaryAnimation, child) {
                    //         const begin = 0.0;
                    //         const end = 1.0;
                    //         const curve = Curves.easeInOut;

                    //         var tween = Tween(begin: begin, end: end)
                    //             .chain(CurveTween(curve: curve));
                    //         var fadeAnimation = animation.drive(tween);

                    //         return FadeTransition(
                    //           opacity: fadeAnimation,
                    //           child: child,
                    //         );
                    //       },
                    //     ),
                    //   );
                    // },
                    child: Text(
                      "profile",
                      style: GoogleFonts.manrope(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  // Text(
                  //   "GECAP App",
                  //   style: GoogleFonts.manrope(
                  //     color: Colors.white,
                  //     fontSize: 16,
                  //   ),
                  // ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
