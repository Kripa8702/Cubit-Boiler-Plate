import 'package:cubit_boiler_plate/features/auth/features/login/view/login_screen.dart';
import 'package:cubit_boiler_plate/features/auth/features/welcome/view/welcome_screen.dart';
import 'package:cubit_boiler_plate/features/landing/view/landing_screen.dart';
import 'package:cubit_boiler_plate/features/landing/widget/custom_navigation_bar.dart';
import 'package:cubit_boiler_plate/features/splash/view/splash_screen.dart';
import 'package:cubit_boiler_plate/services/navigator_service.dart';
import 'package:go_router/go_router.dart';

/// NOTE:
/// * Navigate using path names
/// * To go to auth startup : use NavigatorService.go(AppRouting.authPath)
/// * ---- To go to screens within the auth path, use NavigatorService.push(AppRouting.loginPath)

class AppRouting {
  static const String splashPath = '/';

  /// Auth --------------------------------------
  static const authPath = '/auth';

  static const welcome = 'welcome';
  static const welcomePath = '$authPath/welcome';

  static const login = 'login';
  static const loginPath = '$authPath/login';

  /// Bottom Nav --------------------------------
  static const home = 'home';
  static const homePath = '/$home';

  static const search = 'search';
  static const searchPath = '/$search';

  static const profile = 'profile';
  static const profilePath = '/$profile';

  static final GoRouter router = GoRouter(
    navigatorKey: NavigatorService.navigatorKey,
    routes: [
      GoRoute(
        path: splashPath,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: authPath,
        builder: (context, state) => const WelcomeScreen(),
        routes: [
          GoRoute(
            path: welcome,
            builder: (context, state) => const WelcomeScreen(),
          ),
          GoRoute(
            path: login,
            builder: (context, state) => const LoginScreen(),
          ),
          ]
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            LandingScreen(navigationShell: navigationShell),

        branches: bottomNavItems
            .map(
              (e) => StatefulShellBranch(
                routes: [
                  GoRoute(
                    path: e.path,
                    name: e.name,
                    builder: (context, state) => e.page,
                  )
                ],
              ),
            )
            .toList(),
      )
    ],
  );
}
