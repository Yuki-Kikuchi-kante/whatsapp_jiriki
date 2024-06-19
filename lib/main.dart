import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_jiriki/common/utils/colors.dart';
import 'package:whatsapp_jiriki/common/utils/utils.dart';
import 'package:whatsapp_jiriki/common/widgets/error.dart';
import 'package:whatsapp_jiriki/common/widgets/loader.dart';
import 'package:whatsapp_jiriki/features/auth/controller/auth_controller.dart';
import 'package:whatsapp_jiriki/features/landing/screens/landing_screen.dart';
import 'package:whatsapp_jiriki/firebase_options.dart';
import 'package:whatsapp_jiriki/router.dart';
import 'package:whatsapp_jiriki/screens/mobile_layout_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
        navigatorKey: navigatorKey,
        scaffoldMessengerKey: scaffoldKey,
        onGenerateRoute: (settings) => generateRoute(settings),
        debugShowCheckedModeBanner: false,
        title: 'Whatsapp UI',
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: backgroundColor,
        ),
        home: ref.watch(getCurrentUserProvider).when(
              data: (user) {
                if(user == null){
                 return const LandingScreen();
                }else{
                 return const MobileLayoutScreen();
                }
              },
              error: (err,str) => ErrorScreen(error: err.toString(),),
              loading: ()=> const Loader(),
            )
        );
  }
}
