import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:twitter_clone/data/repositories/auth_repository.dart';
import 'package:twitter_clone/feature/personalization/model/followers_model.dart';
import 'package:twitter_clone/feature/personalization/model/followings_model.dart';

import '../../utils/exceptions/firebase_auth_exceptions.dart';
import '../../utils/exceptions/firebase_exceptions.dart';
import '../../utils/exceptions/format_exceptions.dart';
import '../../utils/exceptions/platform_exceptions.dart';

class FollowerFollowingRepository extends GetxController {
  static FollowerFollowingRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;
  final currentUid = AuthRepository.instance.authUser.uid;

  Future<void> _updateFollowCounts(
    String targetUserId,
    int incrementValue,
  ) async {
    final batch = _db.batch();

    // Update current user's following count
    final currentUserRef = _db.collection("Users").doc(currentUid);
    batch.update(currentUserRef, {
      'followingCount': FieldValue.increment(incrementValue),
    });

    // Update target user's follower count
    final targetUserRef = _db.collection("Users").doc(targetUserId);
    batch.update(targetUserRef, {
      'followerCount': FieldValue.increment(incrementValue),
    });

    await batch.commit();
  }

  Future<void> followUser(
    String targetUserId,
    FollowingsModel currentUserFollowing,
    FollowersModel targetUserFollowers,
  ) async {
    try {
      await _db.runTransaction((transaction) async {
        // Add to current user's following
        transaction.set(
          _db
              .collection("Users")
              .doc(currentUid)
              .collection("Following")
              .doc(targetUserId),
          currentUserFollowing.toJson(),
        );

        // Add to target user's followers
        transaction.set(
          _db
              .collection("Users")
              .doc(targetUserId)
              .collection("Followers")
              .doc(currentUid),
          targetUserFollowers.toJson(),
        );

        // Update counts
        await _updateFollowCounts(targetUserId, 1);
      });
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  Future<void> unFollowUser(String targetUserId) async {
    try {
      await _db.runTransaction((transaction) async {
        // Remove from current user's following
        transaction.delete(
          _db
              .collection("Users")
              .doc(currentUid)
              .collection("Following")
              .doc(targetUserId),
        );

        // Remove from target user's followers
        transaction.delete(
          _db
              .collection("Users")
              .doc(targetUserId)
              .collection("Followers")
              .doc(currentUid),
        );

        // Update counts
        await _updateFollowCounts(targetUserId, -1);
      });
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  Stream<bool> isFollowingStream(String currentUserId, String targetUserId) {
    return _db
        .collection('Users')
        .doc(currentUserId)
        .collection('Following')
        .doc(targetUserId)
        .snapshots()
        .map((docSnapshot) => docSnapshot.exists);
  }

  Stream<List<FollowingsModel>> getUserFollowingStream(String userId) {
    return _db
        .collection('Users')
        .doc(userId)
        .collection('Following')
        .snapshots()
        .map(
          (querySnapshot) =>
              querySnapshot.docs
                  .map((doc) => FollowingsModel.fromSnapshot(doc))
                  .toList(),
        );
  }

  Stream<List<FollowersModel>> getUserFollowersStream(String userId) {
    return _db
        .collection('Users')
        .doc(userId)
        .collection('Followers')
        .snapshots()
        .map(
          (querySnapshot) =>
              querySnapshot.docs
                  .map((doc) => FollowersModel.fromSnapshot(doc))
                  .toList(),
        );
  }
}
