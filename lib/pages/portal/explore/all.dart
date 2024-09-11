import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gecap/components/appbar/appbar.dart';
import 'package:gecap/components/appbar/institute_appbar.dart';
import 'package:gecap/components/footer/footer.dart';
import 'package:gecap/constants/color.dart';
import 'package:google_fonts/google_fonts.dart';

class All extends StatefulWidget {
  String name;
  All({super.key, required this.name});

  @override
  State<All> createState() => _AllState();
}

class _AllState extends State<All> {
  Map<String, dynamic>? details;
  bool _isLoading = false;
  List<Map<String, dynamic>> alumni = [];

  void getData() async {
    try {
      setState(() {
        _isLoading = true;
      });
      final data = await FirebaseFirestore.instance
          .collection("alumni")
          .where("college", isEqualTo: widget.name)
          .get();

      if(data.docs.isNotEmpty){
       for(var doc in data.docs){
        setState(() {
          alumni.add(doc.data());
        });
       }
      }
      print(alumni);

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      return;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    double titleFontSize = width * 0.02;
    // double subtitleFontSize = width * 0.015;
    double toolbarHeight = height * 0.2;
    return _isLoading
        ? const Scaffold(
            backgroundColor: white,
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
                Appbar(
                  toolbarHeight: toolbarHeight,
                  titleFontSize: titleFontSize,
                ),
                SliverList(
                    delegate: SliverChildListDelegate([
                  Container(
                    height: height / 1.5,
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          "${widget.name} Alumni",
                          style: GoogleFonts.manrope(
                              fontSize: width * 0.02,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Table(
                          border: TableBorder.all(),
                          children: [
                            TableRow(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Name",
                                    style: GoogleFonts.manrope(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("Passout",
                                      style: GoogleFonts.manrope(
                                        fontWeight: FontWeight.w600,
                                      )),
                                ),  
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("Contact",
                                      style: GoogleFonts.manrope(
                                        fontWeight: FontWeight.w600,
                                      )),
                                ),
                              ],
                            ),
                            for (var a in alumni)
                              TableRow(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(a['name'] ?? 'No Name',
                                        style: GoogleFonts
                                            .manrope()),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      a['passout'].toString(),
                                      style: GoogleFonts.manrope(),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      a['email'].toString(),
                                      style: GoogleFonts.manrope(),
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Footer(),
                ]))
              ],
            ),
          );
  }
}
