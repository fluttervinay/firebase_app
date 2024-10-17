import 'package:flutter/material.dart';
import 'auth_services.dart';
import 'login.dart';


class HomePage extends StatelessWidget {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    String? displayName = _auth.getcurrentusername();

    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              AuthService().signOut();
              Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen(),));
            },
          )
        ],
      ),
      body: Center(
        child: Text(
          displayName != null
              ? 'Welcome, $displayName'
              : 'Welcome!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}