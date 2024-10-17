import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Fetch the current user
    User? currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Profile Information',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            // Show profile image (you can use any image source)
            Center(
              child: CircleAvatar(
                backgroundColor: Colors.white10,
                radius: 50,
                backgroundImage: NetworkImage(
                  currentUser?.photoURL ?? 'https://static.vecteezy.com/system/resources/thumbnails/020/911/740/small/user-profile-icon-profile-avatar-user-icon-male-icon-face-icon-profile-icon-free-png.png', // Default image if no profile picture
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Display user's email
            Center(
              child: Text(
                'Email: ${currentUser?.email ?? 'No email available'}',
                style: const TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 20),

          ],
        ),
      ),
    );
  }
}
