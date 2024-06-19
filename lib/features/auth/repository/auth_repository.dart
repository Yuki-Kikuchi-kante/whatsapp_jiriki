import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_jiriki/common/repository/commmon_firebase_storage.dart';
import 'package:whatsapp_jiriki/common/utils/utils.dart';
import 'package:whatsapp_jiriki/features/auth/screens/otp_screen.dart';
import 'package:whatsapp_jiriki/features/auth/screens/user_information_screen.dart';
import 'package:whatsapp_jiriki/models/user_model.dart';
import 'package:whatsapp_jiriki/screens/mobile_layout_screen.dart';

final authRepositoryProvider = Provider(
  (ref) => AuthRepository(
    auth: FirebaseAuth.instance,
    firestore: FirebaseFirestore.instance,
  ),
);

class AuthRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  AuthRepository({
    required this.auth,
    required this.firestore,
  });

  Future<UserModel?> getcurrentUser() async {
    UserModel? user;
    DocumentSnapshot<Map<String, dynamic>> snap =
        await firestore.collection('users').doc(auth.currentUser?.uid).get();
    if (snap.data() != null) {
      user = UserModel.fromMap(snap.data()!);
    }
    return user;
  }

  void saveUserData(
      {required String name,
      required File? file,
      required ProviderRef ref}) async {
    try {
      String imageUrl =
          'https://png.pngitem.com/pimgs/s/649-6490124_katie-notopoulos-katienotopoulos-i-write-about-tech-round.png';
      String uid = auth.currentUser!.uid;
      if (file != null) {
        imageUrl = await ref
            .read(commonFirebaseStorageRepositoryProvider)
            .storeFileToFirebase('profilePic/$uid', file);
      }

      UserModel userData = UserModel(
        name: name,
        profilePic: imageUrl,
        phoneNumber: auth.currentUser!.phoneNumber!,
        uid: uid,
        isOnline: false,
        groupId: [],
      );
      await firestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .set(userData.toMap());

      navigatorKey.currentState?.pushNamedAndRemoveUntil(
        MobileLayoutScreen.routeName,
        (route) => false,
      );
    } catch (e) {
      showSnackBar(e.toString());
    }
  }

  void otpSend({
    required String verificationId,
    required String smsCode,
  }) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      await auth.signInWithCredential(credential);
      navigatorKey.currentState?.pushNamedAndRemoveUntil(
        UserInformationScreen.routeName,
        (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      showSnackBar(e.message!);
    }
  }

  void sendPhoneNumber(
    String phoneNumber,
  ) async {
    try {
      await auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          throw Exception(e.message);
        },
        codeSent: (String verificationId, int? resendToken) async {
          await navigatorKey.currentState?.pushNamed(
            OTPScreen.routeName,
            arguments: verificationId,
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } on FirebaseAuthException catch (e) {
      showSnackBar(e.message!);
    }
  }

  Stream<UserModel> userData(String uid) {
    return firestore.collection('users').doc(uid).snapshots().map((doc) {
      return UserModel.fromMap(doc.data()!);
    });
  }

  void setState(bool isOnline) async {
    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .update({'isOnline': isOnline});
  }
}
