import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:login_demo/core/constants/asset_constants.dart';
import 'package:login_demo/core/constants/ui_constants.dart';
import 'package:login_demo/core/theme/app_colors.dart';
import 'package:login_demo/core/theme/text_style.dart';
import 'package:login_demo/core/utils/tap_gard.dart';
import 'package:login_demo/core/utils/utils.dart';
import 'package:login_demo/core/widget/image/app_svg_image.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController? controller;
  final TextStyle? style;
  final String? hintText;
  final TextStyle? hintStyle;
  final String? labelText;
  final TextStyle? labelStyle;
  final TextStyle? errorStyle;
  final String? Function(String?)? validator;
  final Color? borderColor;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? prefixIcon;
  final double prefixIconWidth;
  final Widget? suffixIcon;
  final double suffixIconWidth;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final int? maxLines;
  final int? minLines;
  final InputDecoration? decoration;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final bool autocorrect;
  final bool enableSuggestions;
  final EdgeInsets? padding;
  final bool enable;
  final List<String>? autofillHints;
  final bool readOnly;
  final VoidCallback? onTap;
  final String? initialValue;
  final Color? fillColor;
  final int? maxLength;
  final TapRegionCallback? onTapOutside;
  final bool? isFilled;
  final List<TextInputFormatter> inputFormatters;
  final bool hideCounter;
  final AutovalidateMode? autovalidateMode;
  final bool? showCursor;
  final bool? enableInteractiveSelection;

  const AppTextField({
    super.key,
    this.controller,
    this.style,
    this.hintText,
    this.hintStyle = AppTextStyle.hintStyle,
    this.labelText,
    this.labelStyle = AppTextStyle.textLabelBlack,
    this.errorStyle,
    this.validator,
    this.keyboardType,
    this.obscureText = false,
    this.prefixIcon,
    this.prefixIconWidth = double.maxFinite,
    this.suffixIcon,
    this.suffixIconWidth = double.maxFinite,
    this.onChanged,
    this.maxLines = 1,
    this.minLines = 1,
    this.decoration,
    this.textInputAction,
    this.focusNode,
    this.autocorrect = true,
    this.enableSuggestions = true,
    this.padding,
    this.enable = true,
    this.autofillHints = const [],
    this.readOnly = false,
    this.onTap,
    this.initialValue,
    this.fillColor,
    this.onSubmitted,
    this.maxLength,
    this.onTapOutside,
    this.borderColor,
    this.isFilled = false,
    this.inputFormatters = const <TextInputFormatter>[],
    this.hideCounter = true,
    this.autovalidateMode,
    this.showCursor = true,
    this.enableInteractiveSelection = true,
  });

  @override
  Widget build(BuildContext context) {
    final defaultDecoration = InputDecoration(
      contentPadding:
          padding ??
          const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: UiConstants.paddingMedium,
          ),

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
      filled: isFilled,
      fillColor: fillColor,
      hintText: hintText,
      hintStyle: hintStyle,
      errorStyle: errorStyle ?? AppTextStyle.red.s12.w400,
      errorMaxLines: 10,
      prefixIcon: prefixIcon,
      prefixIconConstraints: BoxConstraints(maxWidth: prefixIconWidth),
      suffixIcon:
          suffixIcon ??
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: controller!,
            builder: (context, value, _) {
              if (value.text.isEmpty) return const SizedBox();
              return IconButton(
                onPressed: () {
                  controller!.clear();
                },
                icon: const AppSvgImage(AssetConstants.closeCircle, width: 22),
              );
            },
          ),
      suffixIconConstraints: BoxConstraints(maxWidth: suffixIconWidth),
      floatingLabelBehavior: FloatingLabelBehavior.auto,
    );

    return Column(
      spacing: 8,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(labelText ?? "", style: labelStyle),
        TextFormField(
          onTap: () {
            // If has other action => hide keyboard
            if (TapGuard.isLocked) {
              hideKeyboard(context);
            }
            safeAction(() {
              onTap?.call();
            });
          },

          cursorColor: AppColors.textFieldFocusBorder,
          onTapOutside: onTapOutside,
          enabled: enable,
          readOnly: readOnly,
          controller: controller,
          style: style ?? AppTextStyle.black.s16.w400,
          decoration: (decoration ?? defaultDecoration).copyWith(),
          validator: validator,
          autovalidateMode: autovalidateMode,
          keyboardType: keyboardType,
          obscureText: obscureText,
          onChanged: onChanged,
          maxLines: obscureText ? 1 : maxLines,
          minLines: minLines,
          textInputAction: textInputAction,
          focusNode: focusNode,
          autocorrect: autocorrect,
          enableSuggestions: enableSuggestions,
          autofillHints: autofillHints,
          initialValue: initialValue,
          onFieldSubmitted: onSubmitted,
          inputFormatters: inputFormatters,
          showCursor: showCursor,
          enableInteractiveSelection: enableInteractiveSelection,
        ),
      ],
    );
  }
}
