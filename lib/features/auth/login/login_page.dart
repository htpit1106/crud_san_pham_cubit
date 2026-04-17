import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_demo/core/constants/asset_constants.dart';
import 'package:login_demo/core/extensions/num_extension.dart';
import 'package:login_demo/core/global/app_cubit.dart';
import 'package:login_demo/core/global/app_state.dart';
import 'package:login_demo/core/theme/app_colors.dart';
import 'package:login_demo/core/utils/validator_utils.dart';
import 'package:login_demo/core/widget/button/app_icon_text_button.dart';
import 'package:login_demo/core/widget/button/app_password_text_field.dart';
import 'package:login_demo/core/widget/button/app_text_field.dart';
import 'package:login_demo/core/widget/image/app_svg_image.dart';
import 'package:login_demo/core/widget/textfield/app_text_button.dart';
import 'package:login_demo/features/auth/login/login_navigator.dart';
import 'login_cubit.dart';
import 'login_state.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginCubit>(
      create: (context) => LoginCubit(
        authRepository: context.read(),
        navigator: LoginNavigator(context: context),
        appCubit: context.read(),
      ),
      child: LoginPageChild(),
    );
  }
}

class LoginPageChild extends StatefulWidget {
  const LoginPageChild({super.key});

  @override
  State<LoginPageChild> createState() => _LoginPageChildState();
}

class _LoginPageChildState extends State<LoginPageChild> {
  late final LoginCubit _cubit;

  @override
  void initState() {
    _cubit = context.read<LoginCubit>();
    _cubit.init();
    super.initState();
  }

  @override
  void dispose() {
    _cubit.accountController.dispose();
    _cubit.passwordController.dispose();
    _cubit.accountFocusNode.dispose();
    _cubit.passwordFocusNode.dispose();
    _cubit.obscureTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
      bottomNavigationBar: _buildGroupButton(),
    );
  }

  Widget _buildBody() {
    return Padding(padding: 16.paddingAll, child: _buiLoginForm());
  }

  Widget _buiLoginForm() {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) =>
          previous.isSubmit != current.isSubmit ||
          previous.loadLoginStatus != current.loadLoginStatus,
      builder: (context, state) {
        return SingleChildScrollView(
          child: AutofillGroup(
            child: Form(
              key: _cubit.loginFormKey,
              child: Column(
                spacing: 24,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  76.height,
                  _buildListInputForm(),
                  _buildButtonLogin(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildListInputForm() {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.isSubmit != current.isSubmit,
      builder: (context, state) {
        return Column(
          children: [
            AppSvgImage(AssetConstants.logoApp),
            AppTextField(
              focusNode: _cubit.accountFocusNode,
              controller: _cubit.accountController,
              labelText: "Tài khoản",
              hintText: "Tài khoản",
              validator: (value) => ValidatorUtils.validateRequiredField(
                value,
                title: "Tài khoản",
              ),
              autovalidateMode: state.isSubmit
                  ? AutovalidateMode.always
                  : AutovalidateMode.disabled,

              textInputAction: TextInputAction.next,
              onSubmitted: (_) {
                FocusScope.of(context).requestFocus(_cubit.passwordFocusNode);
              },
            ),
            AppPasswordTextField(
              focusNode: _cubit.passwordFocusNode,
              controller: _cubit.passwordController,
              obscureTextController: _cubit.obscureTextController,
              labelText: "Mật khẩu",
              hintText: "Mật khẩu",
              validator: (value) => ValidatorUtils.validatePassword(value),
              enableSuffixIcon: true,
              autofillHints: [AutofillHints.password],
              autovalidateMode: state.isSubmit
                  ? AutovalidateMode.always
                  : AutovalidateMode.disabled,

              textInputAction: TextInputAction.done,
              onSubmitted: () {
                _handleLoginPressed();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildButtonLogin() {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) =>
          previous.loadLoginStatus != current.loadLoginStatus,
      builder: (context, state) {
        return Row(
          children: [
            Expanded(
              child: AppTextButton(
                title: "Đăng nhâp",
                onTap: () {
                  _handleLoginPressed();
                },
              ),
            ),
            InkWell(
              onTap: () {},
              child: BlocBuilder<AppCubit, AppState>(
                buildWhen: (previous, current) =>
                    previous.onBiometric != current.onBiometric,
                builder: (c, s) {
                  return AppSvgImage(
                    AssetConstants.fingerPrint,
                    color: s.onBiometric ? AppColors.primary : AppColors.border,
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  void _handleLoginPressed() {
    _unfocusTextField();
  }

  void _unfocusTextField() {
    _cubit.accountFocusNode.unfocus();
    _cubit.passwordFocusNode.unfocus();
  }

  Widget _buildGroupButton() {
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(horizontal: 16, vertical: 21),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        spacing: 8,
        children: [
          AppIconTextButton(),
          AppIconTextButton(iconPath: AssetConstants.facebook, label: "Group"),
          AppIconTextButton(iconPath: AssetConstants.search, label: "Tra cứu"),
        ],
      ),
    );
  }
}
