import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddMemberPage extends StatefulWidget {
  @override
  _AddMemberPageState createState() => _AddMemberPageState();
}

class _AddMemberPageState extends State<AddMemberPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _selectedRole = 'student';

  Future<void> _registerUser() async {
    try {
      String idNumber = _idController.text.trim();
      String password = _passwordController.text.trim();
      String fakeEmail = "$idNumber@college.edu"; // Firebase requires an email

      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: fakeEmail,
        password: password,
      );

      String uid = userCredential.user!.uid;

      await _firestore.collection('users').doc(uid).set({
        'id': idNumber,
        'email': fakeEmail,
        'role': _selectedRole,
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("User added successfully!")));
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to add user: ${e.toString()}")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Member")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: _idController, decoration: InputDecoration(labelText: "ID Number", border: OutlineInputBorder())),
            SizedBox(height: 15),
            TextField(controller: _passwordController, obscureText: true, decoration: InputDecoration(labelText: "Password", border: OutlineInputBorder())),
            SizedBox(height: 15),
            DropdownButtonFormField(value: _selectedRole, items: ['student', 'teacher'].map((role) => DropdownMenuItem(value: role, child: Text(role))).toList(), onChanged: (value) => setState(() => _selectedRole = value!), decoration: InputDecoration(border: OutlineInputBorder(), labelText: "Select Role")),
            SizedBox(height: 25),
            ElevatedButton(onPressed: _registerUser, child: Text("Add Member")),
          ],
        ),
      ),
    );
  }
}
