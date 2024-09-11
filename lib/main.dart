import "package:firebase_core/firebase_core.dart";
import "package:flutter/material.dart";
import "package:gecap/firebase_options.dart";
import "package:gecap/pages/personal/personal/support/support.dart";
import "package:gecap/pages/portal/explore/explore.dart";
import "package:gecap/pages/portal/institute/alumni.dart";
import "package:gecap/pages/portal/institute/institute_dashboard.dart";
import "package:gecap/pages/portal/institute/institute_login.dart";
import "package:gecap/pages/portal/institute/requests.dart";
import "package:gecap/pages/portal/login/login.dart";
import "package:gecap/pages/portal/mainpage/mainpage.dart";

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: InstituteDashboard(),
    );
  }
}
