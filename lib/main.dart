import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_app/app/getX/app_getX.dart';
import 'package:flutter_app/app/route/app_routes.dart';
import 'package:flutter_app/app/theme/app_colors.dart';
import 'package:flutter_app/core/constants/texts.dart';
import 'package:flutter_app/core/utils/user%20data%20storing/user_data_storing.dart';
import 'package:flutter_app/services/app_audio_handler.dart';

import 'app/route/app_routes_names.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeAudioHandler();
  if (defaultTargetPlatform == TargetPlatform.iOS) {
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }
  try {
    await TokenStorage.clearUserSessionOnFreshInstall().timeout(
      const Duration(seconds: 3),
    );
  } catch (error, stackTrace) {
    // A native install-check failure must not prevent Flutter from starting.
    debugPrint('Fresh-install session cleanup failed: $error');
    debugPrintStack(stackTrace: stackTrace);
  }
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  static final GlobalKey<NavigatorState> _navigatorKey =
      GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      navigatorKey: _navigatorKey,
      popGesture: false,
      title: CustomStrings.applicationTitle,
      debugShowCheckedModeBanner: false,
      // Default theme
      themeMode: ThemeMode.dark,
      theme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.dark,
          primary: AppColors.primary,
          secondary: AppColors.secondary,
          surface: AppColors.surface,
          onPrimary: AppColors.onPrimary,
          onSecondary: AppColors.onSecondary,
          onSurface: AppColors.onSurface,
        ),
        textTheme: GoogleFonts.zenOldMinchoTextTheme(
          ThemeData(brightness: Brightness.dark).textTheme,
        ),
        appBarTheme: AppBarThemeData(
          centerTitle: false,
          elevation: 0,
          toolbarHeight: 84,
          backgroundColor: AppColors.black,
          scrolledUnderElevation: 0,
          surfaceTintColor: Colors.transparent,
        ),
        snackBarTheme: const SnackBarThemeData(
          backgroundColor: AppColors.black,
          contentTextStyle: TextStyle(color: AppColors.white),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: AppColors.black,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.onPrimary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            textStyle: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
      ), // Routes
      initialBinding: AppBindings(),
      getPages: AppRoutes.routes,
      unknownRoute: AppRoutes.unknownRoute,
      initialRoute: AppRoutesNames.wordOfGod,
    );
  }
}
