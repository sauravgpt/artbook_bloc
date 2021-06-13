import 'package:flutter/material.dart';

import 'components.dart';

class ProfileStats extends StatelessWidget {
  final bool isCurrentUser;
  final bool isFollowing;
  final int posts;
  final int followers;
  final int following;
  const ProfileStats({
    Key key,
    @required this.isCurrentUser,
    @required this.isFollowing,
    @required this.posts,
    @required this.followers,
    @required this.following,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _Stats(count: posts, label: 'posts'),
              _Stats(count: followers, label: 'followers'),
              _Stats(count: following, label: 'following'),
            ],
          ),
          const SizedBox(height: 8.0),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: ProfileButton(
                isCurrentUser: isCurrentUser,
                isFollowing: isFollowing,
              ))
        ],
      ),
    );
  }
}

class _Stats extends StatelessWidget {
  final int count;
  final String label;
  const _Stats({
    Key key,
    this.count,
    this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          count.toString(),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        Text(
          label,
          style: TextStyle(color: Colors.black54),
        ),
      ],
    );
  }
}
