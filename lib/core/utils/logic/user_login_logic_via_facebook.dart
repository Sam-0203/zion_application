import 'package:flutter_app/core/constants/social_auth_config.dart';
import 'package:flutter_app/core/constants/texts.dart';
import 'package:flutter_app/services/user_login_service.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class UserLoginViaFacebookLogic {
  UserLoginViaFacebookLogic({required UserLoginService userLoginService})
    : _userLoginService = userLoginService;

  final UserLoginService _userLoginService;

  Future<bool> signIn() async {
    if (!SocialAuthConfig.isFacebookConfigured) {
      throw Exception(CustomStrings.loginProviderSetupMissing);
    }

    final result = await FacebookAuth.instance.login(
      permissions: const ['email', 'public_profile'],
    );
    if (result.status == LoginStatus.cancelled) return false;
    if (result.status != LoginStatus.success) {
      throw Exception(
        result.message ?? CustomStrings.unableToContinueWithFacebook,
      );
    }

    final user = await FacebookAuth.instance.getUserData(
      fields: 'id,name,email,picture.width(200)',
    );
    final facebookId = user['id']?.toString().trim();
    if (facebookId == null || facebookId.isEmpty) {
      throw Exception(CustomStrings.loginProviderMissingUserId);
    }

    await _userLoginService.loginWithFacebook(facebookId: facebookId);
    return true;
  }
}
