import 'package:assignment/pages/changepassword.dart';
import 'package:flutter/material.dart';
import 'editprofile.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String name = "Rahul Padwal";
  String username = "rahulpadwal";
  String gender = "Male";
  String phone = "+91 9619466217";
  String email = "rahulp40@gmail.com";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text("Profile")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            CircleAvatar(radius: 50, backgroundImage: AssetImage("assets/images/profileimage.png")),
            SizedBox(height: 10),
            Text(name, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text("Student", style: TextStyle(color: Colors.grey)),
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
              onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context) => ChangePasswordPage()));},
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(backgroundColor: Colors.lightBlueAccent),
              child: Text("Sign Out"),
            ),
          ],
        ),
      ),
    );
  }
}
