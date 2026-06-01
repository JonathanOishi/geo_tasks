import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'Este app foi configurado apenas para Android e iOS.',
      );
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

  static String _requireEnv(String keyName) {
    final value = dotenv.env[keyName]?.trim() ?? '';
    if (value.isEmpty) {
      throw StateError(
        'Firebase API key ausente: configure $keyName no arquivo .env.',
      );
    }
    return value;
  }

  static FirebaseOptions get android => FirebaseOptions(
    apiKey: _requireEnv('FIREBASE_API_KEY_ANDROID'),
    appId: '1:600947018057:android:29a46ce9bec7a7e67c3298',
    messagingSenderId: '600947018057',
    projectId: 'geotasks-1f310',
    storageBucket: 'geotasks-1f310.firebasestorage.app',
  );

  static FirebaseOptions get ios => FirebaseOptions(
    apiKey: _requireEnv('FIREBASE_API_KEY_IOS'),
    appId: '1:600947018057:ios:a6488f2d8196886e7c3298',
    messagingSenderId: '600947018057',
    projectId: 'geotasks-1f310',
    storageBucket: 'geotasks-1f310.firebasestorage.app',
    iosBundleId: 'com.example.geoTasks',
  );
}
