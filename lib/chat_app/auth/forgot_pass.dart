import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart'  as launcher;

class ForgotPass extends StatefulWidget {
  const ForgotPass({super.key});

  @override
  State<ForgotPass> createState() => _ForgotPassState();
}

class _ForgotPassState extends State<ForgotPass> {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  String message = '';

  Future<void> resetPassword() async {
    try {
      await _auth.sendPasswordResetEmail(email: _emailController.text);
      setState(() {
        message = 'Password reset email sent! Check your inbox.';
      });
    } on FirebaseAuthException catch (e) {
      setState(() {
        message = e.message!;
      });
    }
  }


  void _showAlertBox() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20), // Rounded corners
          ),
          backgroundColor: Colors.indigo[50], // Custom background color
          title: Row(
            children: [
              Icon(
                Icons.email_outlined, // Icon at the start of the title
                color: Colors.indigo,
              ),
              SizedBox(width: 8),
              Text(
                'Password Reset',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo,
                ),
              ),
            ],
          ),
          content: Text(
            'A password reset link has been sent to your email. Please check your inbox.',
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.indigo, // Button background color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // Rounded button
                ),
              ),
              child: Text(
                'OK',
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  color: Colors.white, // Button text color
                  fontWeight: FontWeight.w600,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: () {
            _showAlertBox();
          }, icon: Icon(Icons.not_listed_location_outlined))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Forgot password',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Enter the email associated with your account and well send '
                    'an email with instructions to reset your password.',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: Color(0xFF989898),
                  fontWeight: FontWeight.w400,

                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10,),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text("Your Email",
                      style: GoogleFonts.lato(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  TextField(
                    controller: _emailController,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                    ),
                    decoration: InputDecoration(
                        hintText: 'contact@dscodetech.com',
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
                  SizedBox(height: 25,),
                  GestureDetector(
                    onTap: resetPassword,
                    child: Container(
                      width: 376,
                      height: 50,
                      decoration: BoxDecoration(
                          color: Colors.indigo,
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: Center(
                        child: Text('Reset Password',style: GoogleFonts.inter(
                          textStyle: Theme.of(context).textTheme.displayLarge,
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  if (message.isNotEmpty)
                    Text(
                      message,
                      style: TextStyle(color: Colors.green),
                    ),

                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () async {
                        Uri uri = Uri.parse(
                          'mailto:info@example.dev?'
                              'subject=Flutter Url Launcher&body=Hi, Flutter developer',
                        );
                        if (!await launcher.launchUrl(uri)) {
                          debugPrint(
                              "Could not launch the uri");
                        }
                      },
                      child: Text(
                        'Open Email!',
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          color: Colors.indigo,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  )


                ],
              ),
            )
          ],
        ),
      )
    );
  }
}
