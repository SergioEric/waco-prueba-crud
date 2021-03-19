import 'package:flutter/material.dart';

import 'brand.dart';

ThemeData buildLightTheme() {
  final ThemeData base = ThemeData.light();

  final inputDecorationTheme = base.inputDecorationTheme;
  return base.copyWith(
    colorScheme: lightColorScheme,
    // toggleableActiveColor: red,
    accentColor: const Color(0xff58C9B9),
    primaryColor: primary,
    // hintColor: secondary,
    // hoverColor: Colors.orange,

    // dialogBackgroundColor: Sagu.dark,
    // dialogTheme:
    //     DialogTheme(contentTextStyle: TextStyle(color: Colors.white54)),
    // scaffoldBackgroundColor: bgColor,
    // cardColor: shrineBackgroundWhite,
    // textSelectionTheme: TextSelectionThemeData(selectionColor: red),
    // textSelectionColor: red,
    inputDecorationTheme: base.inputDecorationTheme.copyWith(
      prefixStyle: TextStyle(color: Colors.yellowAccent),
      errorBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: error),
      ),
      focusedErrorBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: error, width: 1.5),
      ),
      // focusedBorder: UnderlineInputBorder(
      //   borderSide: BorderSide(color: secondary, width: 2),
      // ),
      helperStyle: TextStyle(color: secondary),
      labelStyle: TextStyle(color: secondary.withOpacity(0.5)),
      // suffixStyle: TextStyle(color: primary)
      // errorStyle: TextStyle(color: Colors.red),
      // hintStyle: TextStyle(color: secondary),
    ),
    // primaryColorDark: const Color(0xff000E24),
    // primaryColorLight: const Color(0xff002C73),
    // timePickerTheme: base.timePickerTheme.copyWith(
    //   // hourMinuteColor: Colors.black45,
    // backgroundColor: Colors.white,
    //   dialHandColor: secondary,
    //   // dialTextColor: Colors.green,
    //   entryModeIconColor: secondary,
    //   // dayPeriodTextColor: Colors.pinkAccent,
    // ),
    scaffoldBackgroundColor: background,
    errorColor: error,
    // buttonTheme: const ButtonThemeData(
    //   colorScheme: _buttonColorScheme,
    // ),

    primaryIconTheme: _customIconTheme(base.iconTheme),
    textTheme: buildTextTheme(baseTheme: base.textTheme),
    // primaryTextTheme: buildSaguTextTheme(baseTheme: base.primaryTextTheme),
    // accentTextTheme: buildSaguTextTheme(baseTheme: base.accentTextTheme),
    iconTheme: _customIconTheme(base.iconTheme),
    appBarTheme: base.appBarTheme.copyWith(
      color: Colors.white,
      textTheme: buildTextTheme(baseTheme: base.textTheme),
      iconTheme: base.iconTheme.copyWith(color: Colors.black),
      elevation: 0,
    ),
    // timePickerTheme: TimePickerThemeData(),
    sliderTheme: const SliderThemeData(
      // activeTickMarkColor: secondaryVariant,
      // activeTrackColor: secondary,
      // thumbColor: secondaryVariant,
      // inactiveTrackColor: secondary.withOpacity(0.6),
      valueIndicatorTextStyle: TextStyle(color: Colors.white),
      valueIndicatorColor: primary,
    ),
  );
}

IconThemeData _customIconTheme(IconThemeData original) {
  return original.copyWith(color: secondary);
}
