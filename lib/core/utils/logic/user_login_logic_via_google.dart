import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/core/constants/social_auth_config.dart';
import 'package:flutter_app/core/constants/texts.dart';
import 'package:flutter_app/services/user_login_service.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserLoginViaGoogleLogic {
  UserLoginViaGoogleLogic({required UserLoginService userLoginService})
    : _userLoginService = userLoginService;

  final UserLoginService _userLoginService;
  static Future<void>? _initialization;

  Future<bool> signIn() async {
    if (!SocialAuthConfig.isGoogleConfigured) {
      throw Exception(CustomStrings.googleServerClientIdMissing);
    }

    try {
      debugPrint('[google sign-in] Initializing Google SDK.');
      await (_initialization ??= GoogleSignIn.instance.initialize(
        clientId: defaultTargetPlatform == TargetPlatform.iOS
            ? SocialAuthConfig.googleIosClientId
            : null,
        serverClientId: SocialAuthConfig.googleServerClientId,
      ));

      if (!GoogleSignIn.instance.supportsAuthenticate()) {
        throw Exception(CustomStrings.loginProviderSetupMissing);
      }

      debugPrint('[google sign-in] Opening Google account picker.');
      final account = await GoogleSignIn.instance.authenticate();
      final email = account.email.trim();
      if (email.isEmpty) {
        throw Exception(CustomStrings.loginProviderMissingEmail);
      }

      debugPrint('[google sign-in] Google account selected; calling app API.');
      await _userLoginService.loginWithGmail(
        gmail: email,
        name: account.displayName,
        photoUrl: account.photoUrl,
      );
      return true;
    } on GoogleSignInException catch (error) {
      if (error.code == GoogleSignInExceptionCode.canceled) return false;
      rethrow;
    } on PlatformException catch (error) {
      throw Exception(
        error.message ?? CustomStrings.unableToContinueWithGoogle,
      );
    }
  }
}
