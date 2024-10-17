import 'dart:io';
import 'package:firebase/chat_app/auth/login_screen.dart';
import 'package:firebase/chat_app/user_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jiffy/jiffy.dart';
import 'message.dart';

class ChatPage extends StatefulWidget {
  final String email;

  const ChatPage({Key? key, required this.email}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController messageController = TextEditingController();
  final DatabaseReference messageRef = FirebaseDatabase.instance.ref().child('Messages');
  final DatabaseReference userRef = FirebaseDatabase.instance.ref().child('Users');
  final ImagePicker _imagePicker = ImagePicker();
  final FirebaseStorage storage = FirebaseStorage.instanceFor(bucket: 'gs://fir-fb3c5.appspot.com');

  @override
  void initState() {
    super.initState();
    _setUserStatusOnline();
  }

  @override
  void dispose() {
    messageController.dispose();
    _setUserStatusOffline();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text('Chat'),
        actions: [
          MaterialButton(
            onPressed: _signOut,
            child: const Text("Sign Out"),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => UserProfilePage()));
            },
            icon: const Icon(Icons.account_circle_outlined),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: MessageScreen(email: widget.email), // Ensure MessageScreen is implemented correctly
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: messageController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.transparent,
                  hintText: 'Enter your message',
                  suffixIcon:  IconButton(
                    icon: const Icon(Icons.image),
                    onPressed: _pickImage,
                  ),
                  hintStyle: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.grey, width: 1.5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.purple, width: 1), // Slightly thinner enabled border
                    borderRadius: BorderRadius.circular(12),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.red, width: 1), // Error border style
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.red, width: 2), // Focused error border style
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                style: GoogleFonts.poppins(
                  fontSize: 16, // Font size for the text
                  color: Colors.black, // Text color
                ),
                onFieldSubmitted: (_) => _sendMessage(),
              ),
            )

          ),

          IconButton(
            icon: Container(
              width: 30, // Set the width of the image
              height: 30, // Set the height of the image
              child: Image.asset(
                'assets/ins.png', // Replace with your image path
                fit: BoxFit.cover, // Scale the image
              ),
            ),
            onPressed: _sendMessage,
            splashRadius: 24, // Radius of the splash effect
          ),

        ],
      ),
    );
  }

  void _sendMessage() {
    if (messageController.text.trim().isNotEmpty) {
      messageRef.push().set({
        'message': messageController.text.trim(),
        'time': Jiffy.now().yMMMMEEEEdjm,
        'email': widget.email,
      });
      messageController.clear();
    }
  }

  Future<void> _pickImage() async {
    final XFile? image = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      await _uploadImage(File(image.path));
    }
  }

  Future<void> _uploadImage(File image) async {
    try {
      final Reference storageRef = storage.ref().child('ChatImages/${DateTime.now().millisecondsSinceEpoch}.png');
      UploadTask uploadTask = storageRef.putFile(image);
      await uploadTask;

      String downloadUrl = await storageRef.getDownloadURL();

      messageRef.push().set({
        'imageUrl': downloadUrl,
        'time': DateTime.now().toIso8601String(),
        'email': widget.email,
      });

      Fluttertoast.showToast(msg: 'Image sent successfully!');
    } catch (e) {
      print('Error uploading image: $e');
      Fluttertoast.showToast(msg: 'Error sending image: $e');
    }
  }

  Future<void> _signOut() async {
    try {
      await _setUserStatusOffline();
      await GoogleSignIn().signOut();
      await _auth.signOut();

      Navigator.pop(
        context,
        MaterialPageRoute(builder: (context) => const Authloginscreen()),
      );
    } catch (e) {
      print('Sign-out error: $e');
    }
  }


  void _setUserStatusOnline() {
    final User? user = _auth.currentUser;
    if (user != null) {
      userRef.child(user.uid).update({
        'status': 'online',
        'lastSeen': DateTime.now().toIso8601String(),
      });

      userRef.child(user.uid).onDisconnect().update({
        'status': 'offline',
        'lastSeen': DateTime.now().toIso8601String(),
      });
    }
  }

  Future<void> _setUserStatusOffline() async {
    final User? user = _auth.currentUser;
    if (user != null) {
      await userRef.child(user.uid).update({
        'status': 'offline',
        'lastSeen': DateTime.now().toIso8601String(),
      });
    }
  }
}
