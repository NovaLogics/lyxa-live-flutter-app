import 'package:hive/hive.dart';
import 'package:lyxa_live/src/core/constants/constants.dart';

class HiveKeys {
  static const loginDataKey = 'login_data';
  static const signUpDataKey = 'sign_up_data';
  static const usernameKey = 'username';
  static const emailKey = 'email';
}

class HiveStorage {
  static final HiveStorage _instance = HiveStorage._internal();
  late Box _box;

  HiveStorage._internal();

  factory HiveStorage() {
    return _instance;
  }

  /// Initialize Hive and open the box
  Future<void> initialize() async {
    _box = await Hive.openBox(hiveBoxLyxa);
    deleteLoginData();
  }

  void deleteLoginData() {
    delete(HiveKeys.loginDataKey);
    delete(HiveKeys.signUpDataKey);
  }

  /// Save a value
  Future<void> save<T>(String key, T value) async {
    await _box.put(key, value);
  }

  /// Retrieve a value
  T? get<T>(String key) {
    return _box.get(key) as T?;
  }

  T getValue<T>(String key, T defaultValue) {
    final value = _box.get(key);
    if (value == null) {
      return defaultValue;
    }
    return value as T;
  }

  /// Delete a key
  Future<void> delete(String key) async {
    await _box.delete(key);
  }

  /// Check if a key exists
  bool contains(String key) {
    return _box.containsKey(key);
  }

  /// Clear all data
  Future<void> clear() async {
    await _box.clear();
  }
}
