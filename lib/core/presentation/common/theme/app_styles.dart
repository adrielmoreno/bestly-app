import "package:flutter/material.dart";

import "color_theme.dart";

class AppStyles {
  // App Theme
  static ThemeData appLightTheme = ThemeData(
    colorScheme: ColorThemme.lightColorScheme,
    useMaterial3: true,
    appBarTheme: const AppBarTheme(surfaceTintColor: Colors.transparent),
  ).copyWith(
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: <TargetPlatform, PageTransitionsBuilder>{
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    ),
  );

  static ThemeData appDarkTheme = ThemeData(
    colorScheme: ColorThemme.darkColorScheme,
    useMaterial3: true,
    appBarTheme: const AppBarTheme(surfaceTintColor: Colors.transparent),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: const Color(0xff00408b),
        foregroundColor: Colors.white,
        textStyle: TextStyle(fontSize: 17),
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 0.4, color: Colors.white),
          borderRadius: BorderRadius.circular(10),
        ),
        iconSize: 34,
      ),
    ),
  ).copyWith(
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: <TargetPlatform, PageTransitionsBuilder>{
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    ),
  );
}
