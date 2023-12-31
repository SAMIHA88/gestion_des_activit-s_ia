// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyCT0W89CD05yvekF5AZL1bCr6qUDvN0qM0',
    appId: '1:252996648395:web:9521adc2269da5d6160a4e',
    messagingSenderId: '252996648395',
    projectId: 'aiactivites',
    authDomain: 'aiactivites.firebaseapp.com',
    storageBucket: 'aiactivites.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB0YzpnSEElSzmRYNy5tA167KSEV-0-qls',
    appId: '1:252996648395:android:ba6b99f2013a98cb160a4e',
    messagingSenderId: '252996648395',
    projectId: 'aiactivites',
    storageBucket: 'aiactivites.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBO9mrTsNNSvJvybWk4DoJ1rGPoTcolJ78',
    appId: '1:252996648395:ios:596687f083e09c10160a4e',
    messagingSenderId: '252996648395',
    projectId: 'aiactivites',
    storageBucket: 'aiactivites.appspot.com',
    iosBundleId: 'com.example.activitesManagement',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBO9mrTsNNSvJvybWk4DoJ1rGPoTcolJ78',
    appId: '1:252996648395:ios:cdf6d32350544d83160a4e',
    messagingSenderId: '252996648395',
    projectId: 'aiactivites',
    storageBucket: 'aiactivites.appspot.com',
    iosBundleId: 'com.example.activitesManagement.RunnerTests',
  );
}
