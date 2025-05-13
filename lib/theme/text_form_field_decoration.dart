import 'package:flutter/material.dart';
import 'package:twitter_clone/theme/palette.dart';

import '../utils/constants/constants.dart';


class TextFormFieldDecoration {
  TextFormFieldDecoration._();

  static InputDecorationTheme lightInputDecorationTheme =InputDecorationTheme(
    filled: true,
    fillColor: Colors.grey.shade200,
    contentPadding: EdgeInsets.all(20),
    border: OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.circular(30),
    ),
    enabledBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(YSizes.inputFieldRadius),
      borderSide:  BorderSide(width: 1, color: Palette.white),
    ),
    focusedBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(YSizes.inputFieldRadius),
      borderSide:  BorderSide(width: 1, color: Palette.darkerGrey),
    ),
    errorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(YSizes.inputFieldRadius),
      borderSide:  BorderSide(width: 1, color: Palette.warning),
    ),
    focusedErrorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(YSizes.inputFieldRadius),
      borderSide:  BorderSide(width: 2, color: Palette.warning),
    ),
  );
  static InputDecorationTheme darkInputDecorationTheme =InputDecorationTheme(
    filled: true,
    fillColor: Colors.black.withAlpha(100),
    contentPadding: EdgeInsets.all(20),
    border: OutlineInputBorder(
      borderSide: BorderSide(width: 1, color: Palette.greyColor),
      borderRadius: BorderRadius.circular(30),
    ),
    enabledBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(YSizes.inputFieldRadius),
      borderSide:  BorderSide(width: 1, color: Palette.darkerGrey),
    ),
    focusedBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(YSizes.inputFieldRadius),
      borderSide:  BorderSide(width: 1, color: Palette.white),
    ),
    errorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(YSizes.inputFieldRadius),
      borderSide:  BorderSide(width: 1, color: Palette.warning),
    ),
    focusedErrorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(YSizes.inputFieldRadius),
      borderSide:  BorderSide(width: 2, color: Palette.warning),
    ),

  );
}