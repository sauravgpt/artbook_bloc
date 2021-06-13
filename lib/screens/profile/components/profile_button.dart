import 'package:flutter/material.dart';

class ProfileButton extends StatelessWidget {
  final bool isCurrentUser;
  final bool isFollowing;
  const ProfileButton({
    Key key,
    this.isCurrentUser,
    this.isFollowing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      child: Text(
        isCurrentUser
            ? 'Edit Profile'
            : isFollowing
                ? 'Unfollow'
                : 'Follow',
      ),
    );
  }
}
