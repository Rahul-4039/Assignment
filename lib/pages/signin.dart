import 'package:assignment/pages/changepassword.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:assignment/pages/editprofile.dart';
import 'package:assignment/studentnav.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();

  bool _rememberMe = false;
  bool _isButtonEnabled = false;
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _idController.addListener(_validateInput);
    _passwordController.addListener(_validateInput);
  }

  void _validateInput() {
    setState(() {
      _isButtonEnabled = _idController.text.isNotEmpty && _passwordController.text.isNotEmpty;
    });
  }

  Future<void> _signIn() async {
    setState(() => _isLoading = true);

    try {
      String idNumber = _idController.text.trim();
      String password = _passwordController.text.trim();
      String fakeEmail = "$idNumber@college.edu"; // Ensuring email format for Firebase

      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: fakeEmail,
        password: password,
      );

      User? user = userCredential.user;
      if (user != null) {
        DatabaseEvent event = await _dbRef.child("users").child(user.uid).once();
        DataSnapshot snapshot = event.snapshot;

        if (snapshot.exists && snapshot.value != null) {
          Map<String, dynamic> userData = Map<String, dynamic>.from(snapshot.value as Map);
          String role = userData['role'] ?? 'student';

          // Check if user has completed profile
          bool isProfileIncomplete = userData['name'] == "" || userData['phone'] == "" || userData['username'] == "";

          if (isProfileIncomplete) {
            // Navigate to Edit Profile Page
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => EditProfilePage(
                  name: userData['name'] ?? "",
                  username: userData['username'] ?? "",
                  gender: userData['gender'] ?? "Male",
                  phone: userData['phone'] ?? "",
                  email: user.email ?? "",
                ),
              ),
            );
          } else {
            // Navigate to Main Navigation
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => MainNavigation()),
            );
          }
        }
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = "Failed to sign in. Please try again.";
      if (e.code == 'user-not-found') {
        errorMessage = "User not found. Please check your ID.";
      } else if (e.code == 'wrong-password') {
        errorMessage = "Incorrect password. Please try again.";
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMessage)));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: ${e.toString()}")));
    } finally {
      setState(() => _isLoading = false);
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ChangePasswordPage()),
                            );
                          },
                          child: Text("Forgot password?", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    SizedBox(height: 40),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isButtonEnabled ? _signIn : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isButtonEnabled ? Colors.blue : Colors.grey,
                          padding: EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: _isLoading
                            ? CircularProgressIndicator(color: Colors.white)
                            : Text("Sign in", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
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
