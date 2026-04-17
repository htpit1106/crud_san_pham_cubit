class ValidatorUtils {
  ValidatorUtils._();

  static final mstCCCDRegex = RegExp(r'^(\d{12}|\d{10}(-\d{3})?|\d{13,14})$');
  static RegExp passwordRegex = RegExp(r'^.{6,50}$');
  static RegExp inputNumberRegex = RegExp(r'[0-9-]');

  static bool isEmptyOrNull(String? value) {
    return value == null || value.isEmpty || value.trim().isEmpty;
  }

  static String? validateRequiredField(String? text, {required String title}) {
    if (isEmptyOrNull(text)) {
      return "$title không được để trống";
    }

    return null;
  }

  static String? validatePassword(String? password) {
    if (isEmptyOrNull(password)) {
      return validateRequiredField(password, title: "Mật khẩu");
    }
    if (!passwordRegex.hasMatch(password ?? "")) {
      return "Mật khẩu phải từ 6–50 ký tự";
    }
    return null;
  }

  static String? validateMstOrCCCd(String? value) {
    if (isEmptyOrNull(value)) {
      return validateRequiredField(value, title: "Mã số thuế");
    }
    if (!mstCCCDRegex.hasMatch(value ?? "")) {
      return "Vui lòng nhập CCCD 12 số hoặc MST hợp lệ (10 số, có thể kèm ‘-XXX’).";
    }
    return null;
  }
}
