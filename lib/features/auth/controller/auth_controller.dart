import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_jiriki/features/auth/repository/auth_repository.dart';
import 'package:whatsapp_jiriki/models/user_model.dart';

final getCurrentUserProvider = FutureProvider((ref) {
  final authController = ref.watch(authControllerProvider);
  return authController.getCurrentUser();
});

final authControllerProvider = Provider((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return AuthController(
    authRepository: authRepository,
    ref: ref,
  );
});

class AuthController {
  final AuthRepository authRepository;
  final ProviderRef ref;
  AuthController({
    required this.authRepository,
    required this.ref,
  });

  Future<UserModel?> getCurrentUser() async {
    UserModel? user = await authRepository.getcurrentUser();
    return user;
  }

  void saveUserData({
    required BuildContext context,
    required String name,
    required File? file,
  }) {
    authRepository.saveUserData(
      name: name,
      file: file,
      ref: ref,
    );
  }

  void otpSend({
    required BuildContext context,
    required String verificationId,
    required String smsCode,
  }) {
    authRepository.otpSend(
      verificationId: verificationId,
      smsCode: smsCode,
    );
  }

  void sendPhoneNumber(String phoneNumber) {
    authRepository.sendPhoneNumber(
      phoneNumber,
    );
  }

  Stream<UserModel> userDataById(String userId) {
    return authRepository.userData(userId);
  }

  void setState(bool isOnline) {
    authRepository.setState(isOnline);
  }
}
