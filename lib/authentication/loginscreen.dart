import 'package:chatchat/providers/authenticationProvider.dart';
import 'package:chatchat/utils/assetManager.dart';
import 'package:country_picker/country_picker.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class Loginscreen extends StatefulWidget {
  const Loginscreen({super.key});

  @override
  State<Loginscreen> createState() => _LoginscreenState();
}

class _LoginscreenState extends State<Loginscreen> {
  final TextEditingController _phoneController = TextEditingController();
  Country selectedCountry = Country(
    phoneCode: '237',
    countryCode: 'CMR',
    e164Sc: 0,
    geographic: true,
    level: 1,
    name: 'Cameroun',
    example: 'Cameroun',
    displayName: 'Cameroun',
    displayNameNoCountryCode: 'CMR',
    e164Key: '',
  );

  @override
  void initState() {
    super.initState();
    _phoneController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  // String? validatePhoneNumber(String value) {
  //   if (value.isEmpty ) {
  //     return 'Please enter your phone number';
  //   } else if (value.length < 9) {
  //     return 'Phone number must be at least 9 digits';
  //   }
  //   return null;
  // }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthenticationProvider>();
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: 10),
                SizedBox(
                  height: 300,
                  width: 300,
                  child: Lottie.asset(AssetsManager.loginChatLottie),
                ),
                Text(
                  'Chat',
                  style: GoogleFonts.openSans(
                    fontSize: 28,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "let's chat buddy",
                  style: GoogleFonts.openSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _phoneController,
                  maxLength: 9,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  onChanged: (value) {
                    setState(() {
                      _phoneController.text = value;
                    });
                  },
                  decoration: InputDecoration(
                    counterText: '',
                    hintText: 'Phone number',
                    hintStyle: GoogleFonts.openSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    prefixIcon: InkWell(
                      onTap: () {
                        showCountryPicker(
                          context: context,
                          showPhoneCode: true,
                          countryListTheme: CountryListThemeData(
                            textStyle: GoogleFonts.openSans(
                              fontSize: 18,
                              color: Colors.black,
                            ),
                            bottomSheetHeight:
                                MediaQuery.of(context).size.height * 0.5,
                          ),
                          onSelect: (Country country) {
                            setState(() {
                              selectedCountry = country;
                            });
                          },
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          "${selectedCountry.flagEmoji} +${selectedCountry.phoneCode}",
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    suffixIcon: _phoneController.text.length == 9
                        ? authProvider.isLoading
                            ? const CircularProgressIndicator()
                            : InkWell(
                                onTap: () {
                                  authProvider.signInWithPhoneNumber(
                                      phoneNumber:
                                          '+${selectedCountry.phoneCode}${_phoneController.text}',
                                      context: context);
                                },
                                child: Container(
                                    height: 40,
                                    width: 40,
                                    margin: const EdgeInsets.all(10),
                                    child: const Icon(
                                        CupertinoIcons.arrow_right,
                                        color: Colors.green)))
                        : const Icon(Icons.help, color: Colors.red),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
