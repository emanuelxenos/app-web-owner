import 'package:flutter/material.dart';
import 'package:unifytechxenoswebowner/core/theme/dark_theme.dart';
import 'package:unifytechxenoswebowner/core/theme/light_theme.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get dark => DarkTheme.theme;
  static ThemeData get light => LightTheme.theme;

  // Cores compartilhadas
  static const Color primaryColor = Color(0xFF6C63FF);
  static const Color primaryLight = Color(0xFF8B83FF);
  static const Color primaryDark = Color(0xFF4B44DB);
  static const Color accentGreen = Color(0xFF00D9A6);
  static const Color accentRed = Color(0xFFFF5C5C);
  static const Color accentOrange = Color(0xFFFFB74D);
  static const Color accentBlue = Color(0xFF4FC3F7);

  // Gradientes
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF6C63FF), Color(0xFF4FC3F7)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient successGradient = LinearGradient(
    colors: [Color(0xFF00D9A6), Color(0xFF00B886)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient dangerGradient = LinearGradient(
    colors: [Color(0xFFFF5C5C), Color(0xFFFF3B3B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient sidebarGradient = LinearGradient(
    colors: [Color(0xFF0F1225), Color(0xFF141833)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Border Radius
  static const double radiusSm = 8.0;
  static const double radiusMd = 12.0;
  static const double radiusLg = 16.0;
  static const double radiusXl = 24.0;

  // Spacing
  static const double spacingSm = 8.0;
  static const double spacingMd = 16.0;
  static const double spacingLg = 24.0;
  static const double spacingXl = 32.0;

  // Shadows (for dark theme glass effect)
  static List<BoxShadow> get glassBoxShadow => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.2),
          blurRadius: 20,
          offset: const Offset(0, 4),
        ),
      ];

  static BoxDecoration glassCard({Color? borderColor, Color? backgroundColor}) => BoxDecoration(
        color: backgroundColor ?? const Color(0xFF1C2039).withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(radiusLg),
        border: Border.all(
          color: borderColor ?? const Color(0xFF2A2E4A).withValues(alpha: 0.6),
          width: 1,
        ),
        boxShadow: glassBoxShadow,
      );

  static BoxDecoration glassCardHighlight({required Color accentColor}) =>
      BoxDecoration(
        color: const Color(0xFF1C2039).withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(radiusLg),
        border: Border.all(
          color: accentColor.withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: accentColor.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      );
}
