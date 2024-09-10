import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gecap/components/appbar/appbar.dart';
import 'package:gecap/components/footer/footer.dart';
import 'package:gecap/constants/color.dart';
import 'package:gecap/pages/personal/personal/dashboard/dashboard.dart';
import 'package:gecap/pages/portal/login/login.dart';
import 'package:gecap/pages/portal/login/signup.dart';
import 'package:gecap/pages/portal/mainpage/mainpage.dart';
import 'package:google_fonts/google_fonts.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirm = TextEditingController();
  bool _isPasswordVisible = false;
  bool _confirmVisible = false;
  bool _isLoading = false;

  void Login(String email, String password) async {
    try {
      setState(() {
        _isLoading = true;
      });

      final alumniData = await FirebaseFirestore.instance
          .collection("alumni")
          .doc(email)
          .get();

      if (alumniData.exists) {
        if (alumniData.data()!["isVerified"]) {
          final data = await FirebaseAuth.instance
              .signInWithEmailAndPassword(email: email, password: password);

          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
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

          CherryToast.success(
            animationType: AnimationType.fromTop,
            title: const Text(
              "Login successfull",
              style: TextStyle(color: Colors.black),
            ),
          ).show(context);
        } else {
        setState(() {
          _emailController.clear();
          _passwordController.clear();
          _confirm.clear();
        });
          CherryToast.info(
            animationType: AnimationType.fromTop,
            title: const Text(
              "Verification is still in progress.",
              style: TextStyle(color: Colors.black),
            ),
          ).show(context);
        }
      }

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print(e);
      CherryToast.error(
        animationType: AnimationType.fromTop,
        title: const Text("Something went wrong.",
            style: TextStyle(color: Colors.black)),
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
                                          'Welcome Alumnus',
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
                                          'Login to your account',
                                          style: GoogleFonts.manrope(
                                            textStyle: TextStyle(
                                              fontSize: titleFontSize * 0.5,
                                              color: const Color.fromARGB(
                                                  255, 29, 29, 29),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 8),
                                          decoration: const BoxDecoration(
                                            color: Colors.white,
                                          ),
                                          child: Column(
                                            children: [
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
                                              if (_emailController
                                                      .text.isEmpty ||
                                                  _passwordController
                                                      .text.isEmpty ||
                                                  _confirm.text.isEmpty) {
                                                CherryToast.error(
                                                  animationType:
                                                      AnimationType.fromTop,
                                                  title: const Text(
                                                    "Please fill up all details.",
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ).show(context);
                                              } else if (_passwordController
                                                      .text !=
                                                  _confirm.text) {
                                                CherryToast.error(
                                                  animationType:
                                                      AnimationType.fromTop,
                                                  title: const Text(
                                                    "Password mismatched.",
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ).show(context);
                                              } else {
                                                Login(_emailController.text,
                                                    _passwordController.text);
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
                                                  'Login',
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
                                              "Not registered?",
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
                                                        const SignIn(),
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
                                                'Sign Up',
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
              fontSize: 16,
              color: Colors.black,
            ),
          ),
        ),
      ],
    ),
  );
}
