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
    apiKey: 'AIzaSyDcA6onNqtecns-FA2Il-Ktg4IzxzlsRis',
    appId: '1:846569139481:web:e585b752a7e0ed5384a988',
    messagingSenderId: '846569139481',
    projectId: 'cping-7e228',
    authDomain: 'cping-7e228.firebaseapp.com',
    storageBucket: 'cping-7e228.appspot.com',
    measurementId: 'G-T0J0GPVC10',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB07CLY1DJybU5oRzqG1QOUA2b_ensNd-0',
    appId: '1:846569139481:android:9f87c44cf0363cb984a988',
    messagingSenderId: '846569139481',
    projectId: 'cping-7e228',
    storageBucket: 'cping-7e228.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBVvqH7tRiD5YLtZgqQcnRTxvjjRaanYLs',
    appId: '1:846569139481:ios:35449ffb5607857084a988',
    messagingSenderId: '846569139481',
    projectId: 'cping-7e228',
    storageBucket: 'cping-7e228.appspot.com',
    androidClientId: '846569139481-gsnid5tq4veq4p2gq7jdpkc7ji5l6vk6.apps.googleusercontent.com',
    iosClientId: '846569139481-de2ciumgqoluo9qtatv4r111kh3jmm88.apps.googleusercontent.com',
    iosBundleId: 'com.example.cping',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBVvqH7tRiD5YLtZgqQcnRTxvjjRaanYLs',
    appId: '1:846569139481:ios:35449ffb5607857084a988',
    messagingSenderId: '846569139481',
    projectId: 'cping-7e228',
    storageBucket: 'cping-7e228.appspot.com',
    androidClientId: '846569139481-gsnid5tq4veq4p2gq7jdpkc7ji5l6vk6.apps.googleusercontent.com',
    iosClientId: '846569139481-de2ciumgqoluo9qtatv4r111kh3jmm88.apps.googleusercontent.com',
    iosBundleId: 'com.example.cping',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDcA6onNqtecns-FA2Il-Ktg4IzxzlsRis',
    appId: '1:846569139481:web:1a5ee23db9f0cfae84a988',
    messagingSenderId: '846569139481',
    projectId: 'cping-7e228',
    authDomain: 'cping-7e228.firebaseapp.com',
    storageBucket: 'cping-7e228.appspot.com',
    measurementId: 'G-VTSEGV5V80',
  );
}
