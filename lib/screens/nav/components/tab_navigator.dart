import 'package:artbook/bloc/auth/auth_bloc.dart';
import 'package:artbook/config/app_router.dart';
import 'package:artbook/enums/enums.dart';
import 'package:artbook/repositories/repositories.dart';
import 'package:artbook/screens/profile/bloc/profile_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../screens.dart';

class TabNavigator extends StatelessWidget {
  static const String tabNavigatorRoute = '/';
  final GlobalKey<NavigatorState> navigatorKey;
  final BottomNavItem item;
  const TabNavigator({
    Key key,
    @required this.navigatorKey,
    @required this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      initialRoute: tabNavigatorRoute,
      onGenerateInitialRoutes: (_, initialRoute) {
        return [
          MaterialPageRoute(
            settings: RouteSettings(name: tabNavigatorRoute),
            builder: (context) => _routeBuilder()[initialRoute](context),
          )
        ];
      },
      onGenerateRoute: AppRouter.onGenerateNestesRoute,
    );
  }

  Map<String, WidgetBuilder> _routeBuilder() {
    return {tabNavigatorRoute: (context) => _getScreen(context, item)};
  }

  Widget _getScreen(BuildContext context, BottomNavItem item) {
    switch (item) {
      case BottomNavItem.feed:
        return FeedScreen();
      case BottomNavItem.search:
        return SearchScreen();
      case BottomNavItem.create:
        return CreatePostsScreen();
      case BottomNavItem.notification:
        return NotificationScreen();
      case BottomNavItem.profile:
        return BlocProvider(
          create: (_) => ProfileBloc(
            userRepository: context.read<UserRepository>(),
            authBloc: context.read<AuthBloc>(),
          )..add(
              ProfileLoadUser(userId: context.read<AuthBloc>().state.user.uid)),
          child: ProfileScreen(),
        );

      default:
        return Scaffold();
    }
  }
}
