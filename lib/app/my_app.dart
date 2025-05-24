import 'package:flutter/material.dart';

import '../core/presentation/common/theme/app_styles.dart';
import 'navegation/routes/router.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: AppRouter.router,
      debugShowCheckedModeBanner: false,
      title: 'Bestly',
      darkTheme: AppStyles.appDarkTheme,
      theme: AppStyles.appDarkTheme,
    );
  }
}
