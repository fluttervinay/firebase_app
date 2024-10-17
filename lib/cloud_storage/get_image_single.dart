import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'full_screen_img.dart';

class FetchDynamicImages extends StatefulWidget {
  const FetchDynamicImages({super.key});

  @override
  State<FetchDynamicImages> createState() => _FetchDynamicImagesState();
}

class _FetchDynamicImagesState extends State<FetchDynamicImages> {
  List<String> imageUrls = []; // Store the fetched image URLs here
  bool isLoading = false;
  FirebaseStorage storage = FirebaseStorage.instanceFor(bucket: 'gs://fir-fb3c5.appspot.com');
  final ImagePicker _imagePicker = ImagePicker(); // For selecting a new image

  // Function to fetch image URLs dynamically from Firestore
  Stream<List<String>> fetchImages() {
    return FirebaseFirestore.instance
        .collection('images') // Your Firestore collection
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc['url'] as String).toList());
  }

  // Function to upload a new image and store its URL in Firestore
  Future<void> uploadImage() async {
    XFile? newImage = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (newImage == null) return;

    setState(() {
      isLoading = true;
    });

    try {
      // Upload the new image
      Reference newImageRef = storage.ref('Images/${DateTime.now().millisecondsSinceEpoch}.png');
      await newImageRef.putFile(File(newImage.path));

      // Get the new download URL
      String newImageUrl = await newImageRef.getDownloadURL();

      // Store the URL in Firestore
      await FirebaseFirestore.instance.collection('images').add({'url': newImageUrl});

      Fluttertoast.showToast(msg: 'Image uploaded successfully 🔥');
    } catch (e) {
      print('Error uploading image: $e');
      Fluttertoast.showToast(msg: 'Failed to upload image');
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Display Image'),
        actions: [
          IconButton(
            icon: Icon(Icons.upload),
            onPressed: uploadImage, // Upload a new image
          ),
        ],
      ),
      body: StreamBuilder<List<String>>(
        stream: fetchImages(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error fetching images'));
          }

          final imageUrls = snapshot.data ?? [];

          return imageUrls.isEmpty
              ? Center(
            child: Text(
              'No images found',
              style: TextStyle(fontSize: 18),
            ),
          )
              : GridView.builder(
            padding: EdgeInsets.all(10),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Number of images in a row
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: imageUrls.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FullScreenImage(imageUrl: imageUrls[index]),
                    ),
                  );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.network(
                    imageUrls[index],
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child; // Image loaded
                      return Center(
                        child: Icon(
                          Icons.image,
                          color: Colors.grey,
                          size: 100,
                        ), // Default icon while loading
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
