import 'dart:io';

import 'package:chatchat/enums/enums.dart';
import 'package:chatchat/utils/constant.dart';
import 'package:chatchat/utils/global_method.dart';
import 'package:chatchat/widget/CustomAppBar.dart';
import 'package:chatchat/widget/displayUserImage.dart';
import 'package:chatchat/widget/frienList.dart';
import 'package:chatchat/widget/groupTypeListTile.dart';
import 'package:chatchat/widget/settingsListTile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';

class CreateGroupScreen extends StatefulWidget {
  const CreateGroupScreen({super.key});

  @override
  State<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

String UserImage = '';
File? fileImage;
File? finalImage;

class _CreateGroupScreenState extends State<CreateGroupScreen> {
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
    // if (fileImage != null) {
    //   setState(() {
    //     finalImage = fileImage;
    //   });
    // }
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

  GroupType groupValue = GroupType.private;
  // group name controller
  final TextEditingController groupNameController = TextEditingController();
  // group description controller
  final TextEditingController groupDescriptionController =
      TextEditingController();

  @override
  void initState() {
    groupNameController;
    groupDescriptionController;
    super.initState();
  }

  @override
  void dispose() {
    groupNameController.dispose();
    groupDescriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: AppBarBackButton(onPressed: () {
            Navigator.pop(context);
          }),
          title: const Text(Constant.createGroup),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Displayuserimage(
                      finalfileImage: finalImage,
                      radius: 50,
                      onTap: () {
                        showBottomSheet();
                      }),
                  const SizedBox(
                    width: 10,
                  ),
                  buildGroupType(),
                ],
              ),
              const SizedBox(
                height: 10,
              ),

              // text field for group name
              TextField(
                  controller: groupNameController,
                  maxLength: 12,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                      label: Text(Constant.groupName),
                      hintText: Constant.groupName,
                      border: OutlineInputBorder())),
              const SizedBox(
                height: 10,
              ),

              // text field for group description
              TextField(
                  controller: groupDescriptionController,
                  maxLines: 2,
                  maxLength: 100,
                  textInputAction: TextInputAction.done,
                  decoration: const InputDecoration(
                      label: Text(Constant.groupDescription),
                      hintText: Constant.groupDescription,
                      border: OutlineInputBorder())),
              const SizedBox(
                height: 10,
              ),
              Card(
                color: Colors.grey.withOpacity(0.9),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Settingslisttile(
                    title: Constant.groupSettings,
                    onTap: () {},
                    icon: Icons.settings,
                    IconColor: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Selected group members",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // cuppertino search field
              const SizedBox(
                height: 10,
              ),
              CupertinoSearchTextField(
                placeholder: Constant.search,
                onChanged: (value) {},
              ),
              const SizedBox(
                height: 10,
              ),
              const Expanded(
                  child: Frienlist(
                viewType: FriendViewType.friend,
              ))
            ],
          ),
        ));
  }

  Column buildGroupType() {
    return Column(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.3,
          child: Grouptypelisttile(
            title: GroupType.private.name,
            value: GroupType.private,
            groupValue: groupValue,
            onChanged: (value) {
              setState(() {
                // print("value : $groupValue");
                groupValue = value!;
              });
            },
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.3,
          child: Grouptypelisttile(
            title: GroupType.public.name,
            value: GroupType.public,
            groupValue: groupValue,
            onChanged: (value) {
              setState(() {
                //print("value : $groupValue");
                groupValue = value!;
              });
            },
          ),
        )
      ],
    );
  }
}