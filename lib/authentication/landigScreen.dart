import 'package:chatchat/providers/authenticationProvider.dart';
import 'package:chatchat/utils/assetManager.dart';
import 'package:chatchat/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class Landigscreen extends StatefulWidget {
  const Landigscreen({super.key});

  @override
  State<Landigscreen> createState() => _LandigscreenState();
}

class _LandigscreenState extends State<Landigscreen> {
  @override
  void initState() {
    // check authentication
    checkAuthentication();
    super.initState();
  }

  void checkAuthentication() async {
    final authProvider = context.read<AuthenticationProvider>();

    bool isAuthenticated = await authProvider.checkAuthenticationState();

    Navigate(isAuthenticated: isAuthenticated);
  }

  Navigate({required bool isAuthenticated}) {
    if (isAuthenticated) {
      Navigator.pushReplacementNamed(context, Constant.homescreen);
    } else {
      Navigator.pushReplacementNamed(context, Constant.loginScreen);
    }
  }

  @override
  Widget build(BuildContext context) {
    //print("landing screen");
    return Scaffold(
      body: Center(
        child: SizedBox(
          height: 400,
          width: 300,
          child: Column(
            children: [
              Lottie.asset(AssetsManager.pepeThinking),
              const SizedBox(
                height: 10,
              ),
              const LinearProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
