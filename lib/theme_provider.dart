import 'package:flutter/material.dart';
import 'package:habit_tracker/themes.dart';

class ThemeProvider extends ChangeNotifier{
  ThemeData _themeData = lightTheme;

  ThemeData get themeData => _themeData;
  bool get isDarkTheme => _themeData==darkTheme;

  set themeData(ThemeData value) {
    _themeData = value;
    notifyListeners();
  }
  void toggleTheme(){
    if(_themeData== lightTheme){
      themeData = darkTheme;
    }
    else{
      themeData = lightTheme;
    }
  }
}