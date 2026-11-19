import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_app/widgets/universal_app_bar.dart';

class AppScaffold extends StatelessWidget {
  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final bool topTrue;
  final bool bottomTrue;
  final bool showAutomaticBackButton;

  /// Pass a custom image path to override the default background image.
  final String? backgroundImage;

  /// the default background image is used.
  final Color? backgroundColor;

  /// Pass false on screens where you don't want the blur.
  final bool blurBackground;

  /// How strong the blur is (only used when [blurBackground] is true).
  final double blurSigma;

  const AppScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.backgroundImage,
    this.backgroundColor,
    this.topTrue = true,
    this.bottomTrue = false,
    this.showAutomaticBackButton = true,
    this.blurBackground = true,
    this.blurSigma = 6,
  });

  static const String _defaultBackground = 'assets/background/Jesus_glow.jpg';

  @override
  Widget build(BuildContext context) {
    final showBackButton =
        showAutomaticBackButton &&
        appBar == null &&
        Navigator.of(context).canPop();
    final effectiveAppBar =
        appBar ??
        (showBackButton ? const UniversalAppBar(toolbarHeight: 56) : null);
    return Stack(
      fit: StackFit.expand,
      children: [
        // Keep the shared background visible behind transparent app bars.
        Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            image: backgroundColor == null
                ? DecorationImage(
                    image: AssetImage(backgroundImage ?? _defaultBackground),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
        ),
        if (blurBackground && backgroundColor == null)
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
            child: Container(color: Colors.transparent),
          ),
        Scaffold(
          backgroundColor: Colors.transparent,
          extendBodyBehindAppBar: false,
          appBar: effectiveAppBar,
          bottomNavigationBar: bottomNavigationBar,
          floatingActionButton: floatingActionButton,
          body: SafeArea(top: topTrue, bottom: bottomTrue, child: body),
        ),
      ],
    );
  }
}
