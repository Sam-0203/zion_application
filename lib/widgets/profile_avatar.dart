import 'package:flutter/material.dart';
import 'package:flutter_app/app/theme/app_colors.dart';
import 'package:flutter_app/core/constants/api_urls.dart';

/// Displays a remote profile photo, with initials shown while it loads or if
/// the URL cannot be loaded.
class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({
    super.key,
    required this.radius,
    this.imageUrl,
    this.initials,
  });

  final double radius;
  final String? imageUrl;
  final String? initials;

  String? _resolvedImageUrl() {
    final value = imageUrl?.trim();
    if (value == null || value.isEmpty) return null;

    final uri = Uri.tryParse(value);
    if (uri == null) return null;
    if (uri.hasScheme) {
      return (uri.scheme == 'http' || uri.scheme == 'https') ? value : null;
    }

    return Uri.parse(APIsurls.baseUrl).resolveUri(uri).toString();
  }

  @override
  Widget build(BuildContext context) {
    final resolvedUrl = _resolvedImageUrl();
    final label = initials?.trim().toUpperCase() ?? '';
    final fallback = label.isNotEmpty
        ? Text(
            label,
            style: TextStyle(
              color: AppColors.primary,
              fontSize: radius * 0.75,
              fontWeight: FontWeight.w800,
            ),
          )
        : Icon(Icons.person, color: AppColors.primary, size: radius * 1.1);

    return CircleAvatar(
      radius: radius,
      backgroundColor: AppColors.primary.withValues(alpha: 0.18),
      child: ClipOval(
        child: SizedBox.expand(
          child: Stack(
            fit: StackFit.expand,
            alignment: Alignment.center,
            children: [
              Center(child: fallback),
              if (resolvedUrl != null)
                Image.network(
                  resolvedUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const SizedBox.shrink(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
