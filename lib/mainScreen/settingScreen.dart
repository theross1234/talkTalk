import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:chatchat/providers/authenticationProvider.dart';
import 'package:chatchat/utils/constant.dart';
import 'package:chatchat/widget/CustomAppBar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Settingscreen extends StatefulWidget {
  const Settingscreen({super.key});

  @override
  State<Settingscreen> createState() => _SettingscreenState();
}

class _SettingscreenState extends State<Settingscreen> {
  bool isDarkMode = false;
// get the saved theme mode
  void getSavedThemeMode() async {
    final savedThemeMode = await AdaptiveTheme.getThemeMode();
    if (savedThemeMode == AdaptiveThemeMode.dark) {
      setState(() {
        isDarkMode = true;
      });
    } else {
      setState(() {
        isDarkMode = false;
      });
    }
  }

  @override
  void initState() {
    getSavedThemeMode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = context.read<AuthenticationProvider>().userModel;

    // get data from the argument
    final uid = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(
        title: const Text(Constant.settings),
        leading: AppBarBackButton(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        actions: [
          currentUser!.uid == uid
              ? IconButton(
                  onPressed: () async {
                    //Navigate to the settings Screen with uid as argument
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              title: const Text(Constant.logout),
                              content: const Text(Constant.logoutMessage),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text(Constant.cancel),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    await context
                                        .read<AuthenticationProvider>()
                                        .logout()
                                        .whenComplete(() {
                                      Navigator.pop(context);
                                      Navigator.pushNamedAndRemoveUntil(
                                          context,
                                          Constant.loginScreen,
                                          (route) => false);
                                    });
                                  },
                                  child: const Text(Constant.logout),
                                ),
                              ],
                            ));
                  },
                  icon: const Icon(Icons.logout),
                )
              : const SizedBox(),
        ],
      ),
      body: Center(
        child: Card(
          child: SwitchListTile(
              title: const Text(Constant.changeTheme),
              secondary: Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
                child: Icon(
                  isDarkMode
                      ? Icons.nightlight_rounded
                      : Icons.wb_sunny_rounded,
                  color: isDarkMode ? Colors.black : Colors.white,
                ),
              ),
              value: isDarkMode,
              onChanged: (value) {
                setState(() {
                  isDarkMode = value;
                });
                if (value) {
                  AdaptiveTheme.of(context).setDark();
                } else {
                  AdaptiveTheme.of(context).setLight();
                }
              }),
        ),
      ),
    );
  }
}
