import 'dart:ui';

import 'package:flutter/material.dart';

class CustomColorScheme {
  final Color primaryColor;
  final Color secondaryColor;
  final Color textColor;
  final Color tabColor;
  final Color cardColor;
  final Color theme;
  CustomColorScheme({
    required this.primaryColor,
    required this.secondaryColor,
    required this.textColor,
    required this.tabColor,
    required this.cardColor,
    required this.theme,
  });
}

class AppTheme {
  final CustomColorScheme? light;
  late  CustomColorScheme? dark;
  late  CustomColorScheme? midnight;
  AppTheme({
    this.light,
    this.dark,
    this.midnight,
  });
}

AppTheme appTheme = AppTheme(
  dark: CustomColorScheme(
    primaryColor:   const Color(0xff4b4b4b),
    secondaryColor: const Color(0xff65646a),
    tabColor:       const Color(0xff8b8e97),
    textColor:      const Color(0xffffffff),
    cardColor:      const Color(0xff8b8e97),
    theme:          const Color(0x00000000)
  )
);

CustomColorScheme? appColors = appTheme.dark;

final ThemeData darkTheme = ThemeData(
  primarySwatch: Colors.grey,
  brightness: Brightness.light,
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.transparent,
    surfaceTint: Colors.transparent,
  ),
);