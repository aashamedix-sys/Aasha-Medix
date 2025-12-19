import 'package:flutter/material.dart';
import '../services/locale_service.dart';

class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale('en');

  Locale get locale => _locale;

  LocaleProvider() {
    _loadSavedLocale();
  }

  Future<void> _loadSavedLocale() async {
    _locale = await LocaleService.getSavedLocale();
    notifyListeners();
  }

  Future<void> setLocale(Locale locale) async {
    if (_locale == locale) return;

    _locale = locale;
    await LocaleService.saveLocale(locale);
    notifyListeners();
  }

  String get currentLanguageName =>
      LocaleService.getLanguageName(_locale.languageCode);
}
