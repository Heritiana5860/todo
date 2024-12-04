import 'package:flutter/material.dart';
import 'package:todo/theme/dark_theme.dart';
import 'package:todo/theme/light_theme.dart';
 
class ThemeProvider with ChangeNotifier {
  ThemeData _themeData = lightTheme;

  ThemeData get getThemeData => _themeData;

  set setTthemeData(ThemeData theme) {
    _themeData = theme;
    notifyListeners();
  }

  void toggleTheme() {
    if(_themeData == lightTheme) {
      setTthemeData = darkTheme;
    } else {
      setTthemeData = lightTheme;
    }
  }

}