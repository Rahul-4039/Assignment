import 'package:flutter/material.dart';

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
  late TextEditingController nameController;
  late TextEditingController usernameController;
  late TextEditingController phoneController;
  late TextEditingController emailController;
  String selectedGender = "Male";

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Edit Profile")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: "Name"),
            ),

            SizedBox(height: 20),

            TextField(
              controller: usernameController,
              decoration: InputDecoration(labelText: "Username"),
            ),

            SizedBox(height: 20),

            DropdownButtonFormField(
              value: selectedGender,
              items: ["Male", "Female"].map((String category) {
                return DropdownMenuItem(value: category, child: Text(category));
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  selectedGender = newValue.toString();
                });
              },
              decoration: InputDecoration(labelText: "Gender"),
            ),

            SizedBox(height: 20),

            TextField(
              controller: phoneController,
              decoration: InputDecoration(labelText: "Phone Number"),
              keyboardType: TextInputType.phone,
            ),

            SizedBox(height: 20),

            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: "Email"),
              keyboardType: TextInputType.emailAddress,
            ),

            SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, {
                  "name": nameController.text,
                  "username": usernameController.text,
                  "gender": selectedGender,
                  "phone": phoneController.text,
                  "email": emailController.text,
                });
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.lightBlueAccent),
              child: Text("Save"),
            ),
          ],
        ),
      ),
    );
  }
}
