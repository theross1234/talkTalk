import 'dart:async';

import 'package:chatchat/providers/authenticationProvider.dart';
import 'package:chatchat/utils/assetManager.dart';
import 'package:chatchat/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();
  String? otpcode;
  late Timer _timer;
  int secondsLeft = 10;
  bool canResendCode = false;

  @override
  void initState() {
    // TODO: implement initState
    startTimer();
    super.initState();
  }

  void startTimer() {
    setState(() {
      canResendCode = false; // Cache le bouton au démarrage
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsLeft > 0) {
        setState(() {
          secondsLeft--; // Décrémente le compteur
        });
      } else {
        setState(() {
          canResendCode = true; // Affiche le bouton après 10 secondes
        });
        _timer.cancel(); // Stoppe le timer
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _pinPutController.dispose();
    _pinPutFocusNode.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // get the arguments
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    final phoneNumber = args[Constant.phoneNumber] as String;
    final verificationId = args[Constant.verificationId] as String;

    final AuthProvider = context.watch<AuthenticationProvider>();
    //final authProvider = context.read<AuthenticationProvider>();
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
          fontSize: 20,
          color: Color.fromRGBO(3, 15, 26, 1),
          fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 198, 213, 231),
        border: Border.all(color: const Color.fromARGB(255, 86, 112, 134)),
        borderRadius: BorderRadius.circular(10),
      ),
    );
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
              child: Column(
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                      height: 200,
                      child: Lottie.asset(
                        AssetsManager.lottieOTP,
                      )),
                  const Text(
                    'Verification du code',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'entrer le code a 6 chiffre que vous avez recu',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.openSans(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    phoneNumber,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.openSans(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                      height: 68,
                      child: Pinput(
                        length: 6,
                        controller: _pinPutController,
                        focusNode: _pinPutFocusNode,
                        defaultPinTheme: defaultPinTheme,
                        onCompleted: (pin) {
                          setState(() {
                            otpcode = pin;
                            // verify the otp code
                          });
                          VerifyOtpScreen(
                            verificationId: verificationId,
                            otp: otpcode!,
                          );
                        },
                        focusedPinTheme: defaultPinTheme.copyWith(
                          height: 56,
                          width: 56,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 223, 232, 240),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        errorPinTheme: defaultPinTheme.copyWith(
                          height: 56,
                          width: 56,
                          decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 223, 232, 240),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: const Color.fromARGB(255, 233, 10, 10),
                              )),
                        ),
                      )),
                  const SizedBox(
                    height: 10,
                  ),
                  AuthProvider.isLoading
                      ? const CircularProgressIndicator()
                      : const SizedBox.shrink(),
                  AuthProvider.isSuccessful
                      ? Container(
                          height: 50,
                          width: 50,
                          decoration: const BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                            //borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.done,
                                color: Colors.white,
                              )),
                        )
                      : const SizedBox.shrink(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'vous n\'avez pas recu le code ?',
                        style: GoogleFonts.openSans(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      canResendCode
                          ? TextButton(
                              onPressed: () {
                                //Todo: resend the code
                              },
                              child: Text(
                                'Renvoyer le code',
                                style: GoogleFonts.openSans(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ))
                          : Text(
                              " renvoyer dans $secondsLeft s",
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void VerifyOtpScreen({
    required String otp,
    required String verificationId,
  }) async {
    print("entrer dans l'otp");
    final authProvider = context.read<AuthenticationProvider>();
    authProvider.verifyOTP(
      otp: otp,
      verificationId: verificationId,
      context: context,
      onSuccess: () async {
        print("onsuccess");
        //1. check if use is in the firestore
        bool isUserExisted = await authProvider.checkUserExists();

        if (isUserExisted) {
          print("user existed");
          //2. if the user is existed

          // * get user information from firestore
          await authProvider.getUserDataFromFirestore();

          // * save user information to provider/sharedd preferences
          await authProvider.saveUserDatatoSharedPreferences();

          // * navigate to the home screen
          Navigate(isUserExisted: true);
        } else {
          print("user not existed");
          //3. if the user doesn't, navigate to the user information screen
          Navigate(isUserExisted: false);
        }
      },
    );
  }

  void Navigate({required bool isUserExisted}) {
    if (isUserExisted) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        Constant.homescreen,
        (route) => false,
      );
    } else {
      Navigator.pushNamedAndRemoveUntil(
        context,
        Constant.userinformationscreen,
        (route) => false,
      );
    }
  }
}
