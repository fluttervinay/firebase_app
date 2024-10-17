import 'dart:io';
import 'dart:ui';
import 'package:firebase/anonymous_auth/anonymous.dart';
import 'package:firebase/chat_app/spalsh_screen.dart';
import 'package:firebase/cloud_storage/image_upload.dart';
import 'package:firebase/otp_verification/email_otp.dart';
import 'package:firebase/realtime_db/realtime_db.dart';
import 'package:firebase/realtime_db/to_do_app.dart';
import 'package:firebase/remot_config/force_update/force_screen.dart';
import 'package:firebase/remot_config/remot_config.dart';
import 'package:firebase/screen/login.dart';
import 'package:firebase/sosial_auth/google_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';

import 'Crashlytics/crlt_screen.dart';
import 'chat_app/chat_screen.dart';
import 'cloud_storage/featch_image.dart';
import 'cloud_storage/refresh/show.dart';
import 'cloud_storage/refresh/upload.dart';
import 'otp_verification/otp_verification_screen.dart';
import 'otp_verification/phoneinput_screen.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  if(Platform.isAndroid){
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: 'AIzaSyDDV_mqKAi-tISK1XmJt4J9WoU2G2qk1fY',
        appId: '1:822219183784:android:e338b011e860e2e504549d',
        projectId: 'fir-fb3c5',
        messagingSenderId: '822219183784',
        storageBucket: 'gs://fir-fb3c5.appspot.com/Images'
      ),
    );
  }else{
    await Firebase.initializeApp();
  }
  FlutterError.onError=(errorDetails){
    print("Crashlytics==>${errorDetails}");
   FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  PlatformDispatcher.instance.onError=(error,stack){
    print("Crashlytics==>${error}");
    FirebaseCrashlytics.instance.recordError(error, stack);
    return true;
  };
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: SpalshScreen(),
    );
    // return  MaterialApp(
    //   title: 'OTP Verification',
    //   initialRoute: '/',
    //   routes: {
    //     '/': (context) => PhoneInputScreen(),
    //     '/otp': (context) => OtpVerificationScreen(
    //       phoneNumber: ModalRoute.of(context)?.settings.arguments as String,
    //     ),
    //   },
    // );
  }
}


