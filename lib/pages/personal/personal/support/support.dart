import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gecap/constants/color.dart';
import 'package:google_fonts/google_fonts.dart';

class Support extends StatefulWidget {
  final alumniData;
  Support({super.key, required this.alumniData});

  @override
  State<Support> createState() => _SupportState();
}

class _SupportState extends State<Support> {
  final _amountController = TextEditingController();
  final _upi = TextEditingController();
  bool _isProcessing = false;
  User? user = FirebaseAuth.instance.currentUser;

  void _simulatePayment() async {
    if (_amountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter an amount")),
      );
      return;
    } else if (_upi.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter your UPI ID")),
      );
      return;
    }

    int donationAmount;
    try {
      donationAmount = int.parse(_amountController.text);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid amount entered")),
      );
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    try {
      await FirebaseFirestore.instance
          .collection("alumni")
          .doc(user!.email)
          .update({
        "donationAmount": FieldValue.increment(donationAmount),
      });

      await FirebaseFirestore.instance
          .collection("alumni")
          .doc(user!.email)
          .collection("donations")
          .add({
        "date":
            "${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}",
        "time":
            "${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}",
        "amount": donationAmount,
      });

      setState(() {
        _isProcessing = false;
      });

      _showPaymentResultDialog(success: true);
    } catch (e) {
      setState(() {
        _isProcessing = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Payment failed: $e")),
      );

      _showPaymentResultDialog(success: false);
    }
  }

  void _showPaymentResultDialog({required bool success}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(success ? 'Payment Successful' : 'Payment Failed'),
        content: Text(success
            ? 'Thank you for your generous support! Your donation will make a lasting impact on the future of our institution.'
            : 'Something went wrong. Please try again.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.sizeOf(context).height;
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: white,
          ),
        ),
        backgroundColor: Colors.green,
        title: Text(
          "Support Your College",
          style: GoogleFonts.manrope(
            color: white,
          ),
        ),
      ),
      body: Container(
        height: height,
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Enter your UPI  ID and amount to proceed with the payment.",
              style: GoogleFonts.manrope(
                  fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              cursorColor: black,
              controller: _upi,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "UPI",
                labelStyle: GoogleFonts.manrope(color: black),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(color: Colors.green),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Enter the amount you would like to donate:",
              style: GoogleFonts.manrope(
                  fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              cursorColor: black,
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Amount",
                labelStyle: GoogleFonts.manrope(color: black),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(color: Colors.green),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Why support your college?",
              style: GoogleFonts.manrope(
                  fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              "As an alumnus, you are a vital part of the college community. Your support ensures that future generations have access to the same or even better opportunities that you once had. "
              "With your generous contribution, we can expand our facilities, provide scholarships to deserving students, and fund research that could lead to groundbreaking innovations. "
              "Together, we can help students achieve their dreams, give back to the community, and build a brighter future.",
              style: GoogleFonts.manrope(fontSize: 16),
            ),
            const SizedBox(height: 10),
            Text(
              "Your donations will directly contribute to:",
              style: GoogleFonts.manrope(
                  fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              "- Providing financial aid to students in need\n"
              "- Expanding and modernizing campus facilities\n"
              "- Supporting academic and extracurricular programs\n"
              "- Funding groundbreaking research initiatives\n"
              "- Enhancing student life and community engagement",
              style: GoogleFonts.manrope(fontSize: 16),
            ),
            const SizedBox(height: 20),
            _isProcessing
                ? const CircularProgressIndicator(
                    color: Colors.green,
                  )
                : ElevatedButton(
                    onPressed: _simulatePayment,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green, // Button background color
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 15), // Button padding
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(30), // Rounded corners
                      ),
                      elevation: 5, // Button shadow
                      shadowColor: Colors.grey.shade300, // Shadow color
                      textStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold, // Text style
                      ),
                    ),
                    child: Text(
                      "Donate Now",
                      style: GoogleFonts.manrope(color: white),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }
}
