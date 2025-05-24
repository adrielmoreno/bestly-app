import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'app/di/app_modules.dart';
import 'app/my_app.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  AppModules().setup();
  runApp(const MyApp());
}
