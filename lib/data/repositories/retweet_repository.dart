import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:twitter_clone/data/repositories/auth_repository.dart';
import 'package:twitter_clone/feature/personalization/model/retweet_model.dart';

import '../../feature/tweet/model/tweet_model.dart';
import '../../utils/exceptions/firebase_auth_exceptions.dart';
import '../../utils/exceptions/firebase_exceptions.dart';
import '../../utils/exceptions/format_exceptions.dart';
import '../../utils/exceptions/platform_exceptions.dart';

class RetweetRepository extends GetxController {
  static RetweetRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  Future<void> postRetweet(RetweetModel retweet) async {
    try {
      await _db
          .collection("Users")
          .doc(AuthRepository.instance.authUser.uid)
          .collection("Retweets")
          .add(retweet.toJson());
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

  Stream<List<RetweetModel>> getRetweetsForUser(String userId) {
    try {
      return _db
          .collection("Users")
          .doc(userId)
          .collection("Retweets")
          .snapshots()
          .map((querySnapshot) {
            return querySnapshot.docs.map((doc) {
              return RetweetModel.fromSnapshot(doc);
            }).toList();
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

  Future<List<TweetModel>> fetchReTweetByUserId(String userId) async {
    try {
      final snapshot = await _db
          .collection("Users")
          .doc(userId)
          .collection("Retweets")
          .get();

      List<String> reTweetIds = snapshot.docs
          .map((doc) => doc['reTweetId'] as String)
          .toList();

      if (reTweetIds.isEmpty) return [];

      List<TweetModel> tweets = [];

      const int batchSize = 10;
      for (int i = 0; i < reTweetIds.length; i += batchSize) {
        final batchIds = reTweetIds.skip(i).take(batchSize).toList();

        final tweetsSnapshot = await _db
            .collection("Tweets")
            .where(FieldPath.documentId, whereIn: batchIds)
            .get();

        final batchTweets = tweetsSnapshot.docs
            .map((doc) => TweetModel.fromSnapshot(doc))
            .toList();

        tweets.addAll(batchTweets);
      }

      return tweets;
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


  Stream<bool> userRepostStream(String originalTweetRef, String userId) {
    return _db
        .collection("Users")
        .doc(userId)
        .collection("Retweets")
        .where("originalTweetRef", isEqualTo: originalTweetRef)
        .snapshots()
        .map((snapshot) => snapshot.docs.isNotEmpty);
  }
}
