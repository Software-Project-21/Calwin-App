import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

Color kLight = Color(0xffe8e8e8);
Color kRed = Color(0xfff05454);
Color kGrey = Color(0xff30475e);
Color kDark = Color(0xff222831);
ThemeData light = ThemeData(
  primaryColor: kLight,
  accentColor: Color.fromRGBO(50, 50, 50, 1.0),
  primaryTextTheme: TextTheme(
    // Section Headings
    headline1: GoogleFonts.montserrat(
        color: kGrey, fontSize: 30, fontWeight: FontWeight.bold),
    headline2: GoogleFonts.montserrat(
        color: kGrey, fontSize: 22, fontWeight: FontWeight.bold),
    // List Font
    bodyText1: GoogleFonts.montserrat(color: kGrey, fontSize: 16),
  ),
);

ThemeData dark = ThemeData(
    primaryColor: kDark,
    accentColor: Color.fromRGBO(200, 200, 200, 1),
    dividerColor: Color.fromRGBO(200, 200, 200, 0.1),
    primaryTextTheme: TextTheme(
      // Section Headings
      headline1: GoogleFonts.montserrat(
          color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
      headline2: GoogleFonts.montserrat(
          color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
      // List Font
      bodyText1: GoogleFonts.montserrat(color: Colors.white, fontSize: 16),
    ));

class ThemeNotifier extends ChangeNotifier {
  final String key = "theme";
  SharedPreferences _prefs;
  bool _isDarkTheme;

  bool get isDarkTheme => _isDarkTheme;

  ThemeNotifier() {
    _isDarkTheme = false;
    _getThemPref();
  }

  // Switch theme
  toggleTheme() {
    _isDarkTheme = !_isDarkTheme;
    _setThemePrefs();
    notifyListeners();
  }

  // Get saved theme preference
  _getThemPref() async {
    await _initPrefs();
    _isDarkTheme = _prefs.getBool(key) ?? false;
    notifyListeners();
  }

  // Set theme preference
  _setThemePrefs() async {
    await _initPrefs();
    _prefs.setBool(key, _isDarkTheme);
  }

  // Initiate a preference
  _initPrefs() async {
    if (_prefs == null) {
      _prefs = await SharedPreferences.getInstance();
    }
  }
}
