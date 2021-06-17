part of 'profile_bloc.dart';

class ProfileState extends Equatable {
  final User user;
  final List<Post> posts;
  final bool isCurrentUser;
  final bool isGridView;
  final ProfileStatus status;
  final Failure failure;
  final bool isFollowing;

  const ProfileState({
    @required this.user,
    @required this.posts,
    @required this.isCurrentUser,
    @required this.isGridView,
    @required this.status,
    @required this.failure,
    @required this.isFollowing,
  });

  factory ProfileState.initial() {
    return const ProfileState(
      user: User.empty,
      posts: [],
      isCurrentUser: false,
      isGridView: true,
      status: ProfileStatus.initial,
      failure: Failure(),
      isFollowing: false,
    );
  }

  @override
  List<Object> get props => [
        user,
        isCurrentUser,
        isGridView,
        status,
        failure,
        isFollowing,
        posts,
      ];

  ProfileState copyWith({
    User user,
    List<Post> posts,
    bool isCurrentUser,
    bool isGridView,
    ProfileStatus status,
    Failure failure,
    int isFollowing,
  }) {
    return ProfileState(
      user: user ?? this.user,
      isCurrentUser: isCurrentUser ?? this.isCurrentUser,
      isGridView: isGridView ?? this.isGridView,
      status: status ?? this.status,
      failure: failure ?? this.failure,
      isFollowing: isFollowing ?? this.isFollowing,
      posts: posts ?? this.posts,
    );
  }
}
