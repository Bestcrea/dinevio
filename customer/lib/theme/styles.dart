import 'package:customer/theme/app_them_data.dart';
import 'package:flutter/material.dart';

class Styles {
  static ThemeData themeData(bool isDarkTheme, BuildContext context) {
    return ThemeData(
      scaffoldBackgroundColor: isDarkTheme ? AppThemData.grey950 : AppThemData.grey25,
      primaryColor: isDarkTheme ? AppThemData.primary400 : AppThemData.primary500,
      brightness: isDarkTheme ? Brightness.dark : Brightness.light,
      drawerTheme: DrawerThemeData(
        backgroundColor: Colors.white, // Fond blanc comme dans les images
        width: 304.0, // Largeur standard pour mobile
        elevation: 16.0,
      ),
      appBarTheme: AppBarTheme(
        surfaceTintColor: isDarkTheme ? AppThemData.grey950 : AppThemData.grey25,
        backgroundColor: isDarkTheme ? AppThemData.grey950 : AppThemData.grey25,
      ),
      timePickerTheme: TimePickerThemeData(
        backgroundColor: isDarkTheme ? AppThemData.grey700 : AppThemData.grey200,
        dialTextStyle: TextStyle(fontWeight: FontWeight.bold, color: isDarkTheme ? AppThemData.grey100 : AppThemData.grey800),
        dialTextColor: isDarkTheme ? AppThemData.grey100 : AppThemData.grey800,
        hourMinuteTextColor: isDarkTheme ? AppThemData.grey100 : AppThemData.grey800,
        dayPeriodTextColor: isDarkTheme ? AppThemData.grey100 : AppThemData.grey800,
      ),
    );
  }
}
