import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../features/auth/login_page.dart';
import '../../../features/auth/view_model/auth_view_model.dart';
import '../../../features/home/home_page.dart';
import '../../../features/navigation/main_screen.dart';
import '../../../features/splash/splash_page.dart';
import '../../di/app_modules.dart';

class AppRouter {
  // Navigation keys
  static final _rootNavegationKey = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavegationKey,
    initialLocation: SplashPage.route,
    refreshListenable: inject<AuthViewModel>(),
    redirect: (context, state) {
      final authProvider = inject<AuthViewModel>();
      final authStatus = authProvider.authStatus;

      if (authStatus == AuthStatus.unAuthenticated) {
        return LoginPage.route;
      } else if (authStatus == AuthStatus.authenticated) {
        return MainScreen.route;
      } else if (authStatus == AuthStatus.checking) {
        // While checking authentication, stay on the splash page
        return SplashPage.route;
      }

      return null;
    },
    routes: [
      // root route
      _singleRoute(
        path: SplashPage.route,
        parentKey: _rootNavegationKey,
        page: const SplashPage(),
      ),
      // Sign In
      _singleRoute(
        path: LoginPage.route,
        parentKey: _rootNavegationKey,
        page: const LoginPage(),
      ),
      // Main Home
      _singleRoute(
        path: MainScreen.route,
        parentKey: _rootNavegationKey,
        page: const MainScreen(),
      ),
      // Home
      _singleRoute(
        path: HomePage.route,
        parentKey: _rootNavegationKey,
        page: const HomePage(),
      ),
    ],
  );

  static GoRoute _singleRoute({
    required String path,
    required Widget page,
    GlobalKey<NavigatorState>? parentKey,
  }) {
    return GoRoute(
      path: path,
      parentNavigatorKey: parentKey,
      pageBuilder: (context, state) => _fadeTransition(page),
    );
  }

  static CustomTransitionPage<dynamic> _fadeTransition(Widget child) {
    return CustomTransitionPage(
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) =>
          FadeTransition(
        opacity: animation,
        child: child,
      ),
    );
  }
}
