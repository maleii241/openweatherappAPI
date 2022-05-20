import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {

  //values for imperial
  static final String _kLocation = "location_key";
  static final String _kLocationQuery = "location_query_key";
  static final String _kCacheWeatherData = "cache_weather_key";
  static final String _kCacheForecastData = "cache_forecast_key";
  static final String _kExpiration = "exp_key";

  static final int twelveHours = 3600 * 1000 * 12;
  static const String imperialKey = "useImperial";
  Future<SharedPreferences> _preferences = SharedPreferences.getInstance();

  static Future<bool> getImperial() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //if value is none return false
    bool value = prefs.getBool(imperialKey) ?? false;
    return value;
  }

  static Future<void> setImperial(bool newValue) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(imperialKey, newValue);
  }

  //values  for dark mode

  static const String darkKey = "useDarkMode";

  static Future<bool> getDark() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //if value is none return false
    bool value = prefs.getBool(darkKey) ?? false;
    return value;
  }

  static Future<void> setDark(bool newValue) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(darkKey, newValue);
  }

  //values for 24h time

  static const String h24key = "use24h";

  static Future<bool> get24() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //if value is none return false
    bool value = prefs.getBool(h24key) ?? true;
    return value;
  }

  static Future<void> set24(bool newValue) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(h24key, newValue);
  }


  //values for wind unit

  static const String windKey = "windUnit";

  static Future<WindUnit> getWindUnit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    WindUnit unit = WindUnit.values[prefs.getInt(windKey) ?? 0];
    return unit;
  }

  static Future<void> setWindUnit(WindUnit unit) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(windKey, unit.index);
    print(unit.toString());
  }


  //values for language

  static const String langKey = "languageCode";

  static Future<String> getLanguageCode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String code = prefs.getString(langKey) ?? "en";
    return code;
  }

  static Future<void> setLanguageCode(String code) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(langKey, code);
    print(code.toString());
  }




  //values for custom owm api key

  static const String owmKey = "openWeatherKey";

  static Future<String> getOpenWeatherAPIKey() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String code = prefs.getString(owmKey) ?? "";
    return code;
  }

  static Future<void> setOpenWeatherAPIKey(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(owmKey, key);
    print(key.toString());
  }

  //values for custom owm api key

  static const String disclaimerRead = "discRead";

  static Future<bool> getDisclaimerRead() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool code = prefs.getBool(disclaimerRead) ?? 0;
    return code;
  }

  static Future<void> setDisclaimerRead(bool key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(disclaimerRead, key);
    print(key.toString());
  }


  static const String defaultLocationKey = "defaultLocationKey";

  static Future<List> getDefaultLocation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> location = prefs.getStringList(defaultLocationKey);

    if (location != null) {
      return [location[0], double.parse(location[1]), double.parse(location[2])];
    }
    return ["Use a default location on app startup."];
  }

  static Future<void> setDefaultLocation({String text, double lat, double long}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(defaultLocationKey, [text, lat.toString(), long.toString()]);
  }

  static Future<void> removeDefaultLocation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(defaultLocationKey);
  }

  /// Gets the location preference from the shared preferences
  Future<int> getLocationPreference() async {
    final SharedPreferences preferences = await _preferences;
    return preferences.get(_kLocation);
  }

  /// Sets the location preference and store it in the shared preferences
  Future<bool> setLocationPreference(int value) async {
    final SharedPreferences preferences = await _preferences;
    return preferences.setInt(_kLocation, value);
  }

  /// Gets the location query preference from the shared preferences to be passed
  /// to the openweathermap.org API
  Future<String> getLocationQuery() async {
    final SharedPreferences preferences = await _preferences;
    return preferences.get(_kLocationQuery);
  }

  /// Sets the location query preference and store it in the shared preferences
  Future<bool> setLocationQuery(String value) async {
    final SharedPreferences preferences = await _preferences;
    return preferences.setString(_kLocationQuery, value);
  }

  /// Parses the latitude value from the query parameter passed to the API
  /// [query] parameter has a value like "lat=21.879610&lon=-102.295227"
  String parseLatitude(String query) {
    final int endIndex = query.indexOf("&");
    if (endIndex != -1) {
      return query.substring(4, endIndex);
    }
    return "";
  }

  /// Parses the longitude value from the query parameter passed to the API
  /// [query] parameter has a value like "lat=21.879610&lon=-102.295227"
  String parseLongitude(String query) {
    final int startIndex = query.indexOf("lon=") + 4;
    if (startIndex != -1) {
      return query.substring(startIndex);
    }
    return "";
  }

  /// Parses the location name value from the query parameter passed to the API
  /// [query] parameter has a value like "q=Aguascalientes"
  String parseCity(String query) {
    final int startIndex = query.indexOf("q=") + 2;
    if (startIndex != -1) {
      return query.substring(startIndex);
    }
    return "";
  }

  /// Caches the server response from the API and store it in a shared preference
  /// as well as the expiration time which is 12 hours from the current timestamp.
  Future<bool> cacheWeatherData(String data) async {
    final SharedPreferences preferences = await _preferences;
    preferences.setInt(_kExpiration, DateTime.now().millisecondsSinceEpoch + twelveHours);
    return preferences.setString(_kCacheWeatherData, data);
  }

  /// Returns the weather json data stored in the shared preference, or *null*
  /// if the cache has expired.
  Future<String> getWeatherFromCache() async {
    final SharedPreferences preferences = await _preferences;
    final int expiration = preferences.get(_kExpiration) ?? null;
    if (expiration == null || expiration < DateTime.now().millisecondsSinceEpoch) {
      preferences.remove(_kExpiration);
      preferences.remove(_kCacheWeatherData);
    }
    return preferences.get(_kCacheWeatherData);
  }

  /// Caches the server response from the API and store it in a shared preference
  /// as well as the expiration time which is 12 hours from the current timestamp.
  Future<bool> cacheForecastData(String data) async {
    final SharedPreferences preferences = await _preferences;
    preferences.setInt(_kExpiration, DateTime.now().millisecondsSinceEpoch + twelveHours);
    return preferences.setString(_kCacheForecastData, data);
  }

  /// Returns the forecast json data stored in the shared preference, or *null*
  /// if the cache has expired.
  Future<String> getForecastFromCache() async {
    final SharedPreferences preferences = await _preferences;
    final int expiration = preferences.get(_kExpiration) ?? null;
    if (expiration == null || expiration < DateTime.now().millisecondsSinceEpoch) {
      preferences.remove(_kExpiration);
      preferences.remove(_kCacheForecastData);
    }
    return preferences.get(_kCacheForecastData);
  }
}




enum WindUnit {
  MS,
  MPH,
  KMPH,
}