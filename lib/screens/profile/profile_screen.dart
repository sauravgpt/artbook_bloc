import 'package:artbook/bloc/auth/auth_bloc.dart';
import 'package:artbook/enums/enums.dart';
import 'package:artbook/repositories/repositories.dart';
import 'package:artbook/widgets/user_profile_image.dart';
import 'package:artbook/widgets/widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/profile_bloc.dart';
import 'components/profile_info.dart';
import 'components/profile_stats.dart';

class ProfileScreenArgs {
  final String userId;

  ProfileScreenArgs({@required this.userId});
}

class ProfileScreen extends StatefulWidget {
  static const String routeName = '/profile';

  static Route route({@required ProfileScreenArgs args}) {
    return MaterialPageRoute(
      settings: RouteSettings(name: routeName),
      builder: (context) => BlocProvider<ProfileBloc>(
        create: (_) => ProfileBloc(
          userRepository: context.read<UserRepository>(),
          authBloc: context.read<AuthBloc>(),
          postRepository: context.read<PostRepository>(),
        )..add(ProfileLoadUser(userId: args.userId)),
        child: ProfileScreen(),
      ),
    );
  }

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state.status == ProfileStatus.error)
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(
                state.failure.message,
              ),
            ),
          );
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(state.user.username),
            actions: [
              if (state.isCurrentUser)
                IconButton(
                  icon: const Icon(Icons.exit_to_app),
                  onPressed: () => context.read<AuthBloc>().add(
                        AuthLogoutRequested(),
                      ),
                ),
            ],
          ),
          body: _buildBody(context, state),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, ProfileState state) {
    switch (state.status) {
      case ProfileStatus.loading:
        return Center(child: CircularProgressIndicator());

      default:
        return RefreshIndicator(
          onRefresh: () async {
            context
                .read<ProfileBloc>()
                .add(ProfileLoadUser(userId: state.user.id));
            return true;
          },
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
                      child: Row(
                        children: [
                          UserProfileImage(
                            radius: 40.0,
                            profileImageUrl: state.user.profileImageUrl,
                          ),
                          ProfileStats(
                            isCurrentUser: state.isCurrentUser,
                            isFollowing: state.isFollowing,
                            posts: 0, // state.posts.length
                            followers: state.user.followers,
                            following: state.user.following,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 10),
                      child: ProfileInfo(
                        username: state.user.username,
                        bio: state.user.bio,
                      ),
                    ),
                  ],
                ),
              ),
              SliverToBoxAdapter(
                child: TabBar(
                  controller: _tabController,
                  labelColor: Theme.of(context).primaryColor,
                  unselectedLabelColor: Colors.grey,
                  tabs: [
                    Tab(icon: Icon(Icons.grid_on, size: 28)),
                    Tab(icon: Icon(Icons.list, size: 28)),
                  ],
                  indicatorWeight: 3.0,
                  onTap: (int index) => context
                      .read<ProfileBloc>()
                      .add(ProfileToggleGridView(index == 0)),
                ),
              ),
              state.isGridView
                  ? SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 2.0,
                        crossAxisSpacing: 2.0,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final post = state.posts[index];
                          return GestureDetector(
                            onTap: () {},
                            child: CachedNetworkImage(
                              imageUrl: post.imageUrl,
                              fit: BoxFit.cover,
                            ),
                          );
                        },
                        childCount: state.posts.length,
                      ),
                    )
                  : SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final post = state.posts[index];
                          return PostView(post: post);
                        },
                        childCount: state.posts.length,
                      ),
                    ),
            ],
          ),
        );

        break;
    }
  }
}
