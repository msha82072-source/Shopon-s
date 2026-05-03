import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // ── USER'S CUSTOM PALETTE (60-30-10 Rule) ──────────────────────────────
  static const Color navyBlue    = Color(0xFF1B2A4A); // Primary  60%
  static const Color creamWhite  = Color(0xFFFDFBF7); // Secondary 30% (Creamy)
  static const Color goldAccent  = Color(0xFFFFC107); // Accent   10% (Yellow) -> Keeping variable name to prevent compilation errors

  // Derived surface shades
  static const Color navyDark    = Color(0xFF111D33); // scaffold background
  static const Color navySurface = Color(0xFF1B2A4A); // card / surface
  static const Color navyDeep    = Color(0xFF0D1B30); // deeper panel

  static const Color errorColor  = Color(0xFFB00020);

  // ── DARK THEME ───────────────────────────────────────────────────────────
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: navyBlue,
    scaffoldBackgroundColor: navyDark,
    colorScheme: ColorScheme.dark(
      primary: goldAccent, // Simple blue accent
      onPrimary: Colors.white,
      secondary: creamWhite,
      surface: navySurface,
      onSurface: creamWhite,
      error: errorColor,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.outfit(
        fontSize: 20,
        fontWeight: FontWeight.w900,
        letterSpacing: 4,
        color: goldAccent,
      ),
      iconTheme: const IconThemeData(color: Colors.white),
    ),
    textTheme: GoogleFonts.outfitTextTheme(ThemeData.dark().textTheme).copyWith(
      displayLarge: GoogleFonts.outfit(
        fontSize: 34,
        fontWeight: FontWeight.w900,
        color: creamWhite,
        letterSpacing: -1,
      ),
      headlineMedium: GoogleFonts.outfit(
        fontSize: 26,
        fontWeight: FontWeight.bold,
        color: creamWhite,
        letterSpacing: 0.5,
      ),
      bodyLarge: GoogleFonts.outfit(
        fontSize: 17,
        color: creamWhite.withValues(alpha: 0.9),
        letterSpacing: 0.3,
      ),
      bodyMedium: GoogleFonts.outfit(
        fontSize: 15,
        color: creamWhite.withValues(alpha: 0.7),
      ),
      labelSmall: GoogleFonts.outfit(
        fontSize: 12,
        fontWeight: FontWeight.w800,
        color: goldAccent,
        letterSpacing: 3,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: goldAccent, // Simple Blue
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 32),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        textStyle: const TextStyle(
          fontWeight: FontWeight.w900,
          fontSize: 16,
          letterSpacing: 2,
        ),
        elevation: 10,
        shadowColor: goldAccent.withValues(alpha: 0.4),
      ),
    ),
    cardTheme: CardThemeData(
      color: navySurface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: goldAccent.withValues(alpha: 0.15), width: 1),
      ),
      elevation: 12,
      shadowColor: Colors.black54,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: navyDeep,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.12)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: goldAccent, width: 2),
      ),
      hintStyle: TextStyle(color: creamWhite.withValues(alpha: 0.4)),
      labelStyle: TextStyle(color: creamWhite.withValues(alpha: 0.6)),
      contentPadding: const EdgeInsets.all(20),
    ),
  );

  // ── LIGHT THEME ──────────────────────────────────────────────────────────
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: navyBlue,
    scaffoldBackgroundColor: creamWhite,
    colorScheme: ColorScheme.light(
      primary: goldAccent, // Simple blue
      onPrimary: Colors.white,
      secondary: navyBlue,
      surface: Colors.white,
      onSurface: navyBlue,
      error: errorColor,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: creamWhite,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.outfit(
        fontSize: 20,
        fontWeight: FontWeight.w900,
        letterSpacing: 4,
        color: navyBlue,
      ),
      iconTheme: const IconThemeData(color: navyBlue),
    ),
    textTheme: GoogleFonts.outfitTextTheme(ThemeData.light().textTheme).copyWith(
      displayLarge: GoogleFonts.outfit(
        fontSize: 34,
        fontWeight: FontWeight.w900,
        color: navyBlue,
        letterSpacing: -1,
      ),
      headlineMedium: GoogleFonts.outfit(
        fontSize: 26,
        fontWeight: FontWeight.bold,
        color: navyBlue,
        letterSpacing: 0.5,
      ),
      bodyLarge: GoogleFonts.outfit(
        fontSize: 17,
        color: navyBlue,
        letterSpacing: 0.3,
      ),
      bodyMedium: GoogleFonts.outfit(
        fontSize: 15,
        color: navyBlue.withValues(alpha: 0.7),
      ),
      labelSmall: GoogleFonts.outfit(
        fontSize: 12,
        fontWeight: FontWeight.w800,
        color: goldAccent,
        letterSpacing: 3,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: goldAccent, // Simple Blue
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 32),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        textStyle: const TextStyle(
          fontWeight: FontWeight.w900,
          fontSize: 16,
          letterSpacing: 2,
        ),
        elevation: 8,
        shadowColor: goldAccent.withValues(alpha: 0.3),
      ),
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: navyBlue.withValues(alpha: 0.05), width: 1),
      ),
      elevation: 8,
      shadowColor: navyBlue.withValues(alpha: 0.1),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: navyBlue.withValues(alpha: 0.1)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: navyBlue.withValues(alpha: 0.1)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: goldAccent, width: 2),
      ),
      hintStyle: TextStyle(color: navyBlue.withValues(alpha: 0.4)),
      labelStyle: TextStyle(color: navyBlue.withValues(alpha: 0.6)),
      contentPadding: const EdgeInsets.all(20),
    ),
  );
}
