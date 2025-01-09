enum ChatViewType { all, chat, group }

enum MessageEnum { text, image, video, audio, document }

enum FriendViewType { all, friend, friendRequest, groupView }

enum GroupType { public, private }

// extension convertMessageEnumToString on String
extension MessageEnumExtension on String {
  MessageEnum toMessageEnum() {
    switch (this) {
      case 'text':
        return MessageEnum.text;
      case 'image':
        return MessageEnum.image;
      case 'video':
        return MessageEnum.video;
      case 'audio':
        return MessageEnum.audio;
      case 'document':
        return MessageEnum.document;
      default:
        return MessageEnum.text;
    }
  }
}
