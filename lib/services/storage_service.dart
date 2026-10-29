import 'package:shared_preferences/shared_preferences.dart';
import 'package:kaam_fast/utils/constants/shared_preferences_key.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  Future<SharedPreferences> get _safePrefs async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  // Token
  Future<void> setToken(String token) async {
    final p = await _safePrefs;
    await p.setString(SharedPreferencesKey.token, token);
  }

  Future<String?> getToken() async {
    final p = await _safePrefs;
    return p.getString(SharedPreferencesKey.token);
  }

  // Role
  Future<void> setRole(String role) async {
    final p = await _safePrefs;
    await p.setString(SharedPreferencesKey.userRole, role);
  }

  Future<String> getRole() async {
    final p = await _safePrefs;
    return p.getString(SharedPreferencesKey.userRole) ?? 'customer';
  }

  // Phone
  Future<void> setPhone(String phone) async {
    final p = await _safePrefs;
    await p.setString(SharedPreferencesKey.userPhone, phone);
  }

  Future<String?> getPhone() async {
    final p = await _safePrefs;
    return p.getString(SharedPreferencesKey.userPhone);
  }

  // Duty
  Future<void> setDuty(bool onDuty) async {
    final p = await _safePrefs;
    await p.setBool(SharedPreferencesKey.isDutyOn, onDuty);
  }

  Future<bool> getDuty() async {
    final p = await _safePrefs;
    return p.getBool(SharedPreferencesKey.isDutyOn) ?? false;
  }

  // Logout / Clear
  Future<void> clearSession() async {
    final p = await _safePrefs;
    await p.remove(SharedPreferencesKey.token);
    await p.remove(SharedPreferencesKey.userId);
    await p.remove(SharedPreferencesKey.userName);
    await p.remove(SharedPreferencesKey.isDutyOn);
  }
}
