import 'package:flutter/material.dart';
import 'package:flutter_app/app/theme/app_colors.dart';
import 'package:flutter_app/core/constants/texts.dart';
import 'package:flutter_app/core/utils/user%20data%20storing/user_data_storing.dart';
import 'package:flutter_app/models/bible/languages_model.dart';
import 'package:flutter_app/viewmodels/bible_viewmodel.dart';
import 'package:flutter_app/widgets/app_scaffold.dart';
import 'package:flutter_app/widgets/glass_card.dart';
import 'package:flutter_app/widgets/loaders/screen_skeleton_loaders.dart';
import 'package:flutter_app/widgets/universal_app_bar.dart';
import 'package:flutter_app/widgets/universal_dialog.dart';
import 'package:get/get.dart';

class UserLanguageSetting extends StatefulWidget {
  const UserLanguageSetting({super.key});

  @override
  State<UserLanguageSetting> createState() => _UserLanguageSettingState();
}

class _UserLanguageSettingState extends State<UserLanguageSetting> {
  late final BibleViewModel _controller;
  int? _wordLanguageId;
  String? _appLanguageCode;

  @override
  void initState() {
    super.initState();
    _controller = Get.find<BibleViewModel>();
    _loadSavedLanguages();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.fetchBibleLanguages();
    });
  }

  Future<void> _loadSavedLanguages() async {
    final wordLanguageId = await TokenStorage.getWordOfGodLanguageId();
    final appLanguageCode = await TokenStorage.getAppLanguageCode();
    if (!mounted) return;
    setState(() {
      _wordLanguageId = wordLanguageId;
      _appLanguageCode = appLanguageCode;
    });
  }

  Future<void> _selectWordLanguage(Datum language) async {
    await TokenStorage.saveWordOfGodLanguage(
      id: language.id,
      code: language.languageCode,
      name: language.languages,
    );
    if (!mounted) return;
    setState(() => _wordLanguageId = language.id);
    _showSavedMessage(
      CustomStrings.wordOfGodLanguageSavedFor(language.languages),
    );
  }

  Future<void> _selectAppLanguage(Datum language) async {
    await TokenStorage.saveAppLanguage(
      code: language.languageCode,
      name: language.languages,
    );
    if (!mounted) return;
    setState(() => _appLanguageCode = language.languageCode);
    _showSavedMessage(CustomStrings.appLanguageSavedFor(language.languages));
  }

  void _showSavedMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: const UniversalAppBar(title: CustomStrings.languagesTitle),
      body: GetBuilder<BibleViewModel>(
        builder: (controller) {
          if (controller.allLanguages == null &&
              controller.allLanguagesError == null) {
            return const LanguageSettingsSkeletonLoader();
          }

          if (controller.allLanguagesError != null) {
            return _buildError();
          }

          final languages = controller.allLanguages?.data ?? const <Datum>[];
          if (languages.isEmpty) {
            return const UniversalNoDataMessage();
          }

          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
            children: [
              const Text(
                CustomStrings.languagesTitle,
                style: TextStyle(
                  color: AppColors.onSurface,
                  fontSize: 25,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                CustomStrings.languagesIntro,
                style: TextStyle(color: AppColors.onSurfaceMuted, fontSize: 14),
              ),
              const SizedBox(height: 24),
              _sectionTitle(CustomStrings.wordOfGodLanguage),
              const SizedBox(height: 8),
              const Text(
                CustomStrings.wordOfGodLanguageDescription,
                style: TextStyle(color: AppColors.onSurfaceMuted, fontSize: 13),
              ),
              const SizedBox(height: 10),
              _languageOptions(
                languages,
                selectedCode: null,
                selectedId: _wordLanguageId,
                onSelected: _selectWordLanguage,
              ),
              const SizedBox(height: 24),
              _sectionTitle(CustomStrings.appLanguage),
              const SizedBox(height: 8),
              const Text(
                CustomStrings.appLanguageDescription,
                style: TextStyle(color: AppColors.onSurfaceMuted, fontSize: 13),
              ),
              const SizedBox(height: 10),
              _languageOptions(
                languages,
                selectedCode: _appLanguageCode,
                selectedId: null,
                onSelected: _selectAppLanguage,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildError() =>
      const UniversalErrorLoader(loader: LanguageSettingsSkeletonLoader());

  Widget _sectionTitle(String title) => Text(
    title,
    style: const TextStyle(
      color: AppColors.primary,
      fontSize: 11,
      fontWeight: FontWeight.w800,
      letterSpacing: 1.2,
    ),
  );

  Widget _languageOptions(
    List<Datum> languages, {
    required String? selectedCode,
    required int? selectedId,
    required ValueChanged<Datum> onSelected,
  }) => GlassCard(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
    borderRadius: 20,
    child: Column(
      children: [
        for (var index = 0; index < languages.length; index++) ...[
          Material(
            color: Colors.transparent,
            child: RadioListTile<String>(
              value: languages[index].languageCode,
              groupValue:
                  selectedCode ??
                  (selectedId == languages[index].id
                      ? languages[index].languageCode
                      : null),
              onChanged: (_) => onSelected(languages[index]),
              activeColor: AppColors.primary,
              contentPadding: EdgeInsets.zero,
              title: Text(languages[index].languages),
              subtitle: Text(
                languages[index].languageCode.toUpperCase(),
                style: const TextStyle(
                  color: AppColors.onSurfaceMuted,
                  fontSize: 12,
                ),
              ),
            ),
          ),
          if (index != languages.length - 1)
            Divider(height: 1, color: AppColors.white.withValues(alpha: 0.1)),
        ],
      ],
    ),
  );
}
