import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,

      colorScheme: const ColorScheme(
        brightness: .light,
        primary: AppColors.primary,
        onPrimary: Colors.white,
        secondary: AppColors.contrast,
        onSecondary: Colors.white,
        surface: Colors.white,
        onSurface: AppColors.text,
        error: AppColors.error,
        onError: Colors.white,
        surfaceContainerLowest: AppColors.background,
      ),

      scaffoldBackgroundColor: AppColors.background,

      textTheme: GoogleFonts.outfitTextTheme().apply(
        bodyColor: AppColors.text,
        displayColor: AppColors.text,
      ),

      inputDecorationTheme: InputDecorationTheme(
        labelStyle: const TextStyle(color: AppColors.text, fontWeight: .bold),

        errorStyle: const TextStyle(fontWeight: .bold, fontSize: 12),

        floatingLabelStyle: const TextStyle(
          color: AppColors.contrast,
          fontWeight: .w600,
        ),

        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.contrast, width: 1),
          borderRadius: .circular(4),
        ),

        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.contrast, width: 2.0),
          borderRadius: .circular(4),
        ),

        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.error),
          borderRadius: .circular(4),
        ),

        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.error, width: 2.0),
          borderRadius: .circular(4),
        ),
      ),

      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: AppColors.contrast,
        selectionColor: Colors.black12,
        selectionHandleColor: AppColors.contrast,
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          disabledBackgroundColor: Colors.grey[300],
          disabledForegroundColor: Colors.grey[500],
          shape: RoundedRectangleBorder(borderRadius: .circular(4)),
          textStyle: GoogleFonts.outfit(fontWeight: .w500, fontSize: 16),
        ),
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: AppColors.text),
        titleTextStyle: TextStyle(
          color: AppColors.text,
          fontSize: 20,
          fontWeight: .bold,
          fontFamily: 'Outfit',
        ),
      ),
    );
  }
}
