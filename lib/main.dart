import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'openinng_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge).then(
    (_) {
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.black,
        systemNavigationBarIconBrightness: Brightness.light,
      ));
      runApp(const MainApp());
    },
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: MaterialApp(
        title: 'Zion App',
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.dark,
        theme: ThemeData(
          fontFamily: "Poppins",
          scaffoldBackgroundColor: Colors.black,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.black,
            toolbarHeight: 75,
            shape: Border(
              bottom: BorderSide(
                color: Colors.grey,
                width: 0.7,
              ),
            ),
          ),
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            backgroundColor: Colors.black,
            selectedItemColor: Colors.white60,
            unselectedItemColor: Colors.grey[800],
            showSelectedLabels: true,
            showUnselectedLabels: false,
            type: BottomNavigationBarType.fixed,
          ),
          textTheme: const TextTheme(
            headlineLarge: TextStyle(
                fontSize: 30,
                fontFamily: "Poppins",
                fontWeight: FontWeight.w800,
                color: Colors.white),
            headlineMedium: TextStyle(
                fontSize: 30,
                fontFamily: "Poppins",
                fontWeight: FontWeight.w600,
                color: Colors.white),
            headlineSmall: TextStyle(
                fontSize: 20,
                fontFamily: "Poppins",
                color: Colors.white,
                fontWeight: FontWeight.w700),
            bodySmall: TextStyle(
                fontSize: 15,
                color: Colors.white70,
                fontFamily: "Poppins",
                fontWeight: FontWeight.w600),
            bodyLarge: TextStyle(
              color: Colors.white60,
              fontFamily: "Poppins",
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),
        ),
        home: const SplashScreen(),
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const OpeningScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: deviceHeight * 0.2 + MediaQuery.of(context).padding.top),
            ClipOval(
              child: Image.asset(
                'assets/icons/App_Launcher.png',
                width: deviceWidth * 0.9,
                height: deviceWidth * 0.9,
                fit: BoxFit.contain,
              ),
            ),
            const Spacer(),
            Text(
              'Welcome Back',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Praise the Lord',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            SizedBox(height: MediaQuery.of(context).padding.bottom + 50),
          ],
        ),
      ),
    );
  }
}