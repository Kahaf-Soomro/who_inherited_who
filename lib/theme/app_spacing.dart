import 'package:flutter/material.dart';

/// Spacing, radius, and animation constants for Who Inherited Who.
///
/// Centralizing these values keeps the UI consistent and maintainable.
class AppSpacing {
  AppSpacing._();

  // ─── Spacing scale ─────────────────────────────────────────────
  static const double xxs = 4;
  static const double xs = 8;
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;
  static const double xxxl = 64;

  // ─── Radius scale ──────────────────────────────────────────────
  static const double radiusXs = 6;
  static const double radiusSm = 10;
  static const double radiusMd = 14;
  static const double radiusLg = 20;
  static const double radiusXl = 28;
  static const double radiusFull = 999;

  // ─── Animation durations ───────────────────────────────────────
  static const Duration durationFast = Duration(milliseconds: 120);
  static const Duration durationNormal = Duration(milliseconds: 220);
  static const Duration durationSlow = Duration(milliseconds: 350);

  // ─── Animation curves ──────────────────────────────────────────
  static const Curve curveFast = Curves.easeOut;
  static const Curve curveNormal = Curves.easeOutCubic;
  static const Curve curveSlow = Curves.easeInOutCubic;

  // ─── Layout ────────────────────────────────────────────────────
  static const double maxContentWidth = 720;
  static const double pagePadding = 24;
  static const double cardPadding = 20;
  static const double sectionGap = 32;
}
