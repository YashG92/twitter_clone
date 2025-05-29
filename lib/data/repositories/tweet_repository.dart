import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:twitter_clone/feature/tweet/model/tweet_model.dart';

import '../../utils/exceptions/firebase_auth_exceptions.dart';
import '../../utils/exceptions/firebase_exceptions.dart';
import '../../utils/exceptions/format_exceptions.dart';
import '../../utils/exceptions/platform_exceptions.dart';

class TweetRepository extends GetxController {
  static TweetRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  Future<String> postTweet(TweetModel tweet) async {
    try {
      final data = await _db.collection("Tweets").add(tweet.toJson());
      return data.id;
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

  Future<void> updateSingleFieldTweetData({
    required String tweetId,
    required Map<String, dynamic> json,
  }) async {
    try {
      await _db.collection("Tweets").doc(tweetId).update(json);
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

  Future<List<TweetModel>> fetchTweet() async {
    try {
      final snapshot =
          await _db
              .collection("Tweets")
              .orderBy('createdAt', descending: true)
              .get();
      final result =
          snapshot.docs.map((doc) => TweetModel.fromSnapshot(doc)).toList();
      return result;
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

  Stream<TweetModel> getTweetStream(String tweetId) {
    return _db
        .collection("Tweets")
        .doc(tweetId)
        .snapshots()
        .map((doc) => TweetModel.fromSnapshot(doc));
  }

  Stream<List<TweetModel>> getUserTweetStream(String userId) {
    return _db
        .collection("Tweets")
        .where('authorId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => TweetModel.fromSnapshot(doc)).toList(),
        );
  }

  Future<List<TweetModel>> fetchTweetByUserId(String userId) async {
    try {
      final snapshot =
          await _db
              .collection("Tweets")
              .where('authorId', isEqualTo: userId)
              .orderBy('createdAt', descending: true)
              .get();
      final result =
          snapshot.docs.map((doc) => TweetModel.fromSnapshot(doc)).toList();
      return result;
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

  Future<void> deleteTweetByUserId(String tweetId) async {
    try {
      await _db.collection("Tweets").doc(tweetId).delete();
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

  Future<void> likeCountUpdate(String tweetId, bool isLiked) async {
    try {
      isLiked
          ? await _db.collection("Tweets").doc(tweetId).update({
            'likeCount': FieldValue.increment(-1),
          })
          : await _db.collection("Tweets").doc(tweetId).update({
            'likeCount': FieldValue.increment(1),
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

  ///Fetch tweet by tweetID
  Future<TweetModel> fetchTweetByTweetId(String tweetId) async {
    try {
      final snapshot = await _db.collection("Tweets").doc(tweetId).get();
      return TweetModel.fromSnapshot(snapshot);
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
