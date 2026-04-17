import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:login_demo/data/model/entities/account_entity.dart';

class SecureStorageHelper {
  static const _accesSession = 'access_session';
  static const _userInfo = "user_info";
  static const _accessToken = 'access_token';
  late final FlutterSecureStorage _storage;

  SecureStorageHelper._(this._storage);

  static final SecureStorageHelper _instance = SecureStorageHelper._(
    const FlutterSecureStorage(),
  );

  static SecureStorageHelper get instance => _instance;

  void refreshStorage() {
    clearSession();
    clearUserInfo();
  }

  // save userInfo
  Future<void> saveUserInfo(Map<String, dynamic> userInfo) async {
    await _storage.write(key: _userInfo, value: jsonEncode(userInfo));
  }

  // get userInfo
  Future<AccountEntity?> getUserInfo() async {
    final value = await _storage.read(key: _userInfo);
    return value != null ? AccountEntity.fromJson(jsonDecode(value)) : null;
  }

  // clear
  Future<void> clearUserInfo() async {
    await _storage.delete(key: _userInfo);
  } 

  Future<void> saveAccessToken({
    required String username,
    required String sessionToken,
    bool isBiometric = false,
  }) async {
    final data = {
      "username": username,
      "sessionToken": sessionToken,
      "loginTime": DateTime.now().millisecondsSinceEpoch,
      "isBiometric": isBiometric,
    };
    await _storage.write(key: _accesSession, value: jsonEncode(data));
  }

  // update biometric
  Future<void> updateBiometric(bool isBiometric) async {
    final session = await getSessionToken();
    if (session == null) return;

    final updated = {...session, "isBiometric": isBiometric};

    await _storage.write(key: _accesSession, value: jsonEncode(updated));
  }

  Future<Map<String, dynamic>?> getSessionToken() async {
    final value = await _storage.read(key: _accesSession);
    if (value != null) {
      return jsonDecode(value);
    }
    return null;
  }

  Future<void> clearSession() async {
    await _storage.delete(key: _accesSession);
  }

  Future<String?> getToken() async {
    final token = await _storage.read(key: _accessToken);
    if (token != null) {
      return token;
    }
    return null;
  }
}
