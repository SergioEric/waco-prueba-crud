import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// we set standar type system, as we're in mobile device
/// normal values of headline 1,2,3,4,5,6 are reduced for improve
/// design system.
TextTheme buildTextTheme({
  required TextTheme baseTheme,
  bool isDarkMode = false,
}) {
  final Color baseTextColor = isDarkMode ? Colors.white : Colors.black;
  return GoogleFonts.ralewayTextTheme(baseTheme).copyWith(
    headline1: GoogleFonts.workSans(
      fontSize: 30,
      fontWeight: FontWeight.w300,
      letterSpacing: 0.5,
      color: baseTextColor,
    ),
    headline2: GoogleFonts.workSans(
      fontSize: 28,
      fontWeight: FontWeight.w300,
      color: baseTextColor,
    ),
    headline3: GoogleFonts.workSans(
      fontSize: 24,
      fontWeight: FontWeight.w400,
      color: baseTextColor,
    ),
    headline4: GoogleFonts.workSans(
      fontSize: 22,
      fontWeight: FontWeight.w400,
      color: baseTextColor,
      // letterSpacing: 0.25,
    ),
    headline5: GoogleFonts.workSans(
      fontSize: 20,
      fontWeight: FontWeight.w400,
      color: baseTextColor,
    ),
    headline6: GoogleFonts.workSans(
      fontSize: 18,
      fontWeight: FontWeight.w500,
      // letterSpacing: 0.5,
      color: baseTextColor,
    ),
    subtitle1: GoogleFonts.workSans(
      fontSize: 16,
      fontWeight: FontWeight.w500, // medium
      letterSpacing: 0.15,
      color: baseTextColor,
    ),
    subtitle2: GoogleFonts.workSans(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
      color: baseTextColor,
    ),
    bodyText1: GoogleFonts.workSans(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.5,
      color: baseTextColor,
    ),
    bodyText2: GoogleFonts.workSans(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.25,
      color: baseTextColor,
    ),
    caption: GoogleFonts.workSans(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.4,
      color: baseTextColor,
    ),
    overline: GoogleFonts.workSans(
      fontSize: 10,
      fontWeight: FontWeight.w400,
      letterSpacing: 1.5,
      color: baseTextColor,
    ),
  );
}
