import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/setting.dart';

ValueNotifier<Setting> setting =  ValueNotifier( Setting());
ValueNotifier<String> currentRoute =  ValueNotifier('Pages');

final languageProvider = ChangeNotifierProvider<LanguageProvider>((ref) {
  return LanguageProvider();
});

class LanguageProvider with ChangeNotifier {
  late String language;

  SettingsProvider() {
    getDefaultLanguage('it');
  }

  setDefaultLanguage(String language) async {
    if (language != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('language', language);
      language = language;
      notifyListeners();
    }
  }

  getDefaultLanguage(String defaultLanguage) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('language')) {
      defaultLanguage = prefs.get('language') as String;
    }
    language = defaultLanguage;
    notifyListeners();
  }
}
