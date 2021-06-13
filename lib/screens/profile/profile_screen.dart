import 'package:artbook/bloc/auth/auth_bloc.dart';
import 'package:artbook/enums/enums.dart';
import 'package:artbook/widgets/user_profile_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/profile_bloc.dart';
import 'components/profile_info.dart';
import 'components/profile_stats.dart';

class ProfileScreen extends StatelessWidget {
  static const String routeName = '/profile';

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
          body: CustomScrollView(
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
              )
            ],
          ),
        );
      },
    );
  }
}
