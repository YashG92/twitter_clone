import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:twitter_clone/data/repositories/auth_repository.dart';

import '../../feature/personalization/model/user_model.dart';
import '../../utils/exceptions/firebase_exceptions.dart';
import '../../utils/exceptions/format_exceptions.dart';
import '../../utils/exceptions/platform_exceptions.dart';

class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  Future<void> saveUserData(UserModel user) async {
    try {
      await _db.collection("Users").doc(user.userId).set(user.toJson());
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

  Future<UserModel> fetchUserData({String? userId}) async {
    try {
      final uid = userId ?? AuthRepository.instance.authUser.uid;

      final documentSnapshot = await _db.collection("Users").doc(uid).get();

      if (documentSnapshot.exists) {
        return UserModel.fromSnapshot(documentSnapshot);
      } else {
        return UserModel.empty();
      }
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

  Stream<UserModel> getUserById(String userId) {
    return _db.collection("Users").doc(userId).snapshots().map((snapshot) {
      //final data = snapshot.data()!;
      return UserModel.fromSnapshot(snapshot);
    });
  }

  Future<void> updateSingleFieldUserData({
    String? userId,
    required Map<String, dynamic> json,
  }) async {
    try {
      await _db
          .collection("Users")
          .doc(userId ?? AuthRepository.instance.authUser.uid)
          .update(json);
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

  Future<String> uploadImage(String path, XFile image) async {
    try {
      final ref = FirebaseStorage.instance.ref(path).child(image.name);
      await ref.putFile(File(image.path));
      final url = await ref.getDownloadURL();
      return url;
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

  Future<List<UserModel>> searchUsers(String query) async {
    final usernameQuery = _db
        .collection('Users')
        .where('username', isGreaterThanOrEqualTo: query)
        .where('username', isLessThan: '${query}z');

    final emailQuery = _db
        .collection('Users')
        .where('email', isGreaterThanOrEqualTo: query)
        .where('email', isLessThan: '${query}z');

    final usernameSnapshot = await usernameQuery.get();
    final emailSnapshot = await emailQuery.get();

    // Combine both results and avoid duplicates using a set of userIds
    final userMap = <String, UserModel>{};

    for (var doc in usernameSnapshot.docs) {
      final user = UserModel.fromSnapshot(doc);
      userMap[user.userId] = user;
    }

    for (var doc in emailSnapshot.docs) {
      final user = UserModel.fromSnapshot(doc);
      userMap[user.userId] = user;
    }

    return userMap.values.toList();
  }

  Stream<UserModel> getUserDataStream({String? userId}) {
    try {
      final uid = userId ?? AuthRepository.instance.authUser.uid;
      return _db.collection("Users").doc(uid).snapshots().map((snapshot) {
        if (snapshot.exists) {
          return UserModel.fromSnapshot(snapshot);
        } else {
          return UserModel.empty();
        }
      });
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
