import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:login_demo/data/model/entities/account_entity.dart';

class FirestoreService {
  FirestoreService._privateConstructor();

  // Singleton instance.
  static final FirestoreService _instance =
      FirestoreService._privateConstructor();

  // Factory constructor returns the singleton instance.
  factory FirestoreService() {
    return _instance;
  }

  static FirestoreService get instance => _instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createAccount(AccountEntity account) async {
    try {
      await _firestore
          .collection('accounts')
          .doc(account.taxIdOrId)
          .set(account.toJson());
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<AccountEntity?> getAccountByTaxIdOrId(String taxIdOrId) async {
    try {
      final account = await _firestore
          .collection('accounts')
          .doc(taxIdOrId)
          .get();
      return AccountEntity.fromJson(account.data() as Map<String, dynamic>);
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<List<AccountEntity>?> getListAccounts() async {
    try {
      final accounts = await _firestore.collection('accounts').get();
      return accounts.docs
          .map((e) => AccountEntity.fromJson(e.data()))
          .toList();
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<void> lockOrUnlockUser(
    String taxIdOrId, {
    required bool enable,
  }) async {
    try {
      if (enable) {
        await _firestore.collection('accounts').doc(taxIdOrId).update({
          'enable': true,
          'failed_login_count': 0,
          'lock_until': null,
        });
        return;
      }
      final lockUntil = DateTime.now().toUtc().add(const Duration(seconds: 5));

      await _firestore.collection('accounts').doc(taxIdOrId).update({
        'enable': false,
        'lock_until': lockUntil.toIso8601String(),
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
