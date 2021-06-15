import 'dart:io';

import 'package:artbook/helpers/helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:artbook/models/models.dart';
import 'package:artbook/repositories/repositories.dart';
import 'package:artbook/screens/edit_profile/cubit/edit_profile_cubit.dart';
import 'package:artbook/screens/profile/bloc/profile_bloc.dart';
import 'package:artbook/widgets/user_profile_image.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileScreenArgs {
  final BuildContext context;
  const EditProfileScreenArgs({
    @required this.context,
  });
}

class EditProfileScreen extends StatelessWidget {
  static const String routeName = '/editProfile';

  static Route route({@required EditProfileScreenArgs args}) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => BlocProvider<EditProfileCubit>(
        create: (_) => EditProfileCubit(
            userRepository: context.read<UserRepository>(),
            storageRepository: context.read<StorageRepository>(),
            profileBloc: args.context.read<ProfileBloc>()),
        child: EditProfileScreen(
          user: args.context.read<ProfileBloc>().state.user,
        ),
      ),
    );
  }

  EditProfileScreen({
    Key key,
    @required this.user,
  }) : super(key: key);

  final _formState = GlobalKey<FormState>();
  final User user;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Edit Profile'),
        ),
        body: BlocConsumer<EditProfileCubit, EditProfileState>(
          listener: (context, state) {
            if (state.status == EditProfileStatus.success) {
              Navigator.of(context).pop();
            } else if (state.status == EditProfileStatus.error) {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    content: Text(state.failure.message),
                  );
                },
              );
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  if (state.status == EditProfileStatus.submitting)
                    LinearProgressIndicator(),
                  const SizedBox(height: 32.0),
                  GestureDetector(
                    onTap: () => _selectProfileImage(context),
                    child: UserProfileImage(
                      radius: 80.0,
                      profileImage: state.profileImage,
                      profileImageUrl: user.profileImageUrl,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Form(
                      key: _formState,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextFormField(
                            initialValue: user.username,
                            decoration: InputDecoration(hintText: 'username'),
                            onChanged: (value) => context
                                .read<EditProfileCubit>()
                                .usernameChanged(value),
                            validator: (value) => value.isEmpty
                                ? 'Username can\'t be empty.'
                                : null,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            initialValue: user.bio,
                            decoration: InputDecoration(hintText: 'bio'),
                            onChanged: (value) => context
                                .read<EditProfileCubit>()
                                .bioChanged(value),
                            validator: (value) =>
                                value.isEmpty ? 'Bio can\'t be empty.' : null,
                          ),
                          const SizedBox(height: 28),
                          ElevatedButton(
                            onPressed: () => _submitForm(context,
                                state.status == EditProfileStatus.submitting),
                            child: const Text('Update'),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _selectProfileImage(BuildContext context) async {
    final pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );
    if (pickedFile != null) {
      context
          .read<EditProfileCubit>()
          .profileImageChanged(File(pickedFile.path));
    }
  }

  _submitForm(BuildContext context, bool isSubmitting) {
    if (_formState.currentState.validate() && !isSubmitting)
      context.read<EditProfileCubit>().submit();
  }
}
