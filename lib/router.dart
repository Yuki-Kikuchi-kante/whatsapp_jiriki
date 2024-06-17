import 'package:flutter/material.dart';
import 'package:whatsapp_jiriki/common/widgets/error.dart';
import 'package:whatsapp_jiriki/features/auth/screens/login_screen.dart';
import 'package:whatsapp_jiriki/features/auth/screens/otp_screen.dart';
import 'package:whatsapp_jiriki/features/auth/screens/user_information_screen.dart';
import 'package:whatsapp_jiriki/features/select_contacts/screens/select_contacts_screen.dart';
import 'package:whatsapp_jiriki/screens/mobile_chat_screen.dart';
import 'package:whatsapp_jiriki/screens/mobile_layout_screen.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case LoginScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      );
    case OTPScreen.routeName:
      String verificationId = settings.arguments as String;
      return MaterialPageRoute(
        builder: (context) => OTPScreen(
          verificationId: verificationId,
        ),
      );
      case UserInformationScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const UserInformationScreen(),
      );
      case MobileLayoutScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const MobileLayoutScreen(),
      );
      case SelectContactsScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const SelectContactsScreen(),
      );
      case MobileChatScreen.routeName:
      Map<String,dynamic> userData = settings.arguments as Map<String,dynamic>;
      final String name = userData['name'];
      final String uid = userData['uid'];
      return MaterialPageRoute(
        builder: (context) =>  MobileChatScreen(name: name, uid: uid,),
      );
    default:
      return MaterialPageRoute(
        builder: (context) => const Scaffold(
          body: ErrorScreen(error: 'ページが見つかりません'),
        ),
      );
  }
}
