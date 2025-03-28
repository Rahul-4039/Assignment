import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:open_file/open_file.dart'; // Import open_file package

class TuploadAssignmentPage extends StatefulWidget {
  @override
  _TuploadAssignmentPageState createState() => _TuploadAssignmentPageState();
}

class _TuploadAssignmentPageState extends State<TuploadAssignmentPage> {
  List<File> _uploadedAssignments = []; // Stores uploaded files

  // Function to pick a file and add it to the list
  Future<void> _pickAndUploadFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        _uploadedAssignments.insert(0, File(result.files.single.path!)); // Add at the top
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: _uploadedAssignments.isEmpty
                  ? Center(child: Text("No assignments uploaded yet", style: TextStyle(fontSize: 16)))
                  : ListView.builder(
                itemCount: _uploadedAssignments.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 3,
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: Icon(Icons.insert_drive_file, size: 40, color: Colors.blue),
                      title: Text(
                        _uploadedAssignments[index].path.split('/').last,
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text("Uploaded successfully"),
                      onTap: () {
                        OpenFile.open(_uploadedAssignments[index].path); // Open file on tap
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _pickAndUploadFile,
        child: Icon(Icons.add, size: 30),
      ),
    );
  }
}
