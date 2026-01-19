import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppProvider extends ChangeNotifier {
  bool _isDarkMode = true; // Default to dark theme as requested
  String _defaultOutputFormat = 'png';
  int _defaultQuality = 90;
  bool _autoSavePreset = false;
  Locale _locale = const Locale('en'); // Default to English

  bool get isDarkMode => _isDarkMode;
  String get defaultOutputFormat => _defaultOutputFormat;
  int get defaultQuality => _defaultQuality;
  bool get autoSavePreset => _autoSavePreset;
  Locale get locale => _locale;
  String get currentLanguageCode => _locale.languageCode;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  void setDefaultOutputFormat(String format) {
    _defaultOutputFormat = format;
    notifyListeners();
  }

  void setDefaultQuality(int quality) {
    _defaultQuality = quality;
    notifyListeners();
  }

  void setAutoSavePreset(bool value) {
    _autoSavePreset = value;
    notifyListeners();
  }

  void setLocale(Locale locale) {
    _locale = locale;
    notifyListeners();
  }

  void setLanguage(String languageCode) {
    _locale = Locale(languageCode);
    notifyListeners();
  }
}
