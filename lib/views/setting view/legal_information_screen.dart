import 'package:flutter/material.dart';
import 'package:flutter_app/app/theme/app_colors.dart';
import 'package:flutter_app/core/constants/texts.dart';
import 'package:flutter_app/widgets/app_scaffold.dart';
import 'package:flutter_app/widgets/glass_card.dart';
import 'package:flutter_app/widgets/universal_app_bar.dart';

enum LegalInformationType { terms, privacy }

class LegalInformationScreen extends StatelessWidget {
  final LegalInformationType type;

  const LegalInformationScreen({super.key, required this.type});

  bool get _isPrivacy => type == LegalInformationType.privacy;

  @override
  Widget build(BuildContext context) {
    final title = _isPrivacy
        ? CustomStrings.privacyPolicy
        : CustomStrings.termsAndConditions;
    final intro = _isPrivacy
        ? CustomStrings.privacyIntro
        : CustomStrings.termsIntro;
    return AppScaffold(
      appBar: UniversalAppBar(title: title),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
        children: [
          Text(
            intro,
            style: const TextStyle(
              color: AppColors.onSurface,
              fontSize: 15,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 18),
          if (_isPrivacy) ...[
            _informationSection(
              CustomStrings.privacyLocalStorageHeading,
              CustomStrings.privacyStoredContent,
            ),
            const SizedBox(height: 20),
            _informationSection(
              CustomStrings.privacyNetworkHeading,
              CustomStrings.privacySentContent,
            ),
            const SizedBox(height: 20),
            _informationSection(
              CustomStrings.privacyPermissionsHeading,
              CustomStrings.privacyDeviceUseContent,
            ),
          ] else ...[
            _sectionHeading(CustomStrings.termsSectionHeading),
            const SizedBox(height: 10),
            _contentCard(CustomStrings.termsAndConditionsContent),
          ],
        ],
      ),
    );
  }

  Widget _sectionHeading(String text) => Text(
    text,
    style: const TextStyle(
      color: AppColors.primary,
      fontSize: 12,
      fontWeight: FontWeight.w800,
      letterSpacing: 1,
    ),
  );

  Widget _informationSection(String heading, List<String> content) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _sectionHeading(heading),
      const SizedBox(height: 10),
      _contentCard(content),
    ],
  );

  Widget _contentCard(List<String> content) => GlassCard(
    borderRadius: 20,
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    child: Column(
      children: [
        for (var i = 0; i < content.length; i++) ...[
          _contentRow(content[i]),
          if (i != content.length - 1)
            Divider(height: 1, color: AppColors.white.withValues(alpha: 0.10)),
        ],
      ],
    ),
  );

  Widget _contentRow(String text) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 14),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 6),
          child: Icon(Icons.circle, color: AppColors.primary, size: 7),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: AppColors.onSurface,
              fontSize: 14,
              height: 1.45,
            ),
          ),
        ),
      ],
    ),
  );
}
