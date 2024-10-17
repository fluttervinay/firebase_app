import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart'; // Import this for getTemporaryDirectory

class UploadImageFromUrl extends StatefulWidget {
  @override
  _UploadImageFromUrlState createState() => _UploadImageFromUrlState();
}

class _UploadImageFromUrlState extends State<UploadImageFromUrl> {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref().child('Images');

  Future<void> uploadImageFromUrl(String imageUrl) async {
    try {
      // Step 1: Download the image
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode != 200) {
        throw Exception('Failed to download image');
      }

      // Step 2: Create a file from the downloaded bytes
      final List<int> bytes = response.bodyBytes;
      final Directory tempDir = await getTemporaryDirectory();
      final File file = File('${tempDir.path}/temp_image.png');
      await file.writeAsBytes(bytes);

      // Step 3: Upload the image to Firebase Storage
      String fileName = 'images/${DateTime.now().millisecondsSinceEpoch}.png';
      Reference ref = _storage.ref(fileName);
      await ref.putFile(file);

      // Step 4: Get the image download URL
      String downloadUrl = await ref.getDownloadURL();

      // Step 5: Store the URL in Firebase Realtime Database
      await _dbRef.push().set(downloadUrl);
      Fluttertoast.showToast(msg: 'Image uploaded from URL successfully!');
    } catch (e) {
      print('Error uploading image from URL: $e');
      Fluttertoast.showToast(msg: 'Failed to upload image from URL');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Image from URL'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            String imageUrl = 'https://example.com/path/to/your/image.png'; // Replace with your image URL
            uploadImageFromUrl(imageUrl);
          },
          child: Text('Upload Image'),
        ),
      ),
    );
  }
}
