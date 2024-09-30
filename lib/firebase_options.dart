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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyCicd3mF5bDznxZDXwofUHNU9PqCCDaSdY',
    appId: '1:373920985117:web:d157b8f49a91eef3bd16f4',
    messagingSenderId: '373920985117',
    projectId: 'ethernode-otter',
    authDomain: 'ethernode-otter.firebaseapp.com',
    storageBucket: 'ethernode-otter.appspot.com',
    measurementId: 'G-B78G6X1C0M',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD1DarJJUuWIK584wq5tZ9tEcRwQ-EaGiY',
    appId: '1:373920985117:android:56463c198fff1bcfbd16f4',
    messagingSenderId: '373920985117',
    projectId: 'ethernode-otter',
    storageBucket: 'ethernode-otter.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBGBIpzxSkpmVW4bl9wsDjmqBQ185DBydk',
    appId: '1:373920985117:ios:304866734a190224bd16f4',
    messagingSenderId: '373920985117',
    projectId: 'ethernode-otter',
    storageBucket: 'ethernode-otter.appspot.com',
    androidClientId: '373920985117-l9q1tj9188uc0tp8cs6hjgp20blgr4c1.apps.googleusercontent.com',
    iosClientId: '373920985117-f8mchq9et4gaulrp6mmm600rnm1kfg69.apps.googleusercontent.com',
    iosBundleId: 'in.ethernode.otter',
  );

}