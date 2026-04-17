enum BiometricStatus { success, notSupport, notEntrolled, failed }

// map error
extension BiometricStatusExtension on BiometricStatus {
  String get message {
    switch (this) {
      case BiometricStatus.success:
        return "Xác thực thành công";
      case BiometricStatus.notSupport:
        return "Thiết bị không hỗ trợ xác thực sinh trắc học";
      case BiometricStatus.notEntrolled:
        return "Chưa có dữ liệu sinh trắc học nào được đăng ký trên thiết bị";
      case BiometricStatus.failed:
        return "Xác thực sinh trắc học thất bại. Vui lòng thử lại.";
    }
  }
}
