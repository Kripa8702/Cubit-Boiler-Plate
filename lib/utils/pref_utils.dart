import 'dart:convert';

import 'package:cubit_boiler_plate/utils/colored_logs.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrefUtils {
  static SharedPreferences? _sharedPreferences;

  Future<void> init() async {
    _sharedPreferences ??= await SharedPreferences.getInstance();
    ColoredLogs.success('::::::::::::::::::::: SharedPreference Initialized :::::::::::::::::::::');
  }

  ///will clear all the data stored in preference
  Future<void> clearPreferencesData() async {
    await _sharedPreferences!.clear();
  }
  /// will remove specific item from preference
  removeItem(String key) async {
    await _sharedPreferences!.remove(key);
  }

  /// get functions
  String? getString(String key) {
    return _sharedPreferences!.getString(key);
  }

  bool? getBool(String key) {
    return _sharedPreferences!.getBool(key);
  }

  Map<String, dynamic> getMapValue(String key) {
    final value = _sharedPreferences!.getString(key);
    if (value != null) {
      return jsonDecode(value) as Map<String, dynamic>;
    }
    return {};
  }

  /// set functions
  Future<void> setBool({required String key, required bool value}) async {
    await _sharedPreferences!.setBool(key, value);
  }

  Future<void> setString({required String key, required String value}) async {
    await _sharedPreferences!.setString(key, value);
  }

  Future<void> setMapValue(
      {required String key, required Map<String, dynamic> value}) async {
    await _sharedPreferences!.setString(key, jsonEncode(value));
  }
}
