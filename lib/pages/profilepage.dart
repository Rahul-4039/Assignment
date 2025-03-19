import 'package:assignment/pages/changepassword.dart';
import 'package:assignment/pages/signin.dart';
import 'package:assignment/pages/editprofile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();

  String name = "Loading...";
  String username = "";
  String gender = "";
  String phone = "";
  String email = "";
  String role = ""; // Student or Teacher

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() async {
    User? user = _auth.currentUser;

    if (user != null) {
      DatabaseEvent event = await _dbRef.child("users").child(user.uid).once();
      DataSnapshot snapshot = event.snapshot;

      if (snapshot.exists && snapshot.value != null) {
        Map<String, dynamic> userData = Map<String, dynamic>.from(snapshot.value as Map);

        setState(() {
          name = userData['name'] ?? "Unknown";
          username = userData['username'] ?? "";
          gender = userData['gender'] ?? "Male";
          phone = userData['phone'] ?? "";
          email = userData['email'] ?? user.email!;
          role = userData['role'] ?? "student";
        });
      }
    }
  }

  void _signOut() async {
    await _auth.signOut();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignInPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            CircleAvatar(radius: 50, backgroundImage: AssetImage("assets/images/profileimage.png")),
            SizedBox(height: 10),
            Text(name, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text(role, style: TextStyle(color: Colors.grey)),
            SizedBox(height: 20),
            ListTile(
              leading: Icon(Icons.edit),
              title: Text("Edit Profile"),
              onTap: () async {
                final updatedData = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditProfilePage(
                      name: name,
                      username: username,
                      gender: gender,
                      phone: phone,
                      email: email,
                    ),
                  ),
                );
                if (updatedData != null) {
                  setState(() {
                    name = updatedData['name'];
                    username = updatedData['username'];
                    gender = updatedData['gender'];
                    phone = updatedData['phone'];
                    email = updatedData['email'];
                  });
                }
              },
            ),
            ListTile(
              leading: Icon(Icons.notifications),
              title: Text("Notification"),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.lock),
              title: Text("Change Password"),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ChangePasswordPage()));
              },
            ),
            Spacer(),
            ElevatedButton(
              onPressed: _signOut,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.lightBlueAccent),
              child: Text("Sign Out"),
            ),
          ],
        ),
      ),
    );
  }
}
