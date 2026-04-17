import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:login_demo/core/configs/app_configs.dart';
import 'package:login_demo/data/model/entities/account_entity.dart';

class HiveHelper {
  HiveHelper._();

  static final HiveHelper _instance = HiveHelper._();

  static HiveHelper get instance => _instance;

  Box? _box;
  final String _boxName = AppConfigs.hiveBoxName;
  Future<void> init() async {
    try {
      _box = await Hive.openBox(_boxName);
    } catch (e) {
      log('Hive init error: $e');
    }
  }

  Box get box {
    if (_box == null || !_box!.isOpen) {
      throw Exception("Hive chưa được init.");
    }
    return _box!;
  }

  Future<void> saveAccounts(List<AccountEntity>? accounts) async {
    try {
      if (accounts == null) return;
      final map = {for (var acc in accounts) acc.taxIdOrId: acc.toJson()};

      await box.putAll(map);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> saveAccount(AccountEntity account) async {
    try {
      await box.put(account.taxIdOrId, account.toJson());
    } catch (e) {
      log(e.toString());
    }
  }

  Future<AccountEntity?> getAccount(String taxIdOrId) async {
    try {
      final data = box.get(taxIdOrId);
      if (data == null) return null;
      return AccountEntity.fromJson(Map<String, dynamic>.from(data));
    } catch (e) {
      log('Hive getAccount error: $e');
      return null;
    }
  }

  Future<void> clear() async {
    try {
      await box.clear();
    } catch (e, st) {
      log('Hive clear error: $e', stackTrace: st);
    }
  }
}
