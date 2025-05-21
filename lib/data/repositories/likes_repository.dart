import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:twitter_clone/feature/personalization/model/likes_model.dart';

import '../../utils/exceptions/firebase_auth_exceptions.dart';
import '../../utils/exceptions/firebase_exceptions.dart';
import '../../utils/exceptions/format_exceptions.dart';
import '../../utils/exceptions/platform_exceptions.dart';
import 'auth_repository.dart';

class LikesRepository extends GetxController {
  static LikesRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;
  final _uid = AuthRepository.instance.authUser.uid;

  Future<void> likeTweet(LikesModel like) async {
    try {
      final batch = _db.batch();

      final userLikeRef = _db
          .collection("Users")
          .doc(like.userId)
          .collection('Likes')
          .doc(like.tweetId);
      batch.set(userLikeRef, like.toJson());

      final tweetRef = _db.collection("Tweets").doc(like.tweetId);
      batch.update(tweetRef, {
        'likeCount': FieldValue.increment(1),
        'likedBy': FieldValue.arrayUnion([_uid]),
      });
      await batch.commit();
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

  Future<void> unLikeTweet(LikesModel like) async {
    try {
      final batch = _db.batch();

      final userLikeRef = _db
          .collection("Users")
          .doc(like.userId)
          .collection('Likes')
          .doc(like.tweetId);
      batch.delete(userLikeRef);

      final tweetRef = _db.collection("Tweets").doc(like.tweetId);
      batch.update(tweetRef, {
        'likeCount': FieldValue.increment(-1),
        'likedBy': FieldValue.arrayRemove([_uid]),
      });
      batch.commit();
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

  Stream<List<LikesModel>> getUserLikes() {
    return _db
        .collection("Users")
        .doc(_uid)
        .collection("Likes")
        .snapshots()
        .map(
          (querySnapshot) =>
              querySnapshot.docs
                  .map((doc) => LikesModel.fromSnapshot(doc))
                  .toList(),
        );
  }

  Stream<LikesModel?> getLikeStatus(String tweetId) {
    return _db
        .collection("Users")
        .doc(_uid)
        .collection('Likes')
        .doc(tweetId)
        .snapshots()
        .map((doc) => doc.exists ? LikesModel.fromSnapshot(doc) : null);
  }
}
