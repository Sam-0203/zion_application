import 'package:flutter/foundation.dart';

class SocialAuthConfig {
  SocialAuthConfig._();

  static const googleServerClientId =
      '1013504979187-ngo7tcq440jievsqoa1q72ohv9els896.apps.googleusercontent.com';

  static const googleIosClientId =
      '1013504979187-jrbb6jiqei7447p70v1m43122itb251f.apps.googleusercontent.com';

  static const googleIosReversedClientId =
      'com.googleusercontent.apps.1013504979187-jrbb6jiqei7447p70v1m43122itb251f';

  static const facebookAppId = 'YOUR_FACEBOOK_APP_ID';
  static const facebookClientToken = 'YOUR_FACEBOOK_CLIENT_TOKEN';

  static bool get isGoogleConfigured {
    final webClientConfigured = !googleServerClientId.startsWith('YOUR_');
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return webClientConfigured &&
          !googleIosClientId.startsWith('YOUR_') &&
          !googleIosReversedClientId.contains('YOUR_');
    }
    return webClientConfigured;
  }

  static bool get isFacebookConfigured =>
      !facebookAppId.startsWith('YOUR_') &&
      !facebookClientToken.startsWith('YOUR_');
}
