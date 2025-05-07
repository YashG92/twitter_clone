import 'package:flutter/material.dart';
import 'package:twitter_clone/theme/palette.dart';
import 'package:twitter_clone/theme/text_theme.dart';

class AppTheme {
  static ThemeData lightTheme =ThemeData(
    scaffoldBackgroundColor: Palette.lightBackgroundColor,
    appBarTheme: AppBarTheme(
      backgroundColor: Palette.lightBackgroundColor,
      titleTextStyle: YTextTheme.whiteTextTheme.headlineSmall,
      elevation: 0,
    ),
    textTheme: YTextTheme.whiteTextTheme,
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Palette.blueColor,
      foregroundColor: Colors.white,
    )
  );

  static ThemeData darkTheme =ThemeData(
    scaffoldBackgroundColor: Palette.darkBackgroundColor,
    appBarTheme: AppBarTheme(
      backgroundColor: Palette.darkBackgroundColor,
      titleTextStyle: YTextTheme.blackTextTheme.headlineSmall,
      elevation: 0,
    ),
    textTheme: YTextTheme.blackTextTheme,
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Palette.blueColor,
      foregroundColor: Colors.white,
    ),
  );
}