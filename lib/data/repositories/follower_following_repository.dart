import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:twitter_clone/feature/personalization/model/followers_model.dart';
import 'package:twitter_clone/feature/personalization/model/followings_model.dart';

import '../../utils/exceptions/firebase_auth_exceptions.dart';
import '../../utils/exceptions/firebase_exceptions.dart';
import '../../utils/exceptions/format_exceptions.dart';
import '../../utils/exceptions/platform_exceptions.dart';

class FollowerFollowingRepository extends GetxController {
  static FollowerFollowingRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;
  final currentUid = FirebaseAuth.instance.currentUser!.uid;

  Future<void> followUser(
    String targetUserId,
    FollowingsModel currentUserFollowing,
    FollowersModel targetUserFollowers,
  ) async {
    try {
      await _db
          .collection("Users")
          .doc(currentUid)
          .collection("Following")
          .doc(targetUserId)
          .set(currentUserFollowing.toJson());

      await _db
          .collection("Users")
          .doc(targetUserId)
          .collection("Followers")
          .doc(currentUid)
          .set(targetUserFollowers.toJson());
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
      await _db
          .collection("Users")
          .doc(currentUid)
          .collection("Following")
          .doc(targetUserId)
          .delete();

      await _db
          .collection("Users")
          .doc(targetUserId)
          .collection("Followers")
          .doc(currentUid)
          .delete();
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

  Stream<List<FollowersModel>> followersStream(String userId) {
    return _db
        .collection("Users")
        .doc(userId)
        .collection("Followers")
        .snapshots()
        .map(
          (querySnapshot) =>
              querySnapshot.docs
                  .map((doc) => FollowersModel.fromSnapshot(doc))
                  .toList(),
        )
        .handleError((error) {
          if (error is FirebaseAuthException) {
            throw TFirebaseAuthException(error.code).message;
          } else if (error is FirebaseException) {
            throw TFirebaseException(error.code).message;
          } else if (error is FormatException) {
            throw const TFormatException();
          } else if (error is PlatformException) {
            throw TPlatformException(error.code).message;
          } else {
            throw 'Something went wrong. Please try again';
          }
        });
  }

  Stream<List<FollowingsModel>> followingStream(String userId) {
    return _db
        .collection("Users")
        .doc(userId)
        .collection("Following")
        .snapshots()
        .map(
          (querySnapshot) =>
              querySnapshot.docs
                  .map((doc) => FollowingsModel.fromSnapshot(doc))
                  .toList(),
        )
        .handleError((error) {
          if (error is FirebaseAuthException) {
            throw TFirebaseAuthException(error.code).message;
          } else if (error is FirebaseException) {
            throw TFirebaseException(error.code).message;
          } else if (error is FormatException) {
            throw const TFormatException();
          } else if (error is PlatformException) {
            throw TPlatformException(error.code).message;
          } else {
            throw 'Something went wrong. Please try again';
          }
        });
  }

  Future<bool> isFollowing(String currentUserId, String targetUserId) async {
    final doc =
        await _db
            .collection('Users')
            .doc(currentUserId)
            .collection('Following')
            .doc(targetUserId)
            .get();
    return doc.exists;
  }

  Future<List<FollowersModel>> getFollowers(String userId) async {
    try {
      final snapshot =
          await _db
              .collection("Users")
              .doc(userId)
              .collection("Followers")
              .get();
      return snapshot.docs
          .map((doc) => FollowersModel.fromSnapshot(doc))
          .toList();
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

  Future<List<FollowingsModel>> getFollowing(String userId) async {
    try {
      final snapshot =
          await _db
              .collection("Users")
              .doc(userId)
              .collection("Following")
              .get();
      return snapshot.docs
          .map((doc) => FollowingsModel.fromSnapshot(doc))
          .toList();
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
}
