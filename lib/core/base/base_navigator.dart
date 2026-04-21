import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:login_demo/core/constants/ui_constants.dart';
import 'package:login_demo/core/extensions/num_extension.dart';
import 'package:login_demo/core/global/global_data.dart';
import 'package:login_demo/core/theme/app_colors.dart';
import 'package:login_demo/core/widget/dialogs/app_dialog.dart';
import 'package:login_demo/navigator/app_router.dart';

/// Base class for feature-specific navigators, providing common navigation
/// actions using GoRouter.
///
/// Feature navigators (e.g., SplashNavigator, MovieListNavigator) should
/// extend this class and add methods specific to their feature's navigation needs.
class BaseNavigator {
  final BuildContext context;
  late FlushbarNavigator flushbarNavigator;
  late AppDialog appDialog;

  /// Creates a BaseNavigator. Requires the [context] from which navigation
  /// will be initiated.
  BaseNavigator({required this.context}) {
    flushbarNavigator = FlushbarNavigator(context);
    appDialog = AppDialog(context);
  }

  String? _currentLocation;

  /// Pops the current route off the GoRouter stack.
  ///
  /// Equivalent to `Navigator.of(context).pop()`, but integrated with GoRouter.
  /// Optionally returns a [result] to the previous route.
  void pop<T extends Object?>([T? result]) {
    // Use the GoRouter extension method on context
    if (context.canPop()) {
      context.pop(result);
    } else {
      // Optional: Add logging or specific handling if pop is called when it shouldn't be
      // (e.g., on the very first screen in the stack)
      debugPrint("Attempted to pop when cannot pop.");
    }
  }

  /// Navigates to a named route, replacing the current route stack if it's
  /// a top-level route, or pushing within a nested stack.
  ///
  /// Use this for general navigation where you don't necessarily want to
  /// keep the current screen in the back stack (e.g., navigating from splash
  /// to home, or switching main tabs).
  ///
  /// - [routeName]: The name of the target route (defined in AppRouter).
  /// - [pathParameters]: Parameters to be embedded in the route path (e.g., `/users/:id`).
  /// - [queryParameters]: Parameters to be appended to the route path (e.g., `?search=query`).
  /// - [extra]: An optional object to pass along to the route, accessible via `GoRouterState.extra`.
  void goNamed(
    String routeName, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, dynamic> queryParameters = const <String, dynamic>{},
    Object? extra,
  }) {
    if (_currentLocation == routeName) return;
    _currentLocation = routeName;
    _clearCurrentLocation();
    context.goNamed(
      routeName,
      pathParameters: pathParameters,
      queryParameters: queryParameters,
      extra: extra,
    );
  }

  void _clearCurrentLocation() async {
    await Future.delayed(100.milliseconds);
    _currentLocation = null;
  }

  /// Pushes a named route onto the GoRouter stack.
  ///
  /// Use this when you want to navigate to a new screen and allow the user
  /// to navigate back to the current screen (e.g., navigating from a list
  /// to a detail screen).
  ///
  /// Returns a `Future<T?>` which completes when the pushed route is popped,
  /// potentially returning a result of type `T`.
  ///
  /// Parameters are the same as [goNamed].
  Future<T?> pushNamed<T extends Object?>(
    String routeName, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, dynamic> queryParameters = const <String, dynamic>{},
    Object? extra,
  }) async {
    if (_currentLocation == routeName) return null;
    _currentLocation = routeName;
    _clearCurrentLocation();
    return context.pushNamed<T>(
      routeName,
      pathParameters: pathParameters,
      queryParameters: queryParameters,
      extra: extra,
    );
  }

  /// Navigates to a specific location (path), replacing the current stack
  /// similar to [goNamed]. Less type-safe than named routes.
  void go(String location, {Object? extra}) {
    if (_currentLocation == location) return;
    _currentLocation = location;
    _clearCurrentLocation();
    context.go(location, extra: extra);
  }

  /// Pushes a specific location (path) onto the stack, similar to [pushNamed].
  /// Less type-safe than named routes.
  Future<T?> push<T extends Object?>(String location, {Object? extra}) async {
    if (_currentLocation == location) return null;
    _currentLocation = location;
    _clearCurrentLocation();
    return context.push<T>(location, extra: extra);
  }

  void replaceNamed(String routeName, {Object? extra}) {
    if (_currentLocation == routeName) return;
    _currentLocation = routeName;
    _clearCurrentLocation();
    context.replaceNamed(routeName, extra: extra);
  }

  void popUntilNamed(String name) {
    Navigator.popUntil(context, ModalRoute.withName(name));
  }

  void openLoginPage() {
    goNamed(AppRouter.loginRouteName);
  }

  void openHome() {
    goNamed(AppRouter.homeName);
  }

  void navigateBack() {
    Navigator.of(context).pop();
  }

  void safePop() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.goNamed(AppRouter.homeName);
    }
  }
}

class FlushbarNavigator {
  final BuildContext _context;

  FlushbarNavigator(context) : _context = context;

  /// Show error flushbar
  Future<void> showError({String? message}) async {
    if (!GlobalData.instance.isShowFlushBar) return;
    await Flushbar(
      message: (message?.isNotEmpty ?? false) ? message : "unknow error",
      messageSize: 15,
      margin: UiConstants.horizontalPaddingMedium.copyWith(
        bottom: UiConstants.paddingMedium,
      ),
      flushbarStyle: FlushbarStyle.FLOATING,
      flushbarPosition: FlushbarPosition.BOTTOM,
      borderRadius: BorderRadius.circular(8),
      icon: Icon(Icons.error, color: AppColors.textErrorRed, size: 24),
      titleColor: AppColors.textBlack,
      duration: const Duration(seconds: 3),
      backgroundColor: AppColors.neutral800,
    ).show(_context);
  }

  Future showSuccess({required String message}) async {
    return await Flushbar(
      message: message,
      messageSize: 15,
      margin: UiConstants.horizontalPaddingMedium.copyWith(
        bottom: UiConstants.paddingMedium,
      ),
      borderRadius: BorderRadius.circular(8),
      flushbarStyle: FlushbarStyle.FLOATING,
      flushbarPosition: FlushbarPosition.TOP,
      icon: const Icon(Icons.done, color: AppColors.buttonBGGreen, size: 24),
      titleColor: AppColors.textBlack,
      duration: const Duration(seconds: 3),
      backgroundColor: AppColors.neutral800,
    ).show(_context);
  }
}
