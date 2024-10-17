import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';


class CrashlyticsExampleScreen extends StatefulWidget {
  @override
  State<CrashlyticsExampleScreen> createState() => _CrashlyticsExampleScreenState();
}

class _CrashlyticsExampleScreenState extends State<CrashlyticsExampleScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Crashlytics Example')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            ElevatedButton(
              onPressed: () {
                try {
                  throw Exception("Manual Exception for testing");
                } catch (e, stackTrace) {
                  FirebaseCrashlytics.instance.recordError(e, stackTrace);
                }
              },
              child: Text('Throw Exception'),
            ),

            // Log a custom message
            ElevatedButton(
              onPressed: () {
                FirebaseCrashlytics.instance.log('Custom log message for tracking');
              },
              child: Text('Log Custom Message'),
            ),

            // Trigger a native crash
            ElevatedButton(
              onPressed: () => FirebaseCrashlytics.instance.crash(), // Crashes the app
              child: Text('Force Native Crash'),
            ),
          ],
        ),
      ),
    );
  }
}

