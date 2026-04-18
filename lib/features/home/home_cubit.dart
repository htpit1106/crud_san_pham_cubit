import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_demo/core/global/app_cubit.dart';
import 'package:login_demo/data/database/secure_storage_helper.dart';
import 'package:login_demo/data/repositories/auth_repository.dart';
import 'package:login_demo/features/home/home_navigator.dart';
import 'package:login_demo/navigator/app_router.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeNavigator navigator;
  final AppCubit appCubit;
  final AuthRepository authRepository;
  HomeCubit({
    required this.navigator,
    required this.appCubit,
    required this.authRepository,
  }) : super(HomeState());

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
    authRepository.getProducts();
  }
}
