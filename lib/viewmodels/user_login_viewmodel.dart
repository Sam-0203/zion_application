import 'package:flutter/foundation.dart';
import 'package:flutter_app/app/route/app_routes_names.dart';
import 'package:flutter_app/core/constants/texts.dart';
import 'package:flutter_app/core/utils/logic/user_login_logic_via_facebook.dart';
import 'package:flutter_app/core/utils/logic/user_login_logic_via_google.dart';
import 'package:flutter_app/services/user_login_service.dart';
import 'package:get/get.dart';

class UserLoginViewModel extends GetxController {
  UserLoginViewModel({
    required UserLoginViaGoogleLogic googleLogin,
    required UserLoginViaFacebookLogic facebookLogin,
  }) : _googleLogin = googleLogin,
       _facebookLogin = facebookLogin;

  final UserLoginViaGoogleLogic _googleLogin;
  final UserLoginViaFacebookLogic _facebookLogin;

  String? activeProvider;
  String? errorMessage;

  bool get isLoading => activeProvider != null;

  Future<void> loginWithGoogle() =>
      _login(provider: 'google', authenticate: _googleLogin.signIn);

  Future<void> loginWithFacebook() =>
      _login(provider: 'facebook', authenticate: _facebookLogin.signIn);

  Future<void> _login({
    required String provider,
    required Future<bool> Function() authenticate,
  }) async {
    if (isLoading) return;

    activeProvider = provider;
    errorMessage = null;
    update();

    try {
      debugPrint('[social login] Starting $provider sign-in.');
      final didLogin = await authenticate();
      if (didLogin) {
        debugPrint('[social login] $provider sign-in and API login succeeded.');
        Get.offAllNamed(AppRoutesNames.mainScreen);
      } else {
        debugPrint('[social login] $provider sign-in was cancelled.');
      }
    } catch (error) {
      errorMessage = _messageFrom(error);
      debugPrint('[social login] $provider failed: $error');
      Get.snackbar(
        CustomStrings.loginFailed,
        errorMessage!,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      activeProvider = null;
      update();
    }
  }

  String _messageFrom(Object error) {
    final message = error.toString().replaceFirst('Exception: ', '').trim();
    return message.isEmpty ? CustomStrings.somethingWentWrong : message;
  }
}

// User logged out
class UserLogoutViewModel extends GetxController {
  final UserLogoutService _logoutService = UserLogoutService();

  bool isLoading = false;

  Future<void> logout() async {
    if (isLoading) return;

    isLoading = true;
    update();

    try {
      await _logoutService.logout();

      debugPrint('[logout] Navigating to login screen.');

      Get.offAllNamed(
        AppRoutesNames.userLoginPage,
        arguments: const {'hideBackButton': true},
      );
    } catch (error) {
      debugPrint('[logout] Failed: $error');

      Get.snackbar(
        CustomStrings.loginFailed,
        error.toString().replaceFirst('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading = false;
      update();
    }
  }
}
