import 'dart:async';
import 'dart:io';
import 'package:firebase/cloud_storage/full_screen_img.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class FetchDynamicImages extends StatefulWidget {
  const FetchDynamicImages({super.key});

  @override
  State<FetchDynamicImages> createState() => _FetchDynamicImagesState();
}

class _FetchDynamicImagesState extends State<FetchDynamicImages> {
  final StreamController<List<String>> _imageStreamController =
  StreamController<List<String>>.broadcast();
  FirebaseStorage storage = FirebaseStorage.instanceFor(bucket: 'gs://fir-fb3c5.appspot.com');
  final ImagePicker _imagePicker = ImagePicker();

  // Function to fetch image URLs dynamically and add them to the stream
  Future<void> fetchImages() async {
    try {
      final ListResult result = await storage.ref('Images').listAll();
      List<String> urls = await Future.wait(result.items.map((ref) => ref.getDownloadURL()));
      _imageStreamController.add(urls); // Emit new URLs to the stream
      Fluttertoast.showToast(msg: 'Images fetched from 🔥base');
    } catch (e) {
      print('Error fetching images: $e');
    }
  }

  // Function to delete image from Firebase Storage
  deleteImage(String imageUrl) async {
    try {
      Reference ref = await storage.refFromURL(imageUrl);
      await ref.delete();
      Fluttertoast.showToast(msg: 'Image deleted from Firebase 🔥');
      fetchImages(); // Refresh images after deletion
    } catch (e) {
      print('Error deleting image: $e');
      Fluttertoast.showToast(msg: 'Failed to delete image');
    }
  }

  // Function to pick a new image and update an existing one
  updateImage(String oldImageUrl) async {
    XFile? newImage = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (newImage == null) return;

    try {
      Reference oldImageRef = await storage.refFromURL(oldImageUrl);
      await oldImageRef.delete();
      Reference newImageRef = storage.ref('Images/${DateTime.now().millisecondsSinceEpoch}.png');
      await newImageRef.putFile(File(newImage.path));
      Fluttertoast.showToast(msg: 'Image updated successfully 🔥');
      fetchImages(); // Refresh images after update
    } catch (e) {
      print('Error updating image: $e');
      Fluttertoast.showToast(msg: 'Failed to update image');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchImages(); // Fetch the images initially
  }

  @override
  void dispose() {
    _imageStreamController.close(); // Close the stream controller when disposing
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Display Image'),
      ),
      body: StreamBuilder<List<String>>(
        stream: _imageStreamController.stream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No images found', style: TextStyle(fontSize: 18)));
          }

          final imageUrls = snapshot.data!; // Get the image URLs from the snapshot

          return GridView.builder(
            padding: EdgeInsets.all(10),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: imageUrls.length,
            itemBuilder: (context, index) {
              return Stack(
                children: [
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => FullScreenImage(imageUrl: imageUrls[index])),
                          );
                        },
                        child: Image.network(
                          imageUrls[index],
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(child: Icon(Icons.image, color: Colors.grey, size: 100));
                          },
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 40,
                    child: CircleAvatar(
                      backgroundColor: Colors.blue,
                      radius: 15,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        icon: Icon(Icons.edit, color: Colors.white, size: 16),
                        onPressed: () {
                          updateImage(imageUrls[index]);
                        },
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: CircleAvatar(
                      backgroundColor: Colors.red,
                      radius: 15,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        icon: Icon(Icons.delete_forever_outlined, color: Colors.white, size: 16),
                        onPressed: () {
                          deleteImage(imageUrls[index]);
                        },
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

