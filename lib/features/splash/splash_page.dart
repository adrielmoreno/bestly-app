import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';

import '../../app/di/app_modules.dart';
import '../../core/domain/repositories/connectivity_repository.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});
  static const String route = '/';

  @override
  State<SplashPage> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _checkConnectivity();
  }

  Future<void> _checkConnectivity() async {
    final hasInternet = await inject<ConnectivityRepository>().hasIntenert;
    log('Has internet: $hasInternet');

    if (!hasInternet) {
      // _navigateTo(NoInternetView.route);
      return;
    }

    // final user = await inject<AccountRepository>().getUserData();

    // if (user != null) {
    //   inject<SessionController>().setUser(user);
    //   _navigateTo(HomeView.route);
    // } else {
    //   _navigateTo(SignInView.route);
    // }
  }

  // _navigateTo(String routeName) {
  //   context.pushReplacement(routeName);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/img/bestly.png',
          width: 150,
        ),
      ),
    );
  }
}
