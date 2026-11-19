import 'package:flutter/material.dart';
import 'package:flutter_app/app/theme/app_colors.dart';
import 'package:flutter_app/widgets/universal_input_field.dart';

/// A reusable search bar.
///
/// Two modes:
/// 1. Tap-only (`readOnly: true` + `onTap`) – looks like a search field and
///    navigates to a search page when tapped.
/// 2. Editable – real text input with a clear button, `onChanged` and
///    `onSubmitted` callbacks.
class UniversalSearchBar extends StatefulWidget {
  const UniversalSearchBar({
    super.key,
    this.hintText = 'Search',
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.onClear,
    this.onTap,
    this.readOnly = false,
    this.autofocus = false,
    this.margin = const EdgeInsets.fromLTRB(16, 12, 16, 4),
    this.borderRadius = 16,
    this.height = 50,
  });

  final String hintText;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onClear;
  final VoidCallback? onTap;
  final bool readOnly;
  final bool autofocus;
  final EdgeInsetsGeometry margin;
  final double borderRadius;
  final double height;

  @override
  State<UniversalSearchBar> createState() => _UniversalSearchBarState();
}

class _UniversalSearchBarState extends State<UniversalSearchBar> {
  late final TextEditingController _controller;
  late final bool _ownsController;

  @override
  void initState() {
    super.initState();
    _ownsController = widget.controller == null;
    _controller = widget.controller ?? TextEditingController();
  }

  @override
  void dispose() {
    if (_ownsController) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _clear() {
    _controller.clear();
    widget.onChanged?.call('');
    widget.onClear?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.margin,
      child: SizedBox(
        height: widget.height,
        child: UniversalInputField(
          controller: _controller,
          hintText: widget.hintText,
          readOnly: widget.readOnly,
          autofocus: widget.autofocus,
          onTap: widget.onTap,
          onChanged: widget.onChanged,
          onFieldSubmitted: widget.onSubmitted,
          textInputAction: TextInputAction.search,
          prefixIcon: Icon(
            Icons.search_rounded,
            color: AppColors.onSurfaceMuted,
            size: 22,
          ),
          suffixIcon: !widget.readOnly
              ? ValueListenableBuilder<TextEditingValue>(
                  valueListenable: _controller,
                  builder: (context, value, _) {
                    if (value.text.isEmpty) return const SizedBox.shrink();
                    return IconButton(
                      onPressed: _clear,
                      tooltip: 'Clear search',
                      icon: Icon(
                        Icons.close_rounded,
                        color: AppColors.onSurfaceMuted,
                        size: 20,
                      ),
                    );
                  },
                )
              : null,
          fillColor: AppColors.white.withValues(alpha: 0.06),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 12,
            horizontal: 12,
          ),
          borderRadius: widget.borderRadius,
        ),
      ),
    );
  }
}
