import 'package:email_auth/email_auth.dart';
import 'package:flutter/material.dart';

class EmailOtp extends StatefulWidget {
  const EmailOtp({super.key});

  @override
  State<EmailOtp> createState() => _EmailOtpState();
}

class _EmailOtpState extends State<EmailOtp> {
  final TextEditingController _emailcontroller=TextEditingController();
  final TextEditingController _otpcontoller=TextEditingController();

    //package servre issue

  late EmailAuth emailAuth;

  void initState() {
    super.initState();
    emailAuth = EmailAuth(sessionName: 'Email Session');
  }

  void sendOtp() async {
    var res = await emailAuth.sendOtp(recipientMail: _emailcontroller.text);
    if (res) {
      // OTP sent successfully
    } else {
      // OTP sending failed
    }
  }

  void verifyOtp() async {
    var res = await emailAuth.validateOtp(
      recipientMail: _emailcontroller.text,
      userOtp: _otpcontoller.text, // assuming you have a TextEditingController for OTP input
    );
    if (res) {
      // OTP verified successfully
    } else {
      // OTP verification failed
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Email OTP Vefication"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _emailcontroller,
                    decoration: InputDecoration(
                      hintText: 'Email',
                    ),
                  ),
                ),
                TextButton(onPressed: () {
                  sendOtp();
                }, child: Text('Send OTP'))
              ],
            ),
            SizedBox(height: 20,),
            SizedBox(
              width: 200,
              child: TextField(

                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: "OTP",
                  hintStyle: TextStyle(color: Colors.grey,),
                ),
              ),
            ),
            SizedBox(height: 20,),
            SizedBox(
              width: 250,
              height: 45,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0), // adjust the value as needed
                  ),
                ),
                onPressed: () {
                  verifyOtp();
                },
                child: Text('Verfy OTP',style: TextStyle(color: Colors.white),),
              ),
            )
          ],
        ),
      ),
    );
  }
}
