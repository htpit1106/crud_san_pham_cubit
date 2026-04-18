import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_demo/core/configs/app_configs.dart';
import 'package:login_demo/core/network/api_util.dart';
import 'package:login_demo/data/repositories/auth_repository.dart';
import 'package:login_demo/core/global/app_cubit.dart';
import 'package:login_demo/core/utils/utils.dart';
import 'core/theme/app_themes.dart';
import 'navigator/app_router.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    final apiClient = ApiUtil.apiClient;
    return MultiBlocProvider(
      providers: [
        BlocProvider<AppCubit>(create: (context) => AppCubit()),
        RepositoryProvider<AuthRepository>(
          create: (context) => AuthRepositoryImpl(apiClient: apiClient),
        ),
      ],
      child: GestureDetector(
        onTap: () {
          hideKeyboard(context);
        },
        child: MaterialApp.router(
          title: AppConfigs.appName,

          themeMode: ThemeMode.system,
          theme: AppThemes(isDarkMode: false).theme,
          darkTheme: AppThemes(isDarkMode: true).theme,
          routerConfig: AppRouter.router,
        ),
      ),
    );
  }
}
