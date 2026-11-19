import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:flutter_app/app/theme/app_colors.dart';
import 'package:flutter_app/core/constants/icons.dart';
import 'package:flutter_app/core/constants/texts.dart';
import 'package:flutter_app/viewmodels/user_login_viewmodel.dart';
import 'package:flutter_app/widgets/app_scaffold.dart';
import 'package:flutter_app/widgets/glass_card.dart';
import 'package:flutter_app/widgets/universal_app_bar.dart';
import 'package:flutter_app/widgets/universal_button.dart';

class UserLoginScreen extends StatelessWidget {
  const UserLoginScreen({super.key});

  Widget _buildSocialButton({
    required Widget icon,
    required String label,
    required Color backgroundColor,
    required Color textColor,
    required VoidCallback onTap,
    required bool isLoading,
  }) {
    return UniversalButton(
      text: label,
      onPressed: onTap,
      isLoading: isLoading,
      leadingIcon: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.14),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(child: icon),
      ),
      backgroundColor: backgroundColor,
      foregroundColor: textColor,
      height: 58,
      width: double.infinity,
      borderRadius: 16,
      fontSize: 14,
      fontWeight: FontWeight.w600,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      borderSide: BorderSide(
        color: AppColors.white.withValues(alpha: 0.14),
        width: 1,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final arguments = Get.arguments;
    final hideBackButton =
        arguments is Map && arguments['hideBackButton'] == true;

    return GetBuilder<UserLoginViewModel>(
      builder: (controller) => AppScaffold(
        topTrue: true,
        appBar: UniversalAppBar(
          showBackButton: !hideBackButton,
          onBack: hideBackButton ? null : () => Get.back(),
        ),
        body: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 30),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 420),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Center(
                          child: Container(
                            width: 88,
                            height: 88,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.primary.withValues(alpha: 0.12),
                              border: Border.all(
                                color: AppColors.primary.withValues(
                                  alpha: 0.42,
                                ),
                                width: 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withValues(
                                    alpha: 0.15,
                                  ),
                                  blurRadius: 24,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Center(
                              child: AppIcons.securityIcon(
                                size: 38,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 22),

                        Text(
                          CustomStrings.loginHeader,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: AppColors.onSurface,
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                          ),
                        ),

                        const SizedBox(height: 10),

                        Text(
                          CustomStrings.loginSubHeader2,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: AppColors.onSurfaceMuted,
                            fontSize: 14,
                            height: 1.5,
                          ),
                        ),

                        const SizedBox(height: 26),

                        GlassCard(
                          padding: const EdgeInsets.all(20),
                          borderRadius: 24,
                          backgroundColor: AppColors.surface.withValues(
                            alpha: 0.62,
                          ),
                          borderColor: AppColors.white.withValues(alpha: 0.12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                CustomStrings.loginOptionText,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: AppColors.onSurfaceMuted,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1.2,
                                ),
                              ),
                              const SizedBox(height: 18),
                              _buildSocialButton(
                                icon: AppIcons.googleIcon(
                                  size: 18,
                                  color: const Color(0xFF4285F4),
                                ),
                                label: CustomStrings.googleLoginButton,
                                backgroundColor: AppColors.surfaceVariant,
                                textColor: AppColors.onSurface,
                                onTap: controller.loginWithGoogle,
                                isLoading:
                                    controller.activeProvider == 'google',
                              ),

                              const SizedBox(height: 14),

                              _buildSocialButton(
                                icon: AppIcons.facebookIcon(
                                  size: 18,
                                  color: Colors.white,
                                ),
                                label: CustomStrings.continueWithFacebook,
                                backgroundColor: AppColors.primary,
                                textColor: AppColors.onPrimary,
                                onTap: controller.loginWithFacebook,
                                isLoading:
                                    controller.activeProvider == 'facebook',
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 18),

                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 13,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.07),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: AppColors.primary.withValues(alpha: 0.18),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.shield_outlined,
                                color: AppColors.primary,
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  CustomStrings.secureAccessMessage,
                                  style: TextStyle(
                                    color: AppColors.onSurface,
                                    fontSize: 12,
                                    height: 1.4,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
