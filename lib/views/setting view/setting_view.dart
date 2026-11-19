import 'package:flutter/material.dart';
import 'package:flutter_app/services/user_login_service.dart';
import 'package:get/get.dart';

import 'package:flutter_app/app/route/app_routes_names.dart';
import 'package:flutter_app/app/theme/app_colors.dart';
import 'package:flutter_app/core/constants/texts.dart';
import 'package:flutter_app/core/utils/user%20data%20storing/user_data_storing.dart';
import 'package:flutter_app/widgets/app_scaffold.dart';
import 'package:flutter_app/widgets/glass_card.dart';
import 'package:flutter_app/widgets/profile_avatar.dart';
import 'package:flutter_app/widgets/universal_dialog.dart';

class SettingView extends StatefulWidget {
  const SettingView({super.key, this.showAppBar = false});
  final bool showAppBar;

  @override
  State<SettingView> createState() => _SettingViewState();
}

class _SettingViewState extends State<SettingView> {
  String? _name;
  String? _email;
  String? _profileImage;
  String? _userInitials;
  bool _isLoggingOut = false;

  @override
  void initState() {
    super.initState();
    _loadAccount();
  }

  Future<void> _loadAccount() async {
    final values = await Future.wait([
      TokenStorage.getUserName(),
      TokenStorage.getUserEmail(),
      TokenStorage.getUserRole(),
      TokenStorage.getUserPhoto(),
      TokenStorage.getUserInitials(),
    ]);
    if (!mounted) return;
    setState(() {
      _name = values[0];
      _email = values[1];
      _profileImage = values[3];
      _userInitials = values[4];
    });
  }

  void _showAbout() {
    UniversalDialog.show<void>(
      context: context,
      title: CustomStrings.aboutZionApp,
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            CustomStrings.aboutZionDescription,
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.onSurfaceMuted, height: 1.5),
          ),
          SizedBox(height: 12),
          Text(
            CustomStrings.appVersion,
            style: TextStyle(color: AppColors.onSurfaceMuted, fontSize: 12),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text(CustomStrings.close),
        ),
      ],
    );
  }

  Future<void> _confirmLogout() async {
    final shouldLogout = await UniversalDialog.show<bool>(
      context: context,
      title: CustomStrings.logOutQuestion,
      content: const Text(
        CustomStrings.logoutConfirmation,
        textAlign: TextAlign.center,
        style: TextStyle(color: AppColors.onSurfaceMuted, height: 1.5),
      ),
      actions: [
        OutlinedButton.icon(
          onPressed: () => Navigator.of(context).pop(false),
          label: const Text(CustomStrings.cancel),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.onSurface,
            side: BorderSide(color: AppColors.primary.withValues(alpha: 0.7)),
            minimumSize: const Size(116, 48),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
        FilledButton.icon(
          onPressed: () => Navigator.of(context).pop(true),
          label: const Text(CustomStrings.logOut),
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.error,
            foregroundColor: AppColors.white,
            minimumSize: const Size(116, 48),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
      ],
    );

    if (shouldLogout == true) await _logout();
  }

  // logout function
  Future<void> _logout() async {
    if (_isLoggingOut) return;

    setState(() => _isLoggingOut = true);

    try {
      final logoutService = UserLogoutService();
      await logoutService.logout();

      if (!mounted) return;
      Get.offAllNamed(
        AppRoutesNames.userLoginPage,
        arguments: const {'hideBackButton': true},
      );
    } catch (error) {
      if (!mounted) return;

      Get.snackbar(
        CustomStrings.loginFailed,
        error.toString().replaceFirst('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      if (mounted) {
        setState(() => _isLoggingOut = false);
      }
    }
  }

  static const _titleStyle = TextStyle(
    color: AppColors.onSurface,
    fontSize: 18,
    fontWeight: FontWeight.w700,
  );

  @override
  Widget build(BuildContext context) {
    final displayName = (_name?.trim().isNotEmpty ?? false)
        ? _name!
        : CustomStrings.zionMember;
    final savedInitials = _userInitials?.trim();
    final initials = savedInitials?.isNotEmpty == true
        ? savedInitials!.toUpperCase()
        : displayName == CustomStrings.zionMember
        ? CustomStrings.zionInitial
        : displayName.trim().characters.first.toUpperCase();

    return AppScaffold(
      showAutomaticBackButton: widget.showAppBar,
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 30),
        children: [
          InkWell(
            // onTap: () => Get.toNamed(AppRoutesNames.userProfile),
            borderRadius: BorderRadius.circular(20),
            child: GlassCard(
              padding: const EdgeInsets.all(16),
              borderRadius: 20,
              child: Row(
                children: [
                  ProfileAvatar(
                    radius: 25,
                    imageUrl: _profileImage,
                    initials: initials,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          displayName,
                          style: _titleStyle.copyWith(fontSize: 16),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          _email?.trim().isNotEmpty == true
                              ? _email!
                              : CustomStrings.yourAccount,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppColors.onSurfaceMuted,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // const Icon(
                  //   Icons.arrow_forward_ios_rounded,
                  //   size: 16,
                  //   color: AppColors.onSurfaceMuted,
                  // ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          _sectionTitle(CustomStrings.yourZionApp),
          const SizedBox(height: 10),
          _settingsGroup([
            _SettingsItem(
              icon: Icons.language_rounded,
              title: CustomStrings.languageSettings,
              subtitle: CustomStrings.languageSettingsSubtitle,
              onTap: () => Get.toNamed(AppRoutesNames.languagesSettings),
            ),
            _SettingsItem(
              icon: Icons.menu_book_rounded,
              title: CustomStrings.bibleLanguages,
              subtitle: CustomStrings.bibleLanguagesSubtitle,
              onTap: () => Get.toNamed(AppRoutesNames.bibleLanguages),
            ),
            _SettingsItem(
              icon: Icons.music_note_rounded,
              title: CustomStrings.worshipSongs,
              subtitle: CustomStrings.worshipSongsSubtitle,
              onTap: () => Get.toNamed(AppRoutesNames.songsScreen),
            ),
            _SettingsItem(
              icon: Icons.volunteer_activism_outlined,
              title: CustomStrings.prayerRequests,
              subtitle: CustomStrings.prayerRequestsSubtitle,
              onTap: () => Get.toNamed(AppRoutesNames.allPrayerRequests),
              showDivider: false,
            ),
          ]),
          const SizedBox(height: 24),
          _sectionTitle(CustomStrings.accountAndApp),
          const SizedBox(height: 10),
          _settingsGroup([
            _SettingsItem(
              icon: Icons.info_outline_rounded,
              title: CustomStrings.aboutZionApp,
              subtitle: CustomStrings.appVersion,
              onTap: _showAbout,
            ),
            _SettingsItem(
              icon: Icons.description_outlined,
              title: CustomStrings.termsAndConditions,
              subtitle: CustomStrings.termsSubtitle,
              onTap: () => Get.toNamed(AppRoutesNames.termsAndConditions),
            ),
            _SettingsItem(
              icon: Icons.privacy_tip_outlined,
              title: CustomStrings.privacyPolicy,
              subtitle: CustomStrings.privacySubtitle,
              onTap: () => Get.toNamed(AppRoutesNames.privacyPolicy),
              showDivider: false,
            ),
          ]),
          const SizedBox(height: 14),
          // GlassCard(
          //   padding: EdgeInsets.zero,
          //   borderRadius: 20,
          //   child: ListTile(
          //     contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          //     leading: const Icon(
          //       Icons.delete_outline_rounded,
          //       color: AppColors.error,
          //     ),
          //     title: const Text(
          //       'Delete account',
          //       style: TextStyle(
          //         color: AppColors.error,
          //         fontWeight: FontWeight.w700,
          //       ),
          //     ),
          //     subtitle: const Text(
          //       'Permanently delete your account and its data',
          //       style: TextStyle(color: AppColors.onSurfaceMuted, fontSize: 12),
          //     ),
          //   ),
          // ),
          // const SizedBox(height: 14),
          GlassCard(
            padding: EdgeInsets.zero,
            borderRadius: 20,
            child: Material(
              color: Colors.transparent,
              child: ListTile(
                onTap: _isLoggingOut ? null : _confirmLogout,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                leading: const Icon(
                  Icons.logout_rounded,
                  color: AppColors.error,
                ),
                title: Text(
                  _isLoggingOut
                      ? CustomStrings.loggingOut
                      : CustomStrings.logOut,
                  style: const TextStyle(
                    color: AppColors.error,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                trailing: _isLoggingOut
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: UniversalLoader.compact(size: 18),
                      )
                    : null,
              ),
            ),
          ),
          const SizedBox(height: 22),
          const Center(
            child: Text(
              CustomStrings.appVersionFooter,
              style: TextStyle(color: AppColors.onSurfaceMuted, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String text) => Text(
    text,
    style: const TextStyle(
      color: AppColors.primary,
      fontSize: 11,
      fontWeight: FontWeight.w800,
      letterSpacing: 1.3,
    ),
  );

  Widget _settingsGroup(List<_SettingsItem> items) => GlassCard(
    padding: const EdgeInsets.symmetric(horizontal: 14),
    borderRadius: 20,
    child: Column(
      children: [
        for (var i = 0; i < items.length; i++) ...[
          _SettingsRow(item: items[i]),
          if (items[i].showDivider && i != items.length - 1)
            Divider(height: 1, color: AppColors.white.withValues(alpha: 0.10)),
        ],
      ],
    ),
  );
}

class _SettingsItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool showDivider;

  const _SettingsItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.showDivider = true,
  });
}

class _SettingsRow extends StatelessWidget {
  final _SettingsItem item;

  const _SettingsRow({required this.item});

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: item.onTap,
    borderRadius: BorderRadius.circular(12),
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        children: [
          Icon(item.icon, color: AppColors.primary, size: 23),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 3),
                Text(
                  item.subtitle,
                  style: const TextStyle(
                    color: AppColors.onSurfaceMuted,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.onSurfaceMuted,
          ),
        ],
      ),
    ),
  );
}
