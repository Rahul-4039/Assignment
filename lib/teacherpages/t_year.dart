import 'package:assignment/teacherpages/t_uploadassignment.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class TyearPage extends StatefulWidget {
  @override
  _TyearPageState createState() => _TyearPageState();
}

class _TyearPageState extends State<TyearPage> {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref().child("courses");
  List<Map<String, dynamic>> courses = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCourses();
  }

  // Fetch courses from Firebase
  void _fetchCourses() {
    _dbRef.onValue.listen((event) {
      setState(() {
        isLoading = false;
        if (event.snapshot.value != null) {
          Map<dynamic, dynamic> data = event.snapshot.value as Map<dynamic, dynamic>;
          courses = data.entries.map((entry) {
            return {
              "id": entry.key,
              "title": entry.value["title"],
              "subtitle": entry.value["subtitle"],
              "teacher": entry.value["teacher"],
              "image": entry.value["image"] ?? "assets/images/be.jpg",
              "page": TuploadAssignmentPage(),
            };
          }).toList();
        } else {
          courses = [];
        }
      });
    });
  }

  // Function to show the popup form for adding a new course
  void _showAddCourseDialog() {
    TextEditingController yearController = TextEditingController();
    TextEditingController branchController = TextEditingController();
    TextEditingController divisionController = TextEditingController();
    TextEditingController subjectController = TextEditingController();
    TextEditingController teacherController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Add New Course"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: yearController, decoration: InputDecoration(labelText: "Year")),
                TextField(controller: branchController, decoration: InputDecoration(labelText: "Branch")),
                TextField(controller: divisionController, decoration: InputDecoration(labelText: "Division")),
                TextField(controller: subjectController, decoration: InputDecoration(labelText: "Subject")),
                TextField(controller: teacherController, decoration: InputDecoration(labelText: "Teacher Name")),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                String newCourseKey = _dbRef.push().key ?? "";
                Map<String, dynamic> newCourse = {
                  "title": "${yearController.text} ${branchController.text}",
                  "subtitle": "Division ${divisionController.text}",
                  "teacher": teacherController.text,
                  "image": "assets/images/default.jpg",
                };

                await _dbRef.child(newCourseKey).set(newCourse);
                Navigator.pop(context);
              },
              child: Text("Done"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(child: CircularProgressIndicator()) // Show loader while fetching data
          : courses.isEmpty
          ? Center(
        child: Text(
          "No courses added",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),
        ),
      ) // Show "No courses added" when list is empty
          : ListView.builder(
        itemCount: courses.length,
        padding: EdgeInsets.all(10),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => courses[index]["page"]),
              );
            },
            child: Container(
              margin: EdgeInsets.only(bottom: 12),
              height: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image: AssetImage(courses[index]["image"]),
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.black.withOpacity(0.4),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          courses[index]["title"],
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          courses[index]["subtitle"],
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          courses[index]["teacher"],
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Icon(Icons.more_vert, color: Colors.white),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddCourseDialog,
        backgroundColor: Colors.blue,
        child: Icon(Icons.add, size: 30, color: Colors.white),
      ),
    );
  }
}
