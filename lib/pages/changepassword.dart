import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class ChangePasswordPage extends StatefulWidget {
  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  bool _isObscureOldPassword = true;
  bool _isObscurePassword = true;
  bool _isObscureConfirmPassword = true;
  bool _isButtonEnabled = false;
  bool _isLoading = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();

  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  void _validateForm() {
    setState(() {
      _isButtonEnabled = _oldPasswordController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty &&
          _confirmPasswordController.text.isNotEmpty &&
          _passwordController.text == _confirmPasswordController.text;
    });
  }

  @override
  void initState() {
    super.initState();
    _oldPasswordController.addListener(_validateForm);
    _passwordController.addListener(_validateForm);
    _confirmPasswordController.addListener(_validateForm);
  }

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _changePassword() async {
    setState(() => _isLoading = true);

    try {
      User? user = _auth.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("User not found.")));
        return;
      }

      // Re-authenticate the user
      AuthCredential credential = EmailAuthProvider.credential(
        email: user.email!,
        password: _oldPasswordController.text.trim(),
      );

      await user.reauthenticateWithCredential(credential);

      // Update the password in Firebase Authentication
      await user.updatePassword(_passwordController.text.trim());

      // Update password in Realtime Database
      await _dbRef.child("users").child(user.uid).update({
        "password": _passwordController.text.trim(),
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Password updated successfully!")));

      Navigator.pop(context); // Go back after success
    } on FirebaseAuthException catch (e) {
      String errorMessage = "Error changing password.";
      if (e.code == 'wrong-password') {
        errorMessage = "Incorrect old password.";
      } else if (e.code == 'weak-password') {
        errorMessage = "New password is too weak.";
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
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Curved Header
            Container(
              height: 180,
              decoration: BoxDecoration(
                color: Colors.lightBlue,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(50),
                  bottomRight: Radius.circular(50),
                ),
              ),
              child: Center(
                child: Text(
                  "Reset Password",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            SizedBox(height: 40),

            // Form Content
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Enter New Password",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 15),
                  Text(
                    "Your new password must be different from the previous password.",
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  SizedBox(height: 25),

                  // Previous Password Field
                  TextField(
                    controller: _oldPasswordController,
                    obscureText: _isObscureOldPassword,
                    decoration: InputDecoration(
                      labelText: "Previous Password",
                      prefixIcon: Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(_isObscureOldPassword ? Icons.visibility_off : Icons.visibility),
                        onPressed: () {
                          setState(() {
                            _isObscureOldPassword = !_isObscureOldPassword;
                          });
                        },
                      ),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),

                  SizedBox(height: 20),

                  // New Password Field
                  TextField(
                    controller: _passwordController,
                    obscureText: _isObscurePassword,
                    decoration: InputDecoration(
                      labelText: "New Password",
                      prefixIcon: Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(_isObscurePassword ? Icons.visibility_off : Icons.visibility),
                        onPressed: () {
                          setState(() {
                            _isObscurePassword = !_isObscurePassword;
                          });
                        },
                      ),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),

                  SizedBox(height: 20),

                  // Confirm Password Field
                  TextField(
                    controller: _confirmPasswordController,
                    obscureText: _isObscureConfirmPassword,
                    decoration: InputDecoration(
                      labelText: "Confirm Password",
                      prefixIcon: Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(_isObscureConfirmPassword ? Icons.visibility_off : Icons.visibility),
                        onPressed: () {
                          setState(() {
                            _isObscureConfirmPassword = !_isObscureConfirmPassword;
                          });
                        },
                      ),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),

                  SizedBox(height: 35),

                  // Continue Button (Disabled Until Conditions Met)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isButtonEnabled ? _changePassword : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isButtonEnabled ? Colors.blue : Colors.grey,
                        padding: EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: _isLoading
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text(
                        "Continue",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
