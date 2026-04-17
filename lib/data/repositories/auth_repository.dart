import 'package:login_demo/data/database/hive_helper.dart';
import 'package:login_demo/data/database/secure_storage_helper.dart';
import 'package:login_demo/data/model/entities/account_entity.dart';
import 'package:login_demo/data/model/enums/login_status.dart';
import 'package:login_demo/data/model/response/login_result.dart';
import 'package:login_demo/core/services/firebase_service.dart';
import 'package:login_demo/core/utils/utils.dart';

abstract class AuthRepository {
  Future<void> createAccount(AccountEntity account);

  Future<LoginResult?> loginByTaxId({
    required String taxIdOrId,
    required String password,
    required String username,
  });

  Future<List<AccountEntity>?> getListAccount();

  Future<void> lockUser(String taxIdOrId);
  Future<void> unlockUser(String taxIdOrId);
}

class AuthRepositoryImpl extends AuthRepository {
  final FirestoreService _firestoreService = FirestoreService.instance;

  @override
  Future<void> createAccount(AccountEntity account) async {
    try {
      await _firestoreService.createAccount(account);
      await SecureStorageHelper.instance.saveUserInfo(account.toJson());
    } catch (e) {
      // silent error handle
    }
  }

  @override
  Future<LoginResult?> loginByTaxId({
    required String taxIdOrId,
    required String password,
    required String username,
  }) async {
    try {
      final isOnline = await checkInternetConnect();
      AccountEntity? account;
      final now = DateTime.now();

      if (isOnline) {
        final remote = await _firestoreService.getAccountByTaxIdOrId(taxIdOrId);
        // if remote null => not found
        if (remote == null) {
          return LoginResult(LoginStatus.notFound);
        }

        final local = await HiveHelper.instance.getAccount(taxIdOrId);
        account = remote.copyWith(
          failedLoginCount: local?.failedLoginCount ?? 0,
        );
        await HiveHelper.instance.saveAccount(account);
      } else {
        account = await HiveHelper.instance.getAccount(taxIdOrId);
      }
      if (account == null) {
        return LoginResult(LoginStatus.noInternet);
      }

      // auto unlock when lock expired
      if (account.enable == false &&
          account.lockUntil != null &&
          !account.lockUntil!.isAfter(now)) {
        await unlockUser(account.taxIdOrId!);
        account = account.copyWith(
          enable: true,
          lockUntil: null,
          failedLoginCount: 0,
        );
        await HiveHelper.instance.saveAccount(account);
      }

      // check lock
      if (account.enable == false &&
          account.lockUntil != null &&
          account.lockUntil!.isAfter(now)) {
        return LoginResult(LoginStatus.locked, account: account);
      }
      // verify
      final hash = hashPassword(password, account.salt!);
      if (hash != account.passwordHash || username != account.username) {
        return LoginResult(LoginStatus.invalid, account: account);
      }
      return LoginResult(LoginStatus.success, account: account);
    } catch (e) {
      // silent error handle
    }
    return null;
  }

  @override
  Future<List<AccountEntity>?> getListAccount() async {
    try {
      final listAccount = await _firestoreService.getListAccounts();
      return listAccount;
    } catch (e) {
      // silent error handle
      return null;
    }
  }

  @override
  Future<void> lockUser(String taxIdOrId) async {
    try {
      await _firestoreService.lockOrUnlockUser(taxIdOrId, enable: false);
    } catch (e) {}
  }

  @override
  Future<void> unlockUser(String taxIdOrId) async {
    try {
      await _firestoreService.lockOrUnlockUser(taxIdOrId, enable: true);
    } catch (e) {}
  }
}
