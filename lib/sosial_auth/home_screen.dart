import 'package:firebase/sosial_auth/google_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomeScreen extends StatefulWidget {
  final String username;
  final String userImage;
  const HomeScreen({super.key, required this.username, required this.userImage});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(color: Colors.white,),
        title: Text('Home',style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.indigo,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 30),
              // child: Text('Welcome ${widget.username}',textScaleFactor: 2,),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(widget.userImage),
                  ),
                  SizedBox(height: 10,),
                  Text(
                    'Welcome, ${widget.username}!',
                    style: TextStyle(fontSize: 24),
                  ),
                ],
              )
            ),
            SizedBox(height: 20,),

            Row(
              children: [
                // ElevatedButton(onPressed: () {
                //   Navigator.push(context, MaterialPageRoute(builder: (context) => GoogleAuth(),));
                // }, child: Text('Google_Login')),

                SizedBox(width: 8,),

                Padding(
                  padding: const EdgeInsets.only(left: 150),
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: IconButton(onPressed: () async{
                      await GoogleSignIn().signOut();
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>const GoogleAuth(),));
                    }, icon: Icon(Icons.login_outlined,color: Colors.white,)),
                  ),
                )
              ],
            ),

          ],
        ),
      ),
    );
  }
}