import 'package:artbook/screens/signup/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:artbook/screens/screens.dart';

class AppRouter {
  static Route onGenerateRoute(RouteSettings settings) {
    print('Route: ${settings.name}');
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          settings: const RouteSettings(name: '/'),
          builder: (_) {
            return const Scaffold();
          },
        );

      case SplashScreen.id:
        return SplashScreen.route();

      case NavScreen.routeName:
        return NavScreen.route();

      case LoginScreen.routeName:
        return LoginScreen.route();

      case SignupScreen.routeName:
        return SignupScreen.route();

      default:
        return _errorRoute();
    }
  }

  static Route onGenerateNestesRoute(RouteSettings settings) {
    print('Nested Route: ${settings.name}');
    switch (settings.name) {
      case EditProfileScreen.routeName:
        return EditProfileScreen.route(
          args: settings.arguments,
        );

      default:
        return _errorRoute();
    }
  }

  static Route _errorRoute() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: '/error'),
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
          centerTitle: true,
        ),
        body: const Center(
          child: Text('Something went wrong...'),
        ),
      ),
    );
  }
}
