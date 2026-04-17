import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_demo/core/global/app_cubit.dart';
import 'package:login_demo/core/services/biometric_service.dart';
import 'package:login_demo/data/database/secure_storage_helper.dart';
import 'package:login_demo/data/model/enums/biometric_status.dart';
import 'package:login_demo/features/home/home_navigator.dart';
import 'package:login_demo/navigator/app_router.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeNavigator navigator;
  final AppCubit appCubit;
  HomeCubit({required this.navigator, required this.appCubit})
    : super(HomeState());

  void init() {
    getUserInfo();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      navigator.flushbarNavigator.showSuccess(message: "Đăng nhập thành công");
    });
  }

  void getUserInfo() async {
    final userInfo = await SecureStorageHelper.instance.getUserInfo();
    emit(state.copyWith(userInfo: userInfo));
  }

  void handleLogout() async {
    await navigator.appDialog.show(
      message: "Bạn có muốn đăng xuất không?",
      textConfirm: "Đăng xuất",
      textCancel: "Huỷ",
      onConfirm: () {
        // SecureStorageHelper.instance.refreshStorage();
        // emit(state.copyWith(userInfo: null));
        AppRouter.markUnauthenticated();
      },
      onCancel: () {
        navigator.navigateBack();
      },
    );
  }

  void onPressFingerPrint() async {
    final isEnabled = appCubit.state.onBiometric;

    await navigator.appDialog.show(
      message: isEnabled
          ? "Bạn có muốn tắt đăng nhập bằng vân tay không?"
          : "Bạn có muốn bật đăng nhập bằng vân tay không?",
      textConfirm: isEnabled ? "Tắt" : "Bật",
      textCancel: "Huỷ",
      onConfirm: () async {
        navigator.navigateBack();

        if (isEnabled) {
          SecureStorageHelper.instance.updateBiometric(false);
          appCubit.setOnBiometric(false);

          WidgetsBinding.instance.addPostFrameCallback((_) {
            navigator.flushbarNavigator.showSuccess(
              message: "Đã tắt đăng nhập bằng vân tay",
            );
          });
        } else {
          final isAuthenticated = await BiometricService.instance
              .authenticate();

          // map  error
          if (isAuthenticated != BiometricStatus.success) {
            navigator.flushbarNavigator.showError(
              message: isAuthenticated.message,
            );
            return;
          }
          SecureStorageHelper.instance.updateBiometric(true);
          appCubit.setOnBiometric(true);

          WidgetsBinding.instance.addPostFrameCallback((_) {
            navigator.flushbarNavigator.showSuccess(
              message: "Bật đăng nhập bằng vân tay thành công",
            );
          });
        }
      },
      onCancel: () {
        navigator.navigateBack();
      },
    );
  }
}
