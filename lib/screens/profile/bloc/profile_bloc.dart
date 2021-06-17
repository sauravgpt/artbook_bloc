import 'dart:async';

import 'package:artbook/bloc/auth/auth_bloc.dart';
import 'package:artbook/models/models.dart';
import 'package:artbook/repositories/repositories.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import './../../../enums/enums.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UserRepository _userRepository;
  final PostRepository _postRepository;
  final AuthBloc _authBloc;
  StreamSubscription<List<Future<Post>>> _postsSubscription;

  ProfileBloc({
    @required UserRepository userRepository,
    @required AuthBloc authBloc,
    @required PostRepository postRepository,
  })  : _userRepository = userRepository,
        _authBloc = authBloc,
        _postRepository = postRepository,
        super(ProfileState.initial());

  @override
  Stream<ProfileState> mapEventToState(
    ProfileEvent event,
  ) async* {
    if (event is ProfileLoadUser)
      yield* _mapProfileLoadUserToState(event);
    else if (event is ProfileToggleGridView) {
      yield* _mapProfileToggleGridViewToState(event);
    } else if (event is ProfileUpdatePosts) {
      yield* _mapProfileUpdatePostsToState(event);
    }
  }

  Stream<ProfileState> _mapProfileLoadUserToState(
    ProfileLoadUser event,
  ) async* {
    yield state.copyWith(status: ProfileStatus.loading);
    try {
      final user = await _userRepository.getUserWithId(userId: event.userId);
      final isCurrentUser = _authBloc.state.user.uid == event.userId;

      _postsSubscription?.cancel();
      _postsSubscription = _postRepository
          .getUserPosts(userId: event.userId)
          .listen((posts) async {
        final allPosts = await Future.wait(posts);
        add(ProfileUpdatePosts(posts: allPosts));
      });

      yield state.copyWith(
        user: user,
        isCurrentUser: isCurrentUser,
        status: ProfileStatus.loaded,
      );
    } catch (e) {
      yield state.copyWith(
        status: ProfileStatus.error,
        failure: Failure(message: 'Unable to load this profile.'),
      );
    }
  }

  Stream<ProfileState> _mapProfileToggleGridViewToState(
    ProfileToggleGridView event,
  ) async* {
    yield state.copyWith(isGridView: event.isGrid);
  }

  @override
  Future<void> close() {
    _postsSubscription?.cancel();
    return super.close();
  }

  Stream<ProfileState> _mapProfileUpdatePostsToState(
      ProfileUpdatePosts event) async* {
    yield state.copyWith(posts: event.posts);
  }
}
