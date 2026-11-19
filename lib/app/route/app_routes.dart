import 'package:get/get.dart';

import 'package:flutter_app/views/bible view/bible_language.dart';
import 'package:flutter_app/views/hom view/home_screen.dart';
import 'package:flutter_app/views/main_screen.dart';
import 'package:flutter_app/views/prayer%20request%20view/all_prayer_request_screen.dart';
import 'package:flutter_app/views/prayer%20request%20view/prayerRequestDetail_screen.dart';
import 'package:flutter_app/views/setting%20view/setting_view.dart';
import 'package:flutter_app/views/setting%20view/legal_information_screen.dart';
import 'package:flutter_app/views/songs view/songs_list_screen.dart';
import 'package:flutter_app/views/songs%20view/song_detail_page.dart';
import 'package:flutter_app/views/user view/profile/userProfile_screen.dart';

import '../../views/bible view/bible_books.dart';
import '../../views/bible view/verses_view.dart';
import '../../views/hom view/wordOfGod_screen.dart';
import '../../views/setting view/user_language_setting.dart';
import '../../views/songs view/songs_search_screen.dart';
import '../../views/user view/logins/admin_login_screen.dart';
import '../../views/user view/logins/user_login_screen.dart';
import '../../views/user view/logins/user_loginselection.dart';
import 'app_routes_names.dart';

class AppRoutes {
  AppRoutes._();

  // Routes list
  static final List<GetPage> routes = [
    // User login selection screen
    GetPage(
      name: AppRoutesNames.userSelection,
      page: () => const UserLoginSelection(),
    ),

    // Admin login
    GetPage(
      name: AppRoutesNames.adminLoginPage,
      page: () => const AdminLoginScreen(),
    ),

    // User login
    GetPage(
      name: AppRoutesNames.userLoginPage,
      page: () => const UserLoginScreen(),
    ),

    // Word of god screen
    GetPage(
      name: AppRoutesNames.wordOfGod,
      page: () => const WordOfGodScreen(),
    ),

    GetPage(
      name: AppRoutesNames.languagesSettings,
      page: () => const UserLanguageSetting(),
    ),
    GetPage(
      name: AppRoutesNames.termsAndConditions,
      page: () =>
          const LegalInformationScreen(type: LegalInformationType.terms),
    ),
    GetPage(
      name: AppRoutesNames.privacyPolicy,
      page: () =>
          const LegalInformationScreen(type: LegalInformationType.privacy),
    ),

    // Main screen
    GetPage(name: AppRoutesNames.mainScreen, page: () => const MainScreen()),

    // Main Screen navigations : =====>
    // Home screen
    GetPage(
      name: AppRoutesNames.homeScreen,
      page: () => const HomeScreen(showAppBar: true),
    ),

    // Songs screen
    GetPage(
      name: AppRoutesNames.songsScreen,
      page: () => const SongsList(showAppBar: true),
    ),
    GetPage(
      name: AppRoutesNames.songsSearch,
      page: () => const SongsSearchScreen(),
    ),

    // Bible languages screen
    GetPage(
      name: AppRoutesNames.bibleLanguages,
      page: () => const BibleLanguagesList(showAppBar: true),
    ),

    // Profile languages screen
    GetPage(
      name: AppRoutesNames.userProfile,
      page: () => const ProfileScreen(),
    ),

    // Profile languages screen
    GetPage(
      name: AppRoutesNames.settings,
      page: () => const SettingView(showAppBar: true),
    ),

    // Inner Screen pages
    GetPage(
      name: AppRoutesNames.allPrayerRequests,
      page: () => const AllPrayerRequestScreen(),
    ),

    // Details screen pages : =====>
    GetPage(
      name: AppRoutesNames.prayerRequestDetailPage,
      page: () => PrayerRequestDetailScreen(prayerId: Get.arguments as int),
    ),

    GetPage(
      name: AppRoutesNames.songsDetailPage,
      page: () => SongDetailPage(songId: Get.arguments as int),
    ),
    GetPage(
      name: AppRoutesNames.bibleBookVerses,
      // page: () => VersesViewScreen(),
      page: () {
        final args = Get.arguments as Map<String, dynamic>;

        return VersesViewScreen(
          bookId: args['book_id'] as int,
          bookName: args['book_name'] as String,
          chapter: args['chapter'] as int,
        );
      },
    ),

    GetPage(
      name: AppRoutesNames.bibleBooks,
      page: () {
        final args = Get.arguments as Map<String, dynamic>;

        return BibleBooksScreen(
          languageId: args['language_id'] as int,
          languageCode: args['language_code'] as String,
          languageName: args['language_name'] as String,
        );
      },
    ),
  ];

  // Fallback route (equivalent to the old `default:` case)
  static GetPage unknownRoute = GetPage(
    name: AppRoutesNames.wordOfGod,
    page: () => const WordOfGodScreen(),
  );
}
