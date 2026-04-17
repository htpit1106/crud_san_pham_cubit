import 'package:login_demo/core/utils/validator_utils.dart';

extension StringExtensions on String {
  /// Capitalizes the first character of the string.
  String capitalize() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }

  /// Checks if the string is a valid email format.

  /// Checks if the string is a valid password format.
  bool isValidPassword() {
    return ValidatorUtils.passwordRegex.hasMatch(this);
  }
}
