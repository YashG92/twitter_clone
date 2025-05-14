import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:twitter_clone/routes/routes.dart';
import 'package:twitter_clone/utils/local_storage/storage_utility.dart';

import '../../utils/exceptions/firebase_auth_exceptions.dart';
import '../../utils/exceptions/firebase_exceptions.dart';
import '../../utils/exceptions/format_exceptions.dart';
import '../../utils/exceptions/platform_exceptions.dart';

class AuthRepository extends GetxController {
  static AuthRepository get instance => Get.find();

  final deviceStorage = GetStorage();
  final _auth = FirebaseAuth.instance;

  User get authUser => _auth.currentUser!;

  screenRedirect() async {
    final user = _auth.currentUser;
    print(user);
    if (user != null) {
      await StorageUtility.init(user.uid);
      Get.offAllNamed(Routes.navigationMenu);
    } else {
      deviceStorage.writeIfNull('isFirstTime', true);
      deviceStorage.read('isFirstTime') != true
          ? Get.offAllNamed(Routes.loginView)
          : Get.offAllNamed(Routes.signUpView);
    }
  }

  Future<UserCredential> registerWithEmailAndPassword(String email, String password)async{
    try{
      return await _auth.createUserWithEmailAndPassword(email: email ,password: password);
    }on FirebaseAuthException catch(e){
      throw TFirebaseAuthException(e.code).message;
    }on FirebaseException catch(e){
      throw TFirebaseException(e.code).message;
    }on FormatException catch(_){
      throw const TFormatException();
    }on PlatformException catch(e) {
      throw TPlatformException(e.code).message;
    }
    catch(e){
      throw 'Something went wrong. Please try again';
    }
  }

  Future<UserCredential> loginWithEmailAndPassword(String email, String password)async{
    try{
      return await _auth.signInWithEmailAndPassword(email: email ,password: password);
    }on FirebaseAuthException catch(e){
      throw TFirebaseAuthException(e.code).message;
    }on FirebaseException catch(e){
      throw TFirebaseException(e.code).message;
    }on FormatException catch(_){
      throw const TFormatException();
    }on PlatformException catch(e) {
      throw TPlatformException(e.code).message;
    }
    catch(e){
      throw 'Something went wrong. Please try again';
    }
  }
}
