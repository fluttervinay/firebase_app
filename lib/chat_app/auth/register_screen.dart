import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/chat_app/auth/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Authregiterscreen extends StatefulWidget {
  const Authregiterscreen({super.key});

  @override
  State<Authregiterscreen> createState() => _AuthregiterscreenState();
}

class _AuthregiterscreenState extends State<Authregiterscreen> {

  final auth = FirebaseAuth.instance;
  CollectionReference ref = FirebaseFirestore.instance.collection('user');

  final TextEditingController passwordController = new TextEditingController();
  final TextEditingController confirmpassController =
  new TextEditingController();
  final TextEditingController emailController = new TextEditingController();

  var error = null;
  bool _isObscure = true;

  register(String email, String password) async {
    if (error == null) {
      await auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .whenComplete(() {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Authloginscreen()));
      });
    } else {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20,),
            Center(
              child: Text('Create an account',
                style: GoogleFonts.poppins(
                  textStyle: Theme.of(context).textTheme.displayLarge,
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            SizedBox(height: 6,),
            Center(
              child: Text('Connect with your friends today!',
                style: GoogleFonts.manrope(
                  fontSize: 14,
                ),
              ),
            ),
            SizedBox(height: 25,),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                    ),
                    controller: emailController,
                    decoration: InputDecoration(
                        hintText: 'Enter Your Email',
                        hintStyle: GoogleFonts.poppins(
                          fontSize: 13,
                        ),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey,
                            ),
                            borderRadius: BorderRadius.circular(12)
                        )
                    ),
                  ),
                  SizedBox(height: 14,),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                        hintText: 'Enter Your Password',
                        hintStyle: GoogleFonts.poppins(
                          fontSize: 13,
                        ),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey,
                            ),
                            borderRadius: BorderRadius.circular(12)
                        )
                    ),
                  ),
                  SizedBox(height: 14,),
                  TextField(
                    controller: confirmpassController,
                    obscureText: true,
                    decoration: InputDecoration(
                        hintText: 'Confirm Password',
                        suffixIcon: IconButton(
                          icon: Icon(_isObscure
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: () {
                            setState(() {
                              _isObscure = !_isObscure;
                            });
                          },
                        ),
                        hintStyle: GoogleFonts.poppins(
                          fontSize: 13,
                        ),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey,
                            ),
                            borderRadius: BorderRadius.circular(12)
                        )
                    ),
                    onChanged: (value) {
                      if (confirmpassController.text != passwordController.text) {
                        setState(() {
                          error = 'error';
                        });
                      } else {
                        setState(() {
                          error = null;
                        });
                      }
                    },
                  )
                ],
              ),
            ),

            SizedBox(height: 14,),
            GestureDetector(
              onTap: () {
                register(emailController.text, passwordController.text);
              },
              child: Container(
                width: 312,
                height: 50,
                decoration: BoxDecoration(
                    color: Colors.indigo,
                    borderRadius: BorderRadius.circular(10)
                ),
                child: Center(
                  child: Text('Sing Up',style: GoogleFonts.poppins(
                    textStyle: Theme.of(context).textTheme.displayLarge,
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),),
                ),
              ),
            ),

            SizedBox(height: 35,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Divider(
                      thickness: 1,
                      color: Colors.grey,
                      indent: 16,
                      endIndent: 10,
                    ),
                  ),
                  Text(
                    'Or With',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      thickness: 1,
                      color: Colors.grey,
                      indent: 10,
                      endIndent: 16,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20,),
            GestureDetector(
              onTap: () {

              },
              child: Container(
                width: 312,
                height: 48,
                child: Stack(
                  children: [
                    Positioned(
                      left: 0,
                      top: 0,
                      child: Container(
                        width: 312,
                        height: 48,
                        decoration: ShapeDecoration(
                          color: Colors.white.withOpacity(0.019999999552965164),
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              width: 1,
                              color: Colors.black.withOpacity(0.4000000059604645),
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 86,
                      top: 11,
                      child:  Text(
                        'Login with Google',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 8,
                      top: 11,
                      child: Container(
                        width: 26,
                        height: 26,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/g.webp"),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 35,),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Already have an account?',
                  style: GoogleFonts.manrope(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w500
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pop(context, MaterialPageRoute(builder: (context) => Authloginscreen(),));
                  },
                  child: Text('Login',
                    style: GoogleFonts.manrope(
                        fontSize: 16,
                        color: Colors.indigo,
                        fontWeight: FontWeight.w700
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
