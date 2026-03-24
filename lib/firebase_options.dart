// File generated based on google-services.json and GoogleService-Info.plist
// Project: karti-hrm-dea83 (support@mahersoftware.com)
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
        return ios; // reuse iOS config for macOS
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDyWx5CJbpGgcz5ZVLev3aDgtZmAwPztm4',
    appId: '1:1084442997964:android:0aea8582db6c3f39d03e69',
    messagingSenderId: '1084442997964',
    projectId: 'karti-hrm-dea83',
    storageBucket: 'karti-hrm-dea83.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD1AXpc64ur2EpqDq8xP3U1zyAbQ70RYVQ',
    appId: '1:1084442997964:ios:a1e662cb77fae71dd03e69',
    messagingSenderId: '1084442997964',
    projectId: 'karti-hrm-dea83',
    storageBucket: 'karti-hrm-dea83.firebasestorage.app',
    iosBundleId: 'online.karti.app',
  );

  // TODO: Add web app in Firebase Console and update these values
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDyWx5CJbpGgcz5ZVLev3aDgtZmAwPztm4',
    appId: '1:1084442997964:android:0aea8582db6c3f39d03e69',
    messagingSenderId: '1084442997964',
    projectId: 'karti-hrm-dea83',
    storageBucket: 'karti-hrm-dea83.firebasestorage.app',
  );
}
