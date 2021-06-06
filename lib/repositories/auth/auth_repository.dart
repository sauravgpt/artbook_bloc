import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import '../../config/paths.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:meta/meta.dart';
import '../../models/models.dart';
import '../repositories.dart';

class AuthRepository extends BaseAuthRepository {
  final FirebaseFirestore _firebaseFirestore;
  final auth.FirebaseAuth _firebaseAuth;

  AuthRepository({
    FirebaseFirestore firebaseFirestore,
    auth.FirebaseAuth firebaseAuth,
  })  : _firebaseAuth = firebaseAuth ?? auth.FirebaseAuth.instance,
        _firebaseFirestore = firebaseFirestore ??FirebaseFirestore.instance;

  @override
  Future<auth.User> signInWithUserNameAndPassword({
    @required String email,
    @required String password,
  }) async {
    try {
      final userCredential = (await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      ));

      return userCredential.user;
    } on auth.FirebaseAuthException catch (e) {
      throw Failure(code: e.code, message: e.message);
    } on PlatformException catch (e) {
      throw Failure(code: e.code, message: e.message);
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } on auth.FirebaseAuthException catch (e) {
      throw Failure(code: e.code, message: e.message);
    } on PlatformException catch (e) {
      throw Failure(code: e.code, message: e.message);
    }
  }

  @override
  Future<auth.User> signUpWithUsernameAndPassword({
    @required String username,
    @required String email,
    @required String password,
  }) async {
    try {
      final userCredentials =
          (await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      ));

      _firebaseFirestore
          .collection(Paths.users)
          .doc(userCredentials.user.uid)
          .set({
        'username': username,
        'email': email,
        'followers': 0,
        'following': 0,
      });
      return userCredentials.user;
    } on auth.FirebaseAuthException catch (e) {
      throw Failure(code: e.code, message: e.message);
    } on PlatformException catch (e) {
      throw Failure(code: e.code, message: e.message);
    }
  }

  @override
  Stream<auth.User> get user => _firebaseAuth.userChanges();
}
