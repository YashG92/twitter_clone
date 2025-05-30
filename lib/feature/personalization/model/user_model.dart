import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String userId;
  String username;
  String email;
  String profileImage;
  String coverImage;
  String bio;
  int followerCount;
  int followingCount;
  int tweetCount;
  DateTime createdAt;

  UserModel({
    required this.userId,
    required this.username,
    required this.email,
    required this.profileImage,
    required this.coverImage,
    required this.bio,
    required this.followerCount,
    required this.followingCount,
    required this.tweetCount,
    required this.createdAt,
  });

  static UserModel empty() => UserModel(
    userId: '',
    username: '',
    email: '',
    profileImage: '',
    bio: '',
    coverImage: '',
    followerCount: 0,
    followingCount: 0,
    tweetCount: 0,
    createdAt: DateTime.now(),
  );

  ///Convert model to JSon structure for storing data in Firebase
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'profileImage': profileImage,
      'coverImage': coverImage,
      'bio': bio,
      'followerCount': followerCount,
      'followingCount': followingCount,
      'tweetCount': tweetCount,
      'createdAt': createdAt = DateTime.now(),
    };
  }

  ///Factory method to create UserModel from Firebase document Snapshot.
  factory UserModel.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) {
    final data = document.data()!;
    return UserModel(
      userId: document.id,
      username: data['username'] ?? '',
      email: data['email'] ?? '',
      profileImage: data['profileImage'],
      coverImage: data['coverImage'] ?? '',
      bio: data['bio'] ?? '',
      followerCount: data['followerCount'] ?? 0,
      followingCount: data['followingCount'] ?? 0,
      tweetCount: data['tweetCount'] ?? 0,
      createdAt: data['createdAt']?.toDate() ?? DateTime.now(),
    );
  }
}
