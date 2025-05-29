import 'package:cloud_firestore/cloud_firestore.dart';

import 'followings_model.dart';

class FollowersModel {
  final String followerId;
  final String userId;
  DateTime followedAt;
  final FollowStatus status;

  FollowersModel({
    required this.followerId,
    required this.userId,
    required this.followedAt,
    this.status = FollowStatus.pending,
  });

  static FollowersModel empty() =>
      FollowersModel(followerId: '', userId: '', followedAt: DateTime.now());

  toJson() {
    return {'userId': userId, 'followedAt': followedAt, 'status': status.index};
  }

  factory FollowersModel.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) {
    final data = document.data()!;
    return FollowersModel(
      followerId: document.id,
      userId: data['userId'],
      followedAt: data['followedAt']?.toDate() ?? DateTime.now(),
      status: FollowStatus.values.firstWhere(
        (status) => status.index == data['status'],
        orElse: () => FollowStatus.pending,
      ),
    );
  }
}
