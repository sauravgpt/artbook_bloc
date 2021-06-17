import 'package:artbook/models/models.dart';
import 'package:artbook/screens/screens.dart';
import 'package:artbook/widgets/user_profile_image.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import './../extensions/extensions.dart';

class PostView extends StatelessWidget {
  final Post post;
  final bool isLiked;
  const PostView({
    @required this.post,
    @required this.isLiked,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () => Navigator.of(context).pushNamed(
                ProfileScreen.routeName,
                arguments: ProfileScreenArgs(userId: post.author.id)),
            child: Row(
              children: [
                UserProfileImage(
                  radius: 18.0,
                  profileImageUrl: post.author.profileImageUrl,
                ),
                const SizedBox(width: 8.0),
                Expanded(
                    child: Text(
                  post.author.username,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                  ),
                )),
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: () {},
          child: CachedNetworkImage(
            imageUrl: post.imageUrl,
            fit: BoxFit.cover,
            width: double.infinity,
            height: MediaQuery.of(context).size.height / 2.25,
          ),
        ),
        Row(
          children: [
            IconButton(
              icon: Icon(
                isLiked == null
                    ? Icons.favorite
                    : (isLiked ? Icons.favorite_border : Icons.favorite_border),
                color: Colors.red,
              ),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.comment_outlined),
              onPressed: () {},
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                '${post.likes} likes',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 4.0),
              Text.rich(
                TextSpan(
                  text: post.author.username,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                  children: [
                    TextSpan(text: ' '),
                    TextSpan(text: post.caption),
                  ],
                ),
              ),
              const SizedBox(height: 4.0),
              Text(
                post.date.timeAgo(),
                style: TextStyle(
                    color: Colors.grey[600], fontWeight: FontWeight.w500),
              )
            ],
          ),
        )
      ],
    );
  }
}
