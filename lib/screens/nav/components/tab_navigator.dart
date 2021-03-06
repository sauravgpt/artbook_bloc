import 'package:artbook/bloc/auth/auth_bloc.dart';
import 'package:artbook/config/app_router.dart';
import 'package:artbook/enums/enums.dart';
import 'package:artbook/repositories/repositories.dart';
import 'package:artbook/screens/create_post/cubit/create_post_cubit.dart';
import 'package:artbook/screens/profile/bloc/profile_bloc.dart';
import 'package:artbook/screens/search/cubit/search_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../screens.dart';

class TabNavigator extends StatelessWidget {
  static const String tabNavigatorRoot = '/';
  final GlobalKey<NavigatorState> navigatorKey;
  final BottomNavItem item;
  const TabNavigator({
    Key key,
    @required this.navigatorKey,
    @required this.item,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final routeBuilders = _routeBuilder();
    return Navigator(
      key: navigatorKey,
      initialRoute: tabNavigatorRoot,
      onGenerateInitialRoutes: (_, initialRoute) {
        return [
          MaterialPageRoute(
            settings: RouteSettings(name: tabNavigatorRoot),
            builder: (context) => routeBuilders[initialRoute](context),
          )
        ];
      },
      onGenerateRoute: AppRouter.onGenerateNestesRoute,
    );
  }

  Map<String, WidgetBuilder> _routeBuilder() {
    return {tabNavigatorRoot: (context) => _getScreen(context, item)};
  }

  Widget _getScreen(BuildContext context, BottomNavItem item) {
    switch (item) {
      case BottomNavItem.feed:
        return FeedScreen();

      case BottomNavItem.search:
        return BlocProvider<SearchCubit>(
          create: (context) => SearchCubit(
            userRepository: context.read<UserRepository>(),
          ),
          child: SearchScreen(),
        );

      case BottomNavItem.create:
        return BlocProvider<CreatePostCubit>(
          create: (context) => CreatePostCubit(
            authBloc: context.read<AuthBloc>(),
            postRepository: context.read<PostRepository>(),
            storageRepository: context.read<StorageRepository>(),
          ),
          child: CreatePostsScreen(),
        );

      case BottomNavItem.notification:
        return NotificationScreen();

      case BottomNavItem.profile:
        return BlocProvider<ProfileBloc>(
          create: (_) => ProfileBloc(
            postRepository: context.read<PostRepository>(),
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
