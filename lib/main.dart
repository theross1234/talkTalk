import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:chatchat/authentication/landigScreen.dart';
import 'package:chatchat/authentication/loginscreen.dart';
import 'package:chatchat/authentication/otp_screen.dart';
import 'package:chatchat/authentication/userInformationScreen.dart';
import 'package:chatchat/firebase_options.dart';
import 'package:chatchat/mainScreen/chatScreen/chatScreen.dart';
import 'package:chatchat/mainScreen/friendRequestScreen.dart';
import 'package:chatchat/mainScreen/friendScreen.dart';
import 'package:chatchat/mainScreen/groups/groupSettingsScreen.dart';
import 'package:chatchat/mainScreen/homescreen.dart';
import 'package:chatchat/mainScreen/profileScreen.dart';
import 'package:chatchat/mainScreen/settingScreen.dart';
import 'package:chatchat/providers/authenticationProvider.dart';
import 'package:chatchat/providers/chat_provider.dart';
import 'package:chatchat/providers/group_provider.dart';
import 'package:chatchat/utils/constant.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final savedThemeMode = await AdaptiveTheme.getThemeMode();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthenticationProvider()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
        ChangeNotifierProvider(create: (_) => GroupProvider()),
      ],
      child: MyApp(savedThemeMode: savedThemeMode),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.savedThemeMode});

  final AdaptiveThemeMode? savedThemeMode;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: ThemeData(
          useMaterial3: true,
          brightness: Brightness.light,
          cardColor: const Color.fromARGB(255, 22, 66, 85),
          colorSchemeSeed: const Color.fromARGB(255, 55, 88, 114)),
      dark: ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark,
          cardColor: const Color.fromARGB(255, 22, 66, 85),
          colorSchemeSeed: const Color.fromARGB(255, 55, 88, 114)),
      initial: savedThemeMode ?? AdaptiveThemeMode.light,
      builder: (theme, darkTheme) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: theme,
          darkTheme: darkTheme,
          initialRoute: Constant.landingScreen,
          routes: {
            Constant.loginScreen: (context) => const Loginscreen(),
            Constant.otpScreen: (context) => const OtpScreen(),
            Constant.userinformationscreen: (context) =>
                const Userinformationscreen(),
            //Constant.homescreen: (context) => const HomeScreen(),
            Constant.homescreen: (context) => const HomeScreen(),
            Constant.landingScreen: (context) => const Landigscreen(),
            Constant.profileScreen: (context) => const Profilescreen(),
            Constant.settingScreen: (context) => const Settingscreen(),
            Constant.friendsScreen: (context) => const Friendscreen(),
            Constant.friendRequestScreen: (context) =>
                const Friendrequestscreen(),
            Constant.chatscreen: (context) => const Chatscreen(),
            Constant.groupSettingsScreen: (context) =>
                const GroupSettingScreen(),
          }),
    );
  }
}
