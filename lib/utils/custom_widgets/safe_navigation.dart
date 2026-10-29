import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kaam_fast/utils/constants/color_picker.dart';
import 'package:kaam_fast/utils/routes/app_routes.dart';

/// Helper to safely navigate back without ever landing on a blank black screen
class SafeNav {
  static void popOrFallback(
    BuildContext context, {
    String fallbackRoute = AppRoutes.customerHome,
    Map<String, dynamic>? extra,
  }) {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(fallbackRoute, extra: extra);
    }
  }
}

/// Standardized safe back button widget for AppBars
class AppBackButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String fallbackRoute;
  final Color color;

  const AppBackButton({
    super.key,
    this.onPressed,
    this.fallbackRoute = AppRoutes.customerHome,
    this.color = kWhite,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back_ios_new_rounded, color: color, size: 20),
      tooltip: 'Back',
      onPressed: onPressed ?? () => SafeNav.popOrFallback(context, fallbackRoute: fallbackRoute),
    );
  }
}
