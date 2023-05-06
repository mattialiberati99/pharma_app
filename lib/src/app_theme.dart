import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pharma_app/src/helpers/app_config.dart';

/// This is the theme representation of the App UI Kit.
///
/// * [headline1]: h1 Title
/// * [headline2]: h2 Title
/// * [headline3]: h3 Title
/// * [headline4]: h4 Title
/// * [headline5]: Eyebrow w400
/// * [bodyText1]: body w700
/// * [bodyText2]: body w400
/// * [subtitleText1]: subtitle w700
/// * [subtitleText2]: subtitle w400
final ThemeData themeData = ThemeData(
  scaffoldBackgroundColor: const Color(0xFFFFFFFF),
  typography: Typography(
    white: TextTheme(
      overline: GoogleFonts.robotoCondensed(
          fontSize: 36, fontWeight: FontWeight.w700, color: AppColors.gray1),
      headline1: GoogleFonts.robotoCondensed(
        fontSize: 34,
        fontWeight: FontWeight.w400,
      ),
      headline2: GoogleFonts.robotoCondensed(
        fontSize: 28,
        fontWeight: FontWeight.w400,
      ),
      headline3: GoogleFonts.robotoCondensed(
        fontSize: 24,
        fontWeight: FontWeight.w400,
      ),
      headline4: GoogleFonts.robotoCondensed(
        fontSize: 22,
      ),
      headline5: GoogleFonts.robotoCondensed(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: Colors.white,
      ),
      headline6: GoogleFonts.manrope(
        fontSize: 16,
        fontWeight: FontWeight.w700,
      ),
      bodyText1: GoogleFonts.roboto(
        fontSize: 17,
        fontWeight: FontWeight.w400,
      ),
      bodyText2: GoogleFonts.roboto(
        fontSize: 13,
        fontWeight: FontWeight.w700,
      ),
      subtitle1: GoogleFonts.roboto(
        fontSize: 30,
        fontWeight: FontWeight.w700,
      ),
      subtitle2: GoogleFonts.roboto(
          fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.gray3),
    ),
  ),
  colorScheme: const ColorScheme(
    brightness: Brightness.light,
    primary: Color.fromARGB(255, 47, 161, 148),
    onPrimary: Color(0xFFFFFFFF),
    secondary: Color(0xFF28B4A6),
    onSecondary: Color(0xFFFFFFFF),
    onBackground: Color(0xFF9E9E9E),
    surface: Color(0xFFF6EDDD),
    onSurface: Color(0xFFDAE8EB),
    background: Color(0xFFF5F5F5),
    error: Color(0xffDF2C2C),
    onError: Color(0xFFFFFFFF),
    onPrimaryContainer: Color(0XFFE3F671), // Yellow without opacity
    onSecondaryContainer:
        Color.fromRGBO(227, 246, 113, 0.7), // Yellow without opacity of 0.7
  ),
);
