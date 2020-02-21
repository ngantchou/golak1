import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class I18nNotifier with ChangeNotifier {
  bool get rtl => currentLang == 'ar' || currentLang == 'ur';

  String currentLang;
  init() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    currentLang = prefs.getString('currentLang') ?? 'en';
    notifyListeners();
  }

  changeLanguage(context, lang) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (lang != null) {
      await FlutterI18n.refresh(context, Locale(lang));
      currentLang = lang;
      prefs.setString('currentLang', lang);
    } else {
      await FlutterI18n.refresh(
          context, Locale(prefs.getString('currentLang') ?? 'en'));
    }
    notifyListeners();
  }
}
