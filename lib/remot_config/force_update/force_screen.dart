import 'package:flutter/material.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:url_launcher/url_launcher.dart';

class Forceupdate extends StatefulWidget {
  @override
  _ForceupdateState createState() => _ForceupdateState();
}

class _ForceupdateState extends State<Forceupdate> {
  late FirebaseRemoteConfig _remoteConfig;

  @override
  void initState() {
    super.initState();
    _setupRemoteConfig();
  }

  Future<void> _setupRemoteConfig() async {
    _remoteConfig = FirebaseRemoteConfig.instance;
    await _remoteConfig.setDefaults(<String, dynamic>{
      'force_update_version': '1.0.0',
      'app_store_url': 'https://apps.apple.com/app/idYOUR_APP_ID',
      'play_store_url': 'https://play.google.com/store/apps/details?id=com.flutter.easy.learn.flutter_tutorial&pcampaignid=web_share', // Replace with your Play Store URL
    });

    // Fetch and activate config
    await _remoteConfig.fetchAndActivate();

    // Check for updates
    _checkForUpdate();
  }

  void _checkForUpdate() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String currentVersion = packageInfo.version;
    String requiredVersion = _remoteConfig.getString('force_update_version');
    print('Update Vertion==>${_remoteConfig.getString('force_update_version')}');

    if (currentVersion != requiredVersion) {
      _showForceUpdateDialog();
    }
  }

  void _showForceUpdateDialog() {
    String appStoreUrl = _remoteConfig.getString('app_store_url');
    String playStoreUrl = _remoteConfig.getString('play_store_url');
    print('Play Store URL ==>${_remoteConfig.getString('play_store_url')}');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.warning_amber_rounded,
              color: Colors.red,
              size: 32,
            ),
            const SizedBox(width: 10),
            Text(
              'Update Required',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
        content: Text(
          'A new version of the app is available. Please update to continue.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            color: Colors.black87,
          ),
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.indigo,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            onPressed: () async {
              if (Theme.of(context).platform == TargetPlatform.iOS) {
                // For iOS, launch the App Store URL
                if (await canLaunch(appStoreUrl)) {
                  await launch(appStoreUrl);
                } else {
                  throw 'Could not launch $appStoreUrl';
                }
              } else {
                // For Android, launch the Play Store URL
                if (await canLaunch(playStoreUrl)) {
                  await launch(playStoreUrl);
                } else {
                  throw 'Could not launch $playStoreUrl';
                }
              }
            },
            child: Text(
              'Update',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Force Update'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Your app vertion is no longer supported.you are missing out on new'
                'features and critical fixes \nplease update today.',textAlign: TextAlign.center,)
          ],
        ),
      ),
    );
  }
}
