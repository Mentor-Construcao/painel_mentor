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
    apiKey: 'AIzaSyBL90a93eUQsqIYMn4YiSthc5VCFn0AcHM',
    appId: '1:137948269951:web:a363e61d9cf5940e3d1e4a',
    messagingSenderId: '137948269951',
    projectId: 'mentor-construcao',
    authDomain: 'mentor-construcao.firebaseapp.com',
    storageBucket: 'mentor-construcao.appspot.com',
    measurementId: 'G-0XB6L0ZXRZ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBJzlHldlwzBFML1Vm3IxANUDduyc31wbs',
    appId: '1:137948269951:android:1287a442365500b23d1e4a',
    messagingSenderId: '137948269951',
    projectId: 'mentor-construcao',
    storageBucket: 'mentor-construcao.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC4xkAyJNPy4xYDvKTm2dXfdyoywDJuquE',
    appId: '1:137948269951:ios:07efb6fb4f8f8ee33d1e4a',
    messagingSenderId: '137948269951',
    projectId: 'mentor-construcao',
    storageBucket: 'mentor-construcao.appspot.com',
    iosClientId: '137948269951-64arphoalnqdbik2m94r6loo84at00io.apps.googleusercontent.com',
    iosBundleId: 'com.example.painelMentor',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyC4xkAyJNPy4xYDvKTm2dXfdyoywDJuquE',
    appId: '1:137948269951:ios:a4aa55fe5da2f4063d1e4a',
    messagingSenderId: '137948269951',
    projectId: 'mentor-construcao',
    storageBucket: 'mentor-construcao.appspot.com',
    iosClientId: '137948269951-m6o3upskif0i213l0oeckom0mqqhbkn7.apps.googleusercontent.com',
    iosBundleId: 'com.example.painelMentor.RunnerTests',
  );
}
