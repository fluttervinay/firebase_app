import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageUpload extends StatefulWidget {
  @override
  _ImageUploadState createState() => _ImageUploadState();
}

class _ImageUploadState extends State<ImageUpload> {
  final ImagePicker _picker = ImagePicker();
  String? _imageUrl;

  Future<void> _uploadImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) {
      print('No image selected');
      return;
    }

    File file = File(image.path);
    String fileName = image.name;

    print('Uploading image: $fileName');

    try {
      Reference ref = FirebaseStorage.instance.ref().child('images/$fileName');
      UploadTask uploadTask = ref.putFile(file);
      await uploadTask;

      String downloadUrl = await ref.getDownloadURL();
      setState(() {
        _imageUrl = downloadUrl; // Update local state
      });

      DatabaseReference dbRef = FirebaseDatabase.instance.ref('images');
      await dbRef.push().set({'url': downloadUrl}); // Save to database

      print('Image uploaded and URL saved in database: $downloadUrl');
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Image'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_imageUrl != null) Image.network(_imageUrl!),
            ElevatedButton(
              onPressed: _uploadImage,
              child: Text('Upload Image'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => ImageDisplay()),
                );
              },
              child: Text('View Uploaded Images'),
            ),
          ],
        ),
      ),
    );
  }
}

class ImageDisplay extends StatefulWidget {
  @override
  _ImageDisplayState createState() => _ImageDisplayState();
}

class _ImageDisplayState extends State<ImageDisplay> {
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref('images');
  List<String> _imageUrls = [];

  @override
  void initState() {
    super.initState();
    _fetchImages(); // Fetch images on init
  }

  Future<void> _fetchImages() async {
    _databaseRef.onValue.listen(
          (event) {
        final data = event.snapshot.value as Map<dynamic, dynamic>?;

        if (data != null) {
          List<String> urls = [];
          data.forEach((key, value) {
            urls.add(value['url']);
          });

          setState(() {
            _imageUrls = urls; // Update the UI with new URLs
          });
        }
      },
      onError: (error) {
        print('Error fetching images: $error');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fetched Images'),
      ),
      body: _imageUrls.isEmpty
          ? Center(child: CircularProgressIndicator())
          : GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1,
        ),
        itemCount: _imageUrls.length,
        itemBuilder: (context, index) {
          return Card(
            child: Image.network(
              _imageUrls[index],
              fit: BoxFit.cover,
            ),
          );
        },
      ),
    );
  }
}
