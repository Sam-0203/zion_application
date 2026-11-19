import 'package:flutter/material.dart';

import 'package:flutter_app/app/theme/app_colors.dart';
import 'package:flutter_app/core/constants/icons.dart';
import 'package:flutter_app/core/constants/texts.dart';
import 'package:flutter_app/core/utils/user%20data%20storing/user_data_storing.dart';
import 'package:flutter_app/views/bible view/bible_language.dart';
import 'package:flutter_app/views/hom view/home_screen.dart';
import 'package:flutter_app/views/setting%20view/setting_view.dart';
import 'package:flutter_app/views/songs view/songs_list_screen.dart';
import 'package:flutter_app/widgets/app_scaffold.dart';
import 'package:flutter_app/widgets/glass_card.dart';
import 'package:flutter_app/widgets/profile_avatar.dart';
import 'package:flutter_app/widgets/universal_app_bar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  String? _profileImage;
  String? _userInitials;
  String? _userName;

  final List<Widget> _pages = const [
    HomeScreen(),
    SongsList(),
    BibleLanguagesList(),
    SettingView(),
  ];

  static const List<String> _labels = [
    CustomStrings.tabHome,
    CustomStrings.tabSongs,
    CustomStrings.tabBible,
    CustomStrings.tabSettings,
  ];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // LOAD USER DATA
  Future<void> _loadUserData() async {
    final image = await TokenStorage.getUserPhoto();
    final initials = await TokenStorage.getUserInitials();
    final name = await TokenStorage.getUserName();

    if (!mounted) return;

    setState(() {
      _profileImage = image;
      _userInitials = initials;
      _userName = name;
    });
  }

  // BOTTOM NAVIGATION
  void _onTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // UNSELECTED ICON
  Icon _iconForUnselected(int index, Color color) {
    switch (index) {
      case 0:
        return AppIcons.homeIcon(size: 24, color: color);

      case 1:
        return AppIcons.songsIcon(size: 24, color: color);

      case 2:
        return AppIcons.bibleIcon(size: 24, color: color);

      case 3:
        return AppIcons.settingsIcon(size: 24, color: color);
      default:
        return AppIcons.settingsIcon(size: 24, color: color);
    }
  }

  // SELECTED ICON
  Icon _iconForSelected(int index, Color color) {
    switch (index) {
      case 0:
        return AppIcons.homeIconFill(size: 24, color: color);

      case 1:
        return AppIcons.songsIconFill(size: 24, color: color);

      case 2:
        return AppIcons.bibleIcon(size: 24, color: color);

      case 3:
        return AppIcons.settingsIconFIll(size: 24, color: color);
      default:
        return AppIcons.settingsIconFIll(size: 24, color: color);
    }
  }

  // PROFILE WIDGET
  Widget _buildProfileWidget() {
    return GlassCard(
      width: 45,
      height: 45,
      borderRadius: 45,
      padding: EdgeInsets.zero,

      child: GestureDetector(
        // onTap: () => _onTap(4),
        onTap: () => _onTap(3),
        child: ProfileAvatar(
          radius: 20,
          imageUrl: _profileImage,
          initials: _userInitials,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: UniversalAppBar(
        showBackButton: false,
        toolbarHeight: 84,
        backgroundColor: AppColors.black,
        titleWidget: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              CustomStrings.appName,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.4,
                color: AppColors.primary.withValues(alpha: 0.95),
                shadows: [
                  Shadow(
                    color: AppColors.black.withValues(alpha: 0.35),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              maxLines: 1,
            ),
            const SizedBox(height: 2),
            Text(
              '${CustomStrings.timeBasedGreeting}, Mr. ${_userName ?? CustomStrings.genericUser}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        actions: _selectedIndex == 0
            ? [
                Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      IconButton(
                        onPressed: () {
                          // Navigate to notifications screen
                        },
                        icon: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primary.withValues(alpha: 0.12),
                          ),
                          child: AppIcons.notificationsIcon(
                            size: 24,
                            color: AppColors.primary,
                          ),
                        ),
                      ),

                      // Notification badge
                      Positioned(
                        top: 5,
                        right: 5,
                        child: Container(
                          constraints: const BoxConstraints(
                            minWidth: 17,
                            minHeight: 17,
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.redAccent,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.black, width: 1.5),
                          ),
                          child: const Text(
                            '3', // Dynamic notification count
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              height: 1.1,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Profile Widget
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: _buildProfileWidget(),
                ),
              ]
            : null,
      ),

      // BODY
      body: IndexedStack(index: _selectedIndex, children: _pages),

      // BOTTOM NAVIGATION
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onTap,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.black,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.onSurfaceMuted,

        items: List.generate(_labels.length, (index) {
          return BottomNavigationBarItem(
            icon: _iconForUnselected(index, AppColors.onSurfaceMuted),

            activeIcon: _iconForSelected(index, AppColors.primary),

            label: _labels[index],
          );
        }),
      ),
    );
  }
}
