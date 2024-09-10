import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TotalAumni extends StatefulWidget {
  const TotalAumni({super.key});

  @override
  State<TotalAumni> createState() => _TotalAumniState();
}

class _TotalAumniState extends State<TotalAumni> {
  List<Map<String, dynamic>> total = [];

  void totalAlumni() async {
    final data = await FirebaseFirestore.instance.collection("gec").get();
    for (var doc in data.docs) {
      setState(() {
        total.add(doc.data());
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    totalAlumni();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return ListView.builder(
      shrinkWrap: true,
      itemCount: total.length,
      itemBuilder: (context, index) {
        // Assuming total contains alumni with 'name' and 'year' fields
        var alumni = total[index];
        return ListTile(
          leading:
              Icon(Icons.person), // Can be replaced with avatar or any icon
          title: Text(alumni['name'] ?? 'No Name'), // Alumni name
          subtitle: Text(
              'Graduation Year: ${alumni['year'] ?? 'N/A'}'), // Alumni graduation year or any other field
          trailing:
              Icon(Icons.arrow_forward), // Optionally, add a trailing icon
          onTap: () {
            // Define what happens when a list item is tapped
          },
        );
      },
    );
  }
}
