import 'package:assignment/pages/signin.dart';
import 'package:assignment/studentnav.dart';
import 'package:assignment/teachernav.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: AuthCheck(), // Auto-check if user is signed in
    );
  }
}

// Widget to check authentication state and navigate based on role
class AuthCheck extends StatelessWidget {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          User? user = snapshot.data;
          if (user != null) {
            return FutureBuilder<DataSnapshot>(
              future: _dbRef.child("users").child(user.uid).get(),
              builder: (context, AsyncSnapshot<DataSnapshot> roleSnapshot) {
                if (roleSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator()); // Loading indicator
                }

                if (roleSnapshot.hasData && roleSnapshot.data!.value != null) {
                  Map<String, dynamic> userData =
                  Map<String, dynamic>.from(roleSnapshot.data!.value as Map);
                  String role = userData['role'] ?? 'student'; // Default to student if role not found

                  // Navigate based on role
                  if (role == "teacher") {
                    return TeacherNav(); // Navigate to Teacher Year Page
                  } else {
                    return MainNavigation(); // Navigate to Student Dashboard
                  }
                } else {
                  return SignInPage(); // If user data not found, go to sign-in page
                }
              },
            );
          } else {
            return SignInPage(); // If user is null, show sign-in page
          }
        } else {
          return SignInPage(); // If not signed in, show sign-in page
        }
      },
    );
  }
}
