import 'package:flutter/material.dart';

/// Central color palette for Who Inherited Who.
///
/// The app uses a dark, neutral, premium aesthetic inspired by
/// Discord, Notion, and Linear. Accent colors are used sparingly.
class AppColors {
  AppColors._();

  // ─── Backgrounds ────────────────────────────────────────────────
  static const Color background = Color(0xFF0F1115);
  static const Color backgroundElevated = Color(0xFF14171A);
  static const Color card = Color(0xFF181C20);
  static const Color cardHover = Color(0xFF1D2227);
  static const Color secondary = Color(0xFF20242A);
  static const Color secondaryHover = Color(0xFF262B32);

  // ─── Borders ───────────────────────────────────────────────────
  static const Color border = Color(0xFF2B3138);
  static const Color borderStrong = Color(0xFF3A424C);
  static const Color borderSubtle = Color(0xFF23282E);

  // ─── Text ──────────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFFF2F3F5);
  static const Color textSecondary = Color(0xFFB5BAC1);
  static const Color textMuted = Color(0xFF80848E);
  static const Color textFaint = Color(0xFF5C6068);

  // ─── Accents (used sparingly) ──────────────────────────────────
  static const Color accentGreen = Color(0xFF4ADE80);
  static const Color accentBlue = Color(0xFF60A5FA);
  static const Color accentOrange = Color(0xFFFB923C);
  static const Color accentPurple = Color(0xFFA78BFA);
  static const Color accentPink = Color(0xFFF472B6);

  // ─── Status ────────────────────────────────────────────────────
  static const Color success = Color(0xFF34D399);
  static const Color error = Color(0xFFF87171);
  static const Color warning = Color(0xFFFBBF24);
  static const Color info = Color(0xFF60A5FA);

  // ─── Canvas / Paper ────────────────────────────────────────────
  /// The drawing surface stays white — like a sheet of paper on a dark desk.
  static const Color paper = Color(0xFFFDFDFC);
  static const Color paperBorder = Color(0xFFE4E4E0);

  // ─── Player avatar palette (deterministic per player) ──────────
  static const List<Color> avatarPalette = [
    Color(0xFF60A5FA), // blue
    Color(0xFF4ADE80), // green
    Color(0xFFFB923C), // orange
    Color(0xFFA78BFA), // purple
    Color(0xFFF472B6), // pink
    Color(0xFFFBBF24), // amber
    Color(0xFF34D399), // emerald
    Color(0xFFF87171), // red
  ];

  /// Deterministic avatar color from a player name.
  static Color avatarColorFor(String name) {
    if (name.isEmpty) return accentBlue;
    final code = name.codeUnits.fold<int>(0, (sum, c) => sum + c);
    return avatarPalette[code % avatarPalette.length];
  }
}
