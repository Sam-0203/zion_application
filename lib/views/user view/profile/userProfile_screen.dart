import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/app/theme/app_colors.dart';
import 'package:flutter_app/core/constants/api_urls.dart';
import 'package:flutter_app/core/constants/texts.dart';
import 'package:flutter_app/core/utils/minimum_loader_duration.dart';
import 'package:flutter_app/core/utils/user%20data%20storing/user_data_storing.dart';
import 'package:flutter_app/models/user/single_user_responses_model.dart';
import 'package:flutter_app/widgets/app_scaffold.dart';
import 'package:flutter_app/widgets/glass_card.dart';
import 'package:flutter_app/widgets/loaders/screen_skeleton_loaders.dart';
import 'package:flutter_app/widgets/profile_avatar.dart';
import 'package:flutter_app/widgets/universal_app_bar.dart';
import 'package:flutter_app/widgets/universal_dialog.dart';
import 'package:http/http.dart' as http;

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  SingleUserResponseModel? _user;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final startedAt = DateTime.now();
    SingleUserResponseModel? loadedUser;
    String? loadError;
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final token = await TokenStorage.getAccessToken();
      final response = await http.get(
        Uri.parse(APIsurls.singleUserDetails),
        headers: {
          'Content-Type': 'application/json',
          if (token != null && token.isNotEmpty)
            'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode != 200) {
        throw Exception(CustomStrings.profileLoadFailure(response.statusCode));
      }

      loadedUser = SingleUserResponseModel.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>,
      );
    } catch (error) {
      loadError = error.toString();
    } finally {
      await waitForMinimumLoaderDuration(startedAt);
      if (mounted) {
        setState(() {
          if (loadedUser != null) _user = loadedUser;
          _error = loadError;
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: const UniversalAppBar(title: CustomStrings.myProfile),
      body: _isLoading && _error == null
          ? const ProfileSkeletonLoader()
          : _error != null
          ? _buildError()
          : _buildProfile(_user!.data),
    );
  }

  Widget _buildError() =>
      const UniversalErrorLoader(loader: ProfileSkeletonLoader());

  Widget _buildProfile(Data user) {
    final info = user.personalInformation;
    final account = user.accountInformation;
    final imageUrl = account.profile.image;
    final initials = account.profile.initials.trim().isNotEmpty
        ? account.profile.initials.toUpperCase()
        : info.name.trim().isNotEmpty
        ? info.name.characters.first.toUpperCase()
        : '?';

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
      children: [
        GlassCard(
          borderRadius: 22,
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              ProfileAvatar(radius: 42, imageUrl: imageUrl, initials: initials),
              const SizedBox(height: 12),
              Text(
                info.name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.onSurface,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                account.role,
                style: const TextStyle(color: AppColors.primary, fontSize: 13),
              ),
            ],
          ),
        ),
        const SizedBox(height: 22),
        const Text(
          CustomStrings.personalInformation,
          style: TextStyle(
            color: AppColors.primary,
            fontSize: 11,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 10),
        GlassCard(
          borderRadius: 20,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Column(
            children: [
              _profileRow(CustomStrings.username, account.username),
              _profileRow(
                CustomStrings.email,
                account.gmail ?? CustomStrings.notProvided,
              ),
              _profileRow(CustomStrings.mobile, info.mobileNumber),
              _profileRow(
                CustomStrings.dateOfBirth,
                _formatDate(info.dateOfBirth),
              ),
              _profileRow(CustomStrings.age, info.age?.toString()),
              _profileRow(CustomStrings.bio, info.bio, isLast: true),
            ],
          ),
        ),
      ],
    );
  }

  Widget _profileRow(String label, String? value, {bool isLast = false}) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 13),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 112,
                  child: Text(
                    label,
                    style: const TextStyle(color: AppColors.onSurfaceMuted),
                  ),
                ),
                Expanded(
                  child: Text(
                    value == null || value.trim().isEmpty
                        ? CustomStrings.notProvided
                        : value,
                    style: const TextStyle(color: AppColors.onSurface),
                  ),
                ),
              ],
            ),
            if (!isLast)
              Padding(
                padding: const EdgeInsets.only(top: 13),
                child: Divider(
                  height: 1,
                  color: AppColors.white.withValues(alpha: 0.10),
                ),
              ),
          ],
        ),
      );

  String? _formatDate(DateTime? date) => date == null
      ? null
      : '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
}
