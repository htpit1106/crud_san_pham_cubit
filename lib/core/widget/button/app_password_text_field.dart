import 'package:flutter/material.dart';
import 'package:login_demo/core/constants/asset_constants.dart';
import 'package:login_demo/core/constants/ui_constants.dart';
import 'package:login_demo/core/theme/app_colors.dart';
import 'package:login_demo/core/theme/text_style.dart';
import 'package:login_demo/core/widget/image/app_svg_image.dart';

class ObscureTextController extends ValueNotifier<bool> {
  ObscureTextController({bool obscureText = true}) : super(obscureText);

  bool get date => value;

  set date(bool obscureText) {
    value = obscureText;
  }
}

class AppPasswordTextField extends StatelessWidget {
  final TextEditingController controller;
  final ObscureTextController obscureTextController;
  final List<String>? autofillHints;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;
  final String? Function(String?)? validator;
  final String? labelText;
  final TextStyle? labelStyle;
  final String? hintText;
  final FocusNode? focusNode;
  final TextStyle? style;
  final EdgeInsets? padding;
  final TextStyle? hintStyle;
  final TextStyle? errorStyle;
  final bool enablePrefixIcon;
  final bool enableSuffixIcon;
  final bool enable;
  final InputDecoration? decoration;
  final bool hideCounter;
  final Color? borderColor;
  final TextInputAction? textInputAction;
  final Function()? onSubmitted;
  final AutovalidateMode? autovalidateMode;

  const AppPasswordTextField({
    super.key,
    required this.controller,
    required this.obscureTextController,
    this.autofillHints = const [],
    this.onFieldSubmitted,
    this.validator,
    this.onChanged,
    this.labelText,
    this.labelStyle = AppTextStyle.textLabelBlack,
    this.hintText,
    this.focusNode,
    this.style,
    this.padding,
    this.hintStyle = AppTextStyle.hintStyle,
    this.errorStyle,
    this.enablePrefixIcon = false,
    this.enableSuffixIcon = false,
    this.enable = true,
    this.decoration,
    this.hideCounter = true,
    this.borderColor,
    this.onSubmitted,
    this.textInputAction,
    this.autovalidateMode,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: obscureTextController,
      builder: (context, bool obscureText, _) {
        final defaultDecoration = InputDecoration(
          contentPadding:
              padding ??
              const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: UiConstants.paddingMedium,
              ),

          hintText: hintText,
          hintStyle: hintStyle,
          focusedBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              Radius.circular(UiConstants.borderRadiusSmall),
            ),
            borderSide: BorderSide(
              color: borderColor ?? AppColors.textFieldFocusBorder,
              width: 1.0,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              Radius.circular(UiConstants.borderRadiusSmall),
            ),
            borderSide: BorderSide(
              color: borderColor ?? AppColors.textFieldPrimaryBorder,
              width: 1.0,
            ),
          ),
          disabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(UiConstants.borderRadiusSmall),
            ),
            borderSide: BorderSide(
              color: AppColors.textFieldDisabledBorder,
              width: 1.0,
            ),
          ),
          errorBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(UiConstants.borderRadiusSmall),
            ),
            borderSide: BorderSide(
              color: AppColors.textFieldPrimaryBorder,
              width: 1.0,
            ),
          ),
          focusedErrorBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(UiConstants.borderRadiusSmall),
            ),
            borderSide: BorderSide(
              color: AppColors.textFieldErrorBorder,
              width: 1.0,
            ),
          ),
          errorStyle: errorStyle ?? AppTextStyle.red.s12,
          errorMaxLines: 10,
          prefixIcon: enablePrefixIcon ? const Icon(Icons.lock_outline) : null,
          suffixIcon: enableSuffixIcon
              ? ValueListenableBuilder<TextEditingValue>(
                  valueListenable: controller,
                  builder: (context, value, _) {
                    final hasText = value.text.isNotEmpty;

                    if (!hasText) return const SizedBox();

                    return ValueListenableBuilder<bool>(
                      valueListenable: obscureTextController,
                      builder: (context, obscureText, _) {
                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          spacing: 0,
                          children: [
                            IconButton(
                              onPressed: () {
                                controller.clear();
                              },
                              icon: const AppSvgImage(
                                AssetConstants.closeCircle,
                                width: 22,
                              ),
                            ),
                            IconButton(
                              splashRadius: 24,
                              onPressed: () {
                                obscureTextController.value = !obscureText;
                              },
                              icon: obscureText
                                  ? const AppSvgImage(
                                      AssetConstants.eyeSlash,
                                      width: 22,
                                    )
                                  : const AppSvgImage(
                                      AssetConstants.eye,
                                      width: 22,
                                    ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                )
              : null,
        );
        return Column(
          spacing: 8,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(labelText ?? "", style: labelStyle),
            TextFormField(
              controller: controller,
              autofillHints: autofillHints,
              focusNode: focusNode,
              style: style ?? AppTextStyle.black.bodyLarge.w500,
              decoration: (decoration ?? defaultDecoration).copyWith(),
              keyboardType: TextInputType.visiblePassword,
              onChanged: onChanged,
              obscureText: obscureTextController.value,
              obscuringCharacter: '●',
              validator: validator,
              onFieldSubmitted: onFieldSubmitted,
              enabled: enable,
              textInputAction: textInputAction,
              onEditingComplete: onSubmitted,
              autovalidateMode: autovalidateMode,
            ),
          ],
        );
      },
    );
  }
}
