import 'package:artbook/models/models.dart';
import 'package:meta/meta.dart';

abstract class BaseUserRepository {
  Future<User> getUserWithId({@required String userId});
  Future<void> updateUser({@required User user});
  Future<List<User>> searchUsers({@required String query});
  void followUser({String userId, String followUserId});
  void unfollowUser({String userId, String unfollowUserId});
  Future<bool> isFollowing({String userId, String otherUserId});
}
