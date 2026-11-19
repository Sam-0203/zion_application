import 'package:flutter/material.dart';
import 'package:flutter_app/app/route/app_routes_names.dart';
import 'package:get/get.dart';

import 'package:flutter_app/app/theme/app_colors.dart';
import 'package:flutter_app/core/constants/icons.dart';
import 'package:flutter_app/core/constants/texts.dart';
import 'package:flutter_app/viewmodels/admin_viewmodel.dart';
import 'package:flutter_app/widgets/app_scaffold.dart';
import 'package:flutter_app/widgets/universal_app_bar.dart';
import 'package:flutter_app/widgets/universal_button.dart';
import 'package:flutter_app/widgets/universal_dialog.dart';
import 'package:flutter_app/widgets/universal_input_field.dart';

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  late AdminLoginViewModel controller;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();

    controller = Get.put(AdminLoginViewModel());
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();

    Get.delete<AdminLoginViewModel>();

    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final success = await controller.login(
      username: _usernameController.text.trim(),
      password: _passwordController.text,
    );

    if (!mounted) return;

    if (success) {
      debugPrint('Admin login success ${_usernameController.text}');
      Get.offAllNamed(AppRoutesNames.mainScreen);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      topTrue: false,
      appBar: const UniversalAppBar(),
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // HEADER ICON
                  Center(child: AppIcons.adminProfileIcon(size: 44)),

                  const SizedBox(height: 16),

                  // HEADER
                  Text(
                    CustomStrings.loginHeader,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    CustomStrings.loginSubHeader,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.onSurfaceMuted,
                      fontSize: 13.5,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 40),

                  // =====================================================
                  // USERNAME LABEL
                  // =====================================================
                  Text(
                    CustomStrings.userName,
                    style: TextStyle(
                      color: AppColors.onSurfaceMuted,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // =====================================================
                  // USERNAME INPUT
                  // =====================================================
                  UniversalInputField(
                    controller: _usernameController,
                    hintText: CustomStrings.enterUserName,

                    prefixIcon: AppIcons.profileIcon(size: 20),

                    textInputAction: TextInputAction.next,

                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return CustomStrings.usernameRequired;
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  // PASSWORD LABEL
                  Text(
                    CustomStrings.password,
                    style: TextStyle(
                      color: AppColors.onSurfaceMuted,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // PASSWORD INPUT
                  UniversalInputField(
                    controller: _passwordController,
                    hintText: CustomStrings.enterPassword,

                    prefixIcon: AppIcons.passwordIcon(size: 20),

                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },

                      child: _obscurePassword
                          ? AppIcons.visibilityOffIcon(size: 20)
                          : AppIcons.visibilityIcon(size: 20),
                    ),

                    obscureText: _obscurePassword,

                    textInputAction: TextInputAction.done,

                    onFieldSubmitted: (_) {
                      _submit();
                    },

                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return CustomStrings.passwordRequired;
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 32),

                  // ERROR + LOGIN BUTTON
                  GetBuilder<AdminLoginViewModel>(
                    builder: (controller) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // ERROR MESSAGE
                          if (controller.errorMessage != null) ...[
                            UniversalErrorLoader(
                              loader: const UniversalLoader.compact(size: 20),
                            ),

                            const SizedBox(height: 16),
                          ],

                          // LOGIN BUTTON
                          UniversalButton(
                            text: CustomStrings.loginButtonText,
                            onPressed: _submit,
                            isLoading: controller.isLoading,
                            height: 52,
                            width: double.infinity,
                            borderRadius: 14,
                            backgroundColor: AppColors.primary,
                            foregroundColor: AppColors.onPrimary,
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
