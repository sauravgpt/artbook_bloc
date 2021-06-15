import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class User extends Equatable {
  final String id;
  final String username;
  final String email;
  final String profileImageUrl;
  final int followers;
  final int following;
  final String bio;
  const User({
    @required this.id,
    @required this.username,
    @required this.email,
    @required this.profileImageUrl,
    @required this.followers,
    @required this.following,
    @required this.bio,
  });

  static const empty = User(
      id: '',
      username: '',
      email: '',
      profileImageUrl: '',
      followers: 0,
      following: 0,
      bio: '');

  @override
  List<Object> get props => [
        id,
        username,
        email,
        profileImageUrl,
        followers,
        following,
        bio,
      ];

  User copyWith({
    String id,
    String username,
    String email,
    String profileImageUrl,
    int followers,
    int following,
    String bio,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      followers: followers ?? this.followers,
      following: following ?? this.following,
      bio: bio ?? this.bio,
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'profileImageUrl': profileImageUrl,
      'followers': followers,
      'following': following,
      'bio': bio,
    };
  }

  factory User.fromDocument(DocumentSnapshot doc) {
    if (doc == null) return null;
    final map = doc.data();
    return User(
      id: doc.id,
      username: map['username'] ?? '',
      email: map['email'] ?? '',
      profileImageUrl: map['profileImageUrl'] ?? '',
      followers: (map['followers'] ?? 0).toInt(),
      following: (map['following'] ?? 0).toInt(),
      bio: map['bio'] ?? '',
    );
  }

  String toJson() => json.encode(toDocument());

  factory User.fromJson(String source) =>
      User.fromDocument(json.decode(source));
}
