import 'package:flutter/foundation.dart';

class AppProvider extends ChangeNotifier {
  bool _isDarkMode = true; // Default to dark theme as requested
  String _defaultOutputFormat = 'png';
  int _defaultQuality = 90;
  bool _autoSavePreset = false;

  bool get isDarkMode => _isDarkMode;
  String get defaultOutputFormat => _defaultOutputFormat;
  int get defaultQuality => _defaultQuality;
  bool get autoSavePreset => _autoSavePreset;

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
}
