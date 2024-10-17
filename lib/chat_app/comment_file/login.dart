// import 'package:firebase/screen/forgot_pass.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import '../remot_config/remot_config.dart';
// import 'chat_screen.dart';
// import 'register_screen.dart';
//
// class HomeeScreen extends StatefulWidget {
//   @override
//   _HomeeScreenState createState() => _HomeeScreenState();
// }
//
// class _HomeeScreenState extends State<HomeeScreen> {
//
//   // @override
//   // void initState() {
//   //   fetchAndActivate();
//   //   super.initState();
//   // }
//
//   bool _isObscure = true;
//   bool _isLoading = false;
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//
//
//   Future<void> signIn(String email, String password) async {
//     if (_formKey.currentState!.validate()) {
//       setState(() {
//         _isLoading = true; // Set loading state to true
//       });
//       try {
//         UserCredential userCredential = await _auth.signInWithEmailAndPassword(
//           email: email,
//           password: password,
//         );
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//             builder: (context) => ChatPage(
//               email: email,
//             ),
//           ),
//         );
//       } on FirebaseAuthException catch (e) {
//         String errorMessage = '';
//
//         if (e.code == 'user-not-found') {
//           errorMessage = 'No user found for that email.';
//         } else if (e.code == 'wrong-password') {
//           errorMessage = 'Wrong password provided for that user.';
//         } else {
//           errorMessage = 'An error occurred. Please try again.';
//         }
//
//         _showErrorDialog(errorMessage); // Show error dialog
//       } finally {
//         setState(() {
//           _isLoading = false; // Reset loading state
//         });
//       }
//     }
//   }
//
//   void _showErrorDialog(String message) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Error'),
//           content: Text(message),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop(); // Close dialog
//               },
//               child: const Text('OK'),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Column(
//           children: <Widget>[
//             Container(
//               color: Colors.blue[900],
//               width: MediaQuery.of(context).size.width,
//               height: MediaQuery.of(context).size.height * 0.70,
//               child: Center(
//                 child: Container(
//                   margin: const EdgeInsets.all(12),
//                   child: Form(
//                     key: _formKey,
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         const SizedBox(height: 30),
//                         const Text(
//                           "Login",
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white,
//                             fontSize: 40,
//                           ),
//                         ),
//                         const SizedBox(height: 20),
//                         TextFormField(
//                           controller: emailController,
//                           decoration: InputDecoration(
//                             filled: true,
//                             fillColor: Colors.white,
//                             hintText: 'Email',
//                             contentPadding: const EdgeInsets.only(
//                                 left: 14.0, bottom: 8.0, top: 8.0),
//                             focusedBorder: OutlineInputBorder(
//                               borderSide: const BorderSide(color: Colors.white),
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                             enabledBorder: UnderlineInputBorder(
//                               borderSide: const BorderSide(color: Colors.white),
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                           ),
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return "Email cannot be empty";
//                             }
//                             if (!RegExp(
//                                 r"^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+\.[a-z]")
//                                 .hasMatch(value)) {
//                               return "Please enter a valid email";
//                             }
//                             return null;
//                           },
//                         ),
//                         const SizedBox(height: 20),
//                         TextFormField(
//                           controller: passwordController,
//                           obscureText: _isObscure,
//                           decoration: InputDecoration(
//                             suffixIcon: IconButton(
//                               icon: Icon(_isObscure
//                                   ? Icons.visibility
//                                   : Icons.visibility_off),
//                               onPressed: () {
//                                 setState(() {
//                                   _isObscure = !_isObscure;
//                                 });
//                               },
//                             ),
//                             filled: true,
//                             fillColor: Colors.white,
//                             hintText: 'Password',
//                             contentPadding: const EdgeInsets.only(
//                                 left: 14.0, bottom: 8.0, top: 15.0),
//                             focusedBorder: OutlineInputBorder(
//                               borderSide: const BorderSide(color: Colors.white),
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                             enabledBorder: UnderlineInputBorder(
//                               borderSide: const BorderSide(color: Colors.white),
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                           ),
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return "Password cannot be empty";
//                             }
//                             if (value.length < 6) {
//                               return "Please enter a valid password (min. 6 characters)";
//                             }
//                             return null;
//                           },
//                         ),
//                         const SizedBox(height: 10),
//                         TextButton(
//                           onPressed: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => ForgotPasswordScreen(),
//                               ),
//                             );
//                           },
//                           child: const Text(
//                             'Forgot Password?',
//                             style: TextStyle(color: Colors.white, fontSize: 18),
//                           ),
//                         ),
//                         const SizedBox(height: 20),
//                         MaterialButton(
//                           shape: RoundedRectangleBorder(
//                               borderRadius:
//                               BorderRadius.all(Radius.circular(20.0))),
//                           elevation: 5.0,
//                           height: 40,
//                           onPressed: _isLoading
//                               ? null // Disable button when loading
//                               : () {
//                             signIn(
//                                 emailController.text.trim(),
//                                 passwordController.text.trim());
//                           },
//                           color: Colors.white,
//                           child: _isLoading
//                               ? const CircularProgressIndicator() // Show loading indicator
//                               : const Text(
//                             "Login",
//                             style: TextStyle(
//                               fontSize: 20,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             Container(
//               color: Colors.white,
//               width: MediaQuery.of(context).size.width,
//               child: Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     const SizedBox(height: 20),
//                     MaterialButton(
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.all(
//                           Radius.circular(20.0),
//                         ),
//                       ),
//                       elevation: 5.0,
//                       height: 40,
//                       onPressed: () {
//                         Navigator.pushReplacement(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => RegisterScreen(),
//                           ),
//                         );
//                       },
//                       color: Colors.blue[900],
//                       child: const Text(
//                         "Register Now",
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 20,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 15),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
