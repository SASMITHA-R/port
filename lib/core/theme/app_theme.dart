import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // ── Dark Palette (Teal + Coral + Amber) ──────────────────────
  static const Color darkBg = Color(0xFF080C10);
  static const Color darkSurface = Color(0xFF0F1419);
  static const Color darkCard = Color(0xFF161D25);
  static const Color darkBorder = Color(0xFF243040);
  static const Color accentTeal = Color(0xFF2DD4BF);
  static const Color accentCoral = Color(0xFFFF6B6B);
  static const Color accentAmber = Color(0xFFFBBF24);
  static const Color accentGreen = Color(0xFF34D399);
  static const Color textPrimary = Color(0xFFEFF6FF);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textMuted = Color(0xFF4A5568);

  // ── Light Palette ─────────────────────────────────────────────
  static const Color lightBg = Color(0xFFF0FDFA);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCard = Color(0xFFE6FFFA);
  static const Color lightBorder = Color(0xFF99F6E4);
  static const Color lightTextPrimary = Color(0xFF0F2027);
  static const Color lightTextSecondary = Color(0xFF4A5568);
  static const Color lightTextMuted = Color(0xFF94A3B8);

  static ThemeData darkTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: darkBg,
      colorScheme: const ColorScheme.dark(
        surface: darkSurface,
        primary: accentTeal,
        secondary: accentCoral,
        onSurface: textPrimary,
      ),
      textTheme: _buildTextTheme(textPrimary, textSecondary),
      useMaterial3: true,
    );
  }

  static ThemeData lightTheme() {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: lightBg,
      colorScheme: const ColorScheme.light(
        surface: lightSurface,
        primary: accentTeal,
        secondary: accentCoral,
        onSurface: lightTextPrimary,
      ),
      textTheme: _buildTextTheme(lightTextPrimary, lightTextSecondary),
      useMaterial3: true,
    );
  }

  static TextTheme _buildTextTheme(Color primary, Color secondary) {
    return TextTheme(
      displayLarge: GoogleFonts.plusJakartaSans(
        fontSize: 64,
        fontWeight: FontWeight.w800,
        color: primary,
        letterSpacing: -2.5,
      ),
      displayMedium: GoogleFonts.plusJakartaSans(
        fontSize: 48,
        fontWeight: FontWeight.w700,
        color: primary,
        letterSpacing: -1.5,
      ),
      displaySmall: GoogleFonts.plusJakartaSans(
        fontSize: 36,
        fontWeight: FontWeight.w700,
        color: primary,
        letterSpacing: -1,
      ),
      headlineMedium: GoogleFonts.plusJakartaSans(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: primary,
      ),
      titleLarge: GoogleFonts.plusJakartaSans(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: primary,
      ),
      titleMedium: GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: primary,
      ),
      bodyLarge: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: secondary,
        height: 1.7,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: secondary,
        height: 1.6,
      ),
      labelLarge: GoogleFonts.jetBrainsMono(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: secondary,
        letterSpacing: 0.5,
      ),
    );
  }
}
