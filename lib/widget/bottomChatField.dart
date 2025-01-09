import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:chatchat/providers/authenticationProvider.dart';
import 'package:chatchat/providers/chat_provider.dart';
import 'package:chatchat/utils/assetManager.dart';
import 'package:chatchat/utils/global_method.dart';
import 'package:chatchat/widget/message_reply_preview.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_sound_record/flutter_sound_record.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:chatchat/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

class BottomChatField extends StatefulWidget {
  final String contactUId;
  final String contactName;
  final String groupId;
  final String contactImage;

  const BottomChatField({
    super.key,
    required this.contactUId,
    required this.contactName,
    required this.groupId,
    required this.contactImage,
  });

  @override
  State<BottomChatField> createState() => _BottomChatFieldState();
}

class _BottomChatFieldState extends State<BottomChatField>
    with TickerProviderStateMixin {
  FlutterSoundRecord? _audioRecorder;
  bool isRecordingAudio = false;
  bool isShowSendButton = false;
  bool isSendingAudio = false;

  late TextEditingController _messageController;
  late FocusNode _focusNode;

  OverlayEntry? _overlayEntry;
  String userImage = '';
  File? fileImage;
  String filePath = '';
  File? finalImage;
  bool isPlay = false;
  late AnimationController _sendButtonAnimationController;
  late AnimationController _animationShowModalController;
  late Animation<double> _scaleAnimation;
  bool isShowEmojiPicker = false;

  // method to hide emoji container
  void hideEmojiContainer() {
    setState(() {
      isShowEmojiPicker = false;
    });
  }

  // show emoji container
  void showEmojiContainer() {
    setState(() {
      isShowEmojiPicker = true;
    });
  }

  // show keyboard
  void showKeyboard() {
    _focusNode.requestFocus();
  }

  // hide keyboard
  void hideKeyboard() {
    _focusNode.unfocus();
  }

  // toggle emoji and keyboard container
  void toggleEmojiKeyboard() {
    if (isShowEmojiPicker) {
      showKeyboard();
      hideEmojiContainer();
    } else {
      hideKeyboard();
      showEmojiContainer();
    }
  }

  @override
  void initState() {
    _messageController = TextEditingController();
    _audioRecorder = FlutterSoundRecord();
    _focusNode = FocusNode();
    _sendButtonAnimationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _animationShowModalController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = CurvedAnimation(
      parent: _animationShowModalController,
      curve: Curves.easeInOut,
    );
    super.initState();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _audioRecorder?.dispose();
    _focusNode.dispose();
    _sendButtonAnimationController.dispose();
    _animationShowModalController.dispose();
    super.dispose();
  }

  // check microphone permission
  Future<bool> _checkMicrophonePermission() async {
    bool hasPermission = await Permission.microphone.isGranted;
    final status = await Permission.microphone.request();
    if (status == PermissionStatus.granted) {
      hasPermission = true;
    } else {
      hasPermission = false;
    }
    return hasPermission;
  }

  // record audio
  void startRecordingAudio() async {
    final hasPermission = await _checkMicrophonePermission();
    if (hasPermission) {
      var tempDir = await getTemporaryDirectory();
      filePath = '${tempDir.path}/audio.aac';
      await _audioRecorder?.start(path: filePath);
      setState(() {
        isRecordingAudio = true;
      });
    }
  }

  // stop recording audio
  void stopRecordingAudio() async {
    await _audioRecorder!.stop();
    setState(() {
      isRecordingAudio = false;
      //isShowSendButton = true;
      isSendingAudio = true;
    });
    // send audio message to firestiore
    sendFileMessageTofirestore(fileType: MessageEnum.audio);
  }

  // select image
  void selectedImage(bool fromCamera) async {
    fileImage = await pickImage(
      fromCamera: fromCamera,
      onFail: (String message) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(message),
        ));
      },
    );
    if (fileImage != null) {
      await cropImage(fileImage!.path);
      // popContext();
    }
  }

  // select video
  Future<void> selectedVideo(bool fromCamera) async {
    File? finalVideofile = await pickVideo(
      fromCamera: fromCamera,
      onFail: (String message) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(message),
        ));
      },
    );
    //popContext();
    if (finalVideofile != null) {
      filePath = finalVideofile.path;
      sendFileMessageTofirestore(fileType: MessageEnum.video);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error video'),
        ),
      );
    }
  }

  // select  file
  Future<void> selectedFile() async {
    File? finalDocumentFile = await pickFile(
      allowedExtensions: ['pdf', 'doc', 'docx', 'xls', 'xlsx', 'ppt', 'pptx'],
      onFail: (String message) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(message),
        ));
      },
    );
    //popContext();

    if (finalDocumentFile != null) {
      filePath = finalDocumentFile.path;
      sendFileMessageTofirestore(fileType: MessageEnum.document);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error file'),
        ),
      );
    }
  }

  void popContext() {
    Navigator.of(context).pop();
  }

  Future<void> cropImage(String croppedFilePath) async {
    if (croppedFilePath.isNotEmpty) {
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: croppedFilePath,
        maxWidth: 800,
        maxHeight: 800,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 90,
      );

      if (croppedFile != null) {
        filePath = croppedFile.path;
        sendFileMessageTofirestore(fileType: MessageEnum.image);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error cropping the image'),
          ),
        );
      }
    }
  }

  Future<void> sendFileMessageTofirestore({
    required MessageEnum fileType,
  }) async {
    final currentUser = context.read<AuthenticationProvider>().userModel!;
    final chatProvider = context.read<ChatProvider>();
    await chatProvider.sendFileMessage(
      sender: currentUser,
      contactUid: widget.contactUId,
      contactName: widget.contactName,
      contactImage: widget.contactImage,
      file: File(filePath),
      messageType: fileType,
      groupId: widget.groupId,
      onSuccess: () {
        _messageController.clear();
        _focusNode.unfocus();
        setState(() {
          isSendingAudio = false;
        });
      },
      onError: (error) {
        setState(() {
          isSendingAudio = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error),
          ),
        );
      },
    );
  }

  void sendTextMessageToFirestore() {
    final currentUser = context.read<AuthenticationProvider>().userModel!;
    final chatProvider = context.read<ChatProvider>();

    chatProvider.sendTextMessage(
      sender: currentUser,
      message: _messageController.text,
      messageType: MessageEnum.text,
      contacUid: widget.contactUId,
      contactName: widget.contactName,
      contactImage: widget.contactImage,
      groupId: widget.groupId,
      onSuccess: () {
        _messageController.clear();
        _focusNode.unfocus();
      },
      onError: () {
        const SnackBar(
          content: Text('Error sending message'),
        );
      },
    );
  }

  void _showCustomModal(BuildContext context, Offset buttonPosition) {
    _overlayEntry = OverlayEntry(
      builder: (context) {
        return GestureDetector(
          onTap: _hideCustomModal,
          child: Stack(
            children: [
              Positioned.fill(
                child: Container(
                  color: Colors.black.withOpacity(0.1),
                ),
              ),
              Positioned(
                left: buttonPosition.dx,
                top: buttonPosition.dy - 190,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Material(
                    color: Colors.transparent,
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      width: 200,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.0),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10.0,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            leading: const Icon(Icons.camera_alt),
                            title: const Text(Constant.image),
                            onTap: () {
                              selectedImage(true);
                              _hideCustomModal();
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.image),
                            title: const Text(Constant.gallery),
                            onTap: () {
                              selectedImage(false);
                              _hideCustomModal();
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.video_call),
                            title: const Text(Constant.video),
                            onTap: () {
                              selectedVideo(false);
                              _hideCustomModal();
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.file_copy),
                            title: const Text(Constant.document),
                            onTap: () {
                              //selectedFile();
                              showCustomSnackBar(
                                  context: context,
                                  title: Constant.maintain,
                                  message: Constant.maintainMessage,
                                  contentType: ContentType.warning);
                              _hideCustomModal();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
    Overlay.of(context).insert(_overlayEntry!);
    _animationShowModalController.forward();
  }

  void _hideCustomModal() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    _animationShowModalController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(builder: (context, chatProvider, child) {
      final messageReply = chatProvider.messageReplyModel;
      final isMessageReply = messageReply != null;
      return Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              border: Border.all(
                color: Theme.of(context).primaryColor,
              ),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Column(
              children: [
                isMessageReply
                    ? const MessageReplyPreview()
                    : const SizedBox.shrink(),
                Row(
                  children: [
                    chatProvider.isLoading
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        :
                        // emoji button
                        IconButton(
                            onPressed: () {
                              toggleEmojiKeyboard();
                            },
                            icon: isShowEmojiPicker
                                ? const Icon(
                                    Icons.keyboard_outlined,
                                    color: Colors.white,
                                  )
                                : const Icon(
                                    Icons.emoji_emotions_outlined,
                                    color: Colors.white,
                                  ),
                          ),
                    // attachment button
                    IconButton(
                      onPressed: () {
                        final RenderBox renderBox =
                            context.findRenderObject() as RenderBox;
                        final Offset position =
                            renderBox.localToGlobal(Offset.zero);
                        _showCustomModal(context, position);
                      },
                      icon: const Icon(
                        Icons.attach_file,
                        color: Colors.white,
                      ),
                    ),
                    Expanded(
                      child: TextFormField(
                        onTap: () {
                          if (isShowEmojiPicker) {
                            toggleEmojiKeyboard();
                          }
                        },
                        controller: _messageController,
                        focusNode: _focusNode,
                        decoration: const InputDecoration(
                          hintText: Constant.sendMessage,
                        ),
                        onChanged: (value) {
                          setState(() {
                            isShowSendButton = value.isNotEmpty;
                          });
                        },
                      ),
                    ),
                    chatProvider.isLoading
                        ? SizedBox(
                            width: 50,
                            height: 50,
                            child: Lottie.asset(
                              AssetsManager
                                  .sendingLottie, // Path to your Lottie file
                              fit: BoxFit.contain,
                            ),
                          )
                        : GestureDetector(
                            onTap: isShowSendButton
                                ? sendTextMessageToFirestore
                                : null,
                            onLongPress:
                                isShowSendButton ? null : startRecordingAudio,
                            onLongPressUp: stopRecordingAudio,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: const Color.fromARGB(255, 30, 62, 88),
                              ),
                              margin: const EdgeInsets.all(5),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: isShowSendButton
                                    ? const Icon(
                                        Icons.arrow_upward,
                                        color: Colors.white,
                                      )
                                    : const Icon(
                                        Icons.mic,
                                        color: Colors.white,
                                      ),
                              ),
                            ),
                          ),
                  ],
                ),
              ],
            ),
          ),
          // show emoji container
          isShowEmojiPicker
              ? ElasticInDown(
                  child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.4,
                      child: EmojiPicker(
                        onEmojiSelected: (category, Emoji emoji) {
                          _messageController.text =
                              _messageController.text + emoji.emoji;
                          if (!isShowSendButton) {
                            setState(() {
                              isShowSendButton = true;
                            });
                          }
                        },
                        onBackspacePressed: () {
                          _messageController.text = _messageController
                              .text.characters
                              .skipLast(1)
                              .toString();
                          if (isShowSendButton &&
                              _messageController.text.isEmpty) {
                            setState(() {
                              isShowSendButton = false;
                            });
                          }
                        },
                        //   config: Config(

                        // ),
                      )),
                )
              : const SizedBox.shrink(),
        ],
      );
    });
  }
}
