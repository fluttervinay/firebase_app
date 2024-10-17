import 'package:flutter/material.dart';

class PhoneInputScreen extends StatefulWidget {
  @override
  _PhoneInputScreenState createState() => _PhoneInputScreenState();
}

class _PhoneInputScreenState extends State<PhoneInputScreen> {
  String phoneNumber = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Enter Phone Number")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(labelText: "Phone Number"),
              onChanged: (value) {
                phoneNumber = value;
              },
            ),
            ElevatedButton(
              onPressed: () {
                // Trigger OTP request (next screen after this)
                Navigator.pushNamed(context, '/otp', arguments: phoneNumber);
              },
              child: Text("Request OTP"),
            ),
          ],
        ),
      ),
    );
  }
}
