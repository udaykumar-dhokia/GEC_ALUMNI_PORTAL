// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBoy3pO9uKuZ6qzdf_wEWF83zLWvJoaUNU',
    appId: '1:731592879019:web:c0a545563b167e2e5640ee',
    messagingSenderId: '731592879019',
    projectId: 'gecap-e745e',
    authDomain: 'gecap-e745e.firebaseapp.com',
    storageBucket: 'gecap-e745e.appspot.com',
    measurementId: 'G-KYMMCP3728',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCB0UAAmvzv_P8Y7nfyeeRB-NSjfm4Ob_g',
    appId: '1:731592879019:android:8b3806ee5f5dfb345640ee',
    messagingSenderId: '731592879019',
    projectId: 'gecap-e745e',
    storageBucket: 'gecap-e745e.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD60zqblz0e8dez5wj-4wk_4DQYOwvcqmI',
    appId: '1:731592879019:ios:2b4d9027010b34605640ee',
    messagingSenderId: '731592879019',
    projectId: 'gecap-e745e',
    storageBucket: 'gecap-e745e.appspot.com',
    iosBundleId: 'com.example.gecap',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyD60zqblz0e8dez5wj-4wk_4DQYOwvcqmI',
    appId: '1:731592879019:ios:2b4d9027010b34605640ee',
    messagingSenderId: '731592879019',
    projectId: 'gecap-e745e',
    storageBucket: 'gecap-e745e.appspot.com',
    iosBundleId: 'com.example.gecap',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBoy3pO9uKuZ6qzdf_wEWF83zLWvJoaUNU',
    appId: '1:731592879019:web:2d231a7e27182ebc5640ee',
    messagingSenderId: '731592879019',
    projectId: 'gecap-e745e',
    authDomain: 'gecap-e745e.firebaseapp.com',
    storageBucket: 'gecap-e745e.appspot.com',
    measurementId: 'G-0FN0HXZV7Q',
  );
}