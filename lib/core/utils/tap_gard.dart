// tap_guard.dart
import 'dart:async';
import 'package:login_demo/core/extensions/num_extension.dart';

Future<void> safeAction(void Function() action) {
  return TapGuard.run(action);
}

class TapGuard {
  static bool _locked = false;

  static get isLocked => _locked;

  static Future<void> run(void Function() action) async {
    // logger.d('action: $action \n time: ${DateTime.now()} \n _locked: $_locked');
    if (_locked) return;
    _locked = true;

    try {
      action();
    } finally {
      Future.delayed(100.milliseconds, () {
        _locked = false;
        // logger.d(
        //     'action: $action \n time: ${DateTime.now()} \n _locked: $_locked');
      });
    }
  }
}
