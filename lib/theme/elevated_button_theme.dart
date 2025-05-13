import 'package:flutter/material.dart';
import 'package:twitter_clone/theme/theme.dart';

import '../utils/constants/constants.dart';

class ElevatedButtonThemes {
  ElevatedButtonThemes._();

  static ElevatedButtonThemeData lightElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Palette.blueColor,
      foregroundColor: Palette.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(YSizes.inputFieldRadius),
      ),
      padding: EdgeInsets.symmetric(vertical: YSizes.md),
    )
  );

  static ElevatedButtonThemeData darkElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Palette.blueColor,
      foregroundColor: Palette.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(YSizes.inputFieldRadius),
      ),
      padding: EdgeInsets.symmetric(vertical: YSizes.md),
    )
  );
}