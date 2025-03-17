import 'package:assignment/pages/addmember.dart';
import 'package:assignment/pages/changepassword.dart';
import 'package:assignment/studentnav.dart';
import 'package:assignment/teachernav.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _rememberMe = false;
  bool _isButtonEnabled = false;
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _validateForm() {
    setState(() {
      _isButtonEnabled = _idController.text.isNotEmpty && _passwordController.text.isNotEmpty;
    });
  }

  @override
  void initState() {
    super.initState();
    _idController.addListener(_validateForm);
    _passwordController.addListener(_validateForm);
  }

  @override
  void dispose() {
    _idController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    if (!_isButtonEnabled) return;

    try {
      String enteredId = _idController.text.trim();
      String enteredPassword = _passwordController.text.trim();

      // Check Firestore if user exists
      QuerySnapshot userQuery = await _firestore
          .collection('users')
          .where('id', isEqualTo: enteredId)
          .limit(1)
          .get();

      if (userQuery.docs.isEmpty) {
        // If user is not found, navigate to Add Member Page
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AddMemberPage()));
        return;
      }

      var userData = userQuery.docs.first;
      String email = userData['email']; // Firebase requires email for authentication
      String role = userData['role'];

      // Authenticate user
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: enteredPassword,
      );

      if (role == 'student') {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainNavigation()));
      } else if (role == 'teacher') {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainNavigation()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Invalid user role")));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Login failed: ${e.toString()}")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset("assets/images/bg_signin.jpg", fit: BoxFit.cover),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.3,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(35),
                  topRight: Radius.circular(35),
                ),
                color: Color(0xFFE3F2FD),
              ),
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 40),
                    Text("Welcome", style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold)),
                    SizedBox(height: 40),
                    TextField(
                      controller: _idController,
                      decoration: InputDecoration(
                        labelText: "ID Number",
                        prefixIcon: Icon(Icons.perm_identity),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 40),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "Password",
                        prefixIcon: Icon(Icons.lock),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              value: _rememberMe,
                              onChanged: (value) {
                                setState(() {
                                  _rememberMe = value!;
                                });
                              },
                            ),
                            Text("Remember me"),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => ChangePasswordPage()));
                          },
                          child: Text("Forgot password?", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    SizedBox(height: 40),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _signIn,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isButtonEnabled ? Colors.blue : Colors.grey,
                          padding: EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: Text("Sign in", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
