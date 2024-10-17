import 'dart:io';
import 'package:firebase/cloud_storage/featch_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class UploadImage extends StatefulWidget {
  const UploadImage({super.key});

  @override
  State<UploadImage> createState() => _UploadImageState();
}

class _UploadImageState extends State<UploadImage> {
  String? imageUrl;
  Reference? imageRef; // To store the reference to the uploaded image
  final ImagePicker _imagePicker = ImagePicker();
  bool isloading = false;

  FirebaseStorage storage = FirebaseStorage.instanceFor(bucket: 'gs://fir-fb3c5.appspot.com');

  pickImage() async {
    XFile? res = await _imagePicker.pickImage(source: ImageSource.gallery);

    if (res != null) {
      uploadtoFirebase(File(res.path));
    }
  }

  uploadtoFirebase(File image) async {
    setState(() {
      isloading = true;
    });
    try {
      imageRef = storage.ref().child('Images/${DateTime.now().millisecondsSinceEpoch}.png');

      await imageRef!.putFile(image).whenComplete(() {
        Fluttertoast.showToast(msg: 'Image uploaded to Firebase 🔥');
      });

      imageUrl = await imageRef!.getDownloadURL();

    } catch (e) {
      print('Error occurred: $e');
    }
    setState(() {
      isloading = false;
    });
  }

  // Function to delete image
  deleteImage() async {
    if (imageRef != null) {
      setState(() {
        isloading = true;
      });
      try {
        await imageRef!.delete();
        Fluttertoast.showToast(msg: 'Image deleted from Firebase 🔥');

        // Reset image URL after deletion
        setState(() {
          imageUrl = null;
          imageRef = null;
        });

      } catch (e) {
        print('Error occurred while deleting: $e');
      }
      setState(() {
        isloading = false;
      });
    } else {
      Fluttertoast.showToast(msg: 'No image to delete');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Image'),
        actions: [
          IconButton(onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => FetchDynamicImages(),));
          }, icon: Icon(Icons.folder))
        ],
      ),
      body: Center(
        child: ListView(
          shrinkWrap: true,
          children: [
            imageUrl == null
                ? Icon(Icons.person, size: 200, color: Colors.grey)
                : Center(
              child: Image.network(
                imageUrl!,
                height: 250,
              ),
            ),
            SizedBox(height: 50),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  pickImage();
                },
                icon: Icon(Icons.image),
                label: Text('Upload Image', style: TextStyle(fontSize: 20)),
              ),
            ),
            if (imageUrl != null)
              Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    deleteImage();
                  },
                  icon: Icon(Icons.delete),
                  label: Text('Delete Image', style: TextStyle(fontSize: 20)),
                ),
              ),
            SizedBox(height: 40),
            if (isloading)
              SpinKitThreeBounce(
                color: Colors.black,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}
