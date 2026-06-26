import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DarkTheme {
  DarkTheme._();

  static const Color _background = Color(0xFF0B0E1A);
  static const Color _surface = Color(0xFF141829);
  static const Color _surfaceVariant = Color(0xFF1C2039);
  static const Color _card = Color(0xFF1C2039);
  static const Color _primary = Color(0xFF6C63FF);
  static const Color _primaryContainer = Color(0xFF2D2A5E);
  static const Color _secondary = Color(0xFF00D9A6);
  static const Color _error = Color(0xFFFF5C5C);
  static const Color _onBackground = Color(0xFFFFFFFF);
  static const Color _onSurface = Color(0xFFE0E0E8);
  static const Color _onSurfaceVariant = Color(0xFF8E92BC);
  static const Color _outline = Color(0xFF2A2E4A);
  static const Color _divider = Color(0xFF232744);

  static ThemeData get theme {
    final textTheme = GoogleFonts.interTextTheme(ThemeData.dark().textTheme);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: _background,
      colorScheme: const ColorScheme.dark(
        primary: _primary,
        primaryContainer: _primaryContainer,
        secondary: _secondary,
        surface: _surface,
        surfaceContainerHighest: _surfaceVariant,
        error: _error,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: _onSurface,
        onSurfaceVariant: _onSurfaceVariant,
        outline: _outline,
      ),
      cardColor: _card,
      dividerColor: _divider,
      textTheme: textTheme.copyWith(
        displayLarge: textTheme.displayLarge?.copyWith(
          color: _onBackground,
          fontWeight: FontWeight.bold,
        ),
        headlineLarge: textTheme.headlineLarge?.copyWith(
          color: _onBackground,
          fontWeight: FontWeight.w700,
          fontSize: 28,
        ),
        headlineMedium: textTheme.headlineMedium?.copyWith(
          color: _onBackground,
          fontWeight: FontWeight.w600,
          fontSize: 22,
        ),
        headlineSmall: textTheme.headlineSmall?.copyWith(
          color: _onBackground,
          fontWeight: FontWeight.w600,
          fontSize: 18,
        ),
        titleLarge: textTheme.titleLarge?.copyWith(
          color: _onBackground,
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
        titleMedium: textTheme.titleMedium?.copyWith(
          color: _onSurface,
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
        bodyLarge: textTheme.bodyLarge?.copyWith(
          color: _onSurface,
          fontSize: 14,
        ),
        bodyMedium: textTheme.bodyMedium?.copyWith(
          color: _onSurfaceVariant,
          fontSize: 13,
        ),
        bodySmall: textTheme.bodySmall?.copyWith(
          color: _onSurfaceVariant,
          fontSize: 12,
        ),
        labelLarge: textTheme.labelLarge?.copyWith(
          color: _onBackground,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: _surface,
        foregroundColor: _onBackground,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: GoogleFonts.inter(
          color: _onBackground,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      cardTheme: CardThemeData(
        color: _card,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: _outline, width: 1),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: _surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: _outline, width: 1),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _surfaceVariant,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _error),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        labelStyle: const TextStyle(color: _onSurfaceVariant),
        hintStyle: TextStyle(color: _onSurfaceVariant.withValues(alpha: 0.6)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: _primary,
          side: const BorderSide(color: _primary),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: _primary,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
      ),
      iconTheme: const IconThemeData(color: _onSurfaceVariant, size: 22),
      dividerTheme: const DividerThemeData(color: _divider, thickness: 1),
      dataTableTheme: DataTableThemeData(
        headingRowColor: WidgetStateProperty.all(_surfaceVariant),
        dataRowColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.hovered)) {
            return _primary.withValues(alpha: 0.08);
          }
          return Colors.transparent;
        }),
        headingTextStyle: GoogleFonts.inter(
          color: _onSurfaceVariant,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
        dataTextStyle: GoogleFonts.inter(
          color: _onSurface,
          fontSize: 13,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _outline),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: _surfaceVariant,
        selectedColor: _primary.withValues(alpha: 0.2),
        labelStyle: GoogleFonts.inter(fontSize: 12),
        side: const BorderSide(color: _outline),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: _surfaceVariant,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: _outline),
        ),
        textStyle: const TextStyle(color: _onSurface, fontSize: 12),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: _surfaceVariant,
        contentTextStyle: const TextStyle(color: _onSurface),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        behavior: SnackBarBehavior.floating,
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: _primary,
        linearTrackColor: _surfaceVariant,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          return states.contains(WidgetState.selected)
              ? _primary
              : _onSurfaceVariant;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          return states.contains(WidgetState.selected)
              ? _primary.withValues(alpha: 0.4)
              : _surfaceVariant;
        }),
      ),
    );
  }
}
