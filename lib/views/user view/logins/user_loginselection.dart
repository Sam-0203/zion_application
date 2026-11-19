import 'package:flutter/material.dart';
import 'package:flutter_app/app/route/app_routes_names.dart';
import 'package:flutter_app/app/theme/app_colors.dart';
import 'package:flutter_app/core/constants/icons.dart';
import 'package:flutter_app/core/constants/texts.dart';
import 'package:flutter_app/widgets/app_scaffold.dart';
import 'package:flutter_app/widgets/glass_card.dart';
import 'package:get/get.dart';

class UserLoginSelection extends StatefulWidget {
  const UserLoginSelection({super.key});

  @override
  State<UserLoginSelection> createState() => _UserLoginSelectionState();
}

class _UserLoginSelectionState extends State<UserLoginSelection> {
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      topTrue: false,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // HEADER
              AppIcons.securityIcon(size: 45),
              const SizedBox(height: 16),

              Text(
                CustomStrings.selectionHeader,
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                CustomStrings.selectionSubHeader,
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.onSurfaceMuted, fontSize: 15),
              ),

              const SizedBox(height: 48),

              // ADMIN
              _RoleCard(
                icon: AppIcons.adminProfileIcon(),
                title: CustomStrings.selectionAdminCardHeader,
                subtitle: CustomStrings.selectionAdminCardSubHeader,
                onTap: () {
                  Get.toNamed(AppRoutesNames.adminLoginPage);
                },
              ),

              const SizedBox(height: 16),

              // USER
              _RoleCard(
                icon: AppIcons.profileIcon(),
                title: CustomStrings.selectionUserCardHeader,
                subtitle: CustomStrings.selectionUserCardSubHeader,
                onTap: () {
                  Get.toNamed(AppRoutesNames.userLoginPage);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Role selection card
class _RoleCard extends StatelessWidget {
  const _RoleCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final Widget icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: GlassCard(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          borderRadius: 20,
          child: Row(
            children: [
              // Icon
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary.withValues(alpha: 0.15),
                ),
                child: Center(child: icon),
              ),

              const SizedBox(width: 16),

              // Title + subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      subtitle,
                      style: TextStyle(
                        color: AppColors.onSurfaceMuted,
                        fontSize: 12.5,
                      ),
                    ),
                  ],
                ),
              ),

              // Arrow
              Icon(
                Icons.chevron_right_rounded,
                color: AppColors.onSurfaceMuted,
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
