import 'package:flutter/material.dart';

import 'brand.dart';

ThemeData buildLightTheme() {
  final ThemeData base = ThemeData.light();

  final inputDecorationTheme = base.inputDecorationTheme;
  return base.copyWith(
    colorScheme: lightColorScheme,
    accentColor: const Color(0xff58C9B9),
    primaryColor: primary,
    inputDecorationTheme: base.inputDecorationTheme.copyWith(
      prefixStyle: TextStyle(color: Colors.yellowAccent),
      errorBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: error),
      ),
      focusedErrorBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: error, width: 1.5),
      ),
      helperStyle: TextStyle(color: secondary),
      labelStyle: TextStyle(color: secondary.withOpacity(0.5)),
    ),
    scaffoldBackgroundColor: background,
    errorColor: error,
    primaryIconTheme: _customIconTheme(base.iconTheme),
    textTheme: buildTextTheme(baseTheme: base.textTheme),
    iconTheme: _customIconTheme(base.iconTheme),
    appBarTheme: base.appBarTheme.copyWith(
      color: Colors.white,
      textTheme: buildTextTheme(baseTheme: base.textTheme),
      iconTheme: base.iconTheme.copyWith(color: Colors.black),
      elevation: 0,
    ),
    sliderTheme: const SliderThemeData(
      valueIndicatorTextStyle: TextStyle(color: Colors.white),
      valueIndicatorColor: primary,
    ),
  );
}

IconThemeData _customIconTheme(IconThemeData original) {
  return original.copyWith(color: secondary);
}
