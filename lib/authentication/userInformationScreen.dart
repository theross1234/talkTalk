import 'dart:io';

import 'package:chatchat/models/user_model.dart';
import 'package:chatchat/providers/authenticationProvider.dart';
import 'package:chatchat/utils/constant.dart';
import 'package:chatchat/utils/global_method.dart';
import 'package:chatchat/widget/CustomAppBar.dart';
import 'package:chatchat/widget/displayUserImage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class Userinformationscreen extends StatefulWidget {
  const Userinformationscreen({super.key});

  @override
  State<Userinformationscreen> createState() => _UserinformationscreenState();
}

class _UserinformationscreenState extends State<Userinformationscreen> {
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  final TextEditingController _usernameController = TextEditingController();

  String UserImage = '';
  File? fileImage;
  File? finalImage;

  @override
  void dispose() {
    // TODO: implement dispose
    _btnController.stop();
    _usernameController.dispose();
    super.dispose();
  }

  void selectedImage(bool fromCamera) async {
    fileImage = await pickImage(
        fromCamera: true,
        onFail: (String message) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(message),
          ));
        });

    print(fileImage?.path);
    // crop the image
    if (fileImage != null) {
      await cropImage(fileImage!.path);
    }
  }

  Future<void> cropImage(filePath) async {
    if (filePath != null) {
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: filePath,
        maxWidth: 800,
        maxHeight: 800,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 90,
      );

      //popDialog();

      if (croppedFile != null) {
        setState(() {
          finalImage = File(croppedFile.path);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('erreur lors du crop de l\'image'),
          ),
        );
      }
    }
  }

  popDialog() {
    Navigator.pop(context);
  }

  void showBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (context) => SizedBox(
              height: MediaQuery.of(context).size.height / 5,
              child: Column(
                children: [
                  ListTile(
                    onTap: () {
                      selectedImage(true);

                      popDialog();
                    },
                    leading: const Icon(Icons.camera),
                    title: const Text('Camera'),
                  ),
                  ListTile(
                    onTap: () {
                      selectedImage(false);

                      popDialog();
                    },
                    leading: const Icon(Icons.image),
                    title: const Text('Gallery'),
                  ),
                ],
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: AppBarBackButton(
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text('user information'),
        ),
        body: Center(
            child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 20.0,
          ),
          child: Column(
            children: [
              Displayuserimage(
                  finalfileImage: finalImage,
                  radius: 50,
                  onTap: () {
                    showBottomSheet();
                  }),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(
                    hintText: 'nom d\'utilisateur',
                    labelText: 'entrer un nom d\'utilisateur',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: double.infinity,
                child: RoundedLoadingButton(
                  controller: _btnController,
                  onPressed: () {
                    if (_usernameController.text.isEmpty ||
                        finalImage == null ||
                        _usernameController.text.length < 3) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'veuillez entrer un nom d\'utilisateur valide'),
                        ),
                      );
                      // showSnackBar(context,
                      //     'veuillez entrer un nom d\'utilisateur valide');
                      _btnController.reset();
                      return;
                    }
                    // save data to  firestore
                    saveUserDataFirestore();
                    //_btnController.success();
                  },
                  successColor: Colors.green,
                  successIcon: Icons.check,
                  errorColor: Colors.red,
                  color: Theme.of(context).primaryColor,
                  child: const Text(
                    'continuer',
                    style: TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontSize: 20,
                      //fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            ],
          ),
        )));
  }

  // save user data to firestore
  void saveUserDataFirestore() async {
    final authProvider = context.read<AuthenticationProvider>();

    UserModel userModel = UserModel(
      uid: authProvider.uid!,
      name: _usernameController.text.trim(),
      token: '',
      phoneNumber: authProvider.phoneNumber!,
      aboutMe: 'yo je fais partie de ${Constant.appName}',
      image: '',
      lastSeen: '',
      createdAt: '',
      isOnline: true,
      friendsUids: [],
      receivefriendRequestsUids: [],
      sentFriendRequestsUids: [],
    );

    authProvider.saveUserDataToFirestore(
        userModel: userModel,
        fileImage: finalImage,
        onSuccess: () async {
          _btnController.success();
          _btnController.reset();
          // save user data to shared preferences
          await authProvider.saveUserDatatoSharedPreferences();
          navigateToHomeScreen();
        },
        onFail: () async {
          _btnController.error();
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('erreur lors de la sauvegarde des donnees'),
          ));
          //showSnackBar(context, 'erreur lors de la sauvegarde des donnees');
          await Future.delayed(const Duration(seconds: 1), () {
            _btnController.reset();
          });
        });
  }

  void navigateToHomeScreen() {
    // Navigate to the home screen and remove all previous screens from the navigation stack
    Navigator.pushNamedAndRemoveUntil(
      context,
      Constant.homescreen,
      (route) => false,
    );
  }
}
