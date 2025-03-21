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
    apiKey: 'AIzaSyAm9Mq9S0bqIybjVYGZIxW2Mn20bVgVLgg',
    appId: '1:136611406015:web:7a679a796215f937d8e60a',
    messagingSenderId: '136611406015',
    projectId: 'my-assignment-e16d2',
    authDomain: 'my-assignment-e16d2.firebaseapp.com',
    storageBucket: 'my-assignment-e16d2.firebasestorage.app',
    measurementId: 'G-QT9BR80CPZ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAGHXP4DrVakclRRKjNndKa_pJhnmMv26M',
    appId: '1:136611406015:android:f14032760f98052cd8e60a',
    messagingSenderId: '136611406015',
    projectId: 'my-assignment-e16d2',
    storageBucket: 'my-assignment-e16d2.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyClLlUomu7k8e9BWbcgZWjCOHu31c134qQ',
    appId: '1:136611406015:ios:806b6b226cb2bd95d8e60a',
    messagingSenderId: '136611406015',
    projectId: 'my-assignment-e16d2',
    storageBucket: 'my-assignment-e16d2.firebasestorage.app',
    iosBundleId: 'com.example.assignment',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyClLlUomu7k8e9BWbcgZWjCOHu31c134qQ',
    appId: '1:136611406015:ios:806b6b226cb2bd95d8e60a',
    messagingSenderId: '136611406015',
    projectId: 'my-assignment-e16d2',
    storageBucket: 'my-assignment-e16d2.firebasestorage.app',
    iosBundleId: 'com.example.assignment',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAm9Mq9S0bqIybjVYGZIxW2Mn20bVgVLgg',
    appId: '1:136611406015:web:b948a3a5c33bb77fd8e60a',
    messagingSenderId: '136611406015',
    projectId: 'my-assignment-e16d2',
    authDomain: 'my-assignment-e16d2.firebaseapp.com',
    storageBucket: 'my-assignment-e16d2.firebasestorage.app',
    measurementId: 'G-1R8Y9J3RTK',
  );
}
