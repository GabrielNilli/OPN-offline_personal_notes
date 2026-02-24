import 'package:flutter/material.dart';

class AppThemes {
  // ── Colori condivisi ─────────────────────────────────────────────
  static const blue = Colors.blueAccent;

  // ── Tema scuro ───────────────────────────────────────────────────
  static final dark = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF0D1117),
    colorScheme: const ColorScheme.dark(
      surface: Color(0xFF0D1117),
      primary: Colors.blueAccent,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF0D1117),
      elevation: 0,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: IconThemeData(color: Colors.white),
    ),
    cardColor: const Color(0xFF161B22),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith(
        (s) =>
            s.contains(WidgetState.selected) ? Colors.blueAccent : Colors.grey,
      ),
      trackColor: WidgetStateProperty.resolveWith(
        (s) => s.contains(WidgetState.selected)
            ? Colors.blueAccent.withOpacity(0.4)
            : Colors.grey.withOpacity(0.3),
      ),
    ),
  );

  // ── Tema chiaro ──────────────────────────────────────────────────
  static final light = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xFFF2F4F7),
    colorScheme: const ColorScheme.light(
      surface: Color(0xFFF2F4F7),
      primary: Colors.blueAccent,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFFF2F4F7),
      elevation: 0,
      titleTextStyle: TextStyle(
        color: Color(0xFF0D1117),
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: IconThemeData(color: Color(0xFF0D1117)),
    ),
    cardColor: Colors.white,
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith(
        (s) =>
            s.contains(WidgetState.selected) ? Colors.blueAccent : Colors.grey,
      ),
      trackColor: WidgetStateProperty.resolveWith(
        (s) => s.contains(WidgetState.selected)
            ? Colors.blueAccent.withOpacity(0.4)
            : Colors.grey.withOpacity(0.3),
      ),
    ),
  );
}
