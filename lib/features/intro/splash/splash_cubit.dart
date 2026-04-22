import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_demo/core/configs/app_configs.dart';
import 'package:login_demo/core/global/app_cubit.dart';
import 'package:login_demo/data/database/secure_storage_helper.dart';
import 'package:login_demo/data/repositories/product_repository.dart';
import 'package:login_demo/features/intro/splash/splash_navigator.dart';
import 'package:login_demo/features/intro/splash/splash_state.dart';
import 'package:login_demo/navigator/app_router.dart';

class SplashCubit extends Cubit<SplashState> {
  DateTime? _showTime;
  final SplashNavigator navigator;
  final ProductRepository authRepository;
  final AppCubit appCubit;

  SplashCubit({
    required this.navigator,
    required this.authRepository,
    required this.appCubit,
  }) : super(SplashState());

  Future<void> init() async {
    await autoLogin();
  }

  Future<void> autoLogin() async {
    final isLoggedIn = await checkLogin();
    await _ensureMinSplashTime();
    if (isLoggedIn) {
      AppRouter.markAuthenticated();
      navigator.openHome();
    } else {
      AppRouter.markUnauthenticated();
      navigator.openLoginPage();
    }
  }

  Future<bool> checkLogin() async {
    _showTime = DateTime.now();
    final accessToken = await SecureStorageHelper.instance.getToken();
    return accessToken != null;
  }

  Future<void> _ensureMinSplashTime() async {
    final elapsed = DateTime.now().difference(_showTime ?? DateTime.now());
    const minDuration = AppConfigs.splashMinDisplayTime;
    if (elapsed < minDuration) {
      await Future.delayed(minDuration - elapsed);
    }
  }
}
