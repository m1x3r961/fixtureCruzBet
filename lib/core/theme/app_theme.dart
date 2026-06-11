import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Tema oscuro premium para la app del Mundial CruzBet.
/// Usa Material 3 con paleta de color personalizada basada en azul ultra-oscuro/verde vibrante.
class AppTheme {
  AppTheme._();

  // --- Paleta de colores Premium (CruzBet) -----------------------------------
  static const _seedColor       = Color(0xFF22C55E); // Verde vibrante (logo/acentos)
  static const _secondaryAccent = Color(0xFF00E5FF); // Cyan vibrante para contrastes
  static const _darkBg          = Color(0xFF0B1116); // Fondo azul muy oscuro casi negro
  static const _cardBg          = Color(0xFF121C24); // Cards ligeramente más claras
  static const _surfaceVariant  = Color(0xFF1C2A36); // Inputs y variantes

  static ThemeData get darkTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _seedColor,
      brightness: Brightness.dark,
      surface: _darkBg,
      surfaceContainerHighest: _cardBg,
      primary: _seedColor,
      secondary: _secondaryAccent,
      tertiary: const Color(0xFFFFD700), // Dorado
      error: const Color(0xFFFF3D57), // Rojo neón suave
    ).copyWith(
      surface: _darkBg,
      surfaceContainerHighest: _surfaceVariant,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      brightness: Brightness.dark,

      // Tipografía con Google Fonts (Outfit)
      textTheme: GoogleFonts.outfitTextTheme(
        ThemeData.dark().textTheme,
      ).apply(
        bodyColor: Colors.white,
        displayColor: Colors.white,
      ),

      // AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent, // Lo manejaremos con gradients donde sea necesario
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.outfit(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: Colors.white,
          letterSpacing: 0.5,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      // Cards
      cardTheme: CardThemeData(
        color: _cardBg,
        elevation: 4,
        shadowColor: Colors.black.withValues(alpha: 0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(
            color: Color(0xFF253641),
            width: 1,
          ),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),

      // Botones primarios (ElevatedButton)
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _seedColor,
          foregroundColor: Colors.white,
          elevation: 4,
          shadowColor: _seedColor.withValues(alpha: 0.4),
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: GoogleFonts.outfit(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ),

      // Botones outline
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 52),
          side: const BorderSide(color: Color(0xFF253641), width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: GoogleFonts.outfit(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Inputs
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _surfaceVariant,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFF253641)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFF253641)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: _seedColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFFF3D57), width: 1.5),
        ),
        labelStyle: const TextStyle(color: Color(0xFF8899AA)),
        hintStyle: const TextStyle(color: Color(0xFF556677)),
      ),

      // Chips
      chipTheme: ChipThemeData(
        backgroundColor: _surfaceVariant,
        labelStyle: GoogleFonts.outfit(fontSize: 12, color: Colors.white70, fontWeight: FontWeight.w500),
        side: BorderSide.none,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),

      scaffoldBackgroundColor: _darkBg,
      dividerColor: const Color(0xFF253641),

      // BottomNavigationBar
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: _darkBg,
        selectedItemColor: _seedColor,
        unselectedItemColor: const Color(0xFF556677),
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),

      // SnackBar
      snackBarTheme: SnackBarThemeData(
        backgroundColor: _surfaceVariant,
        contentTextStyle: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.w500),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Color(0xFF253641)),
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
