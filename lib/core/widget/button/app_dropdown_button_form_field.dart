import 'package:flutter/material.dart';
import 'package:login_demo/core/theme/text_style.dart';

class AppDropdownButtonFormField<T> extends StatelessWidget {
  final String? labelText;
  final List<DropdownMenuItem<T>>? items;
  final Function(T?)? onChanged;
  final T? value;
  final String? hintText;
  const AppDropdownButtonFormField({
    super.key,
    this.labelText,
    this.items,
    this.onChanged,
    this.hintText,
    this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: .start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(labelText ?? ""),
        DropdownButtonFormField<T>(
          // ignore: deprecated_member_use
          value: value,
          decoration: InputDecoration(
            hint: Text(
              hintText ?? "",
              style: AppTextStyle.hintStyle.copyWith(fontSize: 16),
            ),
            border: const OutlineInputBorder(),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
          ),
          items: items ?? [],
          onChanged: (value) {
            onChanged?.call(value);
          },
        ),
      ],
    );
  }
}
