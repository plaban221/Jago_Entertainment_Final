class DefaultFirebaseOptions {
  static dynamic get currentPlatform {
    throw UnsupportedError(
      'Firebase is not configured. '
          'Create firebase_options.dart using FlutterFire CLI.',
    );
  }
}
