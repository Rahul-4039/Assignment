import 'package:assignment/pages/changepassword.dart';
import 'package:assignment/studentnav.dart';
import 'package:flutter/material.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool _rememberMe = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              "assets/images/bg_signin.jpg", // Replace with your image path
              fit: BoxFit.cover,
            ),
          ),


          Positioned(
            top: MediaQuery.of(context).size.height * 0.3, // Adjust the height as needed
            left: 0,
            right: 0,
            bottom: 0, // Fill the rest of the screen
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
                  mainAxisSize: MainAxisSize.min, // Important to prevent overflow
                  children: [
                    SizedBox(height: 40), // Space from top
                    Text(
                      "Welcome back",
                      style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 40),

                    // Email Field
                    TextField(
                      decoration: InputDecoration(
                        labelText: "ID Number",
                        prefixIcon: Icon(Icons.perm_identity),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 40),

                    // Password Field
                    TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "Password",
                        prefixIcon: Icon(Icons.lock),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 25),

                    // Remember Me & Forgot Password
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
                          child: Text(
                            "Forgot password?",
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 40),

                    // Sign In Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => MainNavigation()));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          "Sign in",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      )
      ,
    );
  }

  // Social Icon Widget
  // Widget _buildSocialIcon(String assetName) {
  //   return Padding(
  //     padding: EdgeInsets.symmetric(horizontal: 10),
  //     child: Image.asset(
  //       assetName,
  //       height: 40,
  //       width: 40,
  //     ),
  //   );
  // }
}
