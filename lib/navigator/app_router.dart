import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:login_demo/data/model/entities/product_entity.dart';
import 'package:login_demo/features/auth/login/login_page.dart';
import 'package:login_demo/features/home/add_product/add_product_page.dart';
import 'package:login_demo/features/home/home_page.dart';
import 'package:login_demo/features/intro/splash/splash_page.dart';

class AppRouter {
  static final navigationKey = GlobalKey<NavigatorState>();

  AppRouter._();

  static final ValueNotifier<_AuthStatus> _authStatusNotifier =
      ValueNotifier<_AuthStatus>(_AuthStatus.unknow);

  static void markAuthenticated() {
    _authStatusNotifier.value = _AuthStatus.authenticated;
  }

  static void markUnauthenticated() {
    _authStatusNotifier.value = _AuthStatus.unauthenticated;
  }

  static const String _splashPath = '/';
  static const String _loginPath = '/login';
  static const String _homePath = '/home';
  static const String _addProductPath = '/home/add_product';

  static const String splashRouteName = 'splash';
  static const String loginRouteName = 'login';
  static const String homeName = 'home';
  static const String addProductName = 'add_product';

  static final GoRouter router = GoRouter(
    debugLogDiagnostics: kDebugMode,
    initialLocation: _splashPath,
    navigatorKey: navigationKey,
    refreshListenable: _authStatusNotifier,
    redirect: (BuildContext context, GoRouterState state) async {
      final location = state.matchedLocation;

      if (_authStatusNotifier.value == _AuthStatus.unknow) {
        return _splashPath;
      }

      if (_authStatusNotifier.value == _AuthStatus.unauthenticated) {
        return location == _loginPath ? null : _loginPath;
      }

      if (_authStatusNotifier.value == _AuthStatus.authenticated) {
        if (location == _splashPath || location == _loginPath) {
          return _homePath;
        }

        if (location.startsWith(_homePath)) {
          return null;
        }

        return _homePath;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: _splashPath,
        name: splashRouteName,
        builder: (context, state) => SplashPage(),
      ),
      GoRoute(
        path: _loginPath,
        name: loginRouteName,
        builder: (context, state) => LoginPage(),
      ),
      GoRoute(
        path: _homePath,
        name: homeName,
        builder: (context, state) => HomePage(),
      ),
      GoRoute(
        path: _addProductPath,
        name: addProductName,
        builder: (context, state) {
          final product = state.extra as ProductEntity?;

          if (product == null) {
            return AddProductPage();
          }
          return AddProductPage(productEntity: product);
        },
      ),
    ],
  );
}

enum _AuthStatus { unknow, authenticated, unauthenticated }
