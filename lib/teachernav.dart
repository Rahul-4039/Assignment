import 'package:assignment/teacherpages/t_uploadassignment.dart';
import 'package:assignment/teacherpages/t_year.dart';
import 'package:flutter/material.dart';
import 'package:assignment/pages/profilepage.dart';


class TeacherNav extends StatefulWidget {
  @override
  _TeacherNavState createState() => _TeacherNavState();
}

class _TeacherNavState extends State<TeacherNav> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    TyearPage(),
    TuploadAssignmentPage(),
    ProfilePage(),
  ];

  // List of titles for AppBar
  final List<String> _titles = [
    "Years",             // Title for YearPage
    "Upload Assignment", // Title for UploadAssignmentPage
    "Profile",           // Title for ProfilePage
  ];


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_selectedIndex], style: TextStyle(color: Colors.white),), // Dynamically change title
        backgroundColor: Colors.blueAccent,
      ),
      body: _pages[_selectedIndex], // Show the selected page
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.assignment), label: 'Assignments'),
          BottomNavigationBarItem(icon: Icon(Icons.upload_file), label: 'Uploaded Assignment'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}
