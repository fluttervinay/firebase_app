
import 'package:firebase/remot_config/screen2.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';

import '../main.dart';

Future<void>fetchAndActivate()async{
  final remoteConfig = FirebaseRemoteConfig.instance;
  await remoteConfig.setConfigSettings(RemoteConfigSettings(
    fetchTimeout: const Duration(minutes: 1),
    minimumFetchInterval: const Duration(seconds: 30),
  ));

  await remoteConfig.setDefaults(const {
    "Under_Maintenance": false,
    "App_version": '1.0.0',
    'force_update_version': '1.0.0',
  });

  await remoteConfig.fetchAndActivate();
  print("Under_Maintenance==> ${remoteConfig.getBool('Under_Maintenance')}");
  print("App_version==> ${remoteConfig.getString('App_version')}");

  if(remoteConfig.getBool('Under_Maintenance')){
    navigatorKey.currentState?.pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const ScreenTwo(data: {'Under_Maintenance':'Try After Some Time app is under maintenance.'},),), (route) => false,);
  }

}