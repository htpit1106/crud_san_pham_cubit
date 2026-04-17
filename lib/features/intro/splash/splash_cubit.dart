import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_demo/core/configs/app_configs.dart';
import 'package:login_demo/core/global/app_cubit.dart';
import 'package:login_demo/data/database/hive_helper.dart';
import 'package:login_demo/data/database/secure_storage_helper.dart';
import 'package:login_demo/data/repositories/auth_repository.dart';
import 'package:login_demo/core/utils/utils.dart';

import 'package:login_demo/features/intro/splash/splash_navigator.dart';
import 'package:login_demo/features/intro/splash/splash_state.dart';
import 'package:login_demo/navigator/app_router.dart';

class SplashCubit extends Cubit<SplashState> {
  DateTime? _showTime;
  final SplashNavigator navigator;
  final AuthRepository authRepository;
  final AppCubit appCubit;

  SplashCubit({
    required this.navigator,
    required this.authRepository,
    required this.appCubit,
  }) : super(SplashState());

  void init() {
    saveListAccountsToHive();
    autoLogin();
    checkOnBiometricLogin();
  }

  Future<void> autoLogin() async {
    // final isLoggedIn = await checkLogin();
    await _ensureMinSplashTime();
    // if (isLoggedIn) {
    //   AppRouter.markAuthenticated();
    //   navigator.openHome();
    // } else {
    AppRouter.markUnauthenticated();
    navigator.openLoginPage();
    // }
  }

  Future<bool> checkLogin() async {
    _showTime = DateTime.now();
    final accessToken = await SecureStorageHelper.instance.getAccessToken();
    if (accessToken != null) {
      return accessToken["sessionToken"] != null;
    }
    return false;
  }

  Future<void> _ensureMinSplashTime() async {
    final elapsed = DateTime.now().difference(_showTime ?? DateTime.now());
    const minDuration = AppConfigs.splashMinDisplayTime;
    if (elapsed < minDuration) {
      await Future.delayed(minDuration - elapsed);
    }
  }

  void saveListAccountsToHive() async {
    if (await checkInternetConnect() == false) return;
    final listAccount = await authRepository.getListAccount();
    HiveHelper.instance.saveAccounts(listAccount);
  }

  Future<void> checkOnBiometricLogin() async {
    final accessToken = await SecureStorageHelper.instance.getAccessToken();
    if (accessToken != null &&
        accessToken["isBiometric"] == true &&
        accessToken["sessionToken"] != null) {
      appCubit.setOnBiometric(true);
      return;
    }
    appCubit.setOnBiometric(false);
  }
}
