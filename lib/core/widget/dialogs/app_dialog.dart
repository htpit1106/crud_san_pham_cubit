import 'package:flutter/material.dart';
import 'package:login_demo/core/extensions/num_extension.dart';
import 'package:login_demo/core/theme/app_colors.dart';
import 'package:login_demo/core/theme/text_style.dart';
import 'package:login_demo/navigator/app_router.dart';

class AppDialog {
  final BuildContext _context;

  AppDialog(this._context);

  void hide({dynamic result}) => Navigator.pop(_context, result);

  Future<void> show({
    String message = "",
    String? textConfirm = "Ok",
    String? textCancel,
    TextStyle? textMessageStyle,
    barrierDismissible = true,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    bool? centerTitle,
  }) async {
    final context = AppRouter.navigationKey.currentContext;
    if (context == null) return Future.value();
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.greyEEE,
          shape: RoundedRectangleBorder(borderRadius: 14.radius),
          insetPadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.zero,
          content: Container(
            width: 270,
     
            decoration: BoxDecoration(
              color: AppColors.greyEEE,
              borderRadius: 14.radius,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Offstage(
                  offstage: message.isEmpty,
                  child: Column(
                    children: [
                      ConstrainedBox(
                        constraints: const BoxConstraints(minHeight: 48),
                        child: Padding(
                          padding: 16.paddingAll,
                          child: Center(
                            child: Text(
                              message,
                              style:
                                  textMessageStyle ??
                                  AppTextStyle.black.s14.w400,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(height: 1, color: AppColors.border),
                SizedBox(
                  width: double.maxFinite,
                  child: IntrinsicHeight(
                    child: Row(
                      children: [
                        if (textCancel != null ||
                            (textCancel?.isNotEmpty ?? false)) ...{
                          Expanded(
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(minHeight: 48),
                              child: TextButton(
                                onPressed: () {
                                  if (onCancel == null) {
                                    Navigator.of(context).pop();
                                    return;
                                  }
                                  onCancel.call();
                                },
                                child: Text(
                                  textCancel ?? "Cancel",
                                  style: AppTextStyle.black.s14.w700,
                                ),
                              ),
                            ),
                          ),
                        },
                        Offstage(
                          offstage:
                              textConfirm == null ||
                              textConfirm.isEmpty ||
                              textCancel == null ||
                              textCancel.isEmpty,
                          child: Container(width: 1, color: AppColors.border),
                        ),
                        if (textConfirm != null ||
                            (textConfirm?.isNotEmpty ?? false)) ...{
                          Expanded(
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(minHeight: 48),
                              child: TextButton(
                                onPressed: () {
                                  if (onConfirm == null) {
                                    Navigator.of(context).pop();
                                    return;
                                  }
                                  onConfirm.call();
                                },
                                child: Text(
                                  textConfirm ?? "OK",
                                  textAlign: TextAlign.center,
                                  style: AppTextStyle.black.s14.w700,
                                ),
                              ),
                            ),
                          ),
                        },
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
