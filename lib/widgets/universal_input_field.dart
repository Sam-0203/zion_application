import 'package:flutter/material.dart';
import 'package:flutter_app/app/theme/app_colors.dart';

class UniversalInputField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  final String? Function(String?)? validator;
  final bool obscureText;
  final bool readOnly;
  final bool autofocus;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final void Function(String)? onFieldSubmitted;
  final int minLines;
  final int maxLines;
  final int? maxLength;
  final TextCapitalization textCapitalization;
  final TextStyle? style;
  final TextStyle? hintStyle;
  final TextStyle? counterStyle;
  final Color? fillColor;
  final EdgeInsetsGeometry? contentPadding;
  final double borderRadius;

  const UniversalInputField({
    super.key,
    required this.controller,
    required this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.obscureText = false,
    this.readOnly = false,
    this.autofocus = false,
    this.onTap,
    this.onChanged,
    this.textInputAction,
    this.keyboardType,
    this.onFieldSubmitted,
    this.minLines = 1,
    this.maxLines = 1,
    this.maxLength,
    this.textCapitalization = TextCapitalization.none,
    this.style,
    this.hintStyle,
    this.counterStyle,
    this.fillColor,
    this.contentPadding,
    this.borderRadius = 14,
  });

  @override
  State<UniversalInputField> createState() => _UniversalInputFieldState();
}

class _UniversalInputFieldState extends State<UniversalInputField>
    with WidgetsBindingObserver {
  final FocusNode _focusNode = FocusNode();
  OverlayEntry? _doneToolbarEntry;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _focusNode.addListener(_updateDoneToolbar);
  }

  @override
  void didChangeMetrics() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _updateDoneToolbar();
    });
  }

  void _updateDoneToolbar() {
    if (!mounted) return;

    final isIOS = Theme.of(context).platform == TargetPlatform.iOS;
    final keyboardIsOpen = MediaQuery.viewInsetsOf(context).bottom > 0;

    if (isIOS && _focusNode.hasFocus && keyboardIsOpen) {
      if (_doneToolbarEntry == null) {
        _doneToolbarEntry = OverlayEntry(builder: _buildDoneToolbar);
        Overlay.of(context, rootOverlay: true).insert(_doneToolbarEntry!);
      } else {
        _doneToolbarEntry!.markNeedsBuild();
      }
    } else {
      _removeDoneToolbar();
    }
  }

  Widget _buildDoneToolbar(BuildContext context) {
    final keyboardHeight = MediaQuery.viewInsetsOf(context).bottom;

    return Positioned(
      left: 0,
      right: 0,
      bottom: keyboardHeight,
      child: Material(
        color: const Color(0xFFF0EFF6),
        child: SizedBox(
          height: 56,
          child: Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => _focusNode.unfocus(),
              child: const Text(
                'Done',
                style: TextStyle(fontSize: 18, color: Color(0xFF007AFF)),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _removeDoneToolbar() {
    _doneToolbarEntry?.remove();
    _doneToolbarEntry = null;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _focusNode.removeListener(_updateDoneToolbar);
    _focusNode.dispose();
    _removeDoneToolbar();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      focusNode: _focusNode,
      obscureText: widget.obscureText,
      readOnly: widget.readOnly,
      autofocus: widget.autofocus,
      onTap: widget.onTap,
      onChanged: widget.onChanged,
      minLines: widget.obscureText ? 1 : widget.minLines,
      maxLines: widget.obscureText ? 1 : widget.maxLines,
      maxLength: widget.maxLength,
      textCapitalization: widget.textCapitalization,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      onFieldSubmitted: widget.onFieldSubmitted,
      validator: widget.validator,

      style: widget.style ?? TextStyle(color: AppColors.white),

      decoration: InputDecoration(
        hintText: widget.hintText,

        hintStyle:
            widget.hintStyle ?? TextStyle(color: AppColors.onSurfaceMuted),
        counterStyle: widget.counterStyle,

        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.suffixIcon,

        filled: true,
        fillColor:
            widget.fillColor ?? AppColors.primary.withValues(alpha: 0.06),

        contentPadding:
            widget.contentPadding ??
            const EdgeInsets.symmetric(vertical: 16, horizontal: 16),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: BorderSide.none,
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: BorderSide(
            color: AppColors.onSurfaceMuted.withValues(alpha: 0.15),
          ),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: BorderSide(color: AppColors.primary, width: 1.5),
        ),

        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: BorderSide(color: AppColors.error),
        ),

        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: BorderSide(color: AppColors.error, width: 1.5),
        ),
      ),
    );
  }
}
