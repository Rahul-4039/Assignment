import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class AddMemberPage extends StatefulWidget {
  @override
  _AddMemberPageState createState() => _AddMemberPageState();
}

class _AddMemberPageState extends State<AddMemberPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref(); // Realtime DB reference

  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _selectedRole = 'student';
  bool _isLoading = false;

  Future<void> _registerUser() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      String idNumber = _idController.text.trim();
      String password = _passwordController.text.trim();
      String fakeEmail = "$idNumber@college.edu"; // Firebase requires an email

      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: fakeEmail,
        password: password,
      );

      String uid = userCredential.user!.uid;

      // Save user data to Realtime Database
      await _dbRef.child("users").child(uid).set({
        'id': idNumber,
        'email': fakeEmail,
        'role': _selectedRole,
        'name': "", // Empty profile fields initially
        'username': "",
        'phone': "",
        'gender': "Male",
        'createdAt': ServerValue.timestamp,
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("User added successfully!")));

      // Navigate to Sign-In Page after successful registration
      Navigator.pop(context);
    } catch (e) {
      String errorMessage = "Failed to add user.";
      if (e is FirebaseAuthException) {
        switch (e.code) {
          case "email-already-in-use":
            errorMessage = "ID is already registered!";
            break;
          case "weak-password":
            errorMessage = "Password is too weak!";
            break;
          case "invalid-email":
            errorMessage = "Invalid ID format!";
            break;
          default:
            errorMessage = e.message ?? "An error occurred.";
        }
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMessage)));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Member")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _idController,
                decoration: InputDecoration(labelText: "ID Number", border: OutlineInputBorder()),
                validator: (value) => value!.isEmpty ? "Enter ID Number" : null,
              ),
              SizedBox(height: 15),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(labelText: "Password", border: OutlineInputBorder()),
                validator: (value) => value!.length < 6 ? "Password must be at least 6 characters" : null,
              ),
              SizedBox(height: 15),
              DropdownButtonFormField(
                value: _selectedRole,
                items: ['student', 'teacher']
                    .map((role) => DropdownMenuItem(value: role, child: Text(role)))
                    .toList(),
                onChanged: (value) => setState(() => _selectedRole = value!),
                decoration: InputDecoration(border: OutlineInputBorder(), labelText: "Select Role"),
              ),
              SizedBox(height: 25),
              ElevatedButton(
                onPressed: _isLoading ? null : _registerUser,
                child: _isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text("Add Member"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
