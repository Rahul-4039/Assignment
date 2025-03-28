import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:assignment/studentnav.dart';

import '../teachernav.dart';

class EditProfilePage extends StatefulWidget {
  final String name;
  final String username;
  final String gender;
  final String phone;
  final String email;

  EditProfilePage({
    required this.name,
    required this.username,
    required this.gender,
    required this.phone,
    required this.email,
  });

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();

  late TextEditingController nameController;
  late TextEditingController usernameController;
  late TextEditingController phoneController;
  late TextEditingController emailController;
  String selectedGender = "Male";
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.name);
    usernameController = TextEditingController(text: widget.username);
    phoneController = TextEditingController(text: widget.phone);
    emailController = TextEditingController(text: widget.email);
    selectedGender = widget.gender;
  }

  @override
  void dispose() {
    nameController.dispose();
    usernameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    super.dispose();
  }

  Future<void> _updateProfile() async {
    setState(() => _isLoading = true);

    try {
      User? user = _auth.currentUser;
      if (user != null) {
        String userId = user.uid;

        // Update user details in Realtime Database
        await _dbRef.child("users").child(userId).update({
          "name": nameController.text.trim(),
          "username": usernameController.text.trim(),
          "gender": selectedGender,
          "phone": phoneController.text.trim(),
          "email": emailController.text.trim(),
        });

        // Retrieve the user's role
        DatabaseEvent event = await _dbRef.child("users").child(userId).once();
        DataSnapshot snapshot = event.snapshot;
        String role = "student"; // Default role

        if (snapshot.exists && snapshot.value != null) {
          Map<String, dynamic> userData = Map<String, dynamic>.from(snapshot.value as Map);
          role = userData['role'] ?? 'student';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Profile updated successfully!")),
        );

        // Navigate based on role
        if (role == "teacher") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => TeacherNav()), // Change this to the teacher's dashboard
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MainNavigation()), // Student's dashboard
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to update profile: ${e.toString()}")),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Complete Profile")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: nameController, decoration: InputDecoration(labelText: "Name")),
            SizedBox(height: 20),
            TextField(controller: usernameController, decoration: InputDecoration(labelText: "Username")),
            SizedBox(height: 20),
            DropdownButtonFormField(
              value: selectedGender,
              items: ["Male", "Female"].map((String category) {
                return DropdownMenuItem(value: category, child: Text(category));
              }).toList(),
              onChanged: (newValue) => setState(() => selectedGender = newValue.toString()),
              decoration: InputDecoration(labelText: "Gender"),
            ),
            SizedBox(height: 20),
            TextField(controller: phoneController, decoration: InputDecoration(labelText: "Phone Number"), keyboardType: TextInputType.phone),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _updateProfile,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.lightBlueAccent),
              child: _isLoading ? CircularProgressIndicator(color: Colors.white) : Text("Save"),
            ),
          ],
        ),
      ),
    );
  }
}
