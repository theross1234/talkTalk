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
    apiKey: 'AIzaSyDhQa8VCuqqMR_JoO1rF48KEXWJMMhkAD8',
    appId: '1:407470322523:web:fb53cd8aac31bb6cafa07e',
    messagingSenderId: '407470322523',
    projectId: 'chatchat-16751',
    authDomain: 'chatchat-16751.firebaseapp.com',
    storageBucket: 'chatchat-16751.firebasestorage.app',
    measurementId: 'G-B1EZZSY34R',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyApdrDjGFRHsqRT2VVPlMXw2_Qe4Gc7WVM',
    appId: '1:407470322523:android:98c2817fba7f580aafa07e',
    messagingSenderId: '407470322523',
    projectId: 'chatchat-16751',
    storageBucket: 'chatchat-16751.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCVneGl2nrmieSW854MwA31eO0eBGgrz_4',
    appId: '1:407470322523:ios:44820b9b7e8769abafa07e',
    messagingSenderId: '407470322523',
    projectId: 'chatchat-16751',
    storageBucket: 'chatchat-16751.firebasestorage.app',
    iosBundleId: 'com.theRoss.chatchat',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCVneGl2nrmieSW854MwA31eO0eBGgrz_4',
    appId: '1:407470322523:ios:0c9d94c5b612093cafa07e',
    messagingSenderId: '407470322523',
    projectId: 'chatchat-16751',
    storageBucket: 'chatchat-16751.firebasestorage.app',
    iosBundleId: 'com.example.chatchat',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDhQa8VCuqqMR_JoO1rF48KEXWJMMhkAD8',
    appId: '1:407470322523:web:a08be092be0cf247afa07e',
    messagingSenderId: '407470322523',
    projectId: 'chatchat-16751',
    authDomain: 'chatchat-16751.firebaseapp.com',
    storageBucket: 'chatchat-16751.firebasestorage.app',
    measurementId: 'G-PTG43P7PSF',
  );
}