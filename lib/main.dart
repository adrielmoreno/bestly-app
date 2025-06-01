import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'app/di/app_modules.dart';
import 'app/my_app.dart';
import 'core/data/local/secure_storage_service.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await SecureStorageService.init();
  AppModules().setup();
  runApp(const MyApp());
}
