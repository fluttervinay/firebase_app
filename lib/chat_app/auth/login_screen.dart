import 'package:firebase/chat_app/auth/forgot_pass.dart';
import 'package:firebase/chat_app/auth/register_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../chat_screen.dart';

class Authloginscreen extends StatefulWidget {
  const Authloginscreen({super.key});

  @override
  State<Authloginscreen> createState() => _AuthloginscreenState();
}

class _AuthloginscreenState extends State<Authloginscreen> {
  bool _isChecked = false;

  // @override
  // void initState() {
  //   fetchAndActivate();
  //   super.initState();
  // }

  bool _isObscure = true;
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isloading=false;

  Future<void> signIn(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true; // Set loading state to true
      });
      try {
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ChatPage(
              email: email,
            ),
          ),
        );
      } on FirebaseAuthException catch (e) {
        String errorMessage = '';

        if (e.code == 'user-not-found') {
          errorMessage = 'No user found for that email.';
        } else if (e.code == 'wrong-password') {
          errorMessage = 'Wrong password provided for that user.';
        } else {
          errorMessage = 'An error occurred. Please try again.';
        }

        _showErrorDialog(errorMessage); // Show error dialog
      } finally {
        setState(() {
          _isLoading = false; // Reset loading state
        });
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }


  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Center(
                child: Text('Hi, Welcome Back! 👋',
                  style: GoogleFonts.poppins(
                    textStyle: Theme.of(context).textTheme.displayLarge,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(height: 25,),
             Padding(
               padding: const EdgeInsets.all(16.0),
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   Padding(
                     padding: const EdgeInsets.all(4.0),
                     child: Text("Email",
                       style: GoogleFonts.lato(
                         fontSize: 14,
                       ),
                     ),
                   ),
                   TextField(
                     style: GoogleFonts.poppins(
                       fontSize: 14,
                     ),
                     controller: emailController,
                     decoration: InputDecoration(
                         hintText: 'example@gmail.com',
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
                   Padding(
                     padding: const EdgeInsets.all(4.0),
                     child: Text("Password",
                       style: GoogleFonts.lato(
                         fontSize: 14,
                       ),
                     ),
                   ),
                   TextField(
                     style: GoogleFonts.poppins(
                       fontSize: 14,
                     ),
                     controller: passwordController,
                     obscureText: _isObscure,
                     decoration: InputDecoration(
                         hintText: 'Enter Your Password',
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
                   )
                 ],
               ),
             ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                   Row(
                     children: [
                       Checkbox(
                         checkColor: Colors.black,
                         activeColor: Colors.transparent,
                         side: BorderSide(
                             color: Colors.grey
                         ),
                         value: _isChecked,
                         onChanged: (bool? value) {
                           setState(() {
                             _isChecked = value!;
                           });
                         },
                       ),
                       Text("Remember Me",
                         style: GoogleFonts.manrope(
                           fontSize: 15,
                           fontWeight: FontWeight.w700,
                         ),
                       ),
                     ],
                   ),
                    TextButton(onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ForgotPass(),));
                    }, child: Text('Forgot Password?',
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        color: Colors.redAccent,
                        fontWeight: FontWeight.w500,
                      ),))
                  ],
                ),
              ),

              SizedBox(height: 14,),
              GestureDetector(
                onTap: _isLoading
                    ? null // Disable button when loading
                    : () {
                  signIn(
                      emailController.text.trim(),
                      passwordController.text.trim());
                },
                child: Container(
                  width: 312,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.indigo,
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: Center(
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white,) // Show loading indicator
                        : Text('Login',style: GoogleFonts.poppins(
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
                  signInWithGoogle().then((value) {
                    setState(() {
                      isloading=false;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatPage(email: AutofillHints.email,),
                        ),
                      );
                      print("User Name:${value.user?.displayName}");
                    });
                  },).onError((error, stackTrace) {
                    print('Erro Found: ${error.toString()}');
                  },);
                },
                child: Container(
                  height: 50,
                  width: 312,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.grey,
                      width: 1.3
                    )
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/g.webp', // Replace with your Google logo asset
                        height: 30.0,
                      ),
                      SizedBox(width: 10,),
                      Text(
                        'Login with Google',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
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
                  Text('Don’t have an account ? ',
                    style: GoogleFonts.manrope(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w500
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Authregiterscreen(),));
                    },
                    child: Text('Sign Up',
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
      ),
    );
  }
}
