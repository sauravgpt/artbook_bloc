import 'package:firebase_auth/firebase_auth.dart' as auth;

abstract class BaseAuthRepository {
  Stream<auth.User> get user;

  Future<auth.User> signUpWithUsernameAndPassword({
    String username,
    String email,
    String password,
  });

  Future<auth.User> signInWithUserNameAndPassword({
    String email,
    String password,
  });

  Future<void> signOut();
}
