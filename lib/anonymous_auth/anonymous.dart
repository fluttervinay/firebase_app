import 'package:firebase/screen/hom.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Anonymous Authentication Demo',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _message = '';

  Future<void> _signInAnonymously() async {
    try {
      await _auth.signInAnonymously();
      setState(() {
        _message = 'Signed in anonymously';
        print(_message);
        // Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(),));
      });
    } catch (e) {
      setState(() {
        _message = 'Error signing in anonymously: $e';
        print('Error signing in anonymously: ${e}');
      });
    }
  }
  @override
  void initState() {
    print("Auth Domian==> ${_auth.currentUser?.metadata.creationTime}");
    print("Current User==> ${_auth.currentUser?.metadata.lastSignInTime}");
    print("Current User==> ${_auth.currentUser?.isAnonymous??""}");
    print("Current User==> ${_auth.currentUser?.uid??""}");
    super.initState();
  }

  Future<void> _signOut() async {
    await _auth.signOut();
    setState(() {
      _message = 'Signed out';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Anonymous Authentication Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Anonymously User Detail'),
                SizedBox(height: 3,),
                Text("Status: ${_message}"),
                SizedBox(height: 3,),
                Text("creationTime: ${_auth.currentUser?.metadata.creationTime}"),
                SizedBox(height: 3,),
                Text("lastSignInTime: ${_auth.currentUser?.metadata.lastSignInTime}"),
                SizedBox(height: 3,),
                Text("isAnonymous: ${_auth.currentUser?.isAnonymous??""}"),
                SizedBox(height: 3,),
                Text("UID: ${_auth.currentUser?.uid??""}"),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _signInAnonymously,
              child: Text('Sign in anonymously'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _signOut,
              child: Text('Sign out'),
            ),
          ],
        ),
      ),
    );
  }
}