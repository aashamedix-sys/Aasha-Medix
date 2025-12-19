import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleService {
  static const String _localeKey = 'selected_locale';

  static Future<Locale> getSavedLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final localeString = prefs.getString(_localeKey) ?? 'en';
    return _getLocaleFromString(localeString);
  }

  static Future<void> saveLocale(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeKey, locale.languageCode);
  }

  static Locale _getLocaleFromString(String localeString) {
    switch (localeString) {
      case 'te':
        return const Locale('te');
      case 'hi':
        return const Locale('hi');
      case 'en':
      default:
        return const Locale('en');
    }
  }

  static String getLanguageName(String code) {
    switch (code) {
      case 'te':
        return 'తెలుగు';
      case 'hi':
        return 'हिंदी';
      case 'en':
      default:
        return 'English';
    }
  }
}
