import 'package:hive/hive.dart';
import 'package:lyxa_live/src/core/utils/constants/constants.dart';

class HiveKeys {
  static const loginDataKey = 'login_data';
  static const signUpDataKey = 'sign_up_data';
  static const usernameKey = 'username';
  static const emailKey = 'email';
}

class HiveHelper {
  static final HiveHelper _instance = HiveHelper._internal();
  late Box _box;

  HiveHelper._internal();

  factory HiveHelper() {
    return _instance;
  }

  /// Initialize Hive and open the box
  Future<void> initialize() async {
    _box = await Hive.openBox(HIVE_BOX_LYXA);
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
