import 'package:flutter/material.dart';
import 'package:gecap/constants/color.dart';
import 'package:google_fonts/google_fonts.dart';

class Footer extends StatefulWidget {
  const Footer({super.key});

  @override
  State<Footer> createState() => _FooterState();
}

class _FooterState extends State<Footer> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: height * 0.03, horizontal: width * 0.05),
      color: primary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '© 2024 GECAP | Alumni Portal of Government Engineering Colleges, Gujarat',
            textAlign: TextAlign.center,
            style: GoogleFonts.manrope(
              color: Colors.white,
              fontSize: width * 0.01,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: height * 0.02),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              footerLink('GECAP'),
              SizedBox(width: width * 0.01),
              footerLink('Explore'),
              SizedBox(width: width * 0.01),
              footerLink('ACPC'),
              SizedBox(width: width * 0.01),
              footerLink('About'),
              SizedBox(width: width * 0.01),
              footerLink('Contact'),
            ],
          ),
        ],
      ),
    );
  }

  /// The `footerLink` function returns a clickable text widget styled as a footer link.
  ///
  /// Args:
  ///   text (String): The `text` parameter in the `footerLink` function is a string that represents the
  /// text content of the footer link that will be displayed to the user.
  ///
  /// Returns:
  ///   A `Widget` is being returned. The `Widget` returned is an `InkWell` widget containing a `Text`
  /// widget styled with Google Fonts. The `InkWell` widget has an `onTap` function that can be used to
  /// handle taps on the footer link, such as navigating to different pages.
  Widget footerLink(String text) {
    return InkWell(
      onTap: () {
      },
      child: Text(
        text,
        style: GoogleFonts.manrope(
          color: Colors.white,
          fontSize: 14,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}
