import 'dart:io';

import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gecap/components/appbar/appbar.dart';
import 'package:gecap/components/footer/footer.dart';
import 'package:gecap/constants/color.dart';
import 'package:gecap/pages/portal/login/login.dart';
import 'package:gecap/pages/portal/mainpage/mainpage.dart';
import 'package:google_fonts/google_fonts.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _name = TextEditingController();
  TextEditingController _year = TextEditingController();
  TextEditingController _college = TextEditingController();
  TextEditingController _confirm = TextEditingController();
  TextEditingController _enroll = TextEditingController();
  bool _isPasswordVisible = false;
  bool _confirmVisible = false;
  bool _isLoading = false;
  File? _profileImage;
  final List<String> colleges = [
    "Government Engineering College, Godhra",
    "Government Engineering College, Valsad",
    "Vishwakarma Government Engineering College, Chandkheda, Gandhinagar",
    "Government Engineering College, Bharuch",
    "L.E.College , Morbi",
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
  final List<String> years = [
    "2024",
    "2023",
    "2022",
    "2021",
    "2020",
    "2019",
    "2018",
    "2017",
    "2016",
    "2015",
    "2014",
    "2013",
    "2012",
    "2011",
    "2010",
    "2009",
    "2008",
    "2007",
    "2006",
    "2005",
    "2004",
    "2003",
    "2002",
    "2001",
    "2000"
  ];

  String? selectedCollege;
  String? selectedYear;

  Future<void> _pickProfileImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png'],
    );
    if (result != null) {
      print(result);
      setState(() {
        _profileImage = File(result.files.single.path!);
      });
    } else {
      // User canceled the picker
      print("No file selected");
    }
  }

  void SignUp(String email, String password, final alumniData) async {
    try {
      setState(() {
        _isLoading = true;
      });
      final data = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      final alumni = await FirebaseFirestore.instance
          .collection("alumni")
          .doc(email)
          .set(alumniData);

      final gecQuerySnapshot = await FirebaseFirestore.instance
          .collection("gec")
          .where("name", isEqualTo: alumniData["college"])
          .limit(1)
          .get();

      if (gecQuerySnapshot.docs.isNotEmpty) {
        print(gecQuerySnapshot.docs);
        final gecDoc = gecQuerySnapshot.docs.first;

         await FirebaseFirestore.instance
            .collection("gec")
            .doc(gecDoc.id)
            .collection("alumni_request")
            .add(alumniData);

        await FirebaseFirestore.instance
            .collection("gec")
            .doc(gecDoc.id)
            .update({
          "total": FieldValue.increment(1),
        });
      }

      setState(() {
        _isLoading = false;
      });

      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const Mainpage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = 0.0;
            const end = 1.0;
            const curve = Curves.easeInOut;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var fadeAnimation = animation.drive(tween);

            return FadeTransition(
              opacity: fadeAnimation,
              child: child,
            );
          },
        ),
      );

      CherryToast.success(
        animationType: AnimationType.fromTop,
        title: const Text("Registration successfull. Wait for institute to verify.",
            style: TextStyle(color: Colors.black)),
      ).show(context);
    } catch (e) {
      print(e);
      CherryToast.error(
        animationType: AnimationType.fromTop,
        title: const Text("Something went wrong.",
            style: TextStyle(color: Colors.black)),
        actionHandler: () {
          print("Action button pressed");
        },
      ).show(context);
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    double titleFontSize = width * 0.02;
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
                    toolbarHeight: toolbarHeight, titleFontSize: titleFontSize),
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      const SizedBox(
                        height: 100,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.only(left: 50, right: 50),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      bottomLeft: Radius.circular(20),
                                    ),
                                  ),
                                  width: width * 0.5 - 100,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 100, right: 100),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Join Now',
                                          style: GoogleFonts.manrope(
                                            textStyle: TextStyle(
                                              fontSize: titleFontSize * 1.2,
                                              fontWeight: FontWeight.bold,
                                              color: const Color.fromARGB(
                                                  255, 29, 29, 29),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          'Register yourself by providing your details.',
                                          style: GoogleFonts.manrope(
                                            textStyle: TextStyle(
                                              fontSize: titleFontSize * 0.5,
                                              color: const Color.fromARGB(
                                                  255, 29, 29, 29),
                                            ),
                                          ),
                                        ),
                                        // const SizedBox(height: 20),
                                        // GestureDetector(
                                        //   onTap: () {
                                        //     _pickProfileImage();
                                        //   },
                                        //   child: Container(
                                        //     padding: const EdgeInsets.only(
                                        //         left: 10, bottom: 10),
                                        //     width: double.infinity,
                                        //     child: Stack(
                                        //       children: [
                                        //         GestureDetector(
                                        //           onTap: () {},
                                        //           child: Align(
                                        //             alignment:
                                        //                 Alignment.bottomLeft,
                                        //             child: CircleAvatar(
                                        //               radius: 40,
                                        //               backgroundImage:
                                        //                   _profileImage != null
                                        //                       ? FileImage(
                                        //                           _profileImage!)
                                        //                       : const AssetImage(
                                        //                           "lib/assets/user.jpg"),
                                        //               backgroundColor: white,
                                        //               child: GestureDetector(
                                        //                 onTap: () {
                                        //                   _pickProfileImage();
                                        //                 },
                                        //                 child: const Align(
                                        //                   alignment: Alignment
                                        //                       .bottomRight,
                                        //                   child: CircleAvatar(
                                        //                     radius: 15,
                                        //                     backgroundColor:
                                        //                         black,
                                        //                     child: Icon(
                                        //                       Icons.add,
                                        //                       color: white,
                                        //                     ),
                                        //                   ),
                                        //                 ),
                                        //               ),
                                        //             ),
                                        //           ),
                                        //         ),
                                        //       ],
                                        //     ),
                                        //   ),
                                        // ),
                                        const SizedBox(height: 30),
                                        Container(
                                          decoration: const BoxDecoration(
                                            color: Colors.white,
                                          ),
                                          child: Column(
                                            children: [
                                              Container(
                                                width: 500,
                                                child: DropdownButton<String>(
                                                  style: GoogleFonts.manrope(),
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  hint: Text(
                                                    "Select a College",
                                                    style: GoogleFonts.manrope(
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                  value: selectedCollege,
                                                  isExpanded: true,
                                                  onChanged:
                                                      (String? newValue) {
                                                    setState(() {
                                                      selectedCollege =
                                                          newValue;
                                                    });
                                                  },
                                                  items: colleges
                                                      .map((String college) {
                                                    return DropdownMenuItem<
                                                        String>(
                                                      value: college,
                                                      child: Text(
                                                        college,
                                                        style: GoogleFonts
                                                            .manrope(),
                                                      ),
                                                    );
                                                  }).toList(),
                                                ),
                                              ),
                                              const SizedBox(height: 10),
                                              Container(
                                                width: 500,
                                                child: DropdownButton<String>(
                                                  style: GoogleFonts.manrope(),
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  hint: Text(
                                                    "Select Year of Passout",
                                                    style: GoogleFonts.manrope(
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                  value: selectedYear,
                                                  isExpanded: true,
                                                  onChanged:
                                                      (String? newValue) {
                                                    setState(() {
                                                      selectedYear = newValue;
                                                    });
                                                  },
                                                  items: years
                                                      .map((String college) {
                                                    return DropdownMenuItem<
                                                        String>(
                                                      value: college,
                                                      child: Text(
                                                        college,
                                                        style: GoogleFonts
                                                            .manrope(),
                                                      ),
                                                    );
                                                  }).toList(),
                                                ),
                                              ),
                                              const SizedBox(height: 10),
                                              TextField(
                                                cursorColor: black,
                                                controller: _enroll,
                                                keyboardType:
                                                    TextInputType.number,
                                                decoration: InputDecoration(
                                                    labelText:
                                                        'Enrollment/Roll no.',
                                                    labelStyle:
                                                        GoogleFonts.manrope(
                                                            color: black),
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                    ),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                      borderSide:
                                                          const BorderSide(
                                                              color: primary),
                                                    )),
                                              ),
                                              const SizedBox(height: 10),
                                              TextField(
                                                cursorColor: black,
                                                controller: _name,
                                                decoration: InputDecoration(
                                                    labelText: 'Name',
                                                    labelStyle:
                                                        GoogleFonts.manrope(
                                                            color: black),
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                    ),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                      borderSide:
                                                          const BorderSide(
                                                              color: primary),
                                                    )),
                                              ),
                                              const SizedBox(height: 10),
                                              TextField(
                                                cursorColor: black,
                                                controller: _emailController,
                                                keyboardType:
                                                    TextInputType.emailAddress,
                                                decoration: InputDecoration(
                                                    labelText: 'Email',
                                                    labelStyle:
                                                        GoogleFonts.manrope(
                                                            color: black),
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                    ),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                      borderSide:
                                                          const BorderSide(
                                                              color: primary),
                                                    )),
                                              ),
                                              const SizedBox(height: 10),
                                              TextField(
                                                cursorColor: black,
                                                controller: _passwordController,
                                                obscureText:
                                                    !_isPasswordVisible,
                                                decoration: InputDecoration(
                                                  labelStyle:
                                                      GoogleFonts.manrope(
                                                          color: black),
                                                  labelText: 'Password',
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                    borderSide:
                                                        const BorderSide(
                                                            color: primary),
                                                  ),
                                                  suffixIcon: IconButton(
                                                    icon: Icon(
                                                      _isPasswordVisible
                                                          ? Icons.visibility
                                                          : Icons
                                                              .visibility_off,
                                                    ),
                                                    onPressed: () {
                                                      setState(() {
                                                        _isPasswordVisible =
                                                            !_isPasswordVisible;
                                                      });
                                                    },
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 10),
                                              TextField(
                                                cursorColor: black,
                                                controller: _confirm,
                                                obscureText: !_confirmVisible,
                                                decoration: InputDecoration(
                                                  labelStyle:
                                                      GoogleFonts.manrope(
                                                          color: black),
                                                  labelText: 'Confirm Password',
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                    borderSide:
                                                        const BorderSide(
                                                            color: primary),
                                                  ),
                                                  suffixIcon: IconButton(
                                                    icon: Icon(
                                                      _confirmVisible
                                                          ? Icons.visibility
                                                          : Icons
                                                              .visibility_off,
                                                    ),
                                                    onPressed: () {
                                                      setState(() {
                                                        _confirmVisible =
                                                            !_confirmVisible;
                                                      });
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        SizedBox(
                                          width: double.infinity,
                                          height: 50,
                                          child: ElevatedButton(
                                            onPressed: () {
                                              if (_name.text.isEmpty ||
                                                  _emailController
                                                      .text.isEmpty ||
                                                  _passwordController
                                                      .text.isEmpty ||
                                                  _confirm.text.isEmpty ||
                                                  selectedCollege == null ||
                                                  _enroll.text.isEmpty ||
                                                  selectedYear == null) {
                                                CherryToast.success(
                                                  animationType:
                                                      AnimationType.fromTop,
                                                  title: const Text(
                                                      "Please fill up all details.",
                                                      style: TextStyle(
                                                          color: Colors.black)),
                                                  actionHandler: () {
                                                    print(
                                                        "Action button pressed");
                                                  },
                                                ).show(context);
                                              } else if (_passwordController
                                                      .text.isEmpty !=
                                                  _confirm.text.isEmpty) {
                                                CherryToast.success(
                                                  animationType:
                                                      AnimationType.fromTop,
                                                  title: const Text(
                                                      "Password mismatched.",
                                                      style: TextStyle(
                                                          color: Colors.black)),
                                                  actionHandler: () {
                                                    print(
                                                        "Action button pressed");
                                                  },
                                                ).show(context);
                                              } else {
                                                final data = {
                                                  "name": _name.text,
                                                  "email":
                                                      _emailController.text,
                                                  "password":
                                                      _passwordController.text,
                                                  "college": selectedCollege,
                                                  "enrollment": _enroll.text,
                                                  "passout":
                                                      int.parse(selectedYear!),
                                                  "isVerified": false,
                                                };

                                                SignUp(
                                                    _emailController.text,
                                                    _passwordController.text,
                                                    data);
                                              }
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: primary,
                                              padding: const EdgeInsets.all(0),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                            ),
                                            child: Ink(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: Container(
                                                alignment: Alignment.center,
                                                child: Text(
                                                  'Sign In',
                                                  style: TextStyle(
                                                    fontSize:
                                                        titleFontSize * 0.6,
                                                    color: white,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Already registered?",
                                              style: GoogleFonts.manrope(
                                                fontSize: titleFontSize * 0.5,
                                                color: const Color.fromARGB(
                                                    255, 29, 29, 29),
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  PageRouteBuilder(
                                                    pageBuilder: (context,
                                                            animation,
                                                            secondaryAnimation) =>
                                                        const Login(),
                                                    transitionsBuilder:
                                                        (context,
                                                            animation,
                                                            secondaryAnimation,
                                                            child) {
                                                      const begin = 0.0;
                                                      const end = 1.0;
                                                      const curve =
                                                          Curves.easeInOut;

                                                      var tween = Tween(
                                                              begin: begin,
                                                              end: end)
                                                          .chain(CurveTween(
                                                              curve: curve));
                                                      var fadeAnimation =
                                                          animation
                                                              .drive(tween);

                                                      return FadeTransition(
                                                        opacity: fadeAnimation,
                                                        child: child,
                                                      );
                                                    },
                                                  ),
                                                );
                                              },
                                              child: Text(
                                                'Login',
                                                style: GoogleFonts.manrope(
                                                  fontSize: titleFontSize * 0.5,
                                                  color: const Color.fromARGB(
                                                      255, 29, 29, 29),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 20, top: 20, bottom: 20),
                                  decoration: const BoxDecoration(
                                    color: secondPrimary,
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(20),
                                      bottomRight: Radius.circular(20),
                                    ),
                                  ),
                                  width: width * 0.5 - 100,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Important Instructions",
                                        style: GoogleFonts.manrope(
                                          fontSize: width * 0.015,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      bulletPoint(
                                          'Confidentiality of Password is solely responsibility of the candidate and all care must be taken to protect the password.'),
                                      bulletPoint(
                                          'Never share your password and do not respond to any mail which asks you for your Login-ID/Password.'),
                                      bulletPoint(
                                          'For security reasons, after finishing your work, click the LOGOUT button and close all the windows related to your session.'),
                                      bulletPoint(
                                          'Make sure your account information, such as email address and phone number, is up to date to avoid sign-in issues.'),
                                      bulletPoint(
                                          'Alumni who experience sign-in issues can contact the support team for help with account recovery.'),
                                      bulletPoint(
                                          'Ensure you are using the latest version of the browser for a seamless experience during sign-in.'),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 100,
                          ),
                        ],
                      ),
                      const Footer(),
                    ],
                  ),
                ),
              ],
            ),
          );
  }
}

Widget bulletPoint(String text) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '• ',
          style: TextStyle(fontSize: 20, height: 1.55),
        ),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.manrope(
              fontSize: 17,
              color: Colors.black,
            ),
          ),
        ),
      ],
    ),
  );
}
