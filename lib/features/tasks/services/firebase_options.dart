import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static const String _androidApiKey = String.fromEnvironment(
    'FIREBASE_API_KEY_ANDROID',
  );
  static const String _iosApiKey = String.fromEnvironment(
    'FIREBASE_API_KEY_IOS',
  );
  static const String _webApiKey = String.fromEnvironment(
    'FIREBASE_API_KEY_WEB',
  );

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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: _androidApiKey,
    appId: '1:600947018057:android:29a46ce9bec7a7e67c3298',
    messagingSenderId: '600947018057',
    projectId: 'geotasks-1f310',
    storageBucket: 'geotasks-1f310.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: _iosApiKey,
    appId: '1:600947018057:ios:a6488f2d8196886e7c3298',
    messagingSenderId: '600947018057',
    projectId: 'geotasks-1f310',
    storageBucket: 'geotasks-1f310.firebasestorage.app',
    iosBundleId: 'com.example.geoTasks',
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: _webApiKey,
    appId: '1:600947018057:web:7652970d6b8e1f0a7c3298',
    messagingSenderId: '600947018057',
    projectId: 'geotasks-1f310',
    authDomain: 'geotasks-1f310.firebaseapp.com',
    storageBucket: 'geotasks-1f310.firebasestorage.app',
    measurementId: 'G-E9Q9PRQN7R',
  );
}
