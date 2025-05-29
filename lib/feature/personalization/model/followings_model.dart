import 'package:cloud_firestore/cloud_firestore.dart';

enum FollowStatus { pending, accepted, rejected }

class FollowingsModel {
  final String followingId;
  final String userId;
  DateTime followedAt;
  final FollowStatus status;

  FollowingsModel({
    required this.followingId,
    required this.userId,
    required this.followedAt,
    this.status = FollowStatus.pending,
  });

  static FollowingsModel empty() =>
      FollowingsModel(followingId: '', userId: '', followedAt: DateTime.now());

  toJson() {
    return {
      'userId': userId,
      'followedAt': followedAt,
      'status': status.index,
    };
  }

  factory FollowingsModel.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) {
    final data = document.data()!;
    return FollowingsModel(
      followingId: document.id,
      userId: data['userId'],
      followedAt: data['followedAt']?.toDate() ?? DateTime.now(),
      status: FollowStatus.values.firstWhere(
        (status) => status.index == data['status'],
        orElse: () => FollowStatus.pending,
      ),
    );
  }
}
