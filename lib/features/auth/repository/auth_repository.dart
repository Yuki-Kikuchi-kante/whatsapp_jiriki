import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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

  Future<UserModel?> getcurrentUser()async{
    UserModel? user;
    DocumentSnapshot<Map<String, dynamic>> snap = await firestore.collection('users').doc(auth.currentUser?.uid).get();
    if(snap.data() != null) {
      user = UserModel.fromMap(snap.data()!);
    }
    return user;
  }

  void saveUserData(
      {required BuildContext context,
      required String name,
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

      Navigator.pushNamedAndRemoveUntil(
        context,
        MobileLayoutScreen.routeName,
        (route) => false,
      );
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  void otpSend({
    required BuildContext context,
    required String verificationId,
    required String smsCode,
  }) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      await auth.signInWithCredential(credential);
      Navigator.pushNamedAndRemoveUntil(
        context,
        UserInformationScreen.routeName,
        (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      showSnackBar(context: context, content: e.message!);
    }
  }

  void sendPhoneNumber({
    required String phoneNumber,
    required BuildContext context,
  }) async {
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
          await Navigator.pushNamed(
            context,
            OTPScreen.routeName,
            arguments: verificationId,
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } on FirebaseAuthException catch (e) {
      showSnackBar(context: context, content: e.message!);
    }
  }

  Stream<UserModel> userData(String uid){
    return firestore.collection('users').doc(uid).snapshots().map((doc){
    return UserModel.fromMap(doc.data()!);
    });
  }
}
