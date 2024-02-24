import 'package:flutter/material.dart';

class ThemeManager with ChangeNotifier{
  ThemeMode _themeMode = ThemeMode.light;

  //getter used to get the value of the theme mode in other dart filesas it is a private variable
  get themeMode => ThemeMode.light;

  //function to change themes
  toggleTheme(bool isDark){
    _themeMode = isDark? ThemeMode.dark : ThemeMode.light;

    notifyListeners();
  }
}