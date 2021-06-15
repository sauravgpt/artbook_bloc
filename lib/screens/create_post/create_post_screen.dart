import 'dart:io';

import 'package:artbook/screens/create_post/cubit/create_post_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class CreatePostsScreen extends StatelessWidget {
  static const String routeName = '/createPosts';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: BlocConsumer<CreatePostCubit, CreatePostState>(
          listener: (context, state) {
            if (state.status == CreatePostStatus.success) {
              _formKey.currentState.reset();
              context.read<CreatePostCubit>().reset();

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.green,
                  duration: const Duration(seconds: 1),
                  content: Text('Post Created'),
                ),
              );
            } else if (state.status == CreatePostStatus.error) {
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
            final size = MediaQuery.of(context).size;
            return SingleChildScrollView(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () => _selectPostImage(context),
                    child: Container(
                      height: size.height / 2,
                      width: double.infinity,
                      color: Colors.grey[200],
                      child: state.postImage != null
                          ? Image.file(
                              state.postImage,
                              fit: BoxFit.cover,
                            )
                          : const Icon(
                              Icons.image,
                              color: Colors.grey,
                              size: 120.0,
                            ),
                    ),
                  ),
                  if (state.status == CreatePostStatus.submitting)
                    const LinearProgressIndicator(),
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextFormField(
                            decoration: InputDecoration(hintText: 'caption'),
                            onChanged: (value) => context
                                .read<CreatePostCubit>()
                                .postCaptionChanged(value),
                            validator: (value) => value.trim().isEmpty
                                ? 'Caption cannot be empty'
                                : null,
                          ),
                          const SizedBox(height: 28.0),
                          ElevatedButton(
                            onPressed: () => _submitForm(
                                context,
                                state.postImage,
                                state.status == CreatePostStatus.submitting),
                            child: Text('Post'),
                          ),
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

  _selectPostImage(BuildContext context) async {
    final pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );
    if (pickedFile != null) {
      context.read<CreatePostCubit>().postImageChanged(File(pickedFile.path));
    }
  }

  _submitForm(BuildContext context, File postImage, bool isSubmitting) async {
    if (_formKey.currentState.validate() && !isSubmitting)
      context.read<CreatePostCubit>().onSubmit();
  }
}
