import 'package:flutter/material.dart';
import 'package:twitter_clone/theme/theme.dart';

class AppTheme {
  static ThemeData lightTheme =ThemeData(
    scaffoldBackgroundColor: Palette.lightBackgroundColor,
    brightness: Brightness.light,
    appBarTheme: AppBarTheme(
      backgroundColor: Palette.lightBackgroundColor,
      titleTextStyle: YTextTheme.whiteTextTheme.headlineSmall!.copyWith(fontFamily: 'Chirp'),
      elevation: 0,
    ),
    textTheme: YTextTheme.whiteTextTheme,
    fontFamily: 'Chirp',
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Palette.blueColor,
      foregroundColor: Colors.white,
    )
  );

  static ThemeData darkTheme =ThemeData(
    scaffoldBackgroundColor: Palette.darkBackgroundColor,
    brightness: Brightness.dark,
    appBarTheme: AppBarTheme(
      backgroundColor: Palette.darkBackgroundColor,
      titleTextStyle: YTextTheme.blackTextTheme.headlineSmall!.copyWith(fontFamily: 'Chirp'),
      elevation: 0,
    ),
    textTheme: YTextTheme.blackTextTheme,
    fontFamily: 'Chirp',
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Palette.blueColor,
      foregroundColor: Colors.white,
    ),
  );
}