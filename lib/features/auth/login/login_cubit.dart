import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_demo/core/global/app_cubit.dart';
import 'package:login_demo/data/database/secure_storage_helper.dart';
import 'package:login_demo/data/model/enums/load_status.dart';
import 'package:login_demo/data/repositories/auth_repository.dart';
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
  final TextEditingController accountController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final ObscureTextController obscureTextController = ObscureTextController();
  final FocusNode accountFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();

  void init() {}
  Future<void> onSubmit() async {
    if (state.loadLoginStatus == LoadStatus.loading) return;
    emit(state.copyWith(loadLoginStatus: LoadStatus.loading));
    final result = await authRepository.login(
      accountController.text,
      passwordController.text,
    );

    result.fold(
      (failure) {
        emit(state.copyWith(loadLoginStatus: LoadStatus.failure));
        navigator.flushbarNavigator.showError(message: failure.message);
        AppRouter.markUnauthenticated();
      },
      (response) async {
        emit(state.copyWith(loadLoginStatus: LoadStatus.success));
        await SecureStorageHelper.instance.saveAccessToken(
          response.data?.accessToken,
        );
        AppRouter.markAuthenticated();
        navigator.openHome();
      },
    );
  }
}
