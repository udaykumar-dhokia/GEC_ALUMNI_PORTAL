import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gecap/components/appbar/dbappbar.dart';
import 'package:gecap/constants/color.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:side_sheet/side_sheet.dart'; // Correct package

class Event extends StatefulWidget {
  const Event({super.key});

  @override
  State<Event> createState() => _EventState();
}

class _EventState extends State<Event> {
  User? user = FirebaseAuth.instance.currentUser;
  Map<String, dynamic> alumniData = {};
  bool _isLoading = false;

  void getAlumni() async {
    try {
      setState(() {
        _isLoading = true;
      });
      final data = await FirebaseFirestore.instance
          .collection("alumni")
          .doc(user!.email)
          .get();

      setState(() {
        alumniData = data.data()!;
      });
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = true;
      });
      return;
    }
  }

  Stream<QuerySnapshot> getEvents() {
    return FirebaseFirestore.instance.collection('events').snapshots();
  }

  Future<void> deleteEvent(String eventId) async {
    try {
      await FirebaseFirestore.instance
          .collection('events')
          .doc(eventId)
          .delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Event deleted successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete event: $e')),
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAlumni();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return _isLoading
        ? const Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                color: primary,
              ),
            ),
          )
        : Scaffold(
            backgroundColor: white,
            floatingActionButton: FloatingActionButton(
              shape: CircleBorder(),
              onPressed: () {
                SideSheet.right(
                  context: context,
                  body: CreateEvent(
                    alumniData: alumniData,
                  ),
                  width: MediaQuery.of(context).size.width * 0.4,
                );
              },
              backgroundColor: primary,
              child: const Icon(
                Icons.add,
                color: white,
              ),
            ),
            body: CustomScrollView(
              slivers: [
                DBAppbar(
                  toolbarHeight: height * 0.1,
                  titleFontSize: width * 0.02,
                ),
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('alumni')
                          .doc(alumniData["email"])
                          .collection("events")
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const SliverFillRemaining(
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }
                    
                        if (snapshot.hasError) {
                          return SliverFillRemaining(
                            child: Center(child: Text('Error: ${snapshot.error}')),
                          );
                        }
                    
                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return const SliverFillRemaining(
                            child: Center(child: Text('No events available')),
                          );
                        }
                    
                        final events = snapshot.data!.docs;
                    
                        return SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final event =
                                  events[index].data() as Map<String, dynamic>;
                              final eventId =
                                  events[index].id; // Get the document ID
                              final title = event['title'] ?? 'No title';
                              final description =
                                  event['description'] ?? 'No description';
                              final venue = event['venue'] ?? 'No venue';
                              final date = event['date'] ?? 'No date';
                              final accepted = event['isVerified'];
                    
                              return Card(
                                margin: const EdgeInsets.all(10),
                                elevation: 5,
                                child: ListTile(
                                  contentPadding: const EdgeInsets.all(15),
                                  title: Text(
                                    title,
                                    style: GoogleFonts.epilogue(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 18,
                                    ),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Description: $description',
                                        style: GoogleFonts.epilogue(),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        'Venue: $venue',
                                        style: GoogleFonts.epilogue(),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        'Date: $date',
                                        style: GoogleFonts.epilogue(),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        'Approval: ${accepted ? "Accepted" : "Pending"}',
                                        style: GoogleFonts.epilogue(),
                                      ),
                                    ],
                                  ),
                                  trailing: IconButton(
                                    icon:
                                        const Icon(Icons.delete, color: Colors.red),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: const Text('Delete Event'),
                                          content: const Text(
                                              'Are you sure you want to delete this event?'),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.of(context).pop(),
                                              child: const Text('Cancel'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                                deleteEvent(eventId);
                                              },
                                              child: const Text('Delete'),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              );
                            },
                            childCount: events.length,
                          ),
                        );
                      },
                    ),
              ],
            ),
          );
  }
}

class CreateEvent extends StatefulWidget {
  final alumniData;
  CreateEvent({Key? key, required this.alumniData}) : super(key: key);

  @override
  State<CreateEvent> createState() => CreateEventState();
}

class CreateEventState extends State<CreateEvent> {
  TextEditingController _title = TextEditingController();
  TextEditingController _description = TextEditingController();
  TextEditingController _venue = TextEditingController();
  TextEditingController _date = TextEditingController();
  final List<String> colleges = [
    "Government Engineering College, Godhra",
    "Government Engineering College, Valsad",
    "Vishwakarma Government Engineering College, Chandkheda, Gandhinagar",
    "Government Engineering College, Bharuch",
    "L.E.College, Morbi",
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
  String? selectedCollege;

  Future<int> createEvent(final data) async {
    User? user = FirebaseAuth.instance.currentUser;
    try {
      await FirebaseFirestore.instance
          .collection("alumni")
          .doc(user!.email)
          .collection("events")
          .add(data);

      final query = await FirebaseFirestore.instance
          .collection("gec")
          .where("name", isEqualTo: widget.alumniData["college"])
          .get();

      if (query.docs.isNotEmpty) {
        String id = query.docs.first.id;

        await FirebaseFirestore.instance
            .collection("gec")
            .doc(id)
            .collection("event_request")
            .add(data);
      }

      return 1;
    } catch (e) {
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (_title.text.isEmpty ||
              _description.text.isEmpty ||
              _date.text.isEmpty ||
              selectedCollege == null) {
            CherryToast.error(
              displayCloseButton: false,
              toastPosition: Position.top,
              description: Text(
                "Please provide all required fields.",
                style: GoogleFonts.epilogue(color: Colors.black),
              ),
              animationType: AnimationType.fromTop,
              animationDuration: const Duration(milliseconds: 1000),
              autoDismiss: true,
            ).show(context);
          } else {
            final data = {
              "title": _title.text,
              "description": _description.text,
              "venue": selectedCollege,
              "date": _date.text,
              "isVerified": false,
              "name": widget.alumniData["name"],
              "email": widget.alumniData["email"],
            };
            try {
              int result = await createEvent(data);
              if (result == 0) {
                CherryToast.error(
                  displayCloseButton: false,
                  toastPosition: Position.top,
                  description: Text(
                    "Failed to create Event.",
                    style: GoogleFonts.epilogue(color: Colors.black),
                  ),
                  animationType: AnimationType.fromTop,
                  animationDuration: const Duration(milliseconds: 1000),
                  autoDismiss: true,
                ).show(context);
              } else {
                CherryToast.success(
                  displayCloseButton: false,
                  toastPosition: Position.top,
                  description: Text(
                    "Successfully created the Event.",
                    style: GoogleFonts.epilogue(color: Colors.black),
                  ),
                  animationType: AnimationType.fromTop,
                  animationDuration: const Duration(milliseconds: 1000),
                  autoDismiss: true,
                ).show(context);
              }
            } catch (e) {
              CherryToast.error(
                displayCloseButton: false,
                toastPosition: Position.top,
                description: Text(
                  "An error occurred: $e",
                  style: GoogleFonts.epilogue(color: Colors.black),
                ),
                animationType: AnimationType.fromTop,
                animationDuration: const Duration(milliseconds: 1000),
                autoDismiss: true,
              ).show(context);
            } finally {
              Navigator.pop(context);
            }
          }
        },
        shape: const CircleBorder(),
        backgroundColor: Colors.blue, // Change to a visible color
        child: const Icon(Icons.check,
            color: Colors.white), // Change icon color for visibility
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            floating: true,
            title: DBAppbar(
              toolbarHeight: height * 0.1, // Adjust as needed
              titleFontSize: width * 0.02, // Adjust as needed
            ),
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  TextField(
                    controller: _title,
                    decoration: const InputDecoration(labelText: "Event Title"),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _description,
                    decoration: const InputDecoration(labelText: "Description"),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity, // Changed to take available space
                    child: DropdownButton<String>(
                      style: GoogleFonts.manrope(),
                      borderRadius: BorderRadius.circular(20),
                      hint: Text(
                        "Select a College",
                        style: GoogleFonts.manrope(fontWeight: FontWeight.w600),
                      ),
                      value: selectedCollege,
                      isExpanded: true,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedCollege = newValue;
                        });
                      },
                      items: colleges.map((String college) {
                        return DropdownMenuItem<String>(
                          value: college,
                          child: Text(
                            college,
                            style: GoogleFonts.manrope(),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _date,
                    decoration: InputDecoration(
                      labelText: "Date",
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.calendar_month_outlined),
                        onPressed: () async {
                          DateTime? selectedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2101),
                          );
                          if (selectedDate != null) {
                            setState(() {
                              _date.text = "${selectedDate.toLocal()}"
                                  .split(' ')[0]; // Format date as needed
                            });
                          }
                        },
                      ),
                    ),
                    keyboardType: TextInputType.none,
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}