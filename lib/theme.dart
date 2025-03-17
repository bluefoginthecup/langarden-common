// langarden_common/lib/theme.dart
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primarySwatch: Colors.blue,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.blue,
        elevation: 2,
      ),
      buttonTheme: ButtonThemeData(
        buttonColor: Colors.blue,
        textTheme: ButtonTextTheme.primary,
      ),
      // light theme의 경우 brightness를 지정합니다.
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
      ).copyWith(secondary: Colors.amber),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primarySwatch: Colors.blueGrey,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.blueGrey,
        elevation: 2,
      ),
      buttonTheme: ButtonThemeData(
        buttonColor: Colors.blueGrey,
        textTheme: ButtonTextTheme.primary,
      ),
      // dark theme의 경우, ColorScheme.fromSwatch에 brightness를 명시적으로 Brightness.dark로 설정합니다.
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: Colors.blueGrey,
        brightness: Brightness.dark,
      ).copyWith(secondary: Colors.tealAccent),
    );
  }
}
