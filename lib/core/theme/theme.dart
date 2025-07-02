import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import 'custom_theme/text_theme.dart';

class TAppTheme {
  TAppTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: "Playfair Display",
    brightness: Brightness.light,
    primaryColor: AppColors.primary,
    textTheme: TTextTheme.lightTextTheme,
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: "Playfair Display",
    disabledColor: AppColors.grey,
    brightness: Brightness.dark,
    primaryColor: AppColors.primary,
    textTheme: TTextTheme.darkTextTheme,
  );
}
