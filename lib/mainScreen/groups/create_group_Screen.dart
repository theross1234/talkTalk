import 'dart:io';

import 'package:chatchat/authentication/landigScreen.dart';
import 'package:chatchat/enums/enums.dart';
import 'package:chatchat/models/groupModel.dart';
import 'package:chatchat/providers/authenticationProvider.dart';
import 'package:chatchat/providers/group_provider.dart';
import 'package:chatchat/utils/assetManager.dart';
import 'package:chatchat/utils/constant.dart';
import 'package:chatchat/utils/global_method.dart';
import 'package:chatchat/widget/CustomAppBar.dart';
import 'package:chatchat/widget/displayUserImage.dart';
import 'package:chatchat/widget/frienList.dart';
import 'package:chatchat/widget/groupTypeListTile.dart';
import 'package:chatchat/widget/settingsListTile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:provider/provider.dart';

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
        fromCamera: fromCamera,
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

  //GroupType groupValue = GroupType.private;

  void createGroup() {
    final uid = context.read<AuthenticationProvider>().userModel!.uid;
    final groupProvider = context.read<GroupProvider>();
    // check if group name is empty
    if (groupNameController.text.isEmpty ||
        groupNameController.text.length < 3) {
      showCustomSnackBar(
          context: context,
          title: Constant.warning,
          message: Constant.emptyGroupName,
          contentType: ContentType.warning);
    }

    // check if group description is empty
    if (groupDescriptionController.text.isEmpty) {
      showCustomSnackBar(
          context: context,
          title: Constant.warning,
          message: Constant.emptyGroupDescription,
          contentType: ContentType.warning);
    }

    // group model
    GroupModel groupModel = GroupModel(
        groupId: uid,
        createrUid: uid,
        groupName: groupNameController.text,
        groupImage: '',
        messageType: MessageEnum.text.name,
        groupDescription: groupDescriptionController.text,
        lastMessage: '',
        senderUid: '',
        groupCreatedAt: DateTime.now(),
        timeSent: DateTime.now(),
        isPrivate: groupValue == GroupType.private ? true : false,
        editSettings: true,
        approveMembers: false,
        lockMessages: false,
        requestToJoin: false,
        groupMembersUids: [],
        adminsUids: [],
        awaitingApprovalUids: []);
    // create group
    groupProvider.createGroup(
        groupModel: groupModel,
        groupImage: finalImage,
        onSuccess: () {
          showCustomSnackBar(
            context: context,
            title: Constant.success,
            message: Constant.groupCreated,
            contentType: ContentType.success,
          );
          Navigator.pop(context);
        },
        onFail: (e) {
          showCustomSnackBar(
            context: context,
            title: Constant.error,
            message: e.toString(),
            contentType: ContentType.failure,
          );
        });
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
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: context.watch<GroupProvider>().isLoading == true
                  ? Colors.transparent
                  : Theme.of(context).primaryColor,
              child: context.watch<GroupProvider>().isLoading == true
                  ? const CircularProgressIndicator()
                  : IconButton(
                      onPressed: () {
                        // create group
                        createGroup();
                      },
                      icon: const Icon(Icons.check),
                    ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
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
                  Flexible(
                    child: Displayuserimage(
                      finalfileImage: finalImage,
                      radius: 50,
                      onTap: () {
                        showBottomSheet();
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Flexible(child: buildGroupType()),
                ],
              ),
              const SizedBox(height: 10),

              // Text field for group name
              TextField(
                controller: groupNameController,
                maxLength: 12,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  label: Text(Constant.groupName),
                  hintText: Constant.groupName,
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),

              // Text field for group description
              TextField(
                controller: groupDescriptionController,
                maxLines: 2,
                maxLength: 100,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(
                  label: Text(Constant.groupDescription),
                  hintText: Constant.groupDescription,
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),

              Card(
                color: Colors.grey.withOpacity(0.9),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Settingslisttile(
                    title: Constant.groupSettings,
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        Constant.groupSettingsScreen,
                      );
                    },
                    icon: Icons.settings,
                    IconColor: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              const SizedBox(height: 10),

              const Text(
                Constant.selectGroupMembers,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),

              CupertinoSearchTextField(
                placeholder: Constant.search,
                onChanged: (value) {},
              ),
              const SizedBox(height: 10),

              // Friend list with flexible height
              const SizedBox(
                height: 400, // Adjust height as needed
                child: Frienlist(
                  viewType: FriendViewType.groupView,
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
