import 'package:flutter/widgets.dart';
import 'package:local_auth/local_auth.dart';
import 'package:login_demo/data/model/enums/biometric_status.dart';

class BiometricService {
  BiometricService._privateConstructor();
  static final BiometricService instance =
      BiometricService._privateConstructor();

  final LocalAuthentication _auth = LocalAuthentication();
  Future<bool> isDeviceSupported() async {
    final canCheck = await _auth.canCheckBiometrics;
    final isSupported = await _auth.isDeviceSupported();
    return canCheck || isSupported;
  }

  Future<bool> hasBiometrics() async {
    final biometrics = await _auth.getAvailableBiometrics();
    return biometrics.isNotEmpty;
  }

  Future<BiometricStatus> authenticate() async {
    try {
      final isSupported = await isDeviceSupported();
      if (!isSupported) return BiometricStatus.notSupport;
      final hasBio = await hasBiometrics();
      if (!hasBio) return BiometricStatus.notEntrolled;
      final authenticated = await _auth.authenticate(
        localizedReason: 'Xác thực để đăng nhập',
        biometricOnly: true,
      );
      return authenticated ? BiometricStatus.success : BiometricStatus.failed;
    } catch (e) {
      debugPrint('Biometric authentication error: $e');
      return BiometricStatus.failed;
    }
  }
}
