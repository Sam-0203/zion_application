import 'package:flutter_app/viewmodels/admin_viewmodel.dart';
import 'package:flutter_app/viewmodels/bible_viewmodel.dart';
import 'package:flutter_app/viewmodels/prayer_request_viewmodel.dart';
import 'package:flutter_app/viewmodels/songs_viewmodel.dart';
import 'package:get/get.dart';
import 'package:flutter_app/viewmodels/verses_of_the_day_viewmodel.dart';
import 'package:flutter_app/core/utils/logic/user_login_logic_via_facebook.dart';
import 'package:flutter_app/core/utils/logic/user_login_logic_via_google.dart';
import 'package:flutter_app/services/user_login_service.dart';
import 'package:flutter_app/viewmodels/user_login_viewmodel.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    // controllers
    Get.put(VersesOfTheDayViewModel());
    Get.lazyPut<PrayerRequestAndWordOfGodViewModel>(
      () => PrayerRequestAndWordOfGodViewModel(),
      fenix: true,
    );
    Get.lazyPut<SongsListViewModel>(() => SongsListViewModel(), fenix: true);
    Get.lazyPut<AdminLoginViewModel>(() => AdminLoginViewModel());
    Get.lazyPut<BibleViewModel>(() => BibleViewModel(), fenix: true);
    Get.lazyPut<UserLoginService>(() => UserLoginService(), fenix: true);
    Get.lazyPut<UserLoginViaGoogleLogic>(
      () => UserLoginViaGoogleLogic(userLoginService: Get.find()),
      fenix: true,
    );
    Get.lazyPut<UserLoginViaFacebookLogic>(
      () => UserLoginViaFacebookLogic(userLoginService: Get.find()),
      fenix: true,
    );
    Get.lazyPut<UserLoginViewModel>(
      () => UserLoginViewModel(
        googleLogin: Get.find(),
        facebookLogin: Get.find(),
      ),
      fenix: true,
    );
    Get.lazyPut<UserLogoutService>(() => UserLogoutService(), fenix: true);
  }
}
