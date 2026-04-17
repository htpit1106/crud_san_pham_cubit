import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:login_demo/data/database/hive_helper.dart';
import 'package:login_demo/firebase_options.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Hive.initFlutter();
  await HiveHelper.instance.init();
  runApp(const MyApp());
  FirebaseFirestore.setLoggingEnabled(true);
  FlutterNativeSplash.remove();
}
