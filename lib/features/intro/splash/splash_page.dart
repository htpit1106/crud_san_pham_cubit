import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_demo/core/constants/asset_constants.dart';
import 'package:login_demo/features/intro/splash/splash_cubit.dart';
import 'package:login_demo/features/intro/splash/splash_navigator.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SplashCubit>(
      create: (context) => SplashCubit(
        navigator: SplashNavigator(context: context),
        authRepository: context.read(),
        appCubit: context.read(),
      ),
      child: SplashPageChild(),
    );
  }
}

class SplashPageChild extends StatefulWidget {
  const SplashPageChild({super.key});

  @override
  State<SplashPageChild> createState() => _SplashPageChildState();
}

class _SplashPageChildState extends State<SplashPageChild> {
  late final SplashCubit _cubit;

  @override
  void initState() {
    _cubit = context.read<SplashCubit>();
    _cubit.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(AssetConstants.splashAnimate, fit: BoxFit.cover),
      ),
    );
  }
}
