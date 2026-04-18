import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_demo/core/constants/asset_constants.dart';
import 'package:login_demo/core/global/app_cubit.dart';
import 'package:login_demo/core/global/app_state.dart';
import 'package:login_demo/core/theme/app_colors.dart';
import 'package:login_demo/core/theme/text_style.dart';
import 'package:login_demo/core/widget/image/app_svg_image.dart';
import 'package:login_demo/core/widget/textfield/app_text_button.dart';
import 'package:login_demo/features/home/home_navigator.dart';

import 'home_cubit.dart';
import 'home_state.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit(
        navigator: HomeNavigator(context: context),
        appCubit: context.read(),
        authRepository: context.read(),
      ),
      child: HomePageChild(),
    );
  }
}

class HomePageChild extends StatefulWidget {
  const HomePageChild({super.key});

  @override
  State<HomePageChild> createState() => _HomePageChildState();
}

class _HomePageChildState extends State<HomePageChild> {
  late final HomeCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = context.read<HomeCubit>();
    _cubit.init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _buildBody());
  }

  Widget _buildBody() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            child: BlocBuilder<HomeCubit, HomeState>(
              builder: (context, state) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      state.userInfo?.fullName ?? "unknow name",
                      style: AppTextStyle.black.s20.w700,
                    ),

                    const SizedBox(height: 8),

                    Text(
                      state.userInfo?.username ?? "unknow name",
                      style: AppTextStyle.hintStyle.s14.w400,
                    ),

                    const SizedBox(height: 24),
                    _buildButtonLogout(),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButtonLogout() {
    return BlocBuilder<AppCubit, AppState>(
      buildWhen: (previous, current) =>
          previous.onBiometric != current.onBiometric,
      builder: (context, state) {
        return SizedBox(
          width: double.infinity,
          child: Row(
            children: [
              Expanded(
                child: AppTextButton(
                  title: "Đăng xuất",
                  onTap: () {
                    _cubit.handleLogout();
                  },
                ),
              ),
              InkWell(
                onTap: () {
                  _cubit.onPressFingerPrint();
                },
                child: AppSvgImage(
                  AssetConstants.fingerPrint,
                  color: state.onBiometric == true
                      ? AppColors.primary
                      : AppColors.border,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
