import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../feature/tweet/model/comment_model.dart';
import '../../utils/exceptions/firebase_auth_exceptions.dart';
import '../../utils/exceptions/firebase_exceptions.dart';
import '../../utils/exceptions/format_exceptions.dart';
import '../../utils/exceptions/platform_exceptions.dart';

class CommentRepository extends GetxController {
  static CommentRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  Future<void> postComment(CommentModel comment) async {
    try {
      await _db
          .collection('Tweets')
          .doc(comment.parentTweetId)
          .collection('Comments')
          .add(comment.toJson());
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

  Stream<List<CommentModel>> getCommentsForTweet(String tweetId) {
    return _db
        .collection('Tweets')
        .doc(tweetId)
        .collection('Comments')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map((doc) => CommentModel.fromSnapshot(doc))
                  .toList(),
        );
  }
}
