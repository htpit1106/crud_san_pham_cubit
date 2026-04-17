import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'dart:math';

void hideKeyboard(BuildContext context) {
  FocusScopeNode currentFocus = FocusScope.of(context);
  if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
    FocusManager.instance.primaryFocus?.unfocus();
  }
}

String generateSalt([int length = 16]) {
  const chars =
      'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  final rand = Random.secure();

  return List.generate(length, (_) => chars[rand.nextInt(chars.length)]).join();
}

String hashPassword(String password, String salt) {
  final bytes = utf8.encode(password + salt);
  return sha256.convert(bytes).toString();
}

String generateSessionToken(String username) {
  return username + DateTime.now().millisecondsSinceEpoch.toString();
}

Future<bool> checkInternetConnect() async {
  try {
    final result = await InternetAddress.lookup('google.com');
    return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
  } catch (_) {
    return false;
  }
}
