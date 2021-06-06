import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import './../../bloc/bloc.dart';
import './../screens.dart';

class SplashScreen extends StatelessWidget {
  static const String id = '/splash';

  static Route route() => MaterialPageRoute(
        settings: const RouteSettings(name: id),
        builder: (context) => SplashScreen(),
      );

  const SplashScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.status == AuthStatus.unauthenticated) {
            Navigator.of(context).pushNamed(LoginScreen.routeName);
          } else if (state.status == AuthStatus.authenticated) {
            Navigator.of(context).pushNamed(NavScreen.routeName);
          }
        },
        child: Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}
