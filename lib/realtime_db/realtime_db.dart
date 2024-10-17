import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FirebaseDatabaseExample(),
    );
  }
}

class FirebaseDatabaseExample extends StatefulWidget {
  @override
  _FirebaseDatabaseExampleState createState() =>
      _FirebaseDatabaseExampleState();
}

class _FirebaseDatabaseExampleState extends State<FirebaseDatabaseExample> {
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref(); // Updated ref() method
  String _retrievedData = "No data yet";

  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController userIdController = TextEditingController();

  // Write data to Firebase
  void _writeData() {
    if (userIdController.text.isEmpty) {
      _showSnackBar('User ID is required', Colors.red);
      return;
    }

    _databaseRef.child("users/${userIdController.text}").set({
      "name": nameController.text,
      "age": ageController.text,
      "email": emailController.text
    }).then((_) {
      _showSnackBar('Data added successfully!', Colors.green);
    }).catchError((error) {
      print("Failed to write data: $error");
    });
  }

  // Read data from Firebase and update TextFields
  void _readData() {
    if (userIdController.text.isEmpty) {
      _showSnackBar('User ID is required', Colors.red);
      return;
    }

    _databaseRef.child("users/${userIdController.text}").get().then((DataSnapshot snapshot) {
      if (snapshot.exists) {
        Map<String, dynamic> userData = Map<String, dynamic>.from(snapshot.value as Map);
        setState(() {
          nameController.text = userData["name"];
          ageController.text = userData["age"].toString();
          emailController.text = userData["email"];
          _retrievedData = userData.toString();
        });
        _showSnackBar('Data loaded successfully!', Colors.green);
      } else {
        setState(() {
          _retrievedData = "No data found";
        });
        _showSnackBar('No data found for this User ID', Colors.red);
      }
    }).catchError((error) {
      print("Failed to read data: $error");
    });
  }

  // Update data in Firebase
  void _updateData() {
    if (userIdController.text.isEmpty) {
      _showSnackBar('User ID is required', Colors.red);
      return;
    }

    _databaseRef.child("users/${userIdController.text}").update({
      "name": nameController.text,
      "age": ageController.text,
      "email": emailController.text
    }).then((_) {
      _showSnackBar('Data updated successfully!', Colors.blue);
    }).catchError((error) {
      print("Failed to update data: $error");
    });
  }

  // Delete data from Firebase
  void _deleteData() {
    if (userIdController.text.isEmpty) {
      _showSnackBar('User ID is required', Colors.red);
      return;
    }

    _databaseRef.child("users/${userIdController.text}").remove().then((_) {
      _showSnackBar('Data deleted successfully!', Colors.orange);
      // Clear text fields after deletion
      nameController.clear();
      ageController.clear();
      emailController.clear();
    }).catchError((error) {
      print("Failed to delete data: $error");
    });
  }

  // Show snackbar for feedback
  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: color),
    );
  }

  @override
  void dispose() {
    userIdController.dispose();
    nameController.dispose();
    ageController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firebase Realtime Database - Dynamic'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: userIdController,
                decoration: InputDecoration(
                  hintText: "User ID",
                  labelText: "Enter User ID",
                ),
              ),
              SizedBox(height: 6),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  hintText: "Name",
                  labelText: "Enter Name",
                ),
              ),
              SizedBox(height: 6),
              TextField(
                controller: ageController,
                decoration: InputDecoration(
                  hintText: "Age",
                  labelText: "Enter Age",
                ),
              ),
              SizedBox(height: 6),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: "Email",
                  labelText: "Enter Email",
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Retrieved Data:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                _retrievedData,
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: _writeData,
                child: Text('Write Data'),
              ),
              ElevatedButton(
                onPressed: _readData,
                child: Text('Load Data'),
              ),
              ElevatedButton(
                onPressed: _updateData,
                child: Text('Update Data'),
              ),
              ElevatedButton(
                onPressed: _deleteData,
                child: Text('Delete Data'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
