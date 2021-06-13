import 'package:artbook/enums/enums.dart';
import 'package:artbook/screens/nav/components/cubit/bottom_nav_bar_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'components/components.dart';

class NavScreen extends StatelessWidget {
  static const String routeName = '/nav';

  static Route route() {
    return PageRouteBuilder(
      settings: const RouteSettings(name: routeName),
      transitionDuration: const Duration(seconds: 0),
      pageBuilder: (_, __, ___) => BlocProvider<BottomNavBarCubit>(
        create: (_) => BottomNavBarCubit(),
        child: NavScreen(),
      ),
    );
  }

  final Map<BottomNavItem, GlobalKey<NavigatorState>> navigatorKeys = {
    BottomNavItem.feed: GlobalKey<NavigatorState>(),
    BottomNavItem.search: GlobalKey<NavigatorState>(),
    BottomNavItem.create: GlobalKey<NavigatorState>(),
    BottomNavItem.notification: GlobalKey<NavigatorState>(),
    BottomNavItem.profile: GlobalKey<NavigatorState>(),
  };

  final Map<BottomNavItem, IconData> items = {
    BottomNavItem.feed: Icons.home,
    BottomNavItem.search: Icons.search,
    BottomNavItem.create: Icons.add,
    BottomNavItem.notification: Icons.favorite_border,
    BottomNavItem.profile: Icons.account_circle,
  };

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: BlocBuilder<BottomNavBarCubit, BottomNavBarState>(
        builder: (context, state) {
          return Scaffold(
            body: Stack(
              children: items
                  .map(
                    (item, _) => MapEntry(
                        item,
                        _buildOffStageNavigator(
                          item,
                          item == state.selectedItem,
                        )),
                  )
                  .values
                  .toList(),
            ),
            bottomNavigationBar: BottomNavBar(
              items: items,
              onTap: (int val) {
                final selectedItem = BottomNavItem.values[val];

                _handleSelectedBottomNavItem(
                  context,
                  selectedItem,
                  selectedItem == state.selectedItem,
                );
              },
              selectedItem: state.selectedItem,
            ),
          );
        },
      ),
    );
  }

  void _handleSelectedBottomNavItem(
    BuildContext context,
    BottomNavItem selectedItem,
    bool isSameItem,
  ) {
    if (!isSameItem) {
      navigatorKeys[selectedItem]
          .currentState
          .popUntil((route) => route.isFirst);
    }
    context.read<BottomNavBarCubit>().updateSelectedItem(selectedItem);
  }

  Widget _buildOffStageNavigator(BottomNavItem selectItem, bool isSelectItem) {
    return Offstage(
      offstage: !isSelectItem,
      child: TabNavigator(
          navigatorKey: navigatorKeys[selectItem], item: selectItem),
    );
  }
}
