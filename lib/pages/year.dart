import 'package:assignment/pages/uploadassignment.dart';
import 'package:assignment/teachernav.dart';
import 'package:flutter/material.dart';

class YearPage extends StatefulWidget {
  @override
  _YearPageState createState() => _YearPageState();
}

class _YearPageState extends State<YearPage> {
  final List<Map<String, dynamic>> courses = [
    {
      "title": "BEIT (FH-25)",
      "subtitle": "A & B",
      "teacher": "Dr. Neeraj Sharma",
      "image": "assets/images/fe.jpg", // Your image path
      "page": UploadAssignmentPage(),
    },
    {
      "title": "CC Lab BEIT A&B 2024-25",
      "subtitle": "",
      "teacher": "Kiran Deshmukh",
      "image": "assets/images/se.jpg",
      "page": UploadAssignmentPage(),
    },
    {
      "title": "FH25 Blockchain Lab (ITL 801)",
      "subtitle": "",
      "teacher": "Vedika Avhad",
      "image": "assets/images/te.jpg",
      "page": UploadAssignmentPage(),
    },
    {
      "title": "SAD LAB BEIT 2024-25",
      "subtitle": "",
      "teacher": "Kiran Deshmukh",
      "image": "assets/images/be.jpg",
      "page": UploadAssignmentPage(),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text("Years")),
      body: ListView.builder(
        itemCount: courses.length,
        padding: EdgeInsets.all(10),
        itemBuilder: (context, index) {
          return GestureDetector(
              onTap: () {
            // Navigate to a different page for each container
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => courses[index]["page"],
              ),
            );
          },
            child: Container(
            margin: EdgeInsets.only(bottom: 12),
            height: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                image: AssetImage(courses[index]["image"]!), // Background image
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              children: [
                // Dark overlay for better text visibility
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.black.withOpacity(0.4), // Dark overlay
                  ),
                ),
                // Text content
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        courses[index]["title"]!,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        courses[index]["subtitle"]!,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        courses[index]["teacher"]!,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
                // Three-dot menu in the top right
                Positioned(
                  top: 10,
                  right: 10,
                  child: Icon(Icons.more_vert, color: Colors.white),
                ),
              ],
            ),
          )
          );
        },
      ),
    );
  }
}
