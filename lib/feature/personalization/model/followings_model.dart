import 'package:cloud_firestore/cloud_firestore.dart';

class FollowingsModel {
  final String followingId;
  final String userId;
  DateTime followedAt;

  FollowingsModel({
    required this.followingId,
    required this.userId,
    required this.followedAt,
  });

  static FollowingsModel empty() =>
      FollowingsModel(followingId: '', userId: '', followedAt: DateTime.now());

  toJson() {
    return {'userId': userId, 'followedAt': followedAt};
  }

  factory FollowingsModel.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) {
    final data = document.data()!;
    return FollowingsModel(
      followingId: document.id,
      userId: data['userId'],
      followedAt: data['followedAt']?.toDate() ?? DateTime.now(),
    );
  }
}
