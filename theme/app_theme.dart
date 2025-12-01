import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF050505), // Deep black
    primaryColor: const Color(0xFF00F0FF), // Neon Cyan
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF00F0FF),
      secondary: Color(0xFFFF00AA), // Neon Pink
      surface: Color(0xFF121212),
      background: Color(0xFF050505),
      onPrimary: Colors.black,
      onSecondary: Colors.white,
    ),
    textTheme: GoogleFonts.outfitTextTheme(ThemeData.dark().textTheme).copyWith(
      displayLarge: GoogleFonts.outfit(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      bodyLarge: GoogleFonts.outfit(
        fontSize: 16,
        color: Colors.white70,
      ),
    ),
    cardTheme: CardTheme(
      color: const Color(0xFF1E1E1E),
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      shadowColor: const Color(0xFF00F0FF).withOpacity(0.2),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
    ),
    useMaterial3: true,
  );
}
