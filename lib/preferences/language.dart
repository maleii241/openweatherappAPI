import 'package:flutter_weather/preferences/shared_prefs.dart';
import 'package:flutter_weather/localization.dart';

class Language {

  static Map<String, String> _langCodes = {

    'ru': 'Russian',
    'en': 'English',

  };

  static String _currentLangCode;


  static Future<void> initialise() async {
    _currentLangCode = await SharedPrefs.getLanguageCode();
  }

  static void changeLangCode(String code) {
    _currentLangCode = code;
    SharedPrefs.setLanguageCode(code);
  }
  
  
  
  

  static String getLangString(String code) {
    return _langCodes[code];
    //returns the displayed name of the language code
  }
  
  static String getCurrentCode() {
    return _currentLangCode;
  }

  static List<String> langaugeCodes() {
    //returns all the keys of langCodes
    return _langCodes.keys.toList();
  }

  static String getTranslation(String key) {
    //returns the translation of the value of the key in localizations.dart

    return localizedValues[_currentLangCode][key] ?? "ERROR: $_currentLangCode, '$key'";
  }
}
