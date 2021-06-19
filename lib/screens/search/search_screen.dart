import 'package:artbook/screens/screens.dart';
import 'package:artbook/screens/search/cubit/search_cubit.dart';
import 'package:artbook/widgets/user_profile_image.dart';
import 'package:artbook/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchScreen extends StatefulWidget {
  static const String routeName = '/search';

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: TextField(
            controller: _textController,
            decoration: InputDecoration(
              fillColor: Colors.grey[200],
              border: InputBorder.none,
              hintText: 'Search Users',
              filled: true,
              suffix: IconButton(
                icon: Icon(Icons.clear),
                onPressed: () {
                  context.read<SearchCubit>().clearSearch();
                  _textController.clear();
                },
              ),
            ),
            textInputAction: TextInputAction.done,
            textAlignVertical: TextAlignVertical.center,
            onSubmitted: (query) {
              if (query.isNotEmpty) {
                context.read<SearchCubit>().searchUsers(query.trim());
              }
            },
          ),
        ),
        body: BlocBuilder<SearchCubit, SearchState>(
          builder: (context, state) {
            switch (state.status) {
              case SearchStatus.error:
                return CenteredText(
                  text: state.failure.message,
                );
                break;
              case SearchStatus.loading:
                return Center(
                  child: const CircularProgressIndicator(),
                );
                break;
              case SearchStatus.loaded:
                if (state.users.isNotEmpty) {
                  return ListView.builder(
                    itemCount: state.users.length,
                    itemBuilder: (context, index) {
                      final user = state.users[index];
                      return ListTile(
                        leading: UserProfileImage(
                          radius: 22.0,
                          profileImageUrl: user.profileImageUrl,
                        ),
                        title: Text(
                          user.username,
                          style: const TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                        onTap: () => Navigator.of(context).pushNamed(
                            ProfileScreen.routeName,
                            arguments: ProfileScreenArgs(userId: user.id)),
                      );
                    },
                  );
                } else {
                  return CenteredText(text: 'No Users found');
                }
                break;

              default:
                return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }
}
