import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_demo/core/global/app_cubit.dart';
import 'package:login_demo/core/services/biometric_service.dart';
import 'package:login_demo/data/database/hive_helper.dart';
import 'package:login_demo/data/database/secure_storage_helper.dart';
import 'package:login_demo/data/model/entities/account_entity.dart';
import 'package:login_demo/data/model/enums/biometric_status.dart';
import 'package:login_demo/data/model/enums/load_status.dart';
import 'package:login_demo/data/model/enums/login_status.dart';
import 'package:login_demo/data/repositories/auth_repository.dart';
import 'package:login_demo/core/utils/utils.dart';
import 'package:login_demo/core/widget/button/app_password_text_field.dart';
import 'package:login_demo/features/auth/login/login_navigator.dart';
import 'package:login_demo/features/auth/login/login_state.dart';
import 'package:login_demo/navigator/app_router.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository authRepository;
  final LoginNavigator navigator;
  final AppCubit appCubit;
  LoginCubit({
    required this.authRepository,
    required this.navigator,
    required this.appCubit,
  }) : super(const LoginState());
  final loginFormKey = GlobalKey<FormState>();
  final TextEditingController mstController = TextEditingController();
  final TextEditingController accountController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final ObscureTextController obscureTextController = ObscureTextController();
  final FocusNode mstFocusNode = FocusNode();
  final FocusNode accountFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();

  void init() {
    // createAccount();
  }

  void createAccount() {
    final salt = generateSalt();
    final account = AccountEntity(
      taxIdOrId: "0105987432-098",
      username: "demo",
      passwordHash: hashPassword("123456", salt),
      salt: salt,
      fullName: "Demo User",
      enable: true,
      updateAt: DateTime.now(),
    );

    authRepository.createAccount(account);
  }

  void isSubmitted() {
    if (state.isSubmit) return;
    emit(state.copyWith(isSubmit: true));
  }

  Future<void> onSubmit() async {
    if (state.loadLoginStatus == LoadStatus.loading) return;

    emit(state.copyWith(loadLoginStatus: LoadStatus.loading));

    final result = await authRepository.loginByTaxId(
      taxIdOrId: mstController.text,
      password: passwordController.text,
      username: accountController.text,
    );

    switch (result?.status) {
      case LoginStatus.success:
        emit(state.copyWith(loginStatus: LoginStatus.success));
        _handleSuccess(result!.account!);
        break;

      case LoginStatus.invalid:
        await _handleInvalidLogin(result!.account!);
        _showError("Thông tin đăng nhập không hợp lệ");
        break;

      case LoginStatus.locked:
        _showError("Tài khoản đã bị khóa");
        break;

      case LoginStatus.notFound:
        _showError("Tài khoản không tồn tại");
        break;

      case LoginStatus.noInternet:
        _showError("Không có internet");
        break;
      default:
        _showError("Đã có lỗi xảy ra");
    }
  }

  void _showError(String message) {
    navigator.flushbarNavigator.showError(message: message);
    emit(state.copyWith(loadLoginStatus: LoadStatus.failure));
  }

  Future<void> _handleInvalidLogin(AccountEntity account) async {
    await _increaseFailedCount(account);
  }

  Future<void> _increaseFailedCount(AccountEntity account) async {
    final newCount = (account.failedLoginCount ?? 0) + 1;
    final updatedAccount = account.copyWith(failedLoginCount: newCount);
    await HiveHelper.instance.saveAccount(updatedAccount);
    if (newCount >= 5) {
      authRepository.lockUser(account.taxIdOrId!);
      emit(state.copyWith(isLoginCountLimit: true));
    }
  }

  void _handleSuccess(AccountEntity account) {
    final sessionToken = generateSessionToken(account.username!);

    SecureStorageHelper.instance.saveAccessToken(
      username: account.username!,
      sessionToken: sessionToken,
    );

    navigator.flushbarNavigator.showSuccess(message: "Đăng nhập thành công");

    AppRouter.markAuthenticated();
    emit(state.copyWith(loadLoginStatus: LoadStatus.success));
    navigator.openHome();
  }

  Future<void> loginWithBiometrics() async {
    final onBiometricLogin = await checkOnBiometricLogin();
    if (!onBiometricLogin) {
      appCubit.setOnBiometric(false);
      AppRouter.markUnauthenticated();
      navigator.openLoginPage();
      _showError("Đăng nhập để bật xác thực sinh chắc học");
      return;
    } else {
      final result = await BiometricService.instance.authenticate();

      if (result == BiometricStatus.success) {
        AppRouter.markAuthenticated();
        navigator.openHome();
      } else {
        AppRouter.markUnauthenticated();
        _showError(result.message);
      }
    }
  }

  Future<bool> checkOnBiometricLogin() async {
    final accessToken = await SecureStorageHelper.instance.getAccessToken();
    if (accessToken != null &&
        accessToken["isBiometric"] == true &&
        accessToken["sessionToken"] != null) {
      return true;
    }
    return false;
  }
}
