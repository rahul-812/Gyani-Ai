import 'package:flutter/material.dart';

/// [AppSpacing] defines the standard spacing values based on a 4px/8px grid.
/// Following Material 3 guidelines for consistent layouts.
abstract final class AppSpacing {
  static const double xs = 4.0;
  static const double s = 8.0;
  static const double m = 16.0;
  static const double l = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
  static const double xxxl = 64.0;
}

/// `AppGaps` provides [SizedBox] widgets for consistent spacing between widgets.
abstract final class AppGaps {
  // Vertical Gaps
  static const hXS = SizedBox(height: AppSpacing.xs);
  static const hS = SizedBox(height: AppSpacing.s);
  static const hM = SizedBox(height: AppSpacing.m);
  static const hL = SizedBox(height: AppSpacing.l);
  static const hXL = SizedBox(height: AppSpacing.xl);

  // Horizontal Gaps
  static const wXS = SizedBox(width: AppSpacing.xs);
  static const wS = SizedBox(width: AppSpacing.s);
  static const wM = SizedBox(width: AppSpacing.m);
  static const wL = SizedBox(width: AppSpacing.l);
  static const wXL = SizedBox(width: AppSpacing.xl);
}

/// [AppRadius] defines the corner radius values following Material 3 shapes.
abstract final class AppRadius {
  static const xs = Radius.circular(4.0);
  static const s = Radius.circular(8.0);
  static const m = Radius.circular(12.0);
  static const l = Radius.circular(16.0);
  static const xl = Radius.circular(28.0);
  static const full = Radius.circular(1000.0);
}

/// [AppIconSize] defines standard icon sizes.
abstract final class AppIconSize {
  static const double s = 18.0;
  static const double m = 24.0;
  static const double l = 32.0;
  static const double xl = 48.0;
}

/// [AppPadding] provides common [EdgeInsets] configurations.
abstract final class AppPadding {
  static const allS = EdgeInsets.all(AppSpacing.s);
  static const allM = EdgeInsets.all(AppSpacing.m);
  static const allL = EdgeInsets.all(AppSpacing.l);

  static const horizontalS = EdgeInsets.symmetric(horizontal: AppSpacing.s);
  static const horizontalM = EdgeInsets.symmetric(horizontal: AppSpacing.m);
  static const horizontalL = EdgeInsets.symmetric(horizontal: AppSpacing.l);

  static const verticalS = EdgeInsets.symmetric(vertical: AppSpacing.s);
  static const verticalM = EdgeInsets.symmetric(vertical: AppSpacing.m);
  static const verticalL = EdgeInsets.symmetric(vertical: AppSpacing.l);
}

/// [AppIcons] defines the paths to the vector icons.
abstract final class AppIcons {
  static const String menu = 'icons/menu.svg';
  static const String cross = 'icons/cross.svg';
  static const String tune = 'icons/tune.svg';
  static const String mic = 'icons/mic.svg';
  static const String send = 'icons/send.svg';
  static const String aiEdit = 'icons/ai_edit.svg';
}
